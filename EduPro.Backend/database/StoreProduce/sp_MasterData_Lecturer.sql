USE EduProDb;
GO

-- =============================================
-- GROUP 8: MASTER DATA (DANH MỤC DÙNG CHUNG)
-- =============================================

-- 16. SP Lấy danh sách Khoa
IF OBJECT_ID ('sp_LayDanhSachKhoa', 'P') IS NOT NULL
DROP PROC sp_LayDanhSachKhoa;
GO
CREATE PROCEDURE sp_LayDanhSachKhoa
AS
BEGIN
    SELECT MaKhoa AS Ma, TenKhoa AS Ten FROM Khoa WHERE TrangThai = 1;
END;
GO

-- 17. SP Lấy danh sách Ngành
IF OBJECT_ID ('sp_LayDanhSachNganh', 'P') IS NOT NULL
DROP PROC sp_LayDanhSachNganh;
GO
CREATE PROCEDURE sp_LayDanhSachNganh
AS
BEGIN
    SELECT MaNganh AS Ma, TenNganh AS Ten, MaKhoa FROM Nganh WHERE TrangThai = 1;
END;
GO

-- 18. SP Lấy danh sách Học Kỳ
IF OBJECT_ID ('sp_LayDanhSachHocKy', 'P') IS NOT NULL
DROP PROC sp_LayDanhSachHocKy;
GO
CREATE PROCEDURE sp_LayDanhSachHocKy
AS
BEGIN
    SELECT 
        MaHK AS Ma, 
        TenHK + N' (' + CAST(NgayBatDau AS NVARCHAR) + N' - ' + CAST(NgayKetThuc AS NVARCHAR) + N')' AS Ten 
    FROM HocKy
    ORDER BY NgayBatDau DESC;
END;
GO

-- =============================================
-- GROUP 9: LECTURER (GIẢNG VIÊN)
-- =============================================

-- 19. SP Lấy thông tin giảng viên
IF OBJECT_ID (
    'sp_LayThongTinGiangVien',
    'P'
) IS NOT NULL
DROP PROC sp_LayThongTinGiangVien;
GO
CREATE PROCEDURE sp_LayThongTinGiangVien
    @MaGV NVARCHAR(10)
AS
BEGIN
    SELECT 
        gv.MaGV,
        gv.HoTen,
        gv.Email,
        gv.DienThoai,
        gv.MaKhoa,
        k.TenKhoa
    FROM GiangVien gv
    JOIN Khoa k ON gv.MaKhoa = k.MaKhoa
    WHERE gv.MaGV = @MaGV;
END;
GO