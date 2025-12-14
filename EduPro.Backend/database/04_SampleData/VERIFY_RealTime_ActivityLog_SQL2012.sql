-- ============================================================================
-- Script: VERIFY_RealTime_ActivityLog_SQL2012.sql
-- Mục đích: Kiểm tra nhật ký hoạt động REAL-TIME từ các request API
-- Tương thích: SQL Server 2012+
-- ============================================================================

-- 1. Kiểm tra NhatKyHoatDong mới nhất (từ 30 phút trước)
PRINT N'=== KIỂM TRA NHẬT KỲ HOẠT ĐỘNG MỚI NHẤT (Real-Time) ===';
SELECT TOP 20
    MaNhatKy,
    TenDangNhap,
    LoaiHoatDong,
    MoDun AS [Module/API],
    MoTa AS [Mo Ta],
    DiaChiIP AS [IP Address],
    TrangThai,
    NgayGio AS [Thoi Gian],
    DATEDIFF(MINUTE, NgayGio, GETDATE()) AS [Phut Truoc]
FROM dbo.NhatKyHoatDong
WHERE NgayGio >= DATEADD(MINUTE, -30, GETDATE())
ORDER BY MaNhatKy DESC;

-- 2. Thống kê hoạt động REAL-TIME (từ hôm nay)
PRINT N'=== THỐNG KÊ HOẠT ĐỘNG REAL-TIME (Hôm Nay) ===';
SELECT
    LoaiHoatDong,
    COUNT(*) AS [Tong So],
    SUM(CASE WHEN TrangThai = 'SUCCESS' THEN 1 ELSE 0 END) AS [Thanh Cong],
    SUM(CASE WHEN TrangThai = 'FAILED' THEN 1 ELSE 0 END) AS [That Bai],
    SUM(CASE WHEN TrangThai = 'ERROR' THEN 1 ELSE 0 END) AS [Loi]
FROM dbo.NhatKyHoatDong
WHERE CAST(NgayGio AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY LoaiHoatDong
ORDER BY [Tong So] DESC;

-- 3. Top 10 người dùng hoạt động nhất (Real-Time)
PRINT N'=== TOP 10 NGƯỜI DÙNG HOẠT ĐỘNG NHẤT (Real-Time) ===';
SELECT TOP 10
    TenDangNhap,
    COUNT(*) AS [So Lan Hoat Dong],
    MAX(NgayGio) AS [Hoat Dong Lan Cuoi],
    COUNT(DISTINCT CAST(NgayGio AS DATE)) AS [So Ngay]
FROM dbo.NhatKyHoatDong
WHERE NgayGio >= DATEADD(DAY, -7, GETDATE())
GROUP BY TenDangNhap
ORDER BY [So Lan Hoat Dong] DESC;

-- 4. Kiểm tra tài khoản đã bị khóa (>= 5 lần đăng nhập thất bại)
PRINT N'=== KIỂM TRA TÀI KHOẢN BỊ KHÓA (Real-Time) ===';
SELECT
    TenDangNhap,
    SoLanDangNhapThatBai,
    TrangThai,
    DangNhapLanCuoi AS [Lan Dang Nhap Cuoi],
    DiaChiIPCuoi AS [IP Cuoi]
FROM dbo.TaiKhoan
WHERE SoLanDangNhapThatBai >= 5 OR TrangThai = N'Bị Khóa'
ORDER BY SoLanDangNhapThatBai DESC;

-- 5. Xem chi tiết hoạt động của người dùng admin
DECLARE @TenDangNhap NVARCHAR(50) = 'admin';

PRINT N'=== CHI TIẾT HOẠT ĐỘNG NGƯỜI DÙNG: admin (Real-Time) ===';
SELECT
    MaNhatKy,
    LoaiHoatDong,
    MoTa,
    DiaChiIP,
    TrangThai,
    NgayGio,
    FORMAT(NgayGio, 'dd/MM/yyyy HH:mm:ss', 'vi-VN') AS [Thoi Gian Dinh Dang]
FROM dbo.NhatKyHoatDong
WHERE TenDangNhap = @TenDangNhap
    AND NgayGio >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE))
ORDER BY MaNhatKy DESC;

-- 6. Kiểm tra tất cả API endpoint được gọi gần đây
PRINT N'=== API ENDPOINT ĐƯỢC GỌI GẦN ĐÂY (Real-Time) ===';
SELECT
    MoDun AS [API Endpoint],
    COUNT(*) AS [So Lan Goi],
    SUM(CASE WHEN TrangThai = 'SUCCESS' THEN 1 ELSE 0 END) AS [Thanh Cong],
    SUM(CASE WHEN TrangThai = 'FAILED' THEN 1 ELSE 0 END) AS [That Bai],
    MAX(NgayGio) AS [Goi Lan Cuoi]
FROM dbo.NhatKyHoatDong
WHERE NgayGio >= DATEADD(HOUR, -1, GETDATE())
GROUP BY MoDun
ORDER BY [So Lan Goi] DESC;

-- 7. Thống kê theo loại hoạt động (View, Create, Update, Delete)
PRINT N'=== THỐNG KÊ THEO LOẠI HOẠT ĐỘNG (View, Create, Update, Delete) ===';
SELECT
    LoaiHoatDong,
    COUNT(*) AS [So Lan],
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dbo.NhatKyHoatDong WHERE NgayGio >= DATEADD(HOUR, -24, GETDATE())) AS DECIMAL(5,2)) AS [Phan Tram],
    MIN(NgayGio) AS [Hoat Dong Dau Tien],
    MAX(NgayGio) AS [Hoat Dong Cuoi Cung]
FROM dbo.NhatKyHoatDong
WHERE NgayGio >= DATEADD(HOUR, -24, GETDATE())
GROUP BY LoaiHoatDong
ORDER BY [So Lan] DESC;

-- 8. Báo cáo cảnh báo - Đăng nhập thất bại nhiều lần
PRINT N'=== CẢNH BÁO: ĐĂNG NHẬP THẤT BẠI NHIỀU LẦN ===';
SELECT
    TenDangNhap,
    COUNT(*) AS [So Lan That Bai],
    MAX(NgayGio) AS [Lan Cuoi Cung]
FROM dbo.NhatKyHoatDong
WHERE LoaiHoatDong = 'LOGIN' 
    AND TrangThai = 'FAILED'
    AND NgayGio >= DATEADD(HOUR, -24, GETDATE())
GROUP BY TenDangNhap
HAVING COUNT(*) >= 3
ORDER BY [So Lan That Bai] DESC;

-- 9. Kiểm tra lần đăng nhập cuối cùng của mỗi người dùng
PRINT N'=== LẦN ĐĂNG NHẬP CUỐI CÙNG (Real-Time) ===';
SELECT TOP 20
    t.TenDangNhap,
    t.DangNhapLanCuoi,
    t.DiaChiIPCuoi,
    t.SoLanDangNhapThatBai,
    DATEDIFF(MINUTE, t.DangNhapLanCuoi, GETDATE()) AS [Phut Truoc],
    CASE 
        WHEN t.DangNhapLanCuoi IS NULL THEN N'Chua dang nhap'
        WHEN DATEDIFF(MINUTE, t.DangNhapLanCuoi, GETDATE()) < 5 THEN N'Dang hoat dong'
        WHEN DATEDIFF(MINUTE, t.DangNhapLanCuoi, GETDATE()) < 30 THEN N'Hoat dong gan day'
        ELSE N'Offline'
    END AS [Trang Thai]
FROM dbo.TaiKhoan t
WHERE t.DangNhapLanCuoi IS NOT NULL
ORDER BY t.DangNhapLanCuoi DESC;

-- 10. Tóm tắt thông tin hệ thống
PRINT N'=== TÓM TẮT HỆ THỐNG (Real-Time) ===';
SELECT
    'Tong so ban ghi NhatKyHoatDong' AS [Thong Tin],
    CAST(COUNT(*) AS NVARCHAR(20)) AS [Gia Tri]
FROM dbo.NhatKyHoatDong
UNION ALL
SELECT
    'So nguoi dung co hoat dong',
    CAST(COUNT(DISTINCT TenDangNhap) AS NVARCHAR(20))
FROM dbo.NhatKyHoatDong
UNION ALL
SELECT
    'So tai khoan trong he thong',
    CAST(COUNT(*) AS NVARCHAR(20))
FROM dbo.TaiKhoan
UNION ALL
SELECT
    'So tai khoan bi khoa',
    CAST(COUNT(*) AS NVARCHAR(20))
FROM dbo.TaiKhoan
WHERE SoLanDangNhapThatBai >= 5 OR TrangThai = N'Bị Khóa'
UNION ALL
SELECT
    'Ban ghi hoat dong hom nay',
    CAST(COUNT(*) AS NVARCHAR(20))
FROM dbo.NhatKyHoatDong
WHERE CAST(NgayGio AS DATE) = CAST(GETDATE() AS DATE);

-- ============================================================================
-- HOÀN THÀNH KIỂM TRA
-- ============================================================================
PRINT N'========================================';
PRINT N'✓ Kiểm tra REAL-TIME Activity Log hoàn thành!';
PRINT N'========================================';
