-- =============================================
-- STORED PROCEDURE: sp_UpdateClassStatus
-- Cập nhật trạng thái lớp học phần (chuẩn MaLHP)
-- =============================================

USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_UpdateClassStatus')
    DROP PROCEDURE sp_UpdateClassStatus;
GO

CREATE PROCEDURE sp_UpdateClassStatus
    @MaLHP NVARCHAR(20),
    @TrangThaiLop NVARCHAR(50),
    @NgayBatDau DATE = NULL,
    @NgayKetThuc DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        IF @TrangThaiLop NOT IN (N'Sắp khai giảng', N'Đang khai giảng', N'Kết thúc', N'Hủy')
        BEGIN
            RAISERROR (N'Trạng thái lớp không hợp lệ', 16, 1);
            RETURN;
        END;
        
        IF @NgayBatDau IS NOT NULL AND @NgayKetThuc IS NOT NULL AND @NgayKetThuc < @NgayBatDau
        BEGIN
            RAISERROR (N'Ngày kết thúc không thể trước ngày bắt đầu', 16, 1);
            RETURN;
        END;
        
        UPDATE LopHocPhan
        SET TrangThaiLop = @TrangThaiLop,
            NgayBatDau = ISNULL(@NgayBatDau, NgayBatDau),
            NgayKetThuc = ISNULL(@NgayKetThuc, NgayKetThuc)
        WHERE MaLHP = @MaLHP;
        
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR (N'Không tìm thấy lớp học phần', 16, 1);
            RETURN;
        END;
        
        PRINT N'✓ Cập nhật trạng thái lớp thành công';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMsg NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR (@ErrorMsg, 16, 1);
    END CATCH
END
GO

PRINT N'✓ Created sp_UpdateClassStatus';
GO
