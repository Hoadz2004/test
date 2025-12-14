USE EduProDb;
GO

/*
  Seed học phí mặc định cho tất cả ngành chưa có cấu hình ở một mã học kỳ.
  Mặc định: DonGiaTinChi = 111111, PhuPhiThucHanh = 100000, GiamTruPercent = 0.
  HieuLucTu = GETDATE(), HieuLucDen = NULL.
*/
IF OBJECT_ID('sp_SeedHocPhiDefaults', 'P') IS NOT NULL
    DROP PROCEDURE sp_SeedHocPhiDefaults;
GO

CREATE PROCEDURE sp_SeedHocPhiDefaults
    @MaHK NVARCHAR(10) = 'HK1-2025',
    @DonGia DECIMAL(18,2) = 111111,
    @PhuPhi DECIMAL(18,2) = 100000,
    @GiamTru DECIMAL(5,2) = 0
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy tất cả ngành chưa có cấu hình cho MaHK
    INSERT INTO HocPhiCatalog (MaNganh, MaHK, DonGiaTinChi, PhuPhiThucHanh, GiamTruPercent, HieuLucTu, HieuLucDen, CreatedAt)
    SELECT n.MaNganh, @MaHK, @DonGia, @PhuPhi, @GiamTru, GETDATE(), NULL, GETDATE()
    FROM Nganh n
    WHERE NOT EXISTS (
        SELECT 1 FROM HocPhiCatalog h
        WHERE h.MaNganh = n.MaNganh AND h.MaHK = @MaHK
          AND (h.HieuLucDen IS NULL OR h.HieuLucDen >= GETDATE())
    );
END;
GO

PRINT N'sp_SeedHocPhiDefaults created';
GO
