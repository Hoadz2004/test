USE EduProDb1;
GO

-- 1. Tạo các VaiTro (Roles)
DELETE FROM VaiTro WHERE MaVaiTro IN ('ADMIN', 'SINHVIEN', 'GIANGVIEN');

INSERT INTO VaiTro (MaVaiTro, TenVaiTro)
VALUES 
  ('ADMIN', N'Quản trị viên'),
  ('SINHVIEN', N'Sinh viên'),
  ('GIANGVIEN', N'Giảng viên');

PRINT 'âœ" Vai trà² â‰ Ä'â"¶ Ä'Æ°Ã¡Ì£c tÃ¡Ìo';

-- 2. Tạo admin accounts
DELETE FROM TaiKhoan WHERE TenDangNhap IN ('admin', 'admin2', 'superadmin');

INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, MaVaiTro, TrangThai, NgayTao, SoLanDangNhapThatBai)
VALUES 
  ('admin', 0x8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92, 'ADMIN', 1, GETDATE(), 0),
  ('admin2', 0x8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92, 'ADMIN', 1, GETDATE(), 0),
  ('superadmin', 0x8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92, 'ADMIN', 1, GETDATE(), 0);

PRINT 'âœ" Admin accounts created successfully';
PRINT '   Username: admin';
PRINT '   Password: 123456';

-- 3. Verify
SELECT 'âœ" Admin accounts:' as Result;
SELECT TenDangNhap, MaVaiTro, TrangThai FROM TaiKhoan WHERE MaVaiTro='ADMIN';

GO
