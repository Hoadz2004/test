-- =============================================
-- STORED PROCEDURE: sp_RegisterCourse
-- Đăng ký học phần (MaLHP chuẩn)
-- =============================================

USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_RegisterCourse')
    DROP PROCEDURE sp_RegisterCourse;
GO

CREATE PROCEDURE sp_RegisterCourse
    @MaSV NVARCHAR(20),
    @MaLHP NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM SinhVien WHERE MaSV = @MaSV)
        BEGIN
            RAISERROR (N'Sinh viên không tồn tại', 16, 1);
            RETURN;
        END;
        
        IF NOT EXISTS (SELECT 1 FROM LopHocPhan WHERE MaLHP = @MaLHP)
        BEGIN
            RAISERROR (N'Lớp học phần không tồn tại', 16, 1);
            RETURN;
        END;
        
        IF EXISTS (SELECT 1 FROM DangKyHocPhan WHERE MaSV = @MaSV AND MaLHP = @MaLHP)
        BEGIN
            RAISERROR (N'Sinh viên đã đăng ký lớp này', 16, 1);
            RETURN;
        END;
        
        INSERT INTO DangKyHocPhan (MaSV, MaLHP, NgayDangKy, TrangThai)
        VALUES (@MaSV, @MaLHP, GETDATE(), N'Đăng ký');
        
        PRINT N'✓ Đăng ký học phần thành công';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR (@ErrorMsg, 16, 1);
    END CATCH
END
GO

PRINT N'✓ Created sp_RegisterCourse';
GO
