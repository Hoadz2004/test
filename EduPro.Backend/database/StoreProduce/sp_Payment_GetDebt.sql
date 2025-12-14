USE EduProDb;
GO

IF OBJECT_ID('sp_Payment_GetDebt', 'P') IS NOT NULL
    DROP PROCEDURE sp_Payment_GetDebt;
GO

CREATE PROCEDURE sp_Payment_GetDebt
    @MaSV NVARCHAR(10),
    @MaHK NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- Ensure latest debt
    EXEC sp_Payment_RecalcDebt @MaSV = @MaSV, @MaHK = @MaHK;

    SELECT 
        cn.MaSV, 
        cn.MaHK, 
        cn.SoTienNo, 
        cn.NgayCapNhat,
        hp.GiamTruPercent,
        hp.NgayHetHan,
        hp.DonGiaTinChi,
        hp.PhuPhiThucHanh,
        hp.HieuLucTu,
        hp.HieuLucDen
    FROM CongNo cn
    LEFT JOIN HocPhiCatalog hp 
        ON hp.MaNganh = (SELECT MaNganh FROM SinhVien WHERE MaSV = @MaSV)
       AND hp.MaHK = @MaHK
       AND (hp.HieuLucDen IS NULL OR hp.HieuLucDen >= GETDATE())
    WHERE cn.MaSV = @MaSV AND cn.MaHK = @MaHK;
END;
GO
