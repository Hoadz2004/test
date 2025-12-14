USE EduProDb1;
GO

-- 1. Open Registration for ALL Semesters (Testing Mode)
UPDATE HocKy
SET
    ChoPhepDangKy = 1,
    NgayBatDauDangKy = '2020-01-01',
    NgayKetThucDangKy = '2030-01-01';

-- 2. Fix Vietnamese Font in HocKy (Simple Fix)
UPDATE HocKy SET TenHK = N'Học kỳ 1' WHERE MaHK LIKE '%HK1%';

UPDATE HocKy SET TenHK = N'Học kỳ 2' WHERE MaHK LIKE '%HK2%';

UPDATE HocKy SET TenHK = N'Học kỳ Hè' WHERE MaHK LIKE '%HKH%';

-- 3. Fix Faculties/Majors encoding if broken (Optional, but good for UX)
UPDATE Khoa
SET
    TenKhoa = N'Công Nghệ Thông Tin'
WHERE
    MaKhoa = 'CNTT';

UPDATE Nganh
SET
    TenNganh = N'Kỹ Thuật Phần Mềm'
WHERE
    MaNganh = 'KTPM';