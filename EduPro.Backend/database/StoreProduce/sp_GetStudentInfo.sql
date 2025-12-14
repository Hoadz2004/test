-- =============================================
-- STORED PROCEDURE: sp_GetStudentInfo
-- Lấy thông tin chi tiết sinh viên
-- =============================================

USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_GetStudentInfo')
    DROP PROCEDURE sp_GetStudentInfo;
GO

CREATE PROCEDURE sp_GetStudentInfo
    @MaSV NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        sv.MaSV,
        sv.HoTen,
        sv.NgaySinh,
        sv.GioiTinh,
        sv.DiaChi,
        sv.Email,
        sv.DienThoai,
        sv.MaNganh,
        n.TenNganh,
        sv.MaKhoaTS,
        kts.TenKhoaTS,
        sv.LopHanhChinh,
        sv.TrangThai
    FROM
        SinhVien sv
    LEFT JOIN Nganh n ON sv.MaNganh = n.MaNganh
    LEFT JOIN KhoaTuyenSinh kts ON sv.MaKhoaTS = kts.MaKhoaTS
    WHERE
        sv.MaSV = @MaSV;
    
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR (N'Không tìm thấy sinh viên', 16, 1);
    END
END
GO

PRINT N'✓ Created sp_GetStudentInfo';
GO
