USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- FIX ENCODING FOR SCHEMA TABLE 1 (VIETNAMESE CHARACTERS)
-- SQL SERVER 2012 COMPATIBLE
-- =============================================================

-- 1. FIX KHOA (FACULTY)
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

-- 2. FIX NGANH (MAJOR/SPECIALIZATION)
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

-- 3. FIX KHOA TUYEN SINH (ADMISSION COHORT)
UPDATE KhoaTuyenSinh
SET
    TenKhoaTS = N'Khoá tuyển sinh 2020'
WHERE
    MaKhoaTS = 'KTS2020';

UPDATE KhoaTuyenSinh
SET
    TenKhoaTS = N'Khoá tuyển sinh 2021'
WHERE
    MaKhoaTS = 'KTS2021';

UPDATE KhoaTuyenSinh
SET
    TenKhoaTS = N'Khoá tuyển sinh 2022'
WHERE
    MaKhoaTS = 'KTS2022';

UPDATE KhoaTuyenSinh
SET
    TenKhoaTS = N'Khoá tuyển sinh 2023'
WHERE
    MaKhoaTS = 'KTS2023';

-- 4. FIX PHONG HOC (CLASSROOM)
UPDATE PhongHoc
SET
    TenPhong = N'Phòng học 101'
WHERE
    MaPhong LIKE '%101%';

UPDATE PhongHoc
SET
    TenPhong = N'Phòng học 102'
WHERE
    MaPhong LIKE '%102%';

UPDATE PhongHoc
SET
    TenPhong = N'Phòng thí nghiệm máy tính'
WHERE
    MaPhong LIKE '%LAB%'
    OR TenPhong LIKE '%Lab%';

-- 5. FIX CA HOC (CLASS SHIFT)
UPDATE CaHoc SET MoTa = N'Ca 1 (Tiết 1-3)' WHERE MaCa = 'C1';

UPDATE CaHoc SET MoTa = N'Ca 2 (Tiết 4-6)' WHERE MaCa = 'C2';

UPDATE CaHoc SET MoTa = N'Ca 3 (Tiết 7-9)' WHERE MaCa = 'C3';

UPDATE CaHoc SET MoTa = N'Ca 4 (Tiết 10-12)' WHERE MaCa = 'C4';

UPDATE CaHoc SET MoTa = N'Ca tối 1 (Tiết 13-15)' WHERE MaCa = 'C5';

UPDATE CaHoc SET MoTa = N'Ca tối 2 (Tiết 16-18)' WHERE MaCa = 'C6';

-- 6. FIX HOC PHAN (SUBJECT/COURSE)
UPDATE HocPhan
SET
    TenHP = N'Lập trình .NET'
WHERE
    TenHP LIKE '%.NET%';

UPDATE HocPhan
SET
    TenHP = N'Cơ sở dữ liệu'
WHERE
    TenHP LIKE '%d? li?u%' OR TenHP LIKE '%database%';

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

UPDATE HocPhan
SET
    LoaiHocPhan = N'Lý thuyết'
WHERE
    LoaiHocPhan IS NULL OR LoaiHocPhan = '';

-- 7. FIX GIANG VIEN (LECTURER)
UPDATE GiangVien
SET
    HoTen = N'TS. Nguyễn Văn A'
WHERE
    MaGV = 'GV001';

UPDATE GiangVien SET HoTen = N'ThS. Trần Thị B' WHERE MaGV = 'GV002';

UPDATE GiangVien SET HoTen = N'TS. Lê Văn C' WHERE MaGV = 'GV003';

UPDATE GiangVien SET HoTen = N'TS. Phạm Văn D' WHERE MaGV = 'GV004';

UPDATE GiangVien SET HoTen = N'ThS. Hoàng Thị E' WHERE MaGV = 'GV005';

-- 8. FIX SINH VIEN (STUDENT)
UPDATE SinhVien
SET
    GioiTinh = N'Nam'
WHERE
    GioiTinh = 'M'
    OR GioiTinh = 'Nam';

UPDATE SinhVien
SET
    GioiTinh = N'Nữ'
WHERE
    GioiTinh = 'F'
    OR GioiTinh = 'Female';

UPDATE SinhVien
SET
    TrangThai = N'Đang học'
WHERE
    TrangThai LIKE '%?ang h?c%'
    OR TrangThai = 'Active';

UPDATE SinhVien
SET
    TrangThai = N'Bảo lưu'
WHERE
    TrangThai LIKE '%B?o l??u%'
    OR TrangThai = 'Reserved';

UPDATE SinhVien
SET
    TrangThai = N'Thôi học'
WHERE
    TrangThai LIKE '%Th?i h?c%'
    OR TrangThai = 'Withdrawn';

UPDATE SinhVien
SET
    TrangThai = N'Tốt nghiệp'
WHERE
    TrangThai LIKE '%T?t nghi?p%'
    OR TrangThai = 'Graduated';

-- 9. FIX SINH VIEN TRANG THAI (STUDENT STATUS HISTORY)
UPDATE SinhVien_TrangThai
SET
    TrangThai = N'Đang học'
WHERE
    TrangThai LIKE '%?ang h?c%' OR TrangThai = 'Active';

UPDATE SinhVien_TrangThai
SET
    TrangThai = N'Bảo lưu'
WHERE
    TrangThai LIKE '%B?o l??u%' OR TrangThai = 'Reserved';

UPDATE SinhVien_TrangThai
SET
    TrangThai = N'Thôi học'
WHERE
    TrangThai LIKE '%Th?i h?c%' OR TrangThai = 'Withdrawn';

UPDATE SinhVien_TrangThai
SET
    TrangThai = N'Tốt nghiệp'
WHERE
    TrangThai LIKE '%T?t nghi?p%' OR TrangThai = 'Graduated';

UPDATE SinhVien_TrangThai
SET
    GhiChu = N'Ghi chú không có dấu'
WHERE
    GhiChu LIKE '%ghi ch?%';

PRINT N'✓ Encoding Fixed Successfully - Schema Table 1';
GO
