-- Create Admission
IF OBJECT_ID('sp_Admissions_Create', 'P') IS NOT NULL
    DROP PROCEDURE sp_Admissions_Create;
GO
CREATE PROCEDURE sp_Admissions_Create
    @FullName NVARCHAR(200),
    @Email NVARCHAR(200) = NULL,
    @Phone NVARCHAR(50) = NULL,
    @CCCD NVARCHAR(50) = NULL,
    @NgaySinh DATE = NULL,
    @DiaChi NVARCHAR(300) = NULL,
    @MaNam NVARCHAR(20) = NULL,
    @MaHK NVARCHAR(20) = NULL,
    @MaNganh NVARCHAR(50) = NULL,
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaTraCuu NVARCHAR(20) = CONCAT('TS', FORMAT(GETDATE(), 'yyyyMMddHHmmss'), ABS(CHECKSUM(NEWID())) % 1000);

    INSERT INTO Admissions(FullName, Email, Phone, CCCD, NgaySinh, DiaChi, MaNam, MaHK, MaNganh, TrangThai, MaTraCuu, GhiChu)
    VALUES (@FullName, @Email, @Phone, @CCCD, @NgaySinh, @DiaChi, @MaNam, @MaHK, @MaNganh, N'Đã nộp', @MaTraCuu, @GhiChu);

    DECLARE @Id INT = SCOPE_IDENTITY();
    SELECT @Id AS Id, @MaTraCuu AS MaTraCuu;
END;
GO

-- List admissions (admin)
IF OBJECT_ID('sp_Admissions_List', 'P') IS NOT NULL
    DROP PROCEDURE sp_Admissions_List;
GO
CREATE PROCEDURE sp_Admissions_List
    @MaHK NVARCHAR(20) = NULL,
    @MaNganh NVARCHAR(50) = NULL,
    @TrangThai NVARCHAR(50) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT a.Id, a.FullName, a.Email, a.Phone, a.MaHK, a.MaNganh, a.TrangThai, a.MaTraCuu, a.NgayNop, a.NgayCapNhat,
           sc.Mon1, sc.Mon2, sc.Mon3, sc.Diem1, sc.Diem2, sc.Diem3,
           COUNT(*) OVER() AS TotalRecords
    FROM Admissions a
    OUTER APPLY (
        SELECT
            MAX(CASE WHEN rn = 1 THEN Mon END) AS Mon1,
            MAX(CASE WHEN rn = 1 THEN Diem END) AS Diem1,
            MAX(CASE WHEN rn = 2 THEN Mon END) AS Mon2,
            MAX(CASE WHEN rn = 2 THEN Diem END) AS Diem2,
            MAX(CASE WHEN rn = 3 THEN Mon END) AS Mon3,
            MAX(CASE WHEN rn = 3 THEN Diem END) AS Diem3
        FROM (
            SELECT Mon, Diem, ROW_NUMBER() OVER(ORDER BY Id) rn
            FROM AdmissionScores s
            WHERE s.AdmissionId = a.Id
        ) t
    ) sc
    WHERE (@MaHK IS NULL OR MaHK = @MaHK)
      AND (@MaNganh IS NULL OR MaNganh = @MaNganh)
      AND (@TrangThai IS NULL OR TrangThai = @TrangThai)
    ORDER BY NgayNop DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- Indexes to speed up list filters
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Admissions_Filter' AND object_id = OBJECT_ID('Admissions'))
BEGIN
    CREATE INDEX IX_Admissions_Filter ON Admissions(MaHK, MaNganh, TrangThai, NgayNop DESC);
END;
GO

-- Get by tracking code (public lookup)
IF OBJECT_ID('sp_Admissions_GetByCode', 'P') IS NOT NULL
    DROP PROCEDURE sp_Admissions_GetByCode;
GO
CREATE PROCEDURE sp_Admissions_GetByCode
    @MaTraCuu NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 a.Id, a.FullName, a.Email, a.Phone, a.MaHK, a.MaNganh, a.TrangThai, a.NgayNop, a.NgayCapNhat, a.GhiChu,
                 sc.Mon1, sc.Mon2, sc.Mon3, sc.Diem1, sc.Diem2, sc.Diem3
    FROM Admissions a
    OUTER APPLY (
        SELECT
            MAX(CASE WHEN rn = 1 THEN Mon END) AS Mon1,
            MAX(CASE WHEN rn = 1 THEN Diem END) AS Diem1,
            MAX(CASE WHEN rn = 2 THEN Mon END) AS Mon2,
            MAX(CASE WHEN rn = 2 THEN Diem END) AS Diem2,
            MAX(CASE WHEN rn = 3 THEN Mon END) AS Mon3,
            MAX(CASE WHEN rn = 3 THEN Diem END) AS Diem3
        FROM (
            SELECT Mon, Diem, ROW_NUMBER() OVER(ORDER BY Id) rn
            FROM AdmissionScores s
            WHERE s.AdmissionId = a.Id
        ) t
    ) sc
    WHERE a.MaTraCuu = @MaTraCuu;
END;
GO

-- Update status (admin)
IF OBJECT_ID('sp_Admissions_UpdateStatus', 'P') IS NOT NULL
    DROP PROCEDURE sp_Admissions_UpdateStatus;
GO
CREATE PROCEDURE sp_Admissions_UpdateStatus
    @Id INT,
    @TrangThai NVARCHAR(50),
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Admissions
    SET TrangThai = @TrangThai,
        GhiChu = COALESCE(@GhiChu, GhiChu),
        NgayCapNhat = GETDATE()
    WHERE Id = @Id;

    SELECT TOP 1 Id, FullName, Email, Phone, MaHK, MaNganh, TrangThai, MaTraCuu, NgayNop, NgayCapNhat, GhiChu
    FROM Admissions
    WHERE Id = @Id;
END;
GO
