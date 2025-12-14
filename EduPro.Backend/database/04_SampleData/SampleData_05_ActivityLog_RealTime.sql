-- =============================================
-- NHẬT KÝ HOẠT ĐỘNG - HIỂN THỊ VÀ REAL-TIME
-- =============================================

USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- 1. View để hiển thị nhật ký hoạt động
IF OBJECT_ID('vw_NhatKyHoatDong', 'V') IS NOT NULL
    DROP VIEW vw_NhatKyHoatDong;
GO

CREATE VIEW vw_NhatKyHoatDong
AS
SELECT 
    MaNhatKy,
    TenDangNhap,
    LoaiHoatDong,
    MoDun,
    MoTa,
    DiaChiIP,
    TrangThai,
    CONVERT(VARCHAR(20), NgayGio, 120) AS NgayGioFormatted,
    NgayGio
FROM NhatKyHoatDong
GO

PRINT N'✓ View vw_NhatKyHoatDong đã được tạo thành công!';
GO

-- 2. Stored Procedure để cập nhật trạng thái đăng nhập thực tế
IF OBJECT_ID('sp_DangNhapThanhCong', 'P') IS NOT NULL
    DROP PROCEDURE sp_DangNhapThanhCong;
GO

CREATE PROCEDURE sp_DangNhapThanhCong
    @TenDangNhap NVARCHAR(50),
    @DiaChiIP NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET QUOTED_IDENTIFIER ON;
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Cập nhật TaiKhoan
        UPDATE TaiKhoan 
        SET 
            LanDangNhapCuoi = GETDATE(),
            DangNhapLanCuoi = GETDATE(),
            DiaChiIPCuoi = @DiaChiIP,
            SoLanDangNhapThatBai = 0,
            TrangThai = 1
        WHERE TenDangNhap = @TenDangNhap;
        
        -- 2. Ghi nhật ký hoạt động
        INSERT INTO NhatKyHoatDong (TenDangNhap, LoaiHoatDong, MoDun, MoTa, DiaChiIP, TrangThai, NgayGio)
        VALUES (
            @TenDangNhap, 
            'LOGIN', 
            'Authentication', 
            N'Đăng nhập hệ thống', 
            @DiaChiIP, 
            'SUCCESS',
            GETDATE()
        );
        
        COMMIT TRANSACTION;
        
        -- Trả về thông tin cập nhật
        SELECT 
            TenDangNhap,
            LanDangNhapCuoi,
            DangNhapLanCuoi,
            DiaChiIPCuoi,
            SoLanDangNhapThatBai
        FROM TaiKhoan
        WHERE TenDangNhap = @TenDangNhap;
        
        PRINT N'✓ Đăng nhập thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT N'✗ Lỗi đăng nhập: ' + ERROR_MESSAGE();
    END CATCH
END
GO

PRINT N'✓ Stored Procedure sp_DangNhapThanhCong đã được tạo thành công!';
GO

-- 3. Stored Procedure để ghi nhật ký đăng nhập thất bại
IF OBJECT_ID('sp_DangNhapThatBai', 'P') IS NOT NULL
    DROP PROCEDURE sp_DangNhapThatBai;
GO

CREATE PROCEDURE sp_DangNhapThatBai
    @TenDangNhap NVARCHAR(50),
    @LyDo NVARCHAR(100) = N'Sai mật khẩu',
    @DiaChiIP NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET QUOTED_IDENTIFIER ON;
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Tăng số lần đăng nhập thất bại
        UPDATE TaiKhoan 
        SET SoLanDangNhapThatBai = SoLanDangNhapThatBai + 1
        WHERE TenDangNhap = @TenDangNhap;
        
        -- 2. Nếu đăng nhập thất bại quá 5 lần, khóa tài khoản
        IF (SELECT SoLanDangNhapThatBai FROM TaiKhoan WHERE TenDangNhap = @TenDangNhap) >= 5
        BEGIN
            UPDATE TaiKhoan 
            SET TrangThai = 0
            WHERE TenDangNhap = @TenDangNhap;
            
            INSERT INTO NhatKyHoatDong (TenDangNhap, LoaiHoatDong, MoDun, MoTa, DiaChiIP, TrangThai, NgayGio)
            VALUES (
                @TenDangNhap, 
                'LOGIN', 
                'Authentication', 
                N'Tài khoản bị khóa do đăng nhập thất bại quá 5 lần', 
                @DiaChiIP, 
                'FAILED',
                GETDATE()
            );
            
            PRINT N'⚠ Tài khoản đã bị khóa!';
        END
        ELSE
        BEGIN
            -- 3. Ghi nhật ký hoạt động
            INSERT INTO NhatKyHoatDong (TenDangNhap, LoaiHoatDong, MoDun, MoTa, DiaChiIP, TrangThai, NgayGio)
            VALUES (
                @TenDangNhap, 
                'LOGIN', 
                'Authentication', 
                @LyDo, 
                @DiaChiIP, 
                'FAILED',
                GETDATE()
            );
        END
        
        COMMIT TRANSACTION;
        PRINT N'✓ Ghi nhật ký đăng nhập thất bại thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT N'✗ Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END
GO

PRINT N'✓ Stored Procedure sp_DangNhapThatBai đã được tạo thành công!';
GO

-- 4. Stored Procedure để ghi nhật ký đăng xuất
IF OBJECT_ID('sp_DangXuat', 'P') IS NOT NULL
    DROP PROCEDURE sp_DangXuat;
GO

CREATE PROCEDURE sp_DangXuat
    @TenDangNhap NVARCHAR(50),
    @DiaChiIP NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET QUOTED_IDENTIFIER ON;
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1. Ghi nhật ký đăng xuất
        INSERT INTO NhatKyHoatDong (TenDangNhap, LoaiHoatDong, MoDun, MoTa, DiaChiIP, TrangThai, NgayGio)
        VALUES (
            @TenDangNhap, 
            'LOGOUT', 
            'Authentication', 
            N'Đăng xuất hệ thống', 
            @DiaChiIP, 
            'SUCCESS',
            GETDATE()
        );
        
        COMMIT TRANSACTION;
        PRINT N'✓ Đăng xuất thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT N'✗ Lỗi đăng xuất: ' + ERROR_MESSAGE();
    END CATCH
END
GO

PRINT N'✓ Stored Procedure sp_DangXuat đã được tạo thành công!';
GO

-- 5. Stored Procedure để lấy nhật ký hoạt động
IF OBJECT_ID('sp_LayNhatKyHoatDong', 'P') IS NOT NULL
    DROP PROCEDURE sp_LayNhatKyHoatDong;
GO

CREATE PROCEDURE sp_LayNhatKyHoatDong
    @TenDangNhap NVARCHAR(50) = NULL,
    @LoaiHoatDong NVARCHAR(50) = NULL,
    @SoLuong INT = 100
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@SoLuong)
        MaNhatKy,
        TenDangNhap,
        LoaiHoatDong,
        MoDun,
        MoTa,
        DiaChiIP,
        TrangThai,
        CONVERT(VARCHAR(20), NgayGio, 120) AS NgayGioFormatted,
        NgayGio
    FROM NhatKyHoatDong
    WHERE 
        (@TenDangNhap IS NULL OR TenDangNhap = @TenDangNhap)
        AND (@LoaiHoatDong IS NULL OR LoaiHoatDong = @LoaiHoatDong)
    ORDER BY MaNhatKy DESC;
END
GO

PRINT N'✓ Stored Procedure sp_LayNhatKyHoatDong đã được tạo thành công!';
GO

-- 6. Stored Procedure để lấy thông tin tài khoản cùng với nhật ký gần đây nhất
IF OBJECT_ID('sp_LayThongTinTaiKhoan', 'P') IS NOT NULL
    DROP PROCEDURE sp_LayThongTinTaiKhoan;
GO

CREATE PROCEDURE sp_LayThongTinTaiKhoan
    @TenDangNhap NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thông tin tài khoản
    SELECT 
        TenDangNhap,
        MaVaiTro,
        CASE WHEN TrangThai = 1 THEN N'Hoạt động' ELSE N'Khóa' END AS TrangThaiText,
        DangNhapLanCuoi,
        DiaChiIPCuoi,
        SoLanDangNhapThatBai,
        CONVERT(VARCHAR(20), NgayTao, 120) AS NgayTaoFormatted,
        NgayTao
    FROM TaiKhoan
    WHERE TenDangNhap = @TenDangNhap;
    
    -- Nhật ký hoạt động gần đây nhất (10 bản ghi)
    SELECT TOP 10
        MaNhatKy,
        LoaiHoatDong,
        MoDun,
        MoTa,
        DiaChiIP,
        TrangThai,
        CONVERT(VARCHAR(20), NgayGio, 120) AS NgayGioFormatted,
        NgayGio
    FROM NhatKyHoatDong
    WHERE TenDangNhap = @TenDangNhap
    ORDER BY MaNhatKy DESC;
END
GO

PRINT N'✓ Stored Procedure sp_LayThongTinTaiKhoan đã được tạo thành công!';
GO

PRINT N'========================================';
PRINT N'✓ Cấu hình Nhật ký hoạt động REAL-TIME!';
PRINT N'========================================';
GO
