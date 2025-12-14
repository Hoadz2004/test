USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- Update existing admin with correct password (123456)
UPDATE TaiKhoan
SET
    MatKhauHash = 0x8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92,
    SoLanDangNhapThatBai = 0,
    KhoaLuc = NULL,
    TrangThai = 1
WHERE
    TenDangNhap = 'admin';

-- Insert additional admin accounts if not exists
IF NOT EXISTS (
    SELECT 1
    FROM TaiKhoan
    WHERE
        TenDangNhap = 'admin2'
)
INSERT INTO
    TaiKhoan (
        TenDangNhap,
        MatKhauHash,
        MaVaiTro,
        TrangThai,
        NgayTao,
        SoLanDangNhapThatBai
    )
VALUES (
        'admin2',
        0x8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92,
        'ADMIN',
        1,
        GETDATE (),
        0
    );

IF NOT EXISTS (
    SELECT 1
    FROM TaiKhoan
    WHERE
        TenDangNhap = 'superadmin'
)
INSERT INTO
    TaiKhoan (
        TenDangNhap,
        MatKhauHash,
        MaVaiTro,
        TrangThai,
        NgayTao,
        SoLanDangNhapThatBai
    )
VALUES (
        'superadmin',
        0x8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92,
        'ADMIN',
        1,
        GETDATE (),
        0
    );

PRINT '✅ Admin accounts created/updated. Password: 123456';
GO