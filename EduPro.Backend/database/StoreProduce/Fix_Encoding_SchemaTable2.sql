USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- FIX ENCODING FOR SCHEMA TABLE 2 (VIETNAMESE CHARACTERS)
-- SQL SERVER 2012 COMPATIBLE
-- =============================================================

-- 1. FIX VAI TRO (ROLE)
UPDATE VaiTro
SET
    TenVaiTro = N'Quản Trị Viên'
WHERE
    MaVaiTro = 'ADMIN';

UPDATE VaiTro
SET
    TenVaiTro = N'Giảng Viên'
WHERE
    MaVaiTro = 'LECTURER';

UPDATE VaiTro
SET
    TenVaiTro = N'Sinh Viên'
WHERE
    MaVaiTro = 'STUDENT';

UPDATE VaiTro
SET
    TenVaiTro = N'Trưởng Khoa'
WHERE
    MaVaiTro = 'DEAN';

UPDATE VaiTro
SET
    TenVaiTro = N'Trợ Lý'
WHERE
    MaVaiTro = 'ASSISTANT';

-- 2. FIX QUYEN (PERMISSION)
UPDATE Quyen
SET
    TenQuyen = N'Xem Danh Sách Sinh Viên'
WHERE
    MaQuyen LIKE '%VIEW_STUDENT%';

UPDATE Quyen
SET
    TenQuyen = N'Thêm Sinh Viên'
WHERE
    MaQuyen LIKE '%CREATE_STUDENT%';

UPDATE Quyen
SET
    TenQuyen = N'Sửa Thông Tin Sinh Viên'
WHERE
    MaQuyen LIKE '%EDIT_STUDENT%';

UPDATE Quyen
SET
    TenQuyen = N'Xóa Sinh Viên'
WHERE
    MaQuyen LIKE '%DELETE_STUDENT%';

UPDATE Quyen
SET
    TenQuyen = N'Xem Danh Sách Giảng Viên'
WHERE
    MaQuyen LIKE '%VIEW_LECTURER%';

UPDATE Quyen
SET
    TenQuyen = N'Quản Lý Lớp Học'
WHERE
    MaQuyen LIKE '%MANAGE_CLASS%';

UPDATE Quyen
SET
    TenQuyen = N'Nhập Điểm'
WHERE
    MaQuyen LIKE '%INPUT_GRADE%';

UPDATE Quyen
SET
    TenQuyen = N'Xem Điểm'
WHERE
    MaQuyen LIKE '%VIEW_GRADE%';

UPDATE Quyen
SET
    TenQuyen = N'Quản Lý Đăng Ký'
WHERE
    MaQuyen LIKE '%MANAGE_ENROLLMENT%';

UPDATE Quyen
SET
    TenQuyen = N'Phê Duyệt Đăng Ký'
WHERE
    MaQuyen LIKE '%APPROVE_ENROLLMENT%';

PRINT N'✓ Encoding Fixed Successfully - Schema Table 2';
GO
