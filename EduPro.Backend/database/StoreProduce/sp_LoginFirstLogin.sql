USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- SP Login - Returns FirstLogin flag
CREATE PROCEDURE sp_KiemTraDangNhap
    @TenDangNhap NVARCHAR(50)
AS
BEGIN
    SELECT 
        tk.TenDangNhap, 
        tk.MatKhauHash, 
        tk.MaVaiTro, 
        tk.MaSV, 
        tk.MaGV,
        sv.HoTen AS HoTenSV,
        gv.HoTen AS HoTenGV,
        tk.SoLanDangNhapThatBai,
        tk.KhoaLuc,
        tk.DiaChiIPCuoi,
        tk.LanDauDangNhap
    FROM TaiKhoan tk
    LEFT JOIN SinhVien sv ON tk.MaSV = sv.MaSV
    LEFT JOIN GiangVien gv ON tk.MaGV = gv.MaGV
    WHERE tk.TenDangNhap = @TenDangNhap AND tk.TrangThai = 1;
END;
GO

-- SP to mark first login completed
IF OBJECT_ID ('sp_DanhDauDaDangNhap', 'P') IS NOT NULL
DROP PROC sp_DanhDauDaDangNhap;
GO
CREATE PROCEDURE sp_DanhDauDaDangNhap
    @TenDangNhap NVARCHAR(50)
AS
BEGIN
    UPDATE TaiKhoan SET LanDauDangNhap = 0 WHERE TenDangNhap = @TenDangNhap;
END;
GO

PRINT N'Login SPs updated with FirstLogin support';
GO