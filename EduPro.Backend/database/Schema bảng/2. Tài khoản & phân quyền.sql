-- =============================================
-- Schema: 2. Tài khoản & Phân quyền (Consolidated)
-- Bao gồm: Roles, Permissions, Accounts, Security Tables
-- =============================================

-- 1. Bảng Vai Trò (Roles)
IF OBJECT_ID ('VaiTro', 'U') IS NULL
CREATE TABLE VaiTro (
    MaVaiTro NVARCHAR (20) NOT NULL PRIMARY KEY,
    TenVaiTro NVARCHAR (100) NOT NULL
);
GO

-- 2. Bảng Quyền (Permissions)
IF OBJECT_ID ('Quyen', 'U') IS NULL
CREATE TABLE Quyen (
    MaQuyen NVARCHAR (50) NOT NULL PRIMARY KEY,
    TenQuyen NVARCHAR (200) NOT NULL
);
GO

-- 3. Bảng Phân quyền cho Vai trò (Role-Permission)
IF OBJECT_ID ('VaiTro_Quyen', 'U') IS NULL
CREATE TABLE VaiTro_Quyen (
    MaVaiTro NVARCHAR (20) NOT NULL,
    MaQuyen NVARCHAR (50) NOT NULL,
    PRIMARY KEY (MaVaiTro, MaQuyen),
    CONSTRAINT FK_VTQ_VaiTro FOREIGN KEY (MaVaiTro) REFERENCES VaiTro (MaVaiTro),
    CONSTRAINT FK_VTQ_Quyen FOREIGN KEY (MaQuyen) REFERENCES Quyen (MaQuyen)
);
GO

-- 4. Bảng Tài Khoan (Accounts) - Tích hợp các cột bảo mật
IF OBJECT_ID('TaiKhoan', 'U') IS NULL
CREATE TABLE TaiKhoan (
    TenDangNhap NVARCHAR(50) NOT NULL PRIMARY KEY,
    MatKhauHash VARBINARY(256) NOT NULL,
    MaVaiTro NVARCHAR(20) NOT NULL,
    MaSV NVARCHAR(10) NULL,
    MaGV NVARCHAR(10) NULL,
    TrangThai BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME NOT NULL DEFAULT GETDATE(),
    LanDangNhapCuoi DATETIME NULL,

-- Security Columns (Added for Brute-force protection)
SoLanDangNhapThatBai INT NOT NULL DEFAULT 0,
    KhoaLuc DATETIME NULL,
    DiaChiIPCuoi NVARCHAR(50) NULL,

    CONSTRAINT FK_TK_VaiTro FOREIGN KEY (MaVaiTro) REFERENCES VaiTro (MaVaiTro),
    CONSTRAINT FK_TK_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV),
    CONSTRAINT FK_TK_GV FOREIGN KEY (MaGV) REFERENCES GiangVien (MaGV)
);
GO

-- 5. Bảng TokenBlacklist (Bảo mật: Lưu token đã đăng xuất/hủy)
IF OBJECT_ID ('TokenBlacklist', 'U') IS NULL
CREATE TABLE TokenBlacklist (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    TokenId NVARCHAR (100) NOT NULL, -- JTI (Json Token Id)
    ExpiryDate DATETIME NOT NULL,
    Reason NVARCHAR (200) NULL, -- 'Logout', 'Revoked', etc.
    RevokedAt DATETIME NOT NULL DEFAULT GETDATE ()
);

IF NOT EXISTS (
    SELECT *
    FROM sys.indexes
    WHERE
        name = 'IX_TokenBlacklist_TokenId'
) CREATE NONCLUSTERED INDEX IX_TokenBlacklist_TokenId ON TokenBlacklist (TokenId);
GO

-- 6. Bảng LoginAttempt (Bảo mật: Ghi log đăng nhập)
IF OBJECT_ID ('LoginAttempt', 'U') IS NULL
CREATE TABLE LoginAttempt (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    UserName NVARCHAR (50) NOT NULL,
    IPAddress NVARCHAR (50) NULL,
    AttemptTime DATETIME NOT NULL DEFAULT GETDATE (),
    IsSuccess BIT NOT NULL,
    FailureReason NVARCHAR (255) NULL
);

IF NOT EXISTS (
    SELECT *
    FROM sys.indexes
    WHERE
        name = 'IX_LoginAttempt_UserName'
) CREATE NONCLUSTERED INDEX IX_LoginAttempt_UserName ON LoginAttempt (UserName);
GO

PRINT '✅ Tài khoản & Phân quyền Schema (Consolidated) Checked/Created Successfully.';