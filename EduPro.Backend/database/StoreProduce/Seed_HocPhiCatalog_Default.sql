USE EduProDb;
GO

DECLARE @MaHK NVARCHAR(10);
SELECT TOP 1 @MaHK = MaHK FROM HocKy ORDER BY NgayBatDau DESC;

IF @MaHK IS NULL
BEGIN
    PRINT N'Không tìm thấy học kỳ để seed HocPhiCatalog';
    RETURN;
END

DECLARE @DefaultDonGia DECIMAL(18,2) = 500000;
DECLARE @DefaultPhuPhi DECIMAL(18,2) = 100000;

INSERT INTO HocPhiCatalog (MaNganh, MaHK, DonGiaTinChi, PhuPhiThucHanh, GiamTruPercent, HieuLucTu, HieuLucDen, NgayHetHan)
SELECT MaNganh, @MaHK, @DefaultDonGia, @DefaultPhuPhi, 0, GETDATE(), NULL, DATEADD(day, 90, GETDATE())
FROM Nganh n
WHERE NOT EXISTS (
    SELECT 1 FROM HocPhiCatalog h WHERE h.MaNganh = n.MaNganh AND h.MaHK = @MaHK
);

PRINT N'✓ Seed HocPhiCatalog default cho MaHK=' + @MaHK;
GO
