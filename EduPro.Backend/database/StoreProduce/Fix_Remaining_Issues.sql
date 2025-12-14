USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- FIX REMAINING ENCODING ISSUES

-- 1. FIX HOCKY - CẤU TRÚC đúng theo MaHK
UPDATE HocKy SET TenHK = N'Học kỳ 1' WHERE MaHK LIKE '%1%' AND MaHK NOT LIKE '%HKH%';
UPDATE HocKy SET TenHK = N'Học kỳ 2' WHERE MaHK LIKE '%2%' AND MaHK NOT LIKE '%HKH%';
UPDATE HocKy SET TenHK = N'Học kỳ Hè' WHERE MaHK LIKE '%HKH%' OR MaHK LIKE '%H%';

-- 2. FIX HOCPHAN - FIX TẤT CẢ CORRUPTED DATA
UPDATE HocPhan SET TenHP = N'Nhập môn lập trình' WHERE MaHP = N'CNTT001';
UPDATE HocPhan SET TenHP = N'Cơ sở dữ liệu' WHERE MaHP = N'CNTT002';
UPDATE HocPhan SET TenHP = N'Cấu trúc dữ liệu' WHERE MaHP = N'CNTT003';
UPDATE HocPhan SET TenHP = N'Lập trình hướng đối tượng' WHERE MaHP = N'CNTT004';
UPDATE HocPhan SET TenHP = N'Mạng máy tính' WHERE MaHP = N'CNTT005';
UPDATE HocPhan SET TenHP = N'Giải tích 1' WHERE MaHP = N'MATH001';
UPDATE HocPhan SET TenHP = N'Xác suất thống kê' WHERE MaHP = N'MATH002';
UPDATE HocPhan SET TenHP = N'Tiếng Anh 1' WHERE MaHP = N'ENG001';
UPDATE HocPhan SET TenHP = N'Tiếng Anh 2' WHERE MaHP = N'ENG002';
UPDATE HocPhan SET TenHP = N'Trí tuệ nhân tạo' WHERE MaHP = N'AI01';
UPDATE HocPhan SET TenHP = N'Tiếng Anh 1' WHERE MaHP = N'ANH01';
UPDATE HocPhan SET TenHP = N'Tiếng Anh 2' WHERE MaHP = N'ANH02';
UPDATE HocPhan SET TenHP = N'Tiếng Anh 3' WHERE MaHP = N'ANH03';
UPDATE HocPhan SET TenHP = N'Tiếng Anh chuyên ngành CNTT' WHERE MaHP = N'ANH04';

PRINT N'✓ Remaining Encoding Issues Fixed';
GO
