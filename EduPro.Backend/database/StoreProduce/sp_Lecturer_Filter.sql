USE EduProDb;
GO

-- =============================================
-- FIX GROUP 5: LECTURER FILTER BY FACULTY
-- =============================================

IF OBJECT_ID (
    'sp_LayDanhSachGiangVien_ByKhoa',
    'P'
) IS NOT NULL
DROP PROC sp_LayDanhSachGiangVien_ByKhoa;
GO
CREATE PROCEDURE sp_LayDanhSachGiangVien_ByKhoa
    @MaKhoa NVARCHAR(10) = NULL
AS
BEGIN
    -- If MaKhoa is NULL, should we return all? Or empty? 
    -- User wants filtering, but "All" might be useful if no faculty selected. 
    -- However, request says "not calling all teachers".
    -- Let's return filtered list. If @MaKhoa is NULL, return all (flexibility) or handle inside app.
    
    SELECT 
        gv.MaGV,
        gv.HoTen,
        gv.MaKhoa,
        k.TenKhoa
    FROM GiangVien gv
    JOIN Khoa k ON gv.MaKhoa = k.MaKhoa
    WHERE (@MaKhoa IS NULL OR gv.MaKhoa = @MaKhoa)
    ORDER BY gv.HoTen;
END;
GO