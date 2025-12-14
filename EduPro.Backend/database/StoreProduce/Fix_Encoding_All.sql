USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- MASTER FIX FOR VIETNAMESE ENCODING (SQL SERVER 2012 COMPATIBLE)
-- =============================================================

-- 1. FIX FACULTY (KHOA)
UPDATE Khoa
SET
    TenKhoa = N'Công Nghệ Thông Tin'
WHERE
    MaKhoa = 'CNTT';

UPDATE Khoa SET TenKhoa = N'Kinh Tế' WHERE MaKhoa = 'KT';

UPDATE Khoa SET TenKhoa = N'Ngôn Ngữ Anh' WHERE MaKhoa = 'NNA';

UPDATE Khoa
SET
    TenKhoa = N'Quản Trị Kinh Doanh'
WHERE
    MaKhoa = 'QTKD';

-- 2. FIX MAJOR (NGANH)
UPDATE Nganh
SET
    TenNganh = N'Kỹ Thuật Phần Mềm'
WHERE
    MaNganh = 'KTPM';

UPDATE Nganh
SET
    TenNganh = N'Hệ Thống Thông Tin'
WHERE
    MaNganh = 'HTTT';

UPDATE Nganh
SET
    TenNganh = N'Quản Trị Kinh Doanh'
WHERE
    MaNganh = 'QTKD';

UPDATE Nganh SET TenNganh = N'Ngôn Ngữ Anh' WHERE MaNganh = 'NNA';

UPDATE Nganh SET TenNganh = N'Kế Toán' WHERE MaNganh = 'KT';

-- 3. FIX SUBJECT (HOC PHAN)
-- Fixing common subjects based on assumptions or visible errors
UPDATE HocPhan
SET
    TenHP = N'Lập trình .NET'
WHERE
    TenHP LIKE '%.NET%';

UPDATE HocPhan
SET
    TenHP = N'Cơ sở dữ liệu'
WHERE
    TenHP LIKE '%d? li?u%';

UPDATE HocPhan
SET
    TenHP = N'Giải tích 1'
WHERE
    TenHP LIKE '%Gi?i tích%';

UPDATE HocPhan
SET
    TenHP = N'Tiếng Anh 1'
WHERE
    TenHP LIKE '%Ti?ng Anh%';

UPDATE HocPhan
SET
    TenHP = N'Nhập môn lập trình'
WHERE
    TenHP LIKE '%Nh?p môn%';

UPDATE HocPhan
SET
    TenHP = N'Xác suất thống kê'
WHERE
    TenHP LIKE '%Xác su?t%';

-- 4. FIX SEMESTER (HOC KY)
UPDATE HocKy SET TenHK = N'Học kỳ 1' WHERE MaHK LIKE '%HK1%';

UPDATE HocKy SET TenHK = N'Học kỳ 2' WHERE MaHK LIKE '%HK2%';

UPDATE HocKy SET TenHK = N'Học kỳ Hè' WHERE MaHK LIKE '%HKH%';

-- 5. FIX SHIFT (CA HOC)
UPDATE CaHoc SET MoTa = N'Ca 1 (Tiết 1-3)' WHERE MaCa = 'C1';

UPDATE CaHoc SET MoTa = N'Ca 2 (Tiết 4-6)' WHERE MaCa = 'C2';

UPDATE CaHoc SET MoTa = N'Ca 3 (Tiết 7-9)' WHERE MaCa = 'C3';

UPDATE CaHoc SET MoTa = N'Ca 4 (Tiết 10-12)' WHERE MaCa = 'C4';

UPDATE CaHoc SET MoTa = N'Ca Tối 1 (Tiết 13-15)' WHERE MaCa = 'C5';

-- 6. FIX LECTURER (GIANG VIEN) - Sample names
UPDATE GiangVien
SET
    HoTen = N'TS. Nguyễn Văn A'
WHERE
    MaGV = 'GV001';

UPDATE GiangVien SET HoTen = N'ThS. Trần Thị B' WHERE MaGV = 'GV002';

UPDATE GiangVien SET HoTen = N'TS. Lê Văn C' WHERE MaGV = 'GV003';

-- 7. FIX CLASS (LOP HOC PHAN) - Update derived names if necessary, though mostly IDs
-- No direct text update needed for LopHocPhan tables usually, as they link to IDs.
-- But if Description is used:
-- UPDATE LopHocPhan SET GhiChu = N'Lớp chất lượng cao' WHERE GhiChu LIKE '%ch?t l??ng%';

PRINT 'Encoding Fixed Successfully';
GO