-- Fix all CHECK constraints on SinhVien table
USE EduProDb1;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- Drop old constraints
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'SinhVien' AND CONSTRAINT_NAME = 'CK_SinhVien_GioiTinh')
BEGIN
    ALTER TABLE SinhVien DROP CONSTRAINT CK_SinhVien_GioiTinh;
    PRINT N'✓ Dropped old CK_SinhVien_GioiTinh';
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'SinhVien' AND CONSTRAINT_NAME = 'CK_SinhVien_TrangThai')
BEGIN
    ALTER TABLE SinhVien DROP CONSTRAINT CK_SinhVien_TrangThai;
    PRINT N'✓ Dropped old CK_SinhVien_TrangThai';
END
GO

-- Add new constraints with correct encoding
ALTER TABLE SinhVien 
ADD CONSTRAINT CK_SinhVien_GioiTinh 
CHECK (GioiTinh IS NULL OR GioiTinh IN (N'Khác', N'Nữ', N'Nam'));

PRINT N'✓ Added new CK_SinhVien_GioiTinh with correct encoding';
GO

ALTER TABLE SinhVien 
ADD CONSTRAINT CK_SinhVien_TrangThai 
CHECK (TrangThai IN (N'Tốt nghiệp', N'Đang học', N'Bảo lưu', N'Đợi'));

PRINT N'✓ Added new CK_SinhVien_TrangThai with correct encoding';
GO
