USE EduProDb;
GO

-- =============================================
-- GROUP 7: STUDENT PROFILE
-- =============================================

-- 15. SP Lấy thông tin chi tiết sinh viên
IF OBJECT_ID ('sp_LayThongTinSinhVien', 'P') IS NOT NULL
DROP PROC sp_LayThongTinSinhVien;
GO
CREATE PROCEDURE sp_LayThongTinSinhVien
    @MaSV NVARCHAR(10)
AS
BEGIN
    SELECT 
        sv.MaSV,
        sv.HoTen,
        sv.NgaySinh,
        sv.GioiTinh,
        sv.Email,
        sv.DienThoai,
        sv.LopHanhChinh,
        sv.MaNganh,
        n.TenNganh,
        sv.MaKhoaTS,
        kts.TenKhoaTS,
        sv.TrangThai
    FROM SinhVien sv
    JOIN Nganh n ON sv.MaNganh = n.MaNganh
    JOIN KhoaTuyenSinh kts ON sv.MaKhoaTS = kts.MaKhoaTS
    WHERE sv.MaSV = @MaSV;
END;
GO