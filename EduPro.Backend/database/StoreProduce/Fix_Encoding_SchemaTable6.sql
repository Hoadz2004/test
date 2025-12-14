USE EduProDb;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- FIX ENCODING FOR SCHEMA TABLE 6 (VIETNAMESE CHARACTERS)
-- SQL SERVER 2012 COMPATIBLE
-- =============================================================

-- 1. FIX THONGBAO (NOTIFICATION) - TieuDe & NoiDung
UPDATE ThongBao
SET
    TieuDe = N'Tiêu đề thông báo'
WHERE
    TieuDe LIKE '%tiêu%' OR TieuDe LIKE '%ti?u%';

UPDATE ThongBao
SET
    NoiDung = N'Nội dung thông báo'
WHERE
    NoiDung LIKE '%nội%' OR NoiDung LIKE '%n?i%';

-- 2. FIX LOGHETHONG (SYSTEM LOG) - HanhDong & ChiTiet
UPDATE LogHeThong
SET
    HanhDong = N'Hành động'
WHERE
    HanhDong LIKE '%hành%' OR HanhDong LIKE '%hành%';

UPDATE LogHeThong
SET
    ChiTiet = N'Chi tiết hành động'
WHERE
    ChiTiet LIKE '%chi ti?t%' OR ChiTiet LIKE '%chi tiet%';

PRINT N'✓ Encoding Fixed Successfully - Schema Table 6';
GO
