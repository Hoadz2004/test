USE EduProDb1;
GO

-- =============================================
-- FIX GROUP 4: ENROLLMENT DATA MAPPING
-- =============================================

-- Updated SP with correct column aliases for CourseOfferingDto
IF OBJECT_ID ('sp_LayDanhSachLopMo', 'P') IS NOT NULL
DROP PROC sp_LayDanhSachLopMo;
GO
CREATE PROCEDURE sp_LayDanhSachLopMo
    @MaNam NVARCHAR(10) = NULL,
    @MaHK NVARCHAR(10) = NULL
AS
BEGIN
    SELECT 
        lhp.MaLHP,
        lhp.MaHP, hp.TenHP, hp.SoTinChi,
        lhp.SiSoToiDa,
        (SELECT COUNT(*) FROM DangKyHocPhan dk WHERE dk.MaLHP = lhp.MaLHP) AS SiSoHienTai,
        gv.HoTen AS GiangVien, -- Alias matches DTO 'GiangVien'
        lhp.ThuTrongTuan,      -- Required for Frontend
        lhp.MaCa,              -- Required for Frontend
        ph.TenPhong AS MaPhong -- Mapping TenPhong to MaPhong property for display, or use TenPhong if DTO changes. 
                               -- Note: DTO has 'MaPhong'. Frontend shows {{element.maPhong}}. 
                               -- Often user wants to see Room Name. Let's send TenPhong as MaPhong alias or just MaPhong? 
                               -- Let's return both or map TenPhong to MaPhong if it's display text.
                               -- Current DTO uses 'MaPhong'. If I send TenPhong as MaPhong, it displays Room Name. Good.
    FROM LopHocPhan lhp
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    JOIN GiangVien gv ON lhp.MaGV = gv.MaGV
    JOIN PhongHoc ph ON lhp.MaPhong = ph.MaPhong
    JOIN CaHoc ca ON lhp.MaCa = ca.MaCa
    WHERE (@MaNam IS NULL OR lhp.MaNam = @MaNam)
      AND (@MaHK IS NULL OR lhp.MaHK = @MaHK)
    ORDER BY lhp.MaLHP;
END;
GO