-- Lấy cấu hình môn yêu cầu theo ngành (áp dụng bản hiệu lực hiện tại)
IF OBJECT_ID('sp_Admissions_GetRequirement', 'P') IS NOT NULL
    DROP PROCEDURE sp_Admissions_GetRequirement;
GO
CREATE PROCEDURE sp_Admissions_GetRequirement
    @MaNganh NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 MaNganh, Mon1, Mon2, Mon3, HeSo1, HeSo2, HeSo3, DiemChuan, HieuLucTu, HieuLucDen
    FROM AdmissionRequirements
    WHERE MaNganh = @MaNganh
      AND (HieuLucTu IS NULL OR HieuLucTu <= GETDATE())
      AND (HieuLucDen IS NULL OR HieuLucDen >= GETDATE())
    ORDER BY HieuLucTu DESC;
END;
GO
