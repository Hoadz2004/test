-- ============================================================================
-- Script: VERIFY_RealTime_ActivityLog.sql
-- Mục đích: Kiểm tra nhật ký hoạt động REAL-TIME từ các request API
-- Lưu ý: Chạy script này sau khi:
--   1. Đã integrate ActivityLogService vào Backend API
--   2. Đã chạy API server (dotnet run)
--   3. Đã gọi các endpoint API từ Frontend hoặc Postman
-- ============================================================================

-- 1. Kiểm tra NhatKyHoatDong mới nhất (từ 30 phút trước)
PRINT N'=== KIỂM TRA NHẬT KỲ HOẠT ĐỘNG MỚI NHẤT (Real-Time) ===';
SELECT TOP 20
    MaNhatKy,
    TenDangNhap,
    LoaiHoatDong,
    MoDun AS [Module/API],
    MoTa AS [Mô Tả],
    DiaChiIP AS [IP Address],
    TrangThai,
    NgayGio AS [Thời Gian],
    DATEDIFF(MINUTE, NgayGio, GETDATE()) AS [Phút Trước]
FROM dbo.NhatKyHoatDong
WHERE NgayGio >= DATEADD(MINUTE, -30, GETDATE())
ORDER BY MaNhatKy DESC;

-- 2. Thống kê hoạt động REAL-TIME (từ hôm nay)
PRINT N'=== THỐNG KÊ HOẠT ĐỘNG REAL-TIME (Hôm Nay) ===';
SELECT
    LoaiHoatDong,
    COUNT(*) AS [Tổng Số],
    SUM(CASE WHEN TrangThai = 'SUCCESS' THEN 1 ELSE 0 END) AS [Thành Công],
    SUM(CASE WHEN TrangThai = 'FAILED' THEN 1 ELSE 0 END) AS [Thất Bại],
    SUM(CASE WHEN TrangThai = 'ERROR' THEN 1 ELSE 0 END) AS [Lỗi]
FROM dbo.NhatKyHoatDong
WHERE CAST(NgayGio AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY LoaiHoatDong
ORDER BY [Tổng Số] DESC;

-- 3. Top 10 người dùng hoạt động nhất (Real-Time)
PRINT N'=== TOP 10 NGƯỜI DÙNG HOẠT ĐỘNG NHẤT (Real-Time Hôm Nay) ===';
SELECT TOP 10
    TenDangNhap,
    COUNT(*) AS [Số Lần Hoạt Động],
    MAX(NgayGio) AS [Hoạt Động Lần Cuối],
    COUNT(DISTINCT CAST(NgayGio AS DATE)) AS [Số Ngày]
FROM dbo.NhatKyHoatDong
WHERE CAST(NgayGio AS DATE) >= CAST(GETDATE() AS DATE) - 7
GROUP BY TenDangNhap
ORDER BY [Số Lần Hoạt Động] DESC;

-- 4. Kiểm tra tài khoản đã bị khóa (>= 5 lần đăng nhập thất bại)
PRINT N'=== KIỂM TRA TÀI KHOẢN BỊ KHÓA (Real-Time) ===';
SELECT
    TenDangNhap,
    SoLanDangNhapThatBai,
    TrangThai,
    DangNhapLanCuoi AS [Lần Đăng Nhập Cuối],
    DiaChiIPCuoi AS [IP Cuối]
FROM dbo.TaiKhoan
WHERE SoLanDangNhapThatBai >= 5 OR TrangThai = N'Bị Khóa'
ORDER BY SoLanDangNhapThatBai DESC;

-- 5. Xem chi tiết hoạt động của một người dùng (thay đổi TenDangNhap tại đây)
DECLARE @TenDangNhap NVARCHAR(50) = 'admin';

PRINT N'=== CHI TIẾT HOẠT ĐỘNG NGƯỜI DÙNG: ' + @TenDangNhap + ' (Real-Time) ===';
SELECT
    MaNhatKy,
    LoaiHoatDong,
    MoTa,
    DiaChiIP,
    TrangThai,
    NgayGio,
    FORMAT(NgayGio, 'dd/MM/yyyy HH:mm:ss') AS [Thời Gian Định Dạng]
FROM dbo.NhatKyHoatDong
WHERE TenDangNhap = @TenDangNhap
    AND NgayGio >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE))
ORDER BY MaNhatKy DESC;

-- 6. Kiểm tra tất cả API endpoint được gọi gần đây
PRINT N'=== API ENDPOINT ĐƯỢC GỌI GẦN ĐÂY (Real-Time) ===';
SELECT
    MoDun AS [API Endpoint],
    COUNT(*) AS [Số Lần Gọi],
    SUM(CASE WHEN TrangThai = 'SUCCESS' THEN 1 ELSE 0 END) AS [Thành Công],
    SUM(CASE WHEN TrangThai = 'FAILED' THEN 1 ELSE 0 END) AS [Thất Bại],
    MAX(NgayGio) AS [Gọi Lần Cuối]
FROM dbo.NhatKyHoatDong
WHERE NgayGio >= DATEADD(HOUR, -1, GETDATE())
GROUP BY MoDun
ORDER BY [Số Lần Gọi] DESC;

-- 7. Thống kê theo loại hoạt động (API CRUD)
PRINT N'=== THỐNG KÊ THEO LOẠI HOẠT ĐỘNG (View, Create, Update, Delete) ===';
SELECT
    LoaiHoatDong,
    COUNT(*) AS [Số Lần],
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dbo.NhatKyHoatDong WHERE NgayGio >= DATEADD(HOUR, -24, GETDATE())) AS DECIMAL(5,2)) AS [Phần Trăm],
    MIN(NgayGio) AS [Hoạt Động Đầu Tiên],
    MAX(NgayGio) AS [Hoạt Động Cuối Cùng]
FROM dbo.NhatKyHoatDong
WHERE NgayGio >= DATEADD(HOUR, -24, GETDATE())
GROUP BY LoaiHoatDong
ORDER BY [Số Lần] DESC;

-- 8. Báo cáo cảnh báo - Đăng nhập thất bại nhiều lần
PRINT N'=== CẢNH BÁO: ĐĂNG NHẬP THẤT BẠI NHIỀU LẦN ===';
SELECT
    TenDangNhap,
    COUNT(*) AS [Số Lần Thất Bại],
    MAX(NgayGio) AS [Lần Cuối Cùng],
    STRING_AGG(DISTINCT DiaChiIP, ', ') AS [IP Addresses]
FROM dbo.NhatKyHoatDong
WHERE LoaiHoatDong = 'LOGIN' 
    AND TrangThai = 'FAILED'
    AND NgayGio >= DATEADD(HOUR, -24, GETDATE())
GROUP BY TenDangNhap
HAVING COUNT(*) >= 3
ORDER BY [Số Lần Thất Bại] DESC;

-- 9. Kiểm tra lần đăng nhập cuối cùng của mỗi người dùng
PRINT N'=== LẦN ĐĂNG NHẬP CUỐI CÙNG (Real-Time) ===';
SELECT
    t.TenDangNhap,
    t.DangNhapLanCuoi,
    t.DiaChiIPCuoi,
    t.SoLanDangNhapThatBai,
    DATEDIFF(MINUTE, t.DangNhapLanCuoi, GETDATE()) AS [Phút Trước],
    CASE 
        WHEN t.DangNhapLanCuoi IS NULL THEN N'Chưa đăng nhập'
        WHEN DATEDIFF(MINUTE, t.DangNhapLanCuoi, GETDATE()) < 5 THEN N'Đang hoạt động'
        WHEN DATEDIFF(MINUTE, t.DangNhapLanCuoi, GETDATE()) < 30 THEN N'Hoạt động gần đây'
        ELSE N'Offline'
    END AS [Trạng Thái]
FROM dbo.TaiKhoan t
WHERE t.DangNhapLanCuoi IS NOT NULL
ORDER BY t.DangNhapLanCuoi DESC;

-- ============================================================================
-- HƯỚNG DẪN SỬ DỤNG:
-- ============================================================================
-- 1. Sau khi chạy API server (dotnet run), hãy gọi các endpoint:
--    POST http://localhost:5000/api/auth/login
--    POST http://localhost:5000/api/auth/logout
--    GET http://localhost:5000/api/student/list
--    
-- 2. Dữ liệu sẽ được ghi vào bảng NhatKyHoatDong REAL-TIME
--    
-- 3. Chạy script này để xem dữ liệu REAL-TIME được ghi từ API
--
-- 4. Kiểm tra Middleware đang chạy bằng cách:
--    - Xem request logs trong API console
--    - Xem dữ liệu mới trong SQL query trên
-- ============================================================================
