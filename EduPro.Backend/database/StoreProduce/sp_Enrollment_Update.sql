USE EduProDb;
GO

-- =============================================
-- UPDATE GROUP 4: ENROLLMENT (ĐĂNG KÝ HỌC PHẦN)
-- =============================================

-- 7. SP Lấy danh sách Lớp mở cho đăng ký (Updated with Filters)
IF OBJECT_ID ('sp_LayDanhSachLopMo', 'P') IS NOT NULL
DROP PROC sp_LayDanhSachLopMo;
GO
CREATE PROCEDURE sp_LayDanhSachLopMo
    @MaNam NVARCHAR(10) = NULL,
    @MaHK NVARCHAR(10) = NULL
AS
BEGIN
    SELECT 
        lhp.MaLHP,
        lhp.MaHP, hp.TenHP, hp.SoTinChi,
        lhp.SiSoToiDa,
        (SELECT COUNT(*) FROM DangKyHocPhan dk WHERE dk.MaLHP = lhp.MaLHP AND dk.TrangThai != N'Hủy') AS SiSoHienTai,
        gv.HoTen AS GiangVien,
        N'Thứ ' + CAST(lhp.ThuTrongTuan AS NVARCHAR) + N', ' + ca.MoTa + N', ' + ph.TenPhong AS LichHoc,
        lhp.MaHK, lhp.MaNam,
        lhp.TrangThaiLop,
        CASE 
            WHEN lhp.TrangThaiLop IN (N'Sắp khai giảng', N'Sap khai giang') THEN 'PLANNED'
            WHEN lhp.TrangThaiLop = N'Đang học' THEN 'ONGOING'
            WHEN lhp.TrangThaiLop = N'Kết thúc' THEN 'CLOSED'
            WHEN lhp.TrangThaiLop = N'Hủy' THEN 'CANCELED'
            ELSE 'PLANNED'
        END AS TrangThaiCode,
        CASE 
            WHEN lhp.TrangThaiLop NOT IN (N'Sắp khai giảng', N'Sap khai giang') THEN 0
            WHEN hk.ChoPhepDangKy = 0 THEN 0
            WHEN hk.NgayBatDauDangKy IS NOT NULL AND hk.NgayBatDauDangKy > GETDATE() THEN 0
            WHEN hk.NgayKetThucDangKy IS NOT NULL AND hk.NgayKetThucDangKy < GETDATE() THEN 0
            WHEN (SELECT COUNT(*) FROM DangKyHocPhan dk WHERE dk.MaLHP = lhp.MaLHP AND dk.TrangThai != N'Hủy') >= lhp.SiSoToiDa THEN 0
            ELSE 1
        END AS CoTheDangKy,
        CASE 
            WHEN lhp.TrangThaiLop NOT IN (N'Sắp khai giảng', N'Sap khai giang') THEN N'Lớp không mở đăng ký'
            WHEN hk.ChoPhepDangKy = 0 THEN N'Không trong thời gian đăng ký'
            WHEN hk.NgayBatDauDangKy IS NOT NULL AND hk.NgayBatDauDangKy > GETDATE() THEN N'Chưa đến thời gian đăng ký'
            WHEN hk.NgayKetThucDangKy IS NOT NULL AND hk.NgayKetThucDangKy < GETDATE() THEN N'Đã hết thời gian đăng ký'
            WHEN (SELECT COUNT(*) FROM DangKyHocPhan dk WHERE dk.MaLHP = lhp.MaLHP AND dk.TrangThai != N'Hủy') >= lhp.SiSoToiDa THEN N'Lớp đã đầy'
            ELSE NULL
        END AS LyDoKhongDangKy
    FROM LopHocPhan lhp
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    JOIN GiangVien gv ON lhp.MaGV = gv.MaGV
    JOIN PhongHoc ph ON lhp.MaPhong = ph.MaPhong
    JOIN CaHoc ca ON lhp.MaCa = ca.MaCa
    LEFT JOIN HocKy hk ON hk.MaHK = lhp.MaHK
    WHERE (@MaNam IS NULL OR lhp.MaNam = @MaNam)
      AND (@MaHK IS NULL OR lhp.MaHK = @MaHK)
      AND (lhp.TrangThaiLop IS NULL OR lhp.TrangThaiLop IN (N'Sắp khai giảng', N'Sap khai giang'))
    ORDER BY lhp.MaLHP;
END;
GO
