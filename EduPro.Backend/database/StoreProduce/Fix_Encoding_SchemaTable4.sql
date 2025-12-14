USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- FIX ENCODING FOR SCHEMA TABLE 4 (VIETNAMESE CHARACTERS)
-- SQL SERVER 2012 COMPATIBLE
-- =============================================================

-- 1. FIX LOPHOCDPHAN (CLASS SECTION) - GhiChu field
UPDATE LopHocPhan
SET
    GhiChu = N'Ghi chú không có dấu'
WHERE
    GhiChu LIKE '%ghi ch?%';

-- 2. FIX DANGKYHOCPHAN (ENROLLMENT) - TrangThai field
UPDATE DangKyHocPhan
SET
    TrangThai = N'Đăng ký'
WHERE
    TrangThai LIKE '%?%ng k?%' OR TrangThai LIKE '%Đăng kỳ%';

UPDATE DangKyHocPhan
SET
    TrangThai = N'Hủy'
WHERE
    TrangThai LIKE '%h?y%';

UPDATE DangKyHocPhan
SET
    TrangThai = N'Phê duyệt'
WHERE
    TrangThai LIKE '%phê d?y?t%';

PRINT N'✓ Encoding Fixed Successfully - Schema Table 4';
GO
