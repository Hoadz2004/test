USE EduProDb;
GO

DECLARE @MaNganh NVARCHAR(10) = (SELECT TOP 1 MaNganh FROM Nganh ORDER BY MaNganh);
DECLARE @MaHK NVARCHAR(10) = (SELECT TOP 1 MaHK FROM HocKy ORDER BY NgayBatDau DESC);

IF @MaNganh IS NOT NULL AND @MaHK IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM HocPhiCatalog WHERE MaNganh = @MaNganh AND MaHK = @MaHK)
    BEGIN
        INSERT INTO HocPhiCatalog (MaNganh, MaHK, DonGiaTinChi, PhuPhiThucHanh, HieuLucTu, HieuLucDen)
        VALUES (@MaNganh, @MaHK, 500000, 100000, GETDATE(), NULL);
    END;

    IF NOT EXISTS (SELECT 1 FROM CongNo WHERE MaSV = N'2024001' AND MaHK = @MaHK)
    BEGIN
        INSERT INTO CongNo (MaSV, MaHK, SoTienNo)
        VALUES (N'2024001', @MaHK, 0);
    END;

    IF NOT EXISTS (SELECT 1 FROM CongNo WHERE MaSV = N'2023001' AND MaHK = @MaHK)
    BEGIN
        INSERT INTO CongNo (MaSV, MaHK, SoTienNo)
        VALUES (N'2023001', @MaHK, 0);
    END;
END;
GO
