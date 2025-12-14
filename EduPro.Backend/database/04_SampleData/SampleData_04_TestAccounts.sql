-- =============================================
-- DỮ LIỆU MẪU: TÀI KHOẢN ĐĂNG NHẬP (Test Accounts)
-- =============================================

USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- Tài khoản test:
-- 1. Admin: admin / admin123
-- 2. Giáo viên: gv001 / gv123
-- 3. Sinh viên: sv2022001 / sv123

-- Password hash: dùng HASHBYTES SHA256
-- Test accounts sẽ được hash tại đây

INSERT INTO TaiKhoan (
    TenDangNhap,
    MatKhauHash,
    MaVaiTro,
    MaGV,
    MaSV,
    TrangThai,
    NgayTao,
    LanDangNhapCuoi
)
VALUES
    -- 1. Admin Account
    (
        'admin',
        HASHBYTES('SHA2_256', 'admin123'),  -- Password: admin123 (hashed)
        'ADMIN',
        NULL,
        NULL,
        1,
        GETDATE(),
        NULL
    ),
    -- 2. Lecturer Account (Giảng viên)
    (
        'gv001',
        HASHBYTES('SHA2_256', 'gv123'),     -- Password: gv123 (hashed)
        'GIANGVIEN',
        'GV001',     -- Link tới GiangVien.MaGV
        NULL,
        1,
        GETDATE(),
        NULL
    ),
    -- 3. Student Account (Sinh viên)
    (
        'sv2022001',
        HASHBYTES('SHA2_256', 'sv123'),     -- Password: sv123 (hashed)
        'SINHVIEN',
        NULL,
        '2022001',   -- Link tới SinhVien.MaSV
        1,
        GETDATE(),
        NULL
    );

PRINT N'✓ Đã insert tài khoản test thành công!';
PRINT N'';
PRINT N'=== TEST ACCOUNTS ===';
PRINT N'1. Admin:     admin / admin123';
PRINT N'2. Giáo viên: gv001 / gv123';
PRINT N'3. Sinh viên: sv2022001 / sv123';
PRINT N'';
PRINT N'⚠️  Passwords được hash với SHA2_256';
GO

-- Verify
SELECT TenDangNhap, MaVaiTro, MaGV, MaSV, TrangThai
FROM TaiKhoan
WHERE TenDangNhap IN ('admin', 'gv001', 'sv2022001')
ORDER BY TenDangNhap;
GO
