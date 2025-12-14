-- =============================================
-- BỔ SUNG DỮ LIỆU: TÀI KHOẢN GIẢNG VIÊN & SINH VIÊN CÒN THIẾU
-- =============================================

USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- Bổ sung tài khoản Giảng viên còn thiếu (GV002-GV010)
INSERT INTO TaiKhoan (
    TenDangNhap,
    MatKhauHash,
    MaVaiTro,
    MaSV,
    MaGV,
    TrangThai,
    NgayTao
)
VALUES 
    ('GV002', HASHBYTES('SHA2_256', '123456'), 'GIANGVIEN', NULL, 'GV002', 1, GETDATE()),
    ('GV003', HASHBYTES('SHA2_256', '123456'), 'GIANGVIEN', NULL, 'GV003', 1, GETDATE()),
    ('GV004', HASHBYTES('SHA2_256', '123456'), 'GIANGVIEN', NULL, 'GV004', 1, GETDATE()),
    ('GV005', HASHBYTES('SHA2_256', '123456'), 'GIANGVIEN', NULL, 'GV005', 1, GETDATE()),
    ('GV006', HASHBYTES('SHA2_256', '123456'), 'GIANGVIEN', NULL, 'GV006', 1, GETDATE()),
    ('GV007', HASHBYTES('SHA2_256', '123456'), 'GIANGVIEN', NULL, 'GV007', 1, GETDATE()),
    ('GV008', HASHBYTES('SHA2_256', '123456'), 'GIANGVIEN', NULL, 'GV008', 1, GETDATE()),
    ('GV009', HASHBYTES('SHA2_256', '123456'), 'GIANGVIEN', NULL, 'GV009', 1, GETDATE()),
    ('GV010', HASHBYTES('SHA2_256', '123456'), 'GIANGVIEN', NULL, 'GV010', 1, GETDATE());

-- Bổ sung tài khoản Sinh viên khóa 2022 còn thiếu (2022002-2022009)
INSERT INTO TaiKhoan (
    TenDangNhap,
    MatKhauHash,
    MaVaiTro,
    MaSV,
    MaGV,
    TrangThai,
    NgayTao
)
VALUES 
    ('2022002', HASHBYTES('SHA2_256', '123456'), 'SINHVIEN', '2022002', NULL, 1, GETDATE()),
    ('2022003', HASHBYTES('SHA2_256', '123456'), 'SINHVIEN', '2022003', NULL, 1, GETDATE()),
    ('2022004', HASHBYTES('SHA2_256', '123456'), 'SINHVIEN', '2022004', NULL, 1, GETDATE()),
    ('2022005', HASHBYTES('SHA2_256', '123456'), 'SINHVIEN', '2022005', NULL, 1, GETDATE()),
    ('2022006', HASHBYTES('SHA2_256', '123456'), 'SINHVIEN', '2022006', NULL, 1, GETDATE()),
    ('2022007', HASHBYTES('SHA2_256', '123456'), 'SINHVIEN', '2022007', NULL, 1, GETDATE()),
    ('2022008', HASHBYTES('SHA2_256', '123456'), 'SINHVIEN', '2022008', NULL, 1, GETDATE()),
    ('2022009', HASHBYTES('SHA2_256', '123456'), 'SINHVIEN', '2022009', NULL, 1, GETDATE());

-- Bổ sung tài khoản Sinh viên khóa 2021 (2021001)
INSERT INTO TaiKhoan (
    TenDangNhap,
    MatKhauHash,
    MaVaiTro,
    MaSV,
    MaGV,
    TrangThai,
    NgayTao
)
VALUES 
    ('2021001', HASHBYTES('SHA2_256', '123456'), 'SINHVIEN', '2021001', NULL, 1, '2021-09-01');

PRINT N'✓ Đã bổ sung tài khoản Giảng viên (GV002-GV010) thành công!';
PRINT N'✓ Đã bổ sung tài khoản Sinh viên khóa 2021, 2022 thành công!';
GO
