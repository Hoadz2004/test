USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- FIX ENCODING FOR SCHEMA TABLE 5 (VIETNAMESE CHARACTERS)
-- SQL SERVER 2012 COMPATIBLE
-- =============================================================

-- 1. FIX DIEM (GRADE) - KetQua & NguoiNhap fields
UPDATE Diem
SET
    KetQua = N'Đạt'
WHERE
    KetQua LIKE '%?%t%' OR KetQua LIKE '%Dat%';

UPDATE Diem
SET
    KetQua = N'Không đạt'
WHERE
    KetQua LIKE '%không%' OR KetQua LIKE '%kh?ng%';

-- 2. FIX PHUCKAO (APPEAL) - TrangThai & LyDo fields
UPDATE PhucKhao
SET
    TrangThai = N'Chờ xử lý'
WHERE
    TrangThai LIKE '%chờ%' OR TrangThai LIKE '%ch?%';

UPDATE PhucKhao
SET
    TrangThai = N'Đã xử lý'
WHERE
    TrangThai LIKE '%xử lý%' OR TrangThai LIKE '%x? l?%';

UPDATE PhucKhao
SET
    TrangThai = N'Bị từ chối'
WHERE
    TrangThai LIKE '%từ chối%' OR TrangThai LIKE '%t? ch?i%';

UPDATE PhucKhao
SET
    LyDo = N'Lý do phúc khảo'
WHERE
    LyDo LIKE '%lý do%' OR LyDo LIKE '%lý %';

UPDATE PhucKhao
SET
    GhiChuXuLy = N'Ghi chú xử lý'
WHERE
    GhiChuXuLy LIKE '%ghi ch?%';

-- 3. FIX XETTOTNGHIEP (GRADUATION) - KetQua & LyDo fields
UPDATE XetTotNghiep
SET
    KetQua = N'Đủ điều kiện'
WHERE
    KetQua LIKE '%?%u%' OR KetQua LIKE '%du%';

UPDATE XetTotNghiep
SET
    KetQua = N'Chưa đủ điều kiện'
WHERE
    KetQua LIKE '%ch?a%' OR KetQua LIKE '%chua%';

UPDATE XetTotNghiep
SET
    LyDo = N'Lý do'
WHERE
    LyDo LIKE '%lý %' OR LyDo LIKE '%ly %';

PRINT N'✓ Encoding Fixed Successfully - Schema Table 5';
GO
