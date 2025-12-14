USE EduProDb;
GO

IF OBJECT_ID('sp_Payment_RecalcDebt', 'P') IS NOT NULL
    DROP PROCEDURE sp_Payment_RecalcDebt;
GO

CREATE PROCEDURE sp_Payment_RecalcDebt
    @MaSV NVARCHAR(10),
    @MaHK NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaNganh NVARCHAR(10);
    SELECT @MaNganh = MaNganh FROM SinhVien WHERE MaSV = @MaSV;

    IF @MaNganh IS NULL
    BEGIN
        -- Sinh viên chưa có mã ngành: trả về 0 công nợ để tránh 400
        SELECT 0 AS SoTinChi, 0 AS DonGiaTinChi, 0 AS PhuPhiThucHanh, 0 AS GiamTruPercent,
               0 AS SoTienGoc, 0 AS DaThanhToan, 0 AS SoTienNo;
        RETURN;
    END;

    DECLARE @SoTinChi INT = (
        SELECT ISNULL(SUM(hp.SoTinChi), 0)
        FROM DangKyHocPhan dk
        JOIN LopHocPhan lhp ON dk.MaLHP = lhp.MaLHP
        JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
        WHERE dk.MaSV = @MaSV
          AND lhp.MaHK = @MaHK
          AND dk.TrangThai != N'Hủy'
    );

    DECLARE @DonGia DECIMAL(18,2);
    DECLARE @PhuPhi DECIMAL(18,2);
    DECLARE @GiamTru DECIMAL(18,2);

    SELECT TOP 1
        @DonGia = DonGiaTinChi,
        @PhuPhi = PhuPhiThucHanh,
        @GiamTru = GiamTruPercent
    FROM HocPhiCatalog
    WHERE MaNganh = @MaNganh
      AND MaHK = @MaHK
      AND (HieuLucDen IS NULL OR HieuLucDen >= GETDATE())
    ORDER BY HieuLucTu DESC;

    IF @DonGia IS NULL
    BEGIN
        -- Chưa cấu hình đơn giá: trả về 0 để FE hiển thị không có công nợ
        IF NOT EXISTS (SELECT 1 FROM CongNo WHERE MaSV = @MaSV AND MaHK = @MaHK)
            INSERT INTO CongNo (MaSV, MaHK, SoTienNo) VALUES (@MaSV, @MaHK, 0);
        ELSE
            UPDATE CongNo SET SoTienNo = 0, NgayCapNhat = GETDATE() WHERE MaSV = @MaSV AND MaHK = @MaHK;

        SELECT 0 AS SoTinChi, 0 AS DonGiaTinChi, 0 AS PhuPhiThucHanh, 0 AS GiamTruPercent,
               0 AS SoTienGoc, 0 AS DaThanhToan, 0 AS SoTienNo;
        RETURN;
    END;

    DECLARE @SoTienGoc DECIMAL(18,2) = (@SoTinChi * @DonGia) + (@SoTinChi * ISNULL(@PhuPhi,0));
    DECLARE @Giam DECIMAL(18,2) = (@SoTienGoc * ISNULL(@GiamTru,0) / 100.0);
    SET @SoTienGoc = @SoTienGoc - @Giam;

    -- Tổng tiền đã thanh toán/điều chỉnh từ ledger
    DECLARE @DaThanhToan DECIMAL(18,2) = (
        SELECT ISNULL(SUM(
            CASE pl.Type
                WHEN N'Credit' THEN pl.Amount
                WHEN N'Debit' THEN -pl.Amount
                WHEN N'Refund' THEN -pl.Amount
                WHEN N'Adjustment' THEN pl.Amount
                ELSE 0 END
        ),0)
        FROM PaymentLedger pl
        JOIN PaymentTransaction pt ON pl.PaymentId = pt.Id
        WHERE pt.MaSV = @MaSV AND pt.MaHK = @MaHK
    );

    DECLARE @SoTienNo DECIMAL(18,2) = CASE 
        WHEN @SoTienGoc - @DaThanhToan < 0 THEN 0 
        ELSE @SoTienGoc - @DaThanhToan 
    END;

    IF EXISTS (SELECT 1 FROM CongNo WHERE MaSV = @MaSV AND MaHK = @MaHK)
    BEGIN
        UPDATE CongNo
        SET SoTienNo = @SoTienNo,
            NgayCapNhat = GETDATE()
        WHERE MaSV = @MaSV AND MaHK = @MaHK;
    END
    ELSE
    BEGIN
        INSERT INTO CongNo (MaSV, MaHK, SoTienNo)
        VALUES (@MaSV, @MaHK, @SoTienNo);
    END;

    SELECT @SoTinChi AS SoTinChi,
           @DonGia AS DonGiaTinChi,
           ISNULL(@PhuPhi,0) AS PhuPhiThucHanh,
           ISNULL(@GiamTru,0) AS GiamTruPercent,
           @SoTienGoc AS SoTienGoc,
           @DaThanhToan AS DaThanhToan,
           @SoTienNo AS SoTienNo;
END;
GO
