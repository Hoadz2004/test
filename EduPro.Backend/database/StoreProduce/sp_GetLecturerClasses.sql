-- =============================================
-- STORED PROCEDURE: sp_GetLecturerClasses
-- Lấy danh sách lớp học phần của giảng viên (MaLHP chuẩn)
-- =============================================

USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_GetLecturerClasses')
    DROP PROCEDURE sp_GetLecturerClasses;
GO

CREATE PROCEDURE sp_GetLecturerClasses
    @MaGV NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        lhp.MaLHP,
        lhp.MaHP,
        hp.TenHP,
        hp.SoTinChi,
        lhp.MaPhong,
        lhp.ThuTrongTuan,
        lhp.SoBuoiTrongTuan,
        lhp.SoBuoiHoc,
        lhp.NgayBatDau,
        lhp.NgayKetThuc,
        lhp.TrangThaiLop,
        lhp.MaHK,
        lhp.MaNam,
        lhp.SiSoToiDa,
        COUNT(dk.Id) AS SoSinhVien
    FROM LopHocPhan lhp
    INNER JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    LEFT JOIN DangKyHocPhan dk ON lhp.MaLHP = dk.MaLHP
    WHERE lhp.MaGV = @MaGV
    GROUP BY
        lhp.MaLHP,
        lhp.MaHP,
        hp.TenHP,
        hp.SoTinChi,
        lhp.MaPhong,
        lhp.ThuTrongTuan,
        lhp.SoBuoiTrongTuan,
        lhp.SoBuoiHoc,
        lhp.NgayBatDau,
        lhp.NgayKetThuc,
        lhp.TrangThaiLop,
        lhp.MaHK,
        lhp.MaNam,
        lhp.SiSoToiDa
    ORDER BY lhp.NgayBatDau DESC;
END
GO

PRINT N'✓ Created sp_GetLecturerClasses';
GO
