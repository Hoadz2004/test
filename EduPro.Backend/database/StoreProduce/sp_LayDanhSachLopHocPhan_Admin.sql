USE EduProDb;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID (N'dbo.sp_LayDanhSachLopHocPhan_Admin', N'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_LayDanhSachLopHocPhan_Admin;
GO

CREATE PROCEDURE dbo.sp_LayDanhSachLopHocPhan_Admin
    @MaNam NVARCHAR(10) = NULL,
    @MaHK NVARCHAR(10) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT 
        lhp.MaLHP,
        lhp.MaHP, hp.TenHP, hp.SoTinChi,
        lhp.MaHK, hk.TenHK,
        lhp.MaNam, nh.NamBatDau,
        lhp.MaGV, gv.HoTen AS TenGV,
        lhp.MaPhong, ph.TenPhong,
        lhp.MaCa, ca.MoTa AS TenCa,
        lhp.ThuTrongTuan,
        lhp.SiSoToiDa,
        (SELECT COUNT(*) FROM DangKyHocPhan dk WHERE dk.MaLHP = lhp.MaLHP AND (dk.TrangThai IS NULL OR dk.TrangThai != N'Hủy')) AS SiSoHienTai,
        lhp.GhiChu,
        lhp.NgayBatDau,
        lhp.NgayKetThuc,
        lhp.SoBuoiHoc,
        lhp.SoBuoiTrongTuan,
        lhp.TrangThaiLop,
        lhp.MaKhoa,
        lhp.MaNganh,
        COUNT(*) OVER() AS TotalRecords
    FROM LopHocPhan lhp
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    JOIN HocKy hk ON lhp.MaHK = hk.MaHK
    JOIN NamHoc nh ON lhp.MaNam = nh.MaNam
    JOIN GiangVien gv ON lhp.MaGV = gv.MaGV
    JOIN PhongHoc ph ON lhp.MaPhong = ph.MaPhong
    JOIN CaHoc ca ON lhp.MaCa = ca.MaCa
    WHERE (@MaNam IS NULL OR lhp.MaNam = @MaNam)
      AND (@MaHK IS NULL OR lhp.MaHK = @MaHK)
    ORDER BY lhp.MaLHP DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END;
GO
