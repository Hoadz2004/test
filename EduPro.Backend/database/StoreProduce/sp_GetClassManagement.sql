-- =============================================
-- STORED PROCEDURE: sp_GetClassManagement
-- Lấy danh sách lớp học phần cho quản lý
-- =============================================

USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_GetClassManagement')
    DROP PROCEDURE sp_GetClassManagement;
GO

CREATE PROCEDURE sp_GetClassManagement
    @MaHK NVARCHAR(20) = NULL,
    @MaNam NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT
        lhp.MaLHP,
        lhp.MaHP,
        hp.TenHP,
        hp.SoTinChi,
        lhp.MaGV,
        gv.HoTen AS TenGiangVien,
        lhp.MaPhong,
        lhp.ThuTrongTuan,
        lhp.SoBuoiTrongTuan,
        lhp.SoBuoiHoc,
        lhp.NgayBatDau,
        lhp.NgayKetThuc,
        lhp.TrangThaiLop,
        lhp.SiSoToiDa,
        COUNT(dk.Id) AS SoSinhVienDangKy
    FROM
        LopHocPhan lhp
    INNER JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    INNER JOIN GiangVien gv ON lhp.MaGV = gv.MaGV
    LEFT JOIN DangKyHocPhan dk ON lhp.MaLHP = dk.MaLHP
    WHERE
        (@MaHK IS NULL OR lhp.MaHK = @MaHK)
        AND (@MaNam IS NULL OR lhp.MaNam = @MaNam)
    GROUP BY
        lhp.MaLHP,
        lhp.MaHP,
        hp.TenHP,
        hp.SoTinChi,
        lhp.MaGV,
        gv.HoTen,
        lhp.MaPhong,
        lhp.ThuTrongTuan,
        lhp.SoBuoiTrongTuan,
        lhp.SoBuoiHoc,
        lhp.NgayBatDau,
        lhp.NgayKetThuc,
        lhp.TrangThaiLop,
        lhp.SiSoToiDa
    ORDER BY
        lhp.MaHP, lhp.NgayBatDau DESC;
END
GO

PRINT N'✓ Created sp_GetClassManagement';
GO
