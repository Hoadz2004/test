-- =============================================
-- THÊM DỮ LIỆU MẪU NHẬT KÝ HOẠT ĐỘNG CHO CÁC SINH VIÊN
-- =============================================

USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- Thêm dữ liệu mẫu nhật ký hoạt động cho sinh viên khóa 2022
INSERT INTO NhatKyHoatDong (TenDangNhap, LoaiHoatDong, MoDun, MoTa, DiaChiIP, TrangThai, NgayGio)
SELECT 
    'sv2022001', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.20', 'SUCCESS', '2025-12-10 08:30:00'
UNION ALL
SELECT 'sv2022001', 'VIEW', 'Dashboard', N'Xem trang chủ', '192.168.1.20', 'SUCCESS', '2025-12-10 08:35:00'
UNION ALL
SELECT 'sv2022001', 'VIEW', 'Courses', N'Xem danh sách học phần', '192.168.1.20', 'SUCCESS', '2025-12-10 08:40:00'
UNION ALL
SELECT 'sv2022001', 'LOGOUT', 'Authentication', N'Đăng xuất hệ thống', '192.168.1.20', 'SUCCESS', '2025-12-10 09:00:00'
UNION ALL
SELECT 'sv2022001', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.20', 'SUCCESS', '2025-12-11 07:45:00'
UNION ALL
SELECT 'sv2022001', 'VIEW', 'Dashboard', N'Xem trang chủ', '192.168.1.20', 'SUCCESS', '2025-12-11 07:50:00'
UNION ALL
SELECT 'sv2022001', 'VIEW', 'Grades', N'Xem điểm', '192.168.1.20', 'SUCCESS', '2025-12-11 08:00:00'
UNION ALL
SELECT '2022002', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.21', 'SUCCESS', '2025-12-10 09:15:00'
UNION ALL
SELECT '2022002', 'VIEW', 'Dashboard', N'Xem trang chủ', '192.168.1.21', 'SUCCESS', '2025-12-10 09:20:00'
UNION ALL
SELECT '2022002', 'LOGOUT', 'Authentication', N'Đăng xuất hệ thống', '192.168.1.21', 'SUCCESS', '2025-12-10 10:00:00'
UNION ALL
SELECT '2022003', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.22', 'SUCCESS', '2025-12-11 06:30:00'
UNION ALL
SELECT '2022003', 'VIEW', 'Courses', N'Xem danh sách học phần', '192.168.1.22', 'SUCCESS', '2025-12-11 06:35:00'
UNION ALL
SELECT '2022004', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.23', 'SUCCESS', '2025-12-11 10:15:00'
UNION ALL
SELECT '2022004', 'VIEW', 'Dashboard', N'Xem trang chủ', '192.168.1.23', 'SUCCESS', '2025-12-11 10:20:00'
UNION ALL
SELECT '2022005', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.24', 'FAILED', '2025-12-10 11:00:00'
UNION ALL
SELECT '2022005', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.24', 'SUCCESS', '2025-12-10 11:05:00'
UNION ALL
SELECT '2022006', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.25', 'SUCCESS', '2025-12-09 08:00:00'
UNION ALL
SELECT '2022007', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.26', 'SUCCESS', '2025-12-11 07:00:00'
UNION ALL
SELECT '2022008', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.27', 'SUCCESS', '2025-12-10 14:30:00'
UNION ALL
SELECT '2022009', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.28', 'SUCCESS', '2025-12-08 09:00:00'
UNION ALL
-- Sinh viên khóa 2023
SELECT '2023001', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.30', 'SUCCESS', '2025-12-11 08:30:00'
UNION ALL
SELECT '2023001', 'VIEW', 'Dashboard', N'Xem trang chủ', '192.168.1.30', 'SUCCESS', '2025-12-11 08:35:00'
UNION ALL
SELECT '2023002', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.31', 'SUCCESS', '2025-12-10 10:00:00'
UNION ALL
SELECT '2023003', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.32', 'SUCCESS', '2025-12-11 09:00:00'
UNION ALL
SELECT '2023004', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.33', 'FAILED', '2025-12-11 06:00:00'
UNION ALL
SELECT '2023004', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.33', 'SUCCESS', '2025-12-11 06:05:00'
UNION ALL
SELECT '2023005', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.34', 'SUCCESS', '2025-12-09 15:00:00'
UNION ALL
SELECT '2023006', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.35', 'SUCCESS', '2025-12-11 10:30:00'
UNION ALL
SELECT '2023007', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.36', 'SUCCESS', '2025-12-07 11:00:00'
UNION ALL
SELECT '2023008', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.37', 'SUCCESS', '2025-12-10 08:00:00'
UNION ALL
-- Sinh viên khóa 2024
SELECT '2024001', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.40', 'SUCCESS', '2025-12-11 07:30:00'
UNION ALL
SELECT '2024001', 'VIEW', 'Courses', N'Xem danh sách học phần', '192.168.1.40', 'SUCCESS', '2025-12-11 07:35:00'
UNION ALL
SELECT '2024002', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.41', 'SUCCESS', '2025-12-10 09:00:00'
UNION ALL
SELECT '2024003', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.42', 'SUCCESS', '2025-12-11 08:15:00'
UNION ALL
SELECT '2024004', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.43', 'SUCCESS', '2025-12-09 10:00:00'
UNION ALL
SELECT '2024005', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.44', 'FAILED', '2025-12-11 06:30:00'
UNION ALL
SELECT '2024006', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.45', 'SUCCESS', '2025-12-10 13:00:00'
UNION ALL
SELECT '2024007', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.46', 'SUCCESS', '2025-12-11 09:30:00'
UNION ALL
SELECT '2024008', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.47', 'SUCCESS', '2025-12-08 10:00:00'
UNION ALL
-- Sinh viên khóa 2021
SELECT '2021001', 'LOGIN', 'Authentication', N'Đăng nhập hệ thống', '192.168.1.10', 'SUCCESS', '2025-12-11 11:00:00'
UNION ALL
SELECT '2021001', 'VIEW', 'Dashboard', N'Xem trang chủ', '192.168.1.10', 'SUCCESS', '2025-12-11 11:05:00';

PRINT N'✓ Đã thêm dữ liệu mẫu nhật ký hoạt động cho các sinh viên!';
GO

-- Cập nhật LanDangNhapCuoi từ nhật ký hoạt động
UPDATE tk
SET tk.LanDangNhapCuoi = (
    SELECT MAX(nk.NgayGio)
    FROM NhatKyHoatDong nk
    WHERE nk.TenDangNhap = tk.TenDangNhap AND nk.LoaiHoatDong = 'LOGIN' AND nk.TrangThai = 'SUCCESS'
),
tk.DiaChiIPCuoi = (
    SELECT TOP 1 nk.DiaChiIP
    FROM NhatKyHoatDong nk
    WHERE nk.TenDangNhap = tk.TenDangNhap AND nk.LoaiHoatDong = 'LOGIN' AND nk.TrangThai = 'SUCCESS'
    ORDER BY nk.NgayGio DESC
)
FROM TaiKhoan tk
WHERE tk.MaVaiTro = 'SINHVIEN';

PRINT N'✓ Đã cập nhật LanDangNhapCuoi từ nhật ký hoạt động!';
GO

-- Kiểm tra kết quả
SELECT TOP 20 
    TenDangNhap,
    MaVaiTro,
    LanDangNhapCuoi,
    DiaChiIPCuoi,
    SoLanDangNhapThatBai,
    TrangThai
FROM TaiKhoan
WHERE MaVaiTro = 'SINHVIEN'
ORDER BY LanDangNhapCuoi DESC;

PRINT N'========================================';
PRINT N'✓ Nhật ký hoạt động đã được khởi tạo!';
PRINT N'========================================';
GO
