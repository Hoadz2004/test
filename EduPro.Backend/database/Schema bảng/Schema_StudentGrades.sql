USE EduProDb;
GO

-- SP: Get Grades for Student (My Grades)
-- Used by: Student Grade View
IF OBJECT_ID ('sp_Student_GetGrades', 'P') IS NOT NULL
DROP PROC sp_Student_GetGrades;
GO

CREATE PROCEDURE sp_Student_GetGrades
    @MaSV NVARCHAR(10)
AS
BEGIN
    SELECT 
        lhp.MaHK AS TenHK, -- Or join with HocKy table if needed, for now using Code
        lhp.MaLHP,
        hp.TenHP,
        hp.SoTinChi,
        d.DiemQT,
        d.DiemGK,
        d.DiemCK,
        d.DiemTK,
        d.DiemChu,
        d.DiemHe4,
        d.KetQua
    FROM DangKyHocPhan dk
    JOIN LopHocPhan lhp ON dk.MaLHP = lhp.MaLHP
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    LEFT JOIN Diem d ON dk.MaSV = d.MaSV AND dk.MaLHP = d.MaLHP
    WHERE dk.MaSV = @MaSV
    ORDER BY lhp.MaHK DESC, hp.TenHP;
END;
GO

PRINT 'sp_Student_GetGrades Created';
GO