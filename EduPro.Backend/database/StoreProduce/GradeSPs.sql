USE EduProDb;
GO

-- 10. SP Xem bảng điểm cá nhân của sinh viên
IF OBJECT_ID ('sp_XemBangDiemSinhVien', 'P') IS NOT NULL
DROP PROC sp_XemBangDiemSinhVien;
GO
CREATE PROCEDURE sp_XemBangDiemSinhVien
    @MaSV NVARCHAR(10)
AS
BEGIN
    SELECT 
        hk.TenHK,
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
    FROM Diem d
    JOIN LopHocPhan lhp ON d.MaLHP = lhp.MaLHP
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    JOIN HocKy hk ON lhp.MaHK = hk.MaHK
    WHERE d.MaSV = @MaSV
    ORDER BY hk.MaNam DESC, hk.MaHK DESC, hp.TenHP;
END;
GO