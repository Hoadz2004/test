USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- CREATE SAMPLE ACCOUNTS FOR TESTING
-- =============================================================

-- 1. Create Faculty (Khoa)
IF NOT EXISTS (SELECT 1 FROM Khoa WHERE MaKhoa = N'CNTT')
BEGIN
    INSERT INTO Khoa (MaKhoa, TenKhoa, TrangThai)
    VALUES (N'CNTT', N'Công Nghệ Thông Tin', 1);
END

-- 2. Create Major (Ngành)
IF NOT EXISTS (SELECT 1 FROM Nganh WHERE MaNganh = N'KTPM')
BEGIN
    INSERT INTO Nganh (MaNganh, TenNganh, MaKhoa, TrangThai)
    VALUES (N'KTPM', N'Kỹ Thuật Phần Mềm', N'CNTT', 1);
END

-- 3. Create Admission Cohort (Khóa Tuyển Sinh)
IF NOT EXISTS (SELECT 1 FROM KhoaTuyenSinh WHERE MaKhoaTS = N'KTS2024')
BEGIN
    INSERT INTO KhoaTuyenSinh (MaKhoaTS, TenKhoaTS, NamBatDau)
    VALUES (N'KTS2024', N'Khóa 2024', 2024);
END

-- 4. Create Roles (Vai Trò)
IF NOT EXISTS (SELECT 1 FROM VaiTro WHERE MaVaiTro = N'ADMIN')
    INSERT INTO VaiTro (MaVaiTro, TenVaiTro) VALUES (N'ADMIN', N'Quản Trị Viên');
    
IF NOT EXISTS (SELECT 1 FROM VaiTro WHERE MaVaiTro = N'STUDENT')
    INSERT INTO VaiTro (MaVaiTro, TenVaiTro) VALUES (N'STUDENT', N'Sinh Viên');
    
IF NOT EXISTS (SELECT 1 FROM VaiTro WHERE MaVaiTro = N'LECTURER')
    INSERT INTO VaiTro (MaVaiTro, TenVaiTro) VALUES (N'LECTURER', N'Giảng Viên');

-- 5. Create Student (Sinh Viên)
IF NOT EXISTS (SELECT 1 FROM SinhVien WHERE MaSV = N'SV001')
BEGIN
    INSERT INTO SinhVien (MaSV, HoTen, Email, MaNganh, MaKhoaTS)
    VALUES (N'SV001', N'Nguyễn Văn A', N'sv001@edu.vn', N'KTPM', N'KTS2024');
END

-- 6. Create Lecturer (Giảng Viên)
IF NOT EXISTS (SELECT 1 FROM GiangVien WHERE MaGV = N'GV001')
BEGIN
    INSERT INTO GiangVien (MaGV, HoTen, Email, MaKhoa)
    VALUES (N'GV001', N'TS. Vũ Thị Phương', N'gv001@edu.vn', N'CNTT');
END

-- 7. Create Accounts (Tài Khoản)
-- Student Account
IF NOT EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = N'sv001')
BEGIN
    INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, MaVaiTro, MaSV, TrangThai)
    VALUES (N'sv001', CONVERT(VARBINARY(MAX), N'sv001'), N'STUDENT', N'SV001', 1);
END

-- Lecturer Account
IF NOT EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = N'gv001')
BEGIN
    INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, MaVaiTro, MaGV, TrangThai)
    VALUES (N'gv001', CONVERT(VARBINARY(MAX), N'gv001'), N'LECTURER', N'GV001', 1);
END

-- Admin Account
IF NOT EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = N'admin')
BEGIN
    INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, MaVaiTro, TrangThai)
    VALUES (N'admin', CONVERT(VARBINARY(MAX), N'admin'), N'ADMIN', 1);
END

-- Print confirmation
PRINT N'✓ Sample accounts created successfully!';
PRINT N'';
PRINT N'=== LOGIN ACCOUNTS ===';
PRINT N'Admin:     Username: admin    | Password: admin';
PRINT N'Student:   Username: sv001    | Password: sv001';
PRINT N'Lecturer:  Username: gv001    | Password: gv001';
GO
