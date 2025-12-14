USE EduProDb;
GO

-- =============================================
-- FEATURE: SCHEDULE CONFLICT DETECTION
-- Check if Room or Lecturer is busy at specific Time
-- =============================================

IF OBJECT_ID ('sp_CheckTrungLich', 'P') IS NOT NULL
DROP PROC sp_CheckTrungLich;
GO
CREATE PROCEDURE sp_CheckTrungLich
    @MaNam NVARCHAR(10),
    @MaHK NVARCHAR(10),
    @Thu INT,
    @MaCa NVARCHAR(10),
    @MaPhong NVARCHAR(20) = NULL, -- Optional if only checking Lecturer, but usually check both
    @MaGV NVARCHAR(10) = NULL,    -- Optional if only checking Room
    @MaLHP NVARCHAR(20) = NULL    -- Optional: bỏ qua chính lớp hiện tại khi sửa
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ConflictMessage NVARCHAR(255) = '';
    DECLARE @IsConflict BIT = 0;

    -- 1. Check ROOM Conflict
    IF @MaPhong IS NOT NULL
    BEGIN
        IF EXISTS (
            SELECT 1 FROM LopHocPhan 
            WHERE MaNam = @MaNam AND MaHK = @MaHK 
              AND ThuTrongTuan = @Thu AND MaCa = @MaCa 
              AND MaPhong = @MaPhong
              AND (@MaLHP IS NULL OR MaLHP <> @MaLHP)
        )
        BEGIN
            SET @IsConflict = 1;
            SELECT @ConflictMessage = N'Phòng học đã có lớp khác học vào thời gian này (' + (SELECT TOP 1 MaLHP FROM LopHocPhan WHERE MaNam = @MaNam AND MaHK = @MaHK AND ThuTrongTuan = @Thu AND MaCa = @MaCa AND MaPhong = @MaPhong AND (@MaLHP IS NULL OR MaLHP <> @MaLHP)) + N')';
        END
    END

    -- 2. Check LECTURER Conflict (Only if Room is OK, or report both? Let's prioritize Room then Lecturer)
    IF @IsConflict = 0 AND @MaGV IS NOT NULL
    BEGIN
         IF EXISTS (
            SELECT 1 FROM LopHocPhan 
            WHERE MaNam = @MaNam AND MaHK = @MaHK 
              AND ThuTrongTuan = @Thu AND MaCa = @MaCa 
              AND MaGV = @MaGV
              AND (@MaLHP IS NULL OR MaLHP <> @MaLHP)
        )
        BEGIN
            SET @IsConflict = 1;
            SELECT @ConflictMessage = N'Giảng viên đã có lịch dạy lớp khác vào thời gian này (' + (SELECT TOP 1 MaLHP FROM LopHocPhan WHERE MaNam = @MaNam AND MaHK = @MaHK AND ThuTrongTuan = @Thu AND MaCa = @MaCa AND MaGV = @MaGV AND (@MaLHP IS NULL OR MaLHP <> @MaLHP)) + N')';
        END
    END

    -- Return Result
    SELECT @IsConflict AS IsConflict, @ConflictMessage AS ConflictMessage;
END;
GO
