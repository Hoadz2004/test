USE EduProDb;
GO

-- =============================================
-- GROUP 8b: MASTER DATA REMAINING
-- =============================================

-- 20. SP Lấy danh sách Năm Học
IF OBJECT_ID ('sp_LayDanhSachNamHoc', 'P') IS NOT NULL
DROP PROC sp_LayDanhSachNamHoc;
GO
CREATE PROCEDURE sp_LayDanhSachNamHoc
AS
BEGIN
    ;WITH years AS (
        SELECT DISTINCT 
            MaNam AS Ma, 
            CAST(NamBatDau AS NVARCHAR) + N'-' + CAST(NamKetThuc AS NVARCHAR) AS Ten 
        FROM NamHoc
        WHERE MaNam LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
    )
    SELECT Ma, Ten
    FROM years
    ORDER BY Ma DESC;
END;
GO

-- 21. SP Lấy danh sách Khóa Tuyển Sinh
IF OBJECT_ID (
    'sp_LayDanhSachKhoaTuyenSinh',
    'P'
) IS NOT NULL
DROP PROC sp_LayDanhSachKhoaTuyenSinh;
GO
CREATE PROCEDURE sp_LayDanhSachKhoaTuyenSinh
AS
BEGIN
    SELECT 
        MaKhoaTS AS Ma, 
        TenKhoaTS AS Ten 
    FROM KhoaTuyenSinh
    ORDER BY NamBatDau DESC;
END;
GO

-- 22. SP Lấy danh sách Phòng Học
IF OBJECT_ID ('sp_LayDanhSachPhongHoc', 'P') IS NOT NULL
DROP PROC sp_LayDanhSachPhongHoc;
GO
CREATE PROCEDURE sp_LayDanhSachPhongHoc
AS
BEGIN
    SELECT 
        MaPhong AS Ma, 
        TenPhong + N' (Sức chứa: ' + CAST(SucChua AS NVARCHAR) + N')' AS Ten 
    FROM PhongHoc;
END;
GO

-- 23. SP Lấy danh sách Ca Học
IF OBJECT_ID ('sp_LayDanhSachCaHoc', 'P') IS NOT NULL
DROP PROC sp_LayDanhSachCaHoc;
GO
CREATE PROCEDURE sp_LayDanhSachCaHoc
AS
BEGIN
    SELECT 
        MaCa AS Ma, 
        MoTa + N' (' + CONVERT(VARCHAR(5), GioBatDau, 108) + N' - ' + CONVERT(VARCHAR(5), GioKetThuc, 108) + N')' AS Ten 
    FROM CaHoc;
END;
GO

-- 24. SP Lấy danh sách Học Phần
IF OBJECT_ID ('sp_LayDanhSachHocPhan', 'P') IS NOT NULL
DROP PROC sp_LayDanhSachHocPhan;
GO
CREATE PROCEDURE sp_LayDanhSachHocPhan
AS
BEGIN
    SELECT 
        MaHP AS Ma, 
        TenHP + N' (' + CAST(SoTinChi AS NVARCHAR) + N' TC)' AS Ten 
    FROM HocPhan
    ORDER BY TenHP;
END;
GO
