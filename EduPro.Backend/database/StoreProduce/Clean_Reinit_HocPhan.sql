USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- CLEAN & REINIT HOCPHAN WITH CORRECT UTF-8 ENCODING
-- =============================================================

-- Delete all HocPhan with encoding issues
DELETE FROM HocPhan WHERE MaHP NOT IN (
    N'CNTT001', N'CNTT002', N'CNTT003', N'CNTT004', N'CNTT005',
    N'MATH001', N'MATH002',
    N'ENG001', N'ENG002',
    N'AI01', N'ANH01', N'ANH02', N'ANH03', N'ANH04',
    N'BLOCKCHAIN', N'CLOUD'
);

-- Clean up corrupted entries
DELETE FROM HocPhan WHERE TenHP LIKE '%Trí tuệ nhân tạo%' AND MaHP NOT IN (N'AI01');
DELETE FROM HocPhan WHERE TenHP LIKE '%Ä%' OR TenHP LIKE '%á»%' OR TenHP LIKE '%Ã%';

-- Reinit all HocPhan with correct UTF-8
INSERT INTO HocPhan (MaHP, TenHP, SoTinChi, SoTietLT, SoTietTH, BatBuoc, LoaiHocPhan)
VALUES
    (N'CSDL', N'Cơ sở dữ liệu', 3, 30, 30, 1, N'Lý thuyết'),
    (N'CTDL', N'Cấu trúc dữ liệu', 3, 30, 30, 1, N'Lý thuyết'),
    (N'DATN', N'Đề án tốt nghiệp', 6, 0, 60, 1, N'Thực hành'),
    (N'DDHCM', N'Đường Cộng sản Việt Nam', 2, 30, 0, 0, N'Lý thuyết'),
    (N'DOTNET', N'Lập trình .NET', 3, 30, 30, 1, N'Lý thuyết'),
    (N'GAME01', N'Phát triển Game', 3, 30, 30, 1, N'Thực hành'),
    (N'GDQP01', N'Giáo dục quốc phòng - An ninh', 1, 15, 0, 1, N'Lý thuyết'),
    (N'GDTC01', N'Giáo dục thể chất 1', 1, 0, 30, 1, N'Thực hành'),
    (N'HDH', N'Hệ điều hành', 3, 30, 30, 1, N'Lý thuyết'),
    (N'HTTT', N'Hệ thống thông tin', 3, 30, 30, 1, N'Lý thuyết'),
    (N'IOT01', N'Internet vạn vật (IoT)', 3, 30, 30, 1, N'Lý thuyết'),
    (N'IT001', N'Lập trình C', 3, 30, 30, 1, N'Lý thuyết'),
    (N'IT002', N'Lập trình C++', 3, 30, 30, 1, N'Lý thuyết'),
    (N'IT003', N'Cơ sở dữ liệu SQL', 3, 30, 30, 1, N'Lý thuyết'),
    (N'JAVA', N'Lập trình Java', 3, 30, 30, 1, N'Lý thuyết'),
    (N'KHDL', N'Khoa học dữ liệu', 3, 30, 30, 1, N'Lý thuyết'),
    (N'KTPM', N'Công nghệ phần mềm', 3, 30, 30, 1, N'Lý thuyết'),
    (N'MLCT', N'Những nguyên lý cơ bản của Chủ nghĩa Mác - Lênin', 2, 30, 0, 0, N'Lý thuyết'),
    (N'MMT', N'Mạng máy tính', 3, 30, 30, 1, N'Lý thuyết'),
    (N'MOBILE', N'Phát triển ứng dụng di động', 3, 30, 30, 1, N'Thực hành'),
    (N'NMLT', N'Nhập môn lập trình', 3, 30, 30, 1, N'Lý thuyết'),
    (N'OOP', N'Lập trình hướng đối tượng', 4, 40, 40, 1, N'Lý thuyết'),
    (N'PTTKHT', N'Phân tích thiết kế hệ thống', 3, 30, 30, 1, N'Lý thuyết'),
    (N'PYTHON', N'Lập trình Python', 3, 30, 30, 1, N'Lý thuyết'),
    (N'TIN01', N'Tin học đại cương', 3, 30, 30, 1, N'Lý thuyết'),
    (N'TOAN01', N'Toán cao cấp A1', 3, 40, 0, 1, N'Lý thuyết'),
    (N'TOAN02', N'Toán cao cấp A2', 3, 40, 0, 1, N'Lý thuyết');

PRINT N'✓ HocPhan Cleaned & Reinitialized with Correct UTF-8 Encoding';
GO
