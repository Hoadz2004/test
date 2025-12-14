USE EduProDb1;
GO

-- 8. SP Lấy danh sách lớp học phần đang mở cho đăng ký
-- Logic: Lấy các lớp thuộc học kỳ đang cho phép đăng ký
IF OBJECT_ID (
    'sp_LayDanhSachLopHocPhanMo',
    'P'
) IS NOT NULL
DROP PROC sp_LayDanhSachLopHocPhanMo;
GO
CREATE PROCEDURE sp_LayDanhSachLopHocPhanMo
AS
BEGIN
    SELECT 
        lhp.MaLHP,
        hp.TenHP,
        hp.SoTinChi,
        lhp.SiSoToiDa,
        (SELECT COUNT(*) FROM DangKyHocPhan dk WHERE dk.MaLHP = lhp.MaLHP AND dk.TrangThai != N'Hủy') AS SiSoHienTai,
        gv.HoTen AS GiangVien,
        lhp.ThuTrongTuan,
        lhp.MaCa,
        lhp.MaPhong
    FROM LopHocPhan lhp
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    JOIN HocKy hk ON lhp.MaHK = hk.MaHK
    LEFT JOIN GiangVien gv ON lhp.MaGV = gv.MaGV
    WHERE hk.ChoPhepDangKy = 1
    AND (hk.NgayBatDauDangKy IS NULL OR hk.NgayBatDauDangKy <= GETDATE())
    AND (hk.NgayKetThucDangKy IS NULL OR hk.NgayKetThucDangKy >= GETDATE());
END;
GO

-- 9. SP Lấy kết quả đăng ký của sinh viên
IF OBJECT_ID ('sp_LayKetQuaDangKy', 'P') IS NOT NULL
DROP PROC sp_LayKetQuaDangKy;
GO
CREATE PROCEDURE sp_LayKetQuaDangKy
    @MaSV NVARCHAR(10)
AS
BEGIN
    SELECT 
        dk.MaLHP,
        hp.TenHP,
        hp.SoTinChi,
        lhp.ThuTrongTuan,
        lhp.MaCa,
        lhp.MaPhong,
        dk.TrangThai,
        dk.NgayDangKy
    FROM DangKyHocPhan dk
    JOIN LopHocPhan lhp ON dk.MaLHP = lhp.MaLHP
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    WHERE dk.MaSV = @MaSV AND dk.TrangThai != N'Hủy'
    ORDER BY dk.NgayDangKy DESC;
END;
GO