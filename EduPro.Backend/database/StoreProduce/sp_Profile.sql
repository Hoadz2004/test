USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- SP Change Password
IF OBJECT_ID ('sp_DoiMatKhau', 'P') IS NOT NULL
DROP PROC sp_DoiMatKhau;
GO
CREATE PROCEDURE sp_DoiMatKhau
    @TenDangNhap NVARCHAR(50),
    @MatKhauCuHash VARBINARY(256),
    @MatKhauMoiHash VARBINARY(256)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Verify old password
    IF NOT EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = @TenDangNhap AND MatKhauHash = @MatKhauCuHash)
    BEGIN
        RAISERROR(N'Mật khẩu cũ không đúng', 16, 1);
        RETURN;
    END
    
    -- Update password and mark first login complete
    UPDATE TaiKhoan 
    SET MatKhauHash = @MatKhauMoiHash, 
        LanDauDangNhap = 0
    WHERE TenDangNhap = @TenDangNhap;
    
    SELECT 1 AS Status, N'Đổi mật khẩu thành công!' AS Message;
END;
GO

-- SP Get Profile (SinhVien)
IF OBJECT_ID ('sp_GetSinhVienProfile', 'P') IS NOT NULL
DROP PROC sp_GetSinhVienProfile;
GO
CREATE PROCEDURE sp_GetSinhVienProfile
    @MaSV NVARCHAR(20)
AS
BEGIN
    SELECT sv.*, n.TenNganh, k.TenKhoa, kts.TenKhoaTS
    FROM SinhVien sv
    LEFT JOIN Nganh n ON sv.MaNganh = n.MaNganh
    LEFT JOIN Khoa k ON n.MaKhoa = k.MaKhoa
    LEFT JOIN KhoaTuyenSinh kts ON sv.MaKhoaTS = kts.MaKhoaTS
    WHERE sv.MaSV = @MaSV;
END;
GO

-- SP Update SinhVien Profile
IF OBJECT_ID (
    'sp_UpdateSinhVienProfile',
    'P'
) IS NOT NULL
DROP PROC sp_UpdateSinhVienProfile;
GO
CREATE PROCEDURE sp_UpdateSinhVienProfile
    @MaSV NVARCHAR(20),
    @Email NVARCHAR(100) = NULL,
    @DienThoai NVARCHAR(20) = NULL,
    @DiaChi NVARCHAR(200) = NULL,
    @NgaySinh DATE = NULL,
    @GioiTinh NVARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE SinhVien
    SET Email = ISNULL(@Email, Email),
        DienThoai = ISNULL(@DienThoai, DienThoai),
        DiaChi = ISNULL(@DiaChi, DiaChi),
        NgaySinh = ISNULL(@NgaySinh, NgaySinh),
        GioiTinh = ISNULL(@GioiTinh, GioiTinh)
    WHERE MaSV = @MaSV;
    
    SELECT 1 AS Status, N'Cập nhật thành công!' AS Message;
END;
GO

PRINT N'Profile SPs created';
GO