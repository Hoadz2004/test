-- Nh?p di?m 3 môn và tính t?ng theo yêu c?u
IF OBJECT_ID('sp_Admissions_SaveScores', 'P') IS NOT NULL
    DROP PROCEDURE sp_Admissions_SaveScores;
GO
CREATE PROCEDURE sp_Admissions_SaveScores
    @AdmissionId INT,
    @Mon1 NVARCHAR(50),
    @Diem1 DECIMAL(5,2),
    @Mon2 NVARCHAR(50),
    @Diem2 DECIMAL(5,2),
    @Mon3 NVARCHAR(50),
    @Diem3 DECIMAL(5,2),
    @GhiChu NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM AdmissionScores WHERE AdmissionId = @AdmissionId;

    INSERT INTO AdmissionScores(AdmissionId, Mon, Diem) VALUES
    (@AdmissionId, @Mon1, @Diem1),
    (@AdmissionId, @Mon2, @Diem2),
    (@AdmissionId, @Mon3, @Diem3);

    DECLARE @MaNganh NVARCHAR(50), @MaHK NVARCHAR(20);
    SELECT @MaNganh = MaNganh, @MaHK = MaHK FROM Admissions WHERE Id = @AdmissionId;

    -- L?y yêu c?u theo ngành (b? qua HK, gi? d?nh 1 c?u hình/ ngành)
    DECLARE @HeSo1 DECIMAL(4,2) = 1, @HeSo2 DECIMAL(4,2) = 1, @HeSo3 DECIMAL(4,2) = 1, @DiemChuan DECIMAL(5,2) = NULL;
    DECLARE @ReqMon1 NVARCHAR(50), @ReqMon2 NVARCHAR(50), @ReqMon3 NVARCHAR(50);

    SELECT TOP 1 @ReqMon1 = Mon1, @ReqMon2 = Mon2, @ReqMon3 = Mon3,
                 @HeSo1 = HeSo1, @HeSo2 = HeSo2, @HeSo3 = HeSo3, @DiemChuan = DiemChuan
    FROM AdmissionRequirements
    WHERE MaNganh = @MaNganh
      AND (HieuLucTu IS NULL OR HieuLucTu <= GETDATE())
      AND (HieuLucDen IS NULL OR HieuLucDen >= GETDATE())
    ORDER BY HieuLucTu DESC;

    DECLARE @Total DECIMAL(6,2) = (@Diem1 * @HeSo1) + (@Diem2 * @HeSo2) + (@Diem3 * @HeSo3);
    DECLARE @TrangThai NVARCHAR(50) = N'Ðã n?p';
    IF @DiemChuan IS NOT NULL AND @Total >= @DiemChuan
        SET @TrangThai = N'Ð? di?u ki?n';
    ELSE
        SET @TrangThai = N'Chua d?t';

    UPDATE Admissions
    SET TrangThai = @TrangThai,
        GhiChu = COALESCE(@GhiChu, GhiChu),
        NgayCapNhat = GETDATE()
    WHERE Id = @AdmissionId;

    INSERT INTO AdmissionStatusHistory(AdmissionId, TrangThai, GhiChu)
    VALUES (@AdmissionId, @TrangThai, CONCAT(N'T?ng di?m: ', @Total));

    SELECT @Total AS TongDiem, @TrangThai AS TrangThai;
END;
GO
