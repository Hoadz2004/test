-- =============================================
-- NHẬT KÝ HOẠT ĐỘNG (Activity Log)
-- =============================================

USE EduProDb;
GO

-- 1. Bảng NhatKyHoatDong (Activity Log)
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'NhatKyHoatDong')
BEGIN
    CREATE TABLE NhatKyHoatDong (
        MaNhatKy INT PRIMARY KEY IDENTITY(1,1),
        TenDangNhap NVARCHAR(50) NOT NULL,
        LoaiHoatDong NVARCHAR(50) NOT NULL,  -- LOGIN, LOGOUT, CHANGE_PASSWORD, VIEW, CREATE, UPDATE, DELETE
        MoDun NVARCHAR(100) NULL,  -- Tên module/chức năng
        MoTa NVARCHAR(255) NULL,  -- Mô tả chi tiết
        DiaChiIP NVARCHAR(50) NULL,  -- IP address
        TrangThai NVARCHAR(50) NULL,  -- SUCCESS, FAILED, ERROR
        NgayGio DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_NhatKyHoatDong_TaiKhoan FOREIGN KEY (TenDangNhap) 
            REFERENCES TaiKhoan(TenDangNhap) ON DELETE CASCADE
    );
    
    CREATE INDEX IDX_NhatKyHoatDong_TenDangNhap ON NhatKyHoatDong(TenDangNhap);
    CREATE INDEX IDX_NhatKyHoatDong_NgayGio ON NhatKyHoatDong(NgayGio);
    CREATE INDEX IDX_NhatKyHoatDong_LoaiHoatDong ON NhatKyHoatDong(LoaiHoatDong);
    
    PRINT N'✓ Bảng NhatKyHoatDong đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT N'⚠ Bảng NhatKyHoatDong đã tồn tại!';
END
GO

-- 2. Thêm cột DangNhapLanCuoi vào bảng TaiKhoan nếu chưa có
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('TaiKhoan') AND name = 'DangNhapLanCuoi')
BEGIN
    ALTER TABLE TaiKhoan 
    ADD DangNhapLanCuoi DATETIME NULL;
    
    PRINT N'✓ Cột DangNhapLanCuoi đã được thêm vào bảng TaiKhoan!';
END
ELSE
BEGIN
    PRINT N'⚠ Cột DangNhapLanCuoi đã tồn tại!';
END
GO

-- 3. Thêm cột DiaChiIPCuoi vào bảng TaiKhoan nếu chưa có
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('TaiKhoan') AND name = 'DiaChiIPCuoi')
BEGIN
    ALTER TABLE TaiKhoan 
    ADD DiaChiIPCuoi NVARCHAR(50) NULL;
    
    PRINT N'✓ Cột DiaChiIPCuoi đã được thêm vào bảng TaiKhoan!';
END
ELSE
BEGIN
    PRINT N'⚠ Cột DiaChiIPCuoi đã tồn tại!';
END
GO

-- 4. Thêm cột SoLanDangNhapThatBai vào bảng TaiKhoan nếu chưa có
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('TaiKhoan') AND name = 'SoLanDangNhapThatBai')
BEGIN
    ALTER TABLE TaiKhoan 
    ADD SoLanDangNhapThatBai INT DEFAULT 0;
    
    PRINT N'✓ Cột SoLanDangNhapThatBai đã được thêm vào bảng TaiKhoan!';
END
ELSE
BEGIN
    PRINT N'⚠ Cột SoLanDangNhapThatBai đã tồn tại!';
END
GO

-- 5. Dữ liệu mẫu cho NhatKyHoatDong
IF NOT EXISTS (SELECT 1 FROM NhatKyHoatDong WHERE TenDangNhap = 'admin' AND LoaiHoatDong = 'LOGIN')
BEGIN
    INSERT INTO NhatKyHoatDong (TenDangNhap, LoaiHoatDong, MoDun, MoTa, DiaChiIP, TrangThai, NgayGio)
    SELECT 'admin', 'LOGIN', 'Authentication', 'Đăng nhập hệ thống', '192.168.1.100', 'SUCCESS', GETDATE()
    WHERE EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = 'admin')
    
    UNION ALL
    SELECT 'admin', 'VIEW', 'Dashboard', 'Xem trang chủ', '192.168.1.100', 'SUCCESS', GETDATE()
    WHERE EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = 'admin')
    
    UNION ALL
    SELECT 'daotao01', 'LOGIN', 'Authentication', 'Đăng nhập hệ thống', '192.168.1.101', 'SUCCESS', GETDATE()
    WHERE EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = 'daotao01')
    
    UNION ALL
    SELECT 'GV001', 'LOGIN', 'Authentication', 'Đăng nhập hệ thống', '192.168.1.102', 'SUCCESS', GETDATE()
    WHERE EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = 'GV001')
    
    UNION ALL
    SELECT '2022001', 'LOGIN', 'Authentication', 'Đăng nhập hệ thống', '192.168.1.103', 'SUCCESS', GETDATE()
    WHERE EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = '2022001');
    
    PRINT N'✓ Dữ liệu mẫu nhật ký hoạt động đã được thêm thành công!';
END
ELSE
BEGIN
    PRINT N'⚠ Dữ liệu mẫu nhật ký hoạt động đã tồn tại!';
END
GO

-- 6. Stored Procedure để ghi nhật ký hoạt động
IF OBJECT_ID('sp_GhiNhatKyHoatDong', 'P') IS NOT NULL
    DROP PROCEDURE sp_GhiNhatKyHoatDong;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE PROCEDURE sp_GhiNhatKyHoatDong
    @TenDangNhap NVARCHAR(50),
    @LoaiHoatDong NVARCHAR(50),
    @MoDun NVARCHAR(100) = NULL,
    @MoTa NVARCHAR(255) = NULL,
    @DiaChiIP NVARCHAR(50) = NULL,
    @TrangThai NVARCHAR(50) = 'SUCCESS'
AS
BEGIN
    SET NOCOUNT ON;
    SET QUOTED_IDENTIFIER ON;
    
    INSERT INTO NhatKyHoatDong (TenDangNhap, LoaiHoatDong, MoDun, MoTa, DiaChiIP, TrangThai)
    VALUES (@TenDangNhap, @LoaiHoatDong, @MoDun, @MoTa, @DiaChiIP, @TrangThai);
    
    -- Cập nhật DangNhapLanCuoi nếu là LOGIN
    IF @LoaiHoatDong = 'LOGIN' AND @TrangThai = 'SUCCESS'
    BEGIN
        UPDATE TaiKhoan 
        SET DangNhapLanCuoi = GETDATE(),
            DiaChiIPCuoi = @DiaChiIP,
            SoLanDangNhapThatBai = 0
        WHERE TenDangNhap = @TenDangNhap;
    END
    
    -- Tăng số lần đăng nhập thất bại nếu LOGIN thất bại
    IF @LoaiHoatDong = 'LOGIN' AND @TrangThai = 'FAILED'
    BEGIN
        UPDATE TaiKhoan 
        SET SoLanDangNhapThatBai = SoLanDangNhapThatBai + 1
        WHERE TenDangNhap = @TenDangNhap;
    END
END
GO

PRINT N'✓ Stored Procedure sp_GhiNhatKyHoatDong đã được tạo thành công!';
GO

PRINT N'========================================';
PRINT N'✓ Cấu hình Nhật ký hoạt động hoàn tất!';
PRINT N'========================================';
GO
