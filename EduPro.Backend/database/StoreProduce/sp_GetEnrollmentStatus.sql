-- =============================================
-- STORED PROCEDURE: sp_GetEnrollmentStatus
-- Lấy thông tin kết quả đăng ký học phần của sinh viên
-- =============================================

USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_GetEnrollmentStatus')
    DROP PROCEDURE sp_GetEnrollmentStatus;
GO

CREATE PROCEDURE sp_GetEnrollmentStatus
    @MaSV NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        dk.Id,
        dk.MaSV,
        dk.MaLHP,
        lhp.MaHP,
        hp.TenHP,
        hp.SoTinChi,
        lhp.MaGV,
        gv.HoTen AS TenGiangVien,
        lhp.NgayBatDau,
        lhp.NgayKetThuc,
        lhp.SoBuoiHoc,
        lhp.SoBuoiTrongTuan,
        dk.TrangThai,
        lhp.TrangThaiLop,
        dk.NgayDangKy,
        lhp.MaPhong,
        lhp.ThuTrongTuan
    FROM
        DangKyHocPhan dk
    INNER JOIN LopHocPhan lhp ON dk.MaLHP = lhp.MaLHP
    INNER JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    INNER JOIN GiangVien gv ON lhp.MaGV = gv.MaGV
    WHERE
        dk.MaSV = @MaSV
    ORDER BY
        lhp.NgayBatDau DESC, dk.NgayDangKy DESC;
END
GO

PRINT N'✓ Created sp_GetEnrollmentStatus';
GO
