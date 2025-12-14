USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- FIX HOCPHAN ENCODING - DIRECT UPDATE ONLY
-- =============================================================

-- Fix existing corrupted HocPhan
UPDATE HocPhan SET TenHP = N'Cơ sở dữ liệu' WHERE MaHP = N'CSDL';
UPDATE HocPhan SET TenHP = N'Cấu trúc dữ liệu' WHERE MaHP = N'CTDL';
UPDATE HocPhan SET TenHP = N'Đề án tốt nghiệp' WHERE MaHP = N'DATN';
UPDATE HocPhan SET TenHP = N'Đường Cộng sản Việt Nam' WHERE MaHP = N'DDHCM';
UPDATE HocPhan SET TenHP = N'Lập trình .NET' WHERE MaHP = N'DOTNET';
UPDATE HocPhan SET TenHP = N'Phát triển Game' WHERE MaHP = N'GAME01';
UPDATE HocPhan SET TenHP = N'Giáo dục quốc phòng - An ninh' WHERE MaHP = N'GDQP01';
UPDATE HocPhan SET TenHP = N'Giáo dục thể chất 1' WHERE MaHP = N'GDTC01';
UPDATE HocPhan SET TenHP = N'Hệ điều hành' WHERE MaHP = N'HDH';
UPDATE HocPhan SET TenHP = N'Hệ thống thông tin' WHERE MaHP = N'HTTT';
UPDATE HocPhan SET TenHP = N'Internet vạn vật (IoT)' WHERE MaHP = N'IOT01';
UPDATE HocPhan SET TenHP = N'Lập trình C' WHERE MaHP = N'IT001';
UPDATE HocPhan SET TenHP = N'Lập trình C++' WHERE MaHP = N'IT002';
UPDATE HocPhan SET TenHP = N'Cơ sở dữ liệu SQL' WHERE MaHP = N'IT003';
UPDATE HocPhan SET TenHP = N'Lập trình Java' WHERE MaHP = N'JAVA';
UPDATE HocPhan SET TenHP = N'Khoa học dữ liệu' WHERE MaHP = N'KHDL';
UPDATE HocPhan SET TenHP = N'Công nghệ phần mềm' WHERE MaHP = N'KTPM';
UPDATE HocPhan SET TenHP = N'Những nguyên lý cơ bản của Chủ nghĩa Mác - Lênin' WHERE MaHP = N'MLCT';
UPDATE HocPhan SET TenHP = N'Mạng máy tính' WHERE MaHP = N'MMT';
UPDATE HocPhan SET TenHP = N'Phát triển ứng dụng di động' WHERE MaHP = N'MOBILE';
UPDATE HocPhan SET TenHP = N'Nhập môn lập trình' WHERE MaHP = N'NMLT';
UPDATE HocPhan SET TenHP = N'Lập trình hướng đối tượng' WHERE MaHP = N'OOP';
UPDATE HocPhan SET TenHP = N'Phân tích thiết kế hệ thống' WHERE MaHP = N'PTTKHT';
UPDATE HocPhan SET TenHP = N'Lập trình Python' WHERE MaHP = N'PYTHON';
UPDATE HocPhan SET TenHP = N'Tin học đại cương' WHERE MaHP = N'TIN01';
UPDATE HocPhan SET TenHP = N'Toán cao cấp A1' WHERE MaHP = N'TOAN01';
UPDATE HocPhan SET TenHP = N'Toán cao cấp A2' WHERE MaHP = N'TOAN02';

-- Make sure LoaiHocPhan is set correctly
UPDATE HocPhan SET LoaiHocPhan = N'Lý thuyết' WHERE LoaiHocPhan IS NULL OR LoaiHocPhan = N'';

PRINT N'✓ All HocPhan Fixed with Correct UTF-8 Encoding';
GO
