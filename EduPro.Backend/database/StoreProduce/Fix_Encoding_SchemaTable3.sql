USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- FIX ENCODING FOR SCHEMA TABLE 3 (VIETNAMESE CHARACTERS)
-- SQL SERVER 2012 COMPATIBLE
-- =============================================================

-- 1. FIX CTDT (CURRICULUM)
UPDATE CTDT
SET
    TenCTDT = N'Chương trình đào tạo chuẩn'
WHERE
    TenCTDT LIKE '%chương%' OR TenCTDT LIKE '%?o%';

UPDATE CTDT_ChiTiet
SET
    NhomTuChon = N'Nhóm tự chọn'
WHERE
    NhomTuChon IS NOT NULL AND NhomTuChon LIKE '%nh?m%';

PRINT N'✓ Encoding Fixed Successfully - Schema Table 3';
GO
