/* Combined schema from 'Schema bảng' generated 2025-12-14 22:21:39 */
/* ===== Begin: 001_Improve_LopHocPhan_Schema.sql ===== */
USE EduProDb;
GO

-- =============================================
-- MIGRATION 001: Cáº£i tiáº¿n schema LopHocPhan
-- ThÃªm cÃ¡c field: NgayBatDau, NgayKetThuc, SoBuoiHoc, TrangThaiLop, SoBuoiTrongTuan
-- =============================================

-- Step 1: Kiá»ƒm tra náº¿u cá»™t Ä‘Ã£ tá»“n táº¡i
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LopHocPhan' AND COLUMN_NAME = 'NgayBatDau')
BEGIN
    ALTER TABLE LopHocPhan
    ADD 
        NgayBatDau DATE NULL,
        NgayKetThuc DATE NULL,
        SoBuoiHoc INT DEFAULT 13,
        SoBuoiTrongTuan TINYINT DEFAULT 1,
        TrangThaiLop NVARCHAR(50) DEFAULT N'Sáº¯p khai giáº£ng';
    
    PRINT 'âœ“ Columns added successfully';
END
ELSE
BEGIN
    PRINT 'âš  Columns already exist, skipping...';
END

GO

-- Step 2: Táº¡o constraint check cho TrangThaiLop (náº¿u chÆ°a cÃ³)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE TABLE_NAME = 'LopHocPhan' AND CONSTRAINT_NAME = 'CK_LopHocPhan_TrangThai')
BEGIN
    ALTER TABLE LopHocPhan
    ADD CONSTRAINT CK_LopHocPhan_TrangThai 
    CHECK (TrangThaiLop IN (N'Sáº¯p khai giáº£ng', N'Äang há»c', N'Káº¿t thÃºc', N'Há»§y'));
    
    PRINT 'âœ“ TrangThai constraint added';
END

GO

-- Step 3: Táº¡o constraint check cho SoBuoiTrongTuan
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE TABLE_NAME = 'LopHocPhan' AND CONSTRAINT_NAME = 'CK_LopHocPhan_SoBuoi')
BEGIN
    ALTER TABLE LopHocPhan
    ADD CONSTRAINT CK_LopHocPhan_SoBuoi 
    CHECK (SoBuoiTrongTuan IN (1, 2));
    
    PRINT 'âœ“ SoBuoi constraint added';
END

GO

-- Step 4: Táº¡o constraint check cho ngÃ y
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE TABLE_NAME = 'LopHocPhan' AND CONSTRAINT_NAME = 'CK_LopHocPhan_Ngay')
BEGIN
    ALTER TABLE LopHocPhan
    ADD CONSTRAINT CK_LopHocPhan_Ngay 
    CHECK (NgayBatDau IS NULL OR NgayKetThuc IS NULL OR (NgayBatDau IS NOT NULL AND NgayKetThuc IS NOT NULL AND NgayKetThuc >= NgayBatDau));
    
    PRINT 'âœ“ Ngay constraint added';
END

GO

-- Step 5: Táº¡o Index
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LopHocPhan_TrangThai')
    CREATE INDEX IX_LopHocPhan_TrangThai ON LopHocPhan(TrangThaiLop);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LopHocPhan_NgayBatDau')
    CREATE INDEX IX_LopHocPhan_NgayBatDau ON LopHocPhan(NgayBatDau);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LopHocPhan_MaHP')
    CREATE INDEX IX_LopHocPhan_MaHP ON LopHocPhan(MaHP);

PRINT 'âœ“ Indexes created';

GO

-- =============================================
-- Dá»¯ liá»‡u máº«u: Cáº­p nháº­t cÃ¡c lá»›p hiá»‡n táº¡i
-- =============================================

UPDATE LopHocPhan
SET 
    NgayBatDau = '2024-09-02',
    NgayKetThuc = '2024-12-20',
    SoBuoiHoc = 13,
    SoBuoiTrongTuan = 1,
    TrangThaiLop = N'Sáº¯p khai giáº£ng'
WHERE MaNam = N'NAM2024' AND MaHK = N'HK1';

PRINT 'âœ“ Sample data updated';

GO

PRINT 'âœ“âœ“âœ“ Migration 001 completed successfully!';

/* ===== End: 001_Improve_LopHocPhan_Schema.sql ===== */

/* ===== Begin: 002_Add_MaKhoa_MaNganh_LopHocPhan.sql ===== */
USE EduProDb;
GO

-- ThÃªm cá»™t MaKhoa, MaNganh vÃ o LopHocPhan (nullable) Ä‘á»ƒ FE cÃ³ thá»ƒ preselect Khoa/NgÃ nh
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'LopHocPhan' AND COLUMN_NAME = 'MaKhoa'
)
BEGIN
    ALTER TABLE LopHocPhan ADD MaKhoa NVARCHAR(20) NULL;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'LopHocPhan' AND COLUMN_NAME = 'MaNganh'
)
BEGIN
    ALTER TABLE LopHocPhan ADD MaNganh NVARCHAR(20) NULL;
END
GO

/* ===== End: 002_Add_MaKhoa_MaNganh_LopHocPhan.sql ===== */

/* ===== Begin: 1. Bảng danh mục & người dùng.sql ===== */
CREATE TABLE Khoa (
    MaKhoa NVARCHAR(10) NOT NULL PRIMARY KEY,
    TenKhoa NVARCHAR (100) NOT NULL,
    TrangThai BIT NOT NULL DEFAULT 1,
    NgayTao DATETIME NOT NULL DEFAULT GETDATE ()
);

CREATE TABLE Nganh (
    MaNganh NVARCHAR(10) NOT NULL PRIMARY KEY,
    TenNganh NVARCHAR (100) NOT NULL,
    MaKhoa NVARCHAR(10) NOT NULL,
    TrangThai BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Nganh_Khoa FOREIGN KEY (MaKhoa) REFERENCES Khoa (MaKhoa)
);

CREATE TABLE KhoaTuyenSinh (
    MaKhoaTS NVARCHAR(10) NOT NULL PRIMARY KEY,
    NamBatDau INT NOT NULL,
    TenKhoaTS NVARCHAR (100) NOT NULL
);

CREATE TABLE NamHoc (
    MaNam NVARCHAR(10) NOT NULL PRIMARY KEY,
    NamBatDau INT NOT NULL,
    NamKetThuc INT NOT NULL
);

CREATE TABLE HocKy (
    MaHK NVARCHAR(10) NOT NULL PRIMARY KEY,
    TenHK NVARCHAR (50) NOT NULL, -- HK1, HK2, HÃ¨
    MaNam NVARCHAR(10) NOT NULL,
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    ChoPhepDangKy BIT NOT NULL DEFAULT 0,
    NgayBatDauDangKy DATE NULL,
    NgayKetThucDangKy DATE NULL,
    CONSTRAINT FK_HocKy_NamHoc FOREIGN KEY (MaNam) REFERENCES NamHoc (MaNam),
    CONSTRAINT CK_HocKy_NgayDangKy CHECK (
        NgayBatDauDangKy IS NULL
        OR NgayKetThucDangKy IS NULL
        OR NgayKetThucDangKy >= NgayBatDauDangKy
    )
);

CREATE TABLE PhongHoc (
    MaPhong NVARCHAR(10) NOT NULL PRIMARY KEY,
    TenPhong NVARCHAR (50) NOT NULL,
    SucChua INT NOT NULL
);

CREATE TABLE CaHoc (
    MaCa NVARCHAR(10) NOT NULL PRIMARY KEY,
    MoTa NVARCHAR (100) NOT NULL, -- "Tiáº¿t 1-3", "Tiáº¿t 4-6"
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL
);

CREATE TABLE HocPhan (
    MaHP NVARCHAR(10) NOT NULL PRIMARY KEY,
    TenHP NVARCHAR (200) NOT NULL,
    SoTinChi INT NOT NULL,
    SoTietLT INT NULL,
    SoTietTH INT NULL,
    BatBuoc BIT NOT NULL DEFAULT 1,
    LoaiHocPhan NVARCHAR (50) NULL DEFAULT N'LÃ½ thuyáº¿t'
);

CREATE TABLE GiangVien (
    MaGV NVARCHAR(10) NOT NULL PRIMARY KEY,
    HoTen NVARCHAR (100) NOT NULL,
    Email NVARCHAR (100) NULL,
    DienThoai NVARCHAR (20) NULL,
    MaKhoa NVARCHAR(10) NOT NULL,
    CONSTRAINT FK_GiangVien_Khoa FOREIGN KEY (MaKhoa) REFERENCES Khoa (MaKhoa)
);

CREATE TABLE SinhVien (
    MaSV NVARCHAR(10) NOT NULL PRIMARY KEY,
    HoTen NVARCHAR (100) NOT NULL,
    NgaySinh DATE NOT NULL,
    GioiTinh NVARCHAR (10) NULL, -- "Nam", "Ná»¯"
    DiaChi NVARCHAR (200) NULL,
    Email NVARCHAR (100) NULL,
    DienThoai NVARCHAR (20) NULL,
    MaNganh NVARCHAR(10) NOT NULL,
    MaKhoaTS NVARCHAR(10) NOT NULL,
    LopHanhChinh NVARCHAR (50) NULL,
    TrangThai NVARCHAR (50) NOT NULL DEFAULT N'Äang há»c', -- Äang há»c, Báº£o lÆ°u, ThÃ´i há»c, Tá»‘t nghiá»‡p
    CONSTRAINT FK_SinhVien_Nganh FOREIGN KEY (MaNganh) REFERENCES Nganh (MaNganh),
    CONSTRAINT FK_SinhVien_KTS FOREIGN KEY (MaKhoaTS) REFERENCES KhoaTuyenSinh (MaKhoaTS)
);

CREATE TABLE SinhVien_TrangThai (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaSV NVARCHAR(10) NOT NULL,
    TrangThai NVARCHAR (50) NOT NULL,
    NgayCapNhat DATETIME NOT NULL DEFAULT GETDATE (),
    GhiChu NVARCHAR (200) NULL,
    CONSTRAINT FK_SVTrangThai_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV)
);

/* ===== End: 1. Bảng danh mục & người dùng.sql ===== */

/* ===== Begin: 10. MEDIUM - Bổ sung trường cần thiết.sql ===== */
-- File nÃ y Ä‘Ã£ Ä‘Æ°á»£c tÃ­ch há»£p vÃ o cÃ¡c file táº¡o báº£ng chÃ­nh (#1, #2, #5)
-- Táº¥t cáº£ cÃ¡c cá»™t cáº§n thiáº¿t Ä‘Ã£ Ä‘Æ°á»£c thÃªm vÃ o báº£ng khi táº¡o báº£ng
-- File nÃ y hiá»‡n táº¡i khÃ´ng cÃ³ ná»™i dung Ä‘á»ƒ trÃ¡nh lá»—i trÃ¹ng láº·p
GO

/* ===== End: 10. MEDIUM - Bổ sung trường cần thiết.sql ===== */

/* ===== Begin: 11. MEDIUM - Bổ sung bảng cho 3 module đã đề xuất.sql ===== */
-- Báº£ng CongNo (há»c phÃ­ cÆ¡ báº£n)
CREATE TABLE CongNo (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaSV NVARCHAR(10) NOT NULL,
    MaHK NVARCHAR(10) NOT NULL,
    SoTienNo DECIMAL(18, 2) NOT NULL DEFAULT 0,
    NgayCapNhat DATETIME NOT NULL DEFAULT GETDATE (),
    CONSTRAINT FK_CongNo_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV),
    CONSTRAINT FK_CongNo_HK FOREIGN KEY (MaHK) REFERENCES HocKy (MaHK)
);

-- Báº£ng YeuCauDacBiet (workflow duyá»‡t)
CREATE TABLE YeuCauDacBiet (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaSV NVARCHAR(10) NOT NULL,
    LoaiYeuCau NVARCHAR (50) NOT NULL, -- 'Há»c vÆ°á»£t', 'RÃºt mÃ´n', 'Há»c láº¡i'
    MaLHP NVARCHAR(20) NULL,
    LyDo NVARCHAR (500) NULL,
    TrangThai NVARCHAR (50) NOT NULL DEFAULT N'Chá» duyá»‡t',
    NgayGui DATETIME NOT NULL DEFAULT GETDATE (),
    NgayXuLy DATETIME NULL,
    NguoiXuLy NVARCHAR(50) NULL,
    KetQuaXuLy NVARCHAR (500) NULL,
    CONSTRAINT FK_YCDB_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV),
    CONSTRAINT FK_YCDB_LHP FOREIGN KEY (MaLHP) REFERENCES LopHocPhan (MaLHP)
);

-- Index cho CongNo
CREATE INDEX IX_CongNo_MaSV ON CongNo (MaSV);

CREATE INDEX IX_CongNo_MaHK ON CongNo (MaHK);

-- Index cho YeuCauDacBiet
CREATE INDEX IX_YeuCauDacBiet_MaSV ON YeuCauDacBiet (MaSV);

CREATE INDEX IX_YeuCauDacBiet_TrangThai ON YeuCauDacBiet (TrangThai);

-- Unique constraint cho CongNo
ALTER TABLE CongNo
ADD CONSTRAINT UQ_CongNo_SV_HK UNIQUE (MaSV, MaHK);

-- Check constraint cho YeuCauDacBiet
ALTER TABLE YeuCauDacBiet
ADD CONSTRAINT CK_YeuCau_LoaiYeuCau CHECK (
    LoaiYeuCau IN (
        N'Há»c vÆ°á»£t',
        N'RÃºt mÃ´n',
        N'Há»c láº¡i',
        N'Miá»…n giáº£m há»c phÃ­'
    )
);

ALTER TABLE YeuCauDacBiet
ADD CONSTRAINT CK_YeuCau_TrangThai CHECK (
    TrangThai IN (
        N'Chá» duyá»‡t',
        N'ÄÃ£ duyá»‡t',
        N'Tá»« chá»‘i'
    )
);

/* ===== End: 11. MEDIUM - Bổ sung bảng cho 3 module đã đề xuất.sql ===== */

/* ===== Begin: 12. LOW - Vấn đề nhỏ về data type.sql ===== */
-- Sá»­a data type cho DiemTBTichLuyToiThieu
-- Tá»« DECIMAL(3,2) -> DECIMAL(4,2) Ä‘á»ƒ cÃ³ thá»ƒ lÆ°u 10.00

ALTER TABLE DieuKienTotNghiep
ALTER COLUMN DiemTBTichLuyToiThieu DECIMAL(4, 2) NOT NULL;

/* ===== End: 12. LOW - Vấn đề nhỏ về data type.sql ===== */

/* ===== Begin: 13. Payment - HocPhi - ThanhToan.sql ===== */
-- Schema: Payment / Há»c phÃ­ / Thanh toÃ¡n
USE EduProDb;
GO

-- Báº£ng Ä‘Æ¡n giÃ¡ há»c phÃ­ theo ngÃ nh + há»c ká»³
IF OBJECT_ID('HocPhiCatalog', 'U') IS NULL
BEGIN
    CREATE TABLE HocPhiCatalog (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        MaNganh NVARCHAR(10) NOT NULL,
        MaHK NVARCHAR(10) NOT NULL,
        DonGiaTinChi DECIMAL(18,2) NOT NULL,
        PhuPhiThucHanh DECIMAL(18,2) NOT NULL DEFAULT 0,
        HieuLucTu DATE NOT NULL,
        HieuLucDen DATE NULL,
        GiamTruPercent DECIMAL(5,2) NOT NULL DEFAULT 0, -- giáº£m trá»« %
        NgayHetHan DATE NULL, -- háº¡n ná»™p
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_HocPhi_Nganh FOREIGN KEY (MaNganh) REFERENCES Nganh(MaNganh),
        CONSTRAINT FK_HocPhi_HK FOREIGN KEY (MaHK) REFERENCES HocKy(MaHK),
        CONSTRAINT CK_HocPhi_HieuLuc CHECK (HieuLucDen IS NULL OR HieuLucDen >= HieuLucTu)
    );

    CREATE UNIQUE INDEX UQ_HocPhi_Nganh_HK_Effective
        ON HocPhiCatalog (MaNganh, MaHK, HieuLucTu);
END;
GO

-- Báº£ng giao dá»‹ch thanh toÃ¡n
IF OBJECT_ID('PaymentTransaction', 'U') IS NULL
BEGIN
    CREATE TABLE PaymentTransaction (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        MaSV NVARCHAR(10) NOT NULL,
        MaHK NVARCHAR(10) NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Method NVARCHAR(30) NOT NULL,
        Provider NVARCHAR(30) NULL,
        ProviderRef NVARCHAR(100) NULL,
        ProviderTransId NVARCHAR(100) NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT N'Pending',
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        ConfirmedAt DATETIME NULL,
        Note NVARCHAR(200) NULL,
        CONSTRAINT FK_Payment_SV FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV),
        CONSTRAINT FK_Payment_HK FOREIGN KEY (MaHK) REFERENCES HocKy(MaHK)
    );

    CREATE INDEX IX_Payment_SV_HK ON PaymentTransaction(MaSV, MaHK);
    CREATE INDEX IX_Payment_Status ON PaymentTransaction(Status);

    ALTER TABLE PaymentTransaction WITH CHECK ADD CONSTRAINT CK_Payment_Status
        CHECK (Status IN (N'Pending', N'Succeeded', N'Failed', N'Canceled'));
END;
GO

-- Báº£ng ledger thanh toÃ¡n (audit + hoÃ n/Ä‘iá»u chá»‰nh)
IF OBJECT_ID('PaymentLedger', 'U') IS NULL
BEGIN
    CREATE TABLE PaymentLedger (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        PaymentId INT NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Type NVARCHAR(20) NOT NULL, -- Credit, Debit, Refund, Adjustment
        Description NVARCHAR(200) NULL,
        BalanceAfter DECIMAL(18,2) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Ledger_Payment FOREIGN KEY (PaymentId) REFERENCES PaymentTransaction(Id)
    );

    CREATE INDEX IX_PaymentLedger_PaymentId ON PaymentLedger(PaymentId);

    ALTER TABLE PaymentLedger WITH CHECK ADD CONSTRAINT CK_PaymentLedger_Type
        CHECK (Type IN (N'Credit', N'Debit', N'Refund', N'Adjustment'));
END;
GO

/* ===== End: 13. Payment - HocPhi - ThanhToan.sql ===== */

/* ===== Begin: 14. Admissions.sql ===== */
-- Admissions core tables
IF OBJECT_ID('Admissions', 'U') IS NULL
BEGIN
    CREATE TABLE Admissions (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        FullName NVARCHAR(200) NOT NULL,
        Email NVARCHAR(200) NULL,
        Phone NVARCHAR(50) NULL,
        CCCD NVARCHAR(50) NULL,
        NgaySinh DATE NULL,
        DiaChi NVARCHAR(300) NULL,
        MaNam NVARCHAR(20) NULL,
        MaHK NVARCHAR(20) NULL,
        MaNganh NVARCHAR(50) NULL,
        TrangThai NVARCHAR(50) NOT NULL DEFAULT N'ÄÃ£ ná»™p',
        MaTraCuu NVARCHAR(20) NOT NULL UNIQUE,
        NgayNop DATETIME NOT NULL DEFAULT GETDATE(),
        NgayCapNhat DATETIME NOT NULL DEFAULT GETDATE(),
        GhiChu NVARCHAR(500) NULL
    );
END;
GO

IF OBJECT_ID('AdmissionDocuments', 'U') IS NULL
BEGIN
    CREATE TABLE AdmissionDocuments (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        AdmissionId INT NOT NULL,
        TenTaiLieu NVARCHAR(100) NOT NULL,
        FileUrl NVARCHAR(300) NOT NULL,
        TrangThai NVARCHAR(50) NOT NULL DEFAULT N'ChÆ°a kiá»ƒm tra',
        GhiChu NVARCHAR(300) NULL,
        CONSTRAINT FK_AdmissionDocuments_Admissions FOREIGN KEY (AdmissionId) REFERENCES Admissions(Id) ON DELETE CASCADE
    );
END;
GO

IF OBJECT_ID('AdmissionTransactions', 'U') IS NULL
BEGIN
    CREATE TABLE AdmissionTransactions (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        AdmissionId INT NOT NULL,
        Amount DECIMAL(18,2) NOT NULL DEFAULT 0,
        Status NVARCHAR(50) NOT NULL DEFAULT N'Pending', -- Pending, Success, Failed
        Provider NVARCHAR(50) NULL,
        ProviderRef NVARCHAR(100) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_AdmissionTransactions_Admissions FOREIGN KEY (AdmissionId) REFERENCES Admissions(Id) ON DELETE CASCADE
    );
END;
GO

-- Helpful indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Admissions_MaHK_MaNganh' AND object_id = OBJECT_ID('Admissions'))
BEGIN
    CREATE INDEX IX_Admissions_MaHK_MaNganh ON Admissions(MaHK, MaNganh, TrangThai);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Admissions_Status' AND object_id = OBJECT_ID('Admissions'))
BEGIN
    CREATE INDEX IX_Admissions_Status ON Admissions(TrangThai);
END;
GO

/* ===== End: 14. Admissions.sql ===== */

/* ===== Begin: 15. Admissions_Requirements_Scores.sql ===== */
-- Báº£ng yÃªu cáº§u mÃ´n theo ngÃ nh/khá»‘i thi
IF OBJECT_ID('AdmissionRequirements', 'U') IS NULL
BEGIN
    CREATE TABLE AdmissionRequirements (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        MaNganh NVARCHAR(50) NOT NULL,
        KhoiThi NVARCHAR(50) NOT NULL,
        Mon1 NVARCHAR(50) NOT NULL,
        Mon2 NVARCHAR(50) NOT NULL,
        Mon3 NVARCHAR(50) NOT NULL,
        HeSo1 DECIMAL(4,2) NOT NULL DEFAULT 1,
        HeSo2 DECIMAL(4,2) NOT NULL DEFAULT 1,
        HeSo3 DECIMAL(4,2) NOT NULL DEFAULT 1,
        DiemChuan DECIMAL(5,2) NULL,
        HieuLucTu DATE NULL,
        HieuLucDen DATE NULL
    );
    CREATE INDEX IX_AdmissionRequirements_MaNganh ON AdmissionRequirements(MaNganh);
END;
GO

-- Báº£ng Ä‘iá»ƒm há»“ sÆ¡ theo mÃ´n
IF OBJECT_ID('AdmissionScores', 'U') IS NULL
BEGIN
    CREATE TABLE AdmissionScores (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        AdmissionId INT NOT NULL,
        Mon NVARCHAR(50) NOT NULL,
        Diem DECIMAL(5,2) NOT NULL,
        CONSTRAINT FK_AdmissionScores_Admissions FOREIGN KEY (AdmissionId) REFERENCES Admissions(Id) ON DELETE CASCADE
    );
    CREATE INDEX IX_AdmissionScores_AdmissionId ON AdmissionScores(AdmissionId);
END;
GO

-- Lá»‹ch sá»­ tráº¡ng thÃ¡i (Ä‘á»ƒ log liÃªn há»‡/Ä‘iá»ƒm)
IF OBJECT_ID('AdmissionStatusHistory', 'U') IS NULL
BEGIN
    CREATE TABLE AdmissionStatusHistory (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        AdmissionId INT NOT NULL,
        TrangThai NVARCHAR(50) NOT NULL,
        GhiChu NVARCHAR(500) NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_AdmissionStatusHistory_Admissions FOREIGN KEY (AdmissionId) REFERENCES Admissions(Id) ON DELETE CASCADE
    );
    CREATE INDEX IX_AdmissionStatusHistory_AdmissionId ON AdmissionStatusHistory(AdmissionId);
END;
GO

/* ===== End: 15. Admissions_Requirements_Scores.sql ===== */

/* ===== Begin: 2. Tài khoản & phân quyền.sql ===== */
-- =============================================
-- Schema: 2. TÃ i khoáº£n & PhÃ¢n quyá»n (Consolidated)
-- Bao gá»“m: Roles, Permissions, Accounts, Security Tables
-- =============================================

-- 1. Báº£ng Vai TrÃ² (Roles)
IF OBJECT_ID ('VaiTro', 'U') IS NULL
CREATE TABLE VaiTro (
    MaVaiTro NVARCHAR (20) NOT NULL PRIMARY KEY,
    TenVaiTro NVARCHAR (100) NOT NULL
);
GO

-- 2. Báº£ng Quyá»n (Permissions)
IF OBJECT_ID ('Quyen', 'U') IS NULL
CREATE TABLE Quyen (
    MaQuyen NVARCHAR (50) NOT NULL PRIMARY KEY,
    TenQuyen NVARCHAR (200) NOT NULL
);
GO

-- 3. Báº£ng PhÃ¢n quyá»n cho Vai trÃ² (Role-Permission)
IF OBJECT_ID ('VaiTro_Quyen', 'U') IS NULL
CREATE TABLE VaiTro_Quyen (
    MaVaiTro NVARCHAR (20) NOT NULL,
    MaQuyen NVARCHAR (50) NOT NULL,
    PRIMARY KEY (MaVaiTro, MaQuyen),
    CONSTRAINT FK_VTQ_VaiTro FOREIGN KEY (MaVaiTro) REFERENCES VaiTro (MaVaiTro),
    CONSTRAINT FK_VTQ_Quyen FOREIGN KEY (MaQuyen) REFERENCES Quyen (MaQuyen)
);
GO

-- 4. Báº£ng TÃ i Khoan (Accounts) - TÃ­ch há»£p cÃ¡c cá»™t báº£o máº­t
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

-- 5. Báº£ng TokenBlacklist (Báº£o máº­t: LÆ°u token Ä‘Ã£ Ä‘Äƒng xuáº¥t/há»§y)
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

-- 6. Báº£ng LoginAttempt (Báº£o máº­t: Ghi log Ä‘Äƒng nháº­p)
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

PRINT 'âœ… TÃ i khoáº£n & PhÃ¢n quyá»n Schema (Consolidated) Checked/Created Successfully.';

/* ===== End: 2. Tài khoản & phân quyền.sql ===== */

/* ===== Begin: 3. Chương trình đào tạo & tiên quyết.sql ===== */
CREATE TABLE CTDT (
    MaCTDT INT IDENTITY (1, 1) PRIMARY KEY,
    MaNganh NVARCHAR(10) NOT NULL,
    MaKhoaTS NVARCHAR(10) NOT NULL,
    TenCTDT NVARCHAR (200) NOT NULL,
    NamBanHanh INT NOT NULL,
    CONSTRAINT FK_CTDT_Nganh FOREIGN KEY (MaNganh) REFERENCES Nganh (MaNganh),
    CONSTRAINT FK_CTDT_KTS FOREIGN KEY (MaKhoaTS) REFERENCES KhoaTuyenSinh (MaKhoaTS)
);

CREATE TABLE CTDT_ChiTiet (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaCTDT INT NOT NULL,
    MaHP NVARCHAR(10) NOT NULL,
    HocKyDuKien INT NOT NULL,
    BatBuoc BIT NOT NULL DEFAULT 1,
    NhomTuChon NVARCHAR (50) NULL,
    CONSTRAINT FK_CTDTC_CTDT FOREIGN KEY (MaCTDT) REFERENCES CTDT (MaCTDT),
    CONSTRAINT FK_CTDTC_HP FOREIGN KEY (MaHP) REFERENCES HocPhan (MaHP)
);

CREATE TABLE TienQuyet (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaHP NVARCHAR(10) NOT NULL,
    MaHP_TienQuyet NVARCHAR(10) NOT NULL,
    CONSTRAINT FK_TQ_HP FOREIGN KEY (MaHP) REFERENCES HocPhan (MaHP),
    CONSTRAINT FK_TQ_HP_TQ FOREIGN KEY (MaHP_TienQuyet) REFERENCES HocPhan (MaHP)
);

/* ===== End: 3. Chương trình đào tạo & tiên quyết.sql ===== */

/* ===== Begin: 4. Kế hoạch đào tạo – Lớp học phần – Đăng ký.sql ===== */
CREATE TABLE LopHocPhan (
    MaLHP NVARCHAR(20) NOT NULL PRIMARY KEY,
    MaHP NVARCHAR(10) NOT NULL,
    MaHK NVARCHAR(10) NOT NULL,
    MaNam NVARCHAR(10) NOT NULL,
    MaGV NVARCHAR(10) NOT NULL,
    MaPhong NVARCHAR(10) NOT NULL,
    MaCa NVARCHAR(10) NOT NULL,
    ThuTrongTuan TINYINT NOT NULL, -- 2..7
    SiSoToiDa INT NOT NULL,
    GhiChu NVARCHAR (200) NULL,
    CONSTRAINT FK_LHP_HP FOREIGN KEY (MaHP) REFERENCES HocPhan (MaHP),
    CONSTRAINT FK_LHP_HK FOREIGN KEY (MaHK) REFERENCES HocKy (MaHK),
    CONSTRAINT FK_LHP_NH FOREIGN KEY (MaNam) REFERENCES NamHoc (MaNam),
    CONSTRAINT FK_LHP_GV FOREIGN KEY (MaGV) REFERENCES GiangVien (MaGV),
    CONSTRAINT FK_LHP_PH FOREIGN KEY (MaPhong) REFERENCES PhongHoc (MaPhong),
    CONSTRAINT FK_LHP_CA FOREIGN KEY (MaCa) REFERENCES CaHoc (MaCa)
);

CREATE TABLE DangKyHocPhan (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaSV NVARCHAR(10) NOT NULL,
    MaLHP NVARCHAR(20) NOT NULL,
    NgayDangKy DATETIME NOT NULL DEFAULT GETDATE (),
    TrangThai NVARCHAR (50) NOT NULL DEFAULT N'ÄÄƒng kÃ½',
    CONSTRAINT FK_DKHP_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV),
    CONSTRAINT FK_DKHP_LHP FOREIGN KEY (MaLHP) REFERENCES LopHocPhan (MaLHP)
);

/* ===== End: 4. Kế hoạch đào tạo – Lớp học phần – Đăng ký.sql ===== */

/* ===== Begin: 5. AuditLog.sql ===== */
USE EduProDb;
GO

IF OBJECT_ID ('AuditLog', 'U') IS NULL
CREATE TABLE AuditLog (
    LogId INT IDENTITY (1, 1) PRIMARY KEY,
    Action NVARCHAR (50) NOT NULL, -- e.g., 'CREATE_USER', 'LOCK_ACCOUNT'
    EntityTable NVARCHAR (50) NOT NULL, -- e.g., 'TaiKhoan', 'SinhVien'
    EntityId NVARCHAR (50) NOT NULL, -- Primary Key of the entity
    OldValue NVARCHAR (MAX) NULL, -- JSON or text
    NewValue NVARCHAR (MAX) NULL, -- JSON or text
    PerformedBy NVARCHAR (50) NOT NULL, -- Username of admin
    IPAddress NVARCHAR (50) NULL,
    UserAgent NVARCHAR (200) NULL,
    Timestamp DATETIME NOT NULL DEFAULT GETDATE ()
);
GO

IF NOT EXISTS (
    SELECT *
    FROM sys.indexes
    WHERE
        name = 'IX_AuditLog_PerformedBy'
) CREATE NONCLUSTERED INDEX IX_AuditLog_PerformedBy ON AuditLog (PerformedBy);

IF NOT EXISTS (
    SELECT *
    FROM sys.indexes
    WHERE
        name = 'IX_AuditLog_Action'
) CREATE NONCLUSTERED INDEX IX_AuditLog_Action ON AuditLog (Action);

IF NOT EXISTS (
    SELECT *
    FROM sys.indexes
    WHERE
        name = 'IX_AuditLog_Timestamp'
) CREATE NONCLUSTERED INDEX IX_AuditLog_Timestamp ON AuditLog (Timestamp);

PRINT 'âœ… Created AuditLog Table with Indexes';
GO

/* ===== End: 5. AuditLog.sql ===== */

/* ===== Begin: 5. Điểm, phúc khảo, tốt nghiệp.sql ===== */
CREATE TABLE Diem (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaSV NVARCHAR(10) NOT NULL,
    MaLHP NVARCHAR(20) NOT NULL,
    DiemQT DECIMAL(4, 2) NULL,
    DiemGK DECIMAL(4, 2) NULL,
    DiemCK DECIMAL(4, 2) NULL,
    DiemTK DECIMAL(4, 2) NULL,
    DiemChu NVARCHAR (2) NULL,
    DiemHe4 DECIMAL(3, 2) NULL,
    KetQua NVARCHAR (20) NULL, -- "Äáº¡t" / "KhÃ´ng Ä‘áº¡t"
    NgayCapNhat DATETIME NOT NULL DEFAULT GETDATE (),
    NguoiNhap NVARCHAR(50) NULL,
    CONSTRAINT FK_Diem_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV),
    CONSTRAINT FK_Diem_LHP FOREIGN KEY (MaLHP) REFERENCES LopHocPhan (MaLHP),
    CONSTRAINT CK_Diem_DiemQT CHECK (DiemQT IS NULL OR (DiemQT >= 0 AND DiemQT <= 10)),
    CONSTRAINT CK_Diem_DiemGK CHECK (DiemGK IS NULL OR (DiemGK >= 0 AND DiemGK <= 10)),
    CONSTRAINT CK_Diem_DiemCK CHECK (DiemCK IS NULL OR (DiemCK >= 0 AND DiemCK <= 10))
);

CREATE TABLE PhucKhao (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaSV NVARCHAR(10) NOT NULL,
    MaLHP NVARCHAR(20) NOT NULL,
    LyDo NVARCHAR (500) NOT NULL,
    TrangThai NVARCHAR (50) NOT NULL DEFAULT N'Chá» xá»­ lÃ½',
    NgayGui DATETIME NOT NULL DEFAULT GETDATE (),
    NgayXuLy DATETIME NULL,
    GhiChuXuLy NVARCHAR (500) NULL,
    CONSTRAINT FK_PK_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV),
    CONSTRAINT FK_PK_LHP FOREIGN KEY (MaLHP) REFERENCES LopHocPhan (MaLHP)
);

CREATE TABLE DieuKienTotNghiep (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaNganh NVARCHAR(10) NOT NULL,
    MaKhoaTS NVARCHAR(10) NOT NULL,
    SoTinChiToiThieu INT NOT NULL,
    DiemTBTichLuyToiThieu DECIMAL(3, 2) NOT NULL,
    CONSTRAINT FK_DKTN_Nganh FOREIGN KEY (MaNganh) REFERENCES Nganh (MaNganh),
    CONSTRAINT FK_DKTN_KTS FOREIGN KEY (MaKhoaTS) REFERENCES KhoaTuyenSinh (MaKhoaTS)
);

CREATE TABLE XetTotNghiep (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaSV NVARCHAR(10) NOT NULL,
    LanXet INT NOT NULL,
    KetQua NVARCHAR (50) NOT NULL, -- "Äá»§ Ä‘iá»u kiá»‡n", "ChÆ°a Ä‘á»§ Ä‘iá»u kiá»‡n"
    LyDo NVARCHAR (500) NULL,
    NgayXet DATETIME NOT NULL DEFAULT GETDATE (),
    CONSTRAINT FK_XTN_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV)
);

/* ===== End: 5. Điểm, phúc khảo, tốt nghiệp.sql ===== */

/* ===== Begin: 6. Thông báo & log.sql ===== */
CREATE TABLE ThongBao (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    TieuDe NVARCHAR (200) NOT NULL,
    NoiDung NVARCHAR (MAX) NOT NULL,
    NguoiGui NVARCHAR(50) NOT NULL,
    NgayGui DATETIME NOT NULL DEFAULT GETDATE ()
);

CREATE TABLE ThongBao_NguoiNhan (
    IdThongBao INT NOT NULL,
    TenDangNhap NVARCHAR(50) NOT NULL,
    DaDoc BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (IdThongBao, TenDangNhap),
    CONSTRAINT FK_TBNN_TB FOREIGN KEY (IdThongBao) REFERENCES ThongBao (Id),
    CONSTRAINT FK_TBNN_TK FOREIGN KEY (TenDangNhap) REFERENCES TaiKhoan (TenDangNhap)
);

CREATE TABLE LogHeThong (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    TenDangNhap NVARCHAR(50) NOT NULL,
    HanhDong NVARCHAR (200) NOT NULL,
    ThoiGian DATETIME NOT NULL DEFAULT GETDATE (),
    ChiTiet NVARCHAR (MAX) NULL
);

/* ===== End: 6. Thông báo & log.sql ===== */

/* ===== Begin: 7. CRITICAL - Thiếu Index để tối ưu performance.sql ===== */
-- CRITICAL: ThÃªm Index Ä‘á»ƒ tá»‘i Æ°u performance
-- Index cho cÃ¡c trÆ°á»ng thÆ°á»ng query

-- Index cho SinhVien
CREATE INDEX IX_SinhVien_MaNganh ON SinhVien (MaNganh);

CREATE INDEX IX_SinhVien_MaKhoaTS ON SinhVien (MaKhoaTS);

CREATE INDEX IX_SinhVien_TrangThai ON SinhVien (TrangThai);

-- Index cho DangKyHocPhan
CREATE INDEX IX_DangKyHocPhan_MaSV ON DangKyHocPhan (MaSV);

CREATE INDEX IX_DangKyHocPhan_MaLHP ON DangKyHocPhan (MaLHP);

CREATE INDEX IX_DangKyHocPhan_TrangThai ON DangKyHocPhan (TrangThai);

-- Index cho Diem
CREATE INDEX IX_Diem_MaSV ON Diem (MaSV);

CREATE INDEX IX_Diem_MaLHP ON Diem (MaLHP);

-- Index cho TaiKhoan
CREATE INDEX IX_TaiKhoan_MaSV ON TaiKhoan (MaSV);

CREATE INDEX IX_TaiKhoan_MaGV ON TaiKhoan (MaGV);

CREATE INDEX IX_TaiKhoan_MaVaiTro ON TaiKhoan (MaVaiTro);

-- Index cho LopHocPhan
CREATE INDEX IX_LopHocPhan_MaHP ON LopHocPhan (MaHP);

CREATE INDEX IX_LopHocPhan_MaHK ON LopHocPhan (MaHK);

CREATE INDEX IX_LopHocPhan_MaGV ON LopHocPhan (MaGV);

-- Index cho GiangVien
CREATE INDEX IX_GiangVien_MaKhoa ON GiangVien (MaKhoa);

-- Index cho Nganh
CREATE INDEX IX_Nganh_MaKhoa ON Nganh (MaKhoa);

-- Index cho CTDT_ChiTiet
CREATE INDEX IX_CTDT_ChiTiet_MaCTDT ON CTDT_ChiTiet (MaCTDT);

CREATE INDEX IX_CTDT_ChiTiet_MaHP ON CTDT_ChiTiet (MaHP);

-- Index cho ThongBao_NguoiNhan
CREATE INDEX IX_ThongBao_NguoiNhan_TenDangNhap ON ThongBao_NguoiNhan (TenDangNhap);

CREATE INDEX IX_ThongBao_NguoiNhan_DaDoc ON ThongBao_NguoiNhan (DaDoc);

-- Index cho LogHeThong
CREATE INDEX IX_LogHeThong_TenDangNhap ON LogHeThong (TenDangNhap);

CREATE INDEX IX_LogHeThong_ThoiGian ON LogHeThong (ThoiGian);

/* ===== End: 7. CRITICAL - Thiếu Index để tối ưu performance.sql ===== */

/* ===== Begin: 8. IMPORTANT - Thiếu UNIQUE constraints.sql ===== */
-- IMPORTANT: ThÃªm UNIQUE constraints Ä‘á»ƒ trÃ¡nh duplicate data
-- Sá»­ dá»¥ng FILTERED INDEX cho cÃ¡c cá»™t cho phÃ©p NULL (SQL Server specific)

SET QUOTED_IDENTIFIER ON;
GO

-- TaiKhoan: 1 sinh viÃªn chá»‰ cÃ³ 1 tÃ i khoáº£n (bá» qua náº¿u MaSV lÃ  NULL)
CREATE UNIQUE
INDEX UIX_TaiKhoan_MaSV ON TaiKhoan (MaSV)
WHERE
    MaSV IS NOT NULL;

-- TaiKhoan: 1 giáº£ng viÃªn chá»‰ cÃ³ 1 tÃ i khoáº£n (bá» qua náº¿u MaGV lÃ  NULL)
CREATE UNIQUE
INDEX UIX_TaiKhoan_MaGV ON TaiKhoan (MaGV)
WHERE
    MaGV IS NOT NULL;

-- Email khÃ´ng Ä‘Æ°á»£c trÃ¹ng (bá» qua náº¿u Email lÃ  NULL)
CREATE UNIQUE
INDEX UIX_SinhVien_Email ON SinhVien (Email)
WHERE
    Email IS NOT NULL;

CREATE UNIQUE
INDEX UIX_GiangVien_Email ON GiangVien (Email)
WHERE
    Email IS NOT NULL;

-- DangKyHocPhan: Sinh viÃªn khÃ´ng Ä‘Äƒng kÃ½ trÃ¹ng lá»›p há»c pháº§n
-- (MaSV, MaLHP khÃ´ng nullable nÃªn dÃ¹ng Constraint thÆ°á»ng ok, nhÆ°ng Index cÅ©ng tá»‘t)
ALTER TABLE DangKyHocPhan
ADD CONSTRAINT UQ_DangKy_SV_LHP UNIQUE (MaSV, MaLHP);

-- Diem: 1 sinh viÃªn chá»‰ cÃ³ 1 báº£n Ä‘iá»ƒm cho 1 lá»›p há»c pháº§n
ALTER TABLE Diem ADD CONSTRAINT UQ_Diem_SV_LHP UNIQUE (MaSV, MaLHP);

-- TienQuyet: KhÃ´ng Ä‘á»‹nh nghÄ©a trÃ¹ng Ä‘iá»u kiá»‡n tiÃªn quyáº¿t
ALTER TABLE TienQuyet
ADD CONSTRAINT UQ_TienQuyet_HP UNIQUE (MaHP, MaHP_TienQuyet);

-- CTDT: Má»—i ngÃ nh-khÃ³a chá»‰ cÃ³ 1 CTÄT chÃ­nh thá»©c
ALTER TABLE CTDT
ADD CONSTRAINT UQ_CTDT_Nganh_Khoa UNIQUE (MaNganh, MaKhoaTS);

-- CongNo: Má»—i sinh viÃªn chá»‰ cÃ³ 1 dÃ²ng cÃ´ng ná»£ cho 1 há»c ká»³
-- (ÄÃ£ cÃ³ trong file 11, nhÆ°ng nháº¯c láº¡i logic á»Ÿ Ä‘Ã¢y Ä‘á»ƒ rÃµ rÃ ng - khÃ´ng cháº¡y láº¡i lá»‡nh nÃ y náº¿u file 11 Ä‘Ã£ cháº¡y)
-- ALTER TABLE CongNo ADD CONSTRAINT UQ_CongNo_SV_HK UNIQUE(MaSV, MaHK);

/* ===== End: 8. IMPORTANT - Thiếu UNIQUE constraints.sql ===== */

/* ===== Begin: 9. IMPORTANT - Thiếu CHECK constraints.sql ===== */
-- IMPORTANT: ThÃªm CHECK constraints Ä‘á»ƒ validate dá»¯ liá»‡u
-- LÆ°u Ã½: CK_Diem_DiemQT, CK_Diem_DiemGK, CK_Diem_DiemCK Ä‘Ã£ Ä‘Æ°á»£c thÃªm vÃ o file #5

-- Validate Ä‘iá»ƒm sá»‘ (0-10) - Tiáº¿t TK (TÃ­ch lÅ©y)
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_Diem_DiemTK' AND TABLE_NAME = 'Diem'
)
BEGIN
    ALTER TABLE Diem
    ADD CONSTRAINT CK_Diem_DiemTK CHECK (
        DiemTK IS NULL
        OR (
            DiemTK >= 0
            AND DiemTK <= 10
        )
    );
END;

-- Validate Ä‘iá»ƒm há»‡ 4
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_Diem_DiemHe4' AND TABLE_NAME = 'Diem'
)
BEGIN
    ALTER TABLE Diem
    ADD CONSTRAINT CK_Diem_DiemHe4 CHECK (
        DiemHe4 IS NULL
        OR (
            DiemHe4 >= 0
            AND DiemHe4 <= 4
        )
    );
END;

-- Validate Ä‘iá»ƒm chá»¯
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_Diem_DiemChu' AND TABLE_NAME = 'Diem'
)
BEGIN
    ALTER TABLE Diem
    ADD CONSTRAINT CK_Diem_DiemChu CHECK (
        DiemChu IS NULL
        OR DiemChu IN (
            N'A+',
            N'A',
            N'B+',
            N'B',
            N'C+',
            N'C',
            N'D+',
            N'D',
            N'F'
        )
    );
END;

-- Validate káº¿t quáº£
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_Diem_KetQua' AND TABLE_NAME = 'Diem'
)
BEGIN
    ALTER TABLE Diem
    ADD CONSTRAINT CK_Diem_KetQua CHECK (
        KetQua IS NULL
        OR KetQua IN (N'Äáº¡t', N'KhÃ´ng Ä‘áº¡t')
    );
END;

-- Validate há»c ká»³ (ngÃ y káº¿t thÃºc pháº£i sau ngÃ y báº¯t Ä‘áº§u)
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_HocKy_NgayBatDau' AND TABLE_NAME = 'HocKy'
)
BEGIN
    ALTER TABLE HocKy
    ADD CONSTRAINT CK_HocKy_NgayBatDau CHECK (NgayKetThuc > NgayBatDau);
END;

-- Validate nÄƒm há»c
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_NamHoc' AND TABLE_NAME = 'NamHoc'
)
BEGIN
    ALTER TABLE NamHoc
    ADD CONSTRAINT CK_NamHoc CHECK (NamKetThuc = NamBatDau + 1);
END;
GO

-- Validate thá»© trong tuáº§n (2=Thá»© 2, 7=Chá»§ nháº­t)
ALTER TABLE LopHocPhan
ADD CONSTRAINT CK_LHP_ThuTrongTuan CHECK (ThuTrongTuan BETWEEN 2 AND 7);

-- Validate sÄ© sá»‘
ALTER TABLE LopHocPhan
ADD CONSTRAINT CK_LHP_SiSo CHECK (SiSoToiDa > 0);

ALTER TABLE PhongHoc
ADD CONSTRAINT CK_PhongHoc_SucChua CHECK (SucChua > 0);

-- Validate sá»‘ tÃ­n chá»‰
ALTER TABLE HocPhan
ADD CONSTRAINT CK_HocPhan_SoTinChi CHECK (SoTinChi > 0);

-- Validate giá» há»c
ALTER TABLE CaHoc
ADD CONSTRAINT CK_CaHoc_Gio CHECK (GioKetThuc > GioBatDau);

-- Validate tráº¡ng thÃ¡i sinh viÃªn
ALTER TABLE SinhVien
ADD CONSTRAINT CK_SinhVien_TrangThai CHECK (
    TrangThai IN (
        N'Äang há»c',
        N'Báº£o lÆ°u',
        N'ThÃ´i há»c',
        N'Tá»‘t nghiá»‡p'
    )
);

-- Validate giá»›i tÃ­nh
ALTER TABLE SinhVien
ADD CONSTRAINT CK_SinhVien_GioiTinh CHECK (
    GioiTinh IS NULL
    OR GioiTinh IN (N'Nam', N'Ná»¯', N'KhÃ¡c')
);

-- Validate tráº¡ng thÃ¡i Ä‘Äƒng kÃ½
ALTER TABLE DangKyHocPhan
ADD CONSTRAINT CK_DangKy_TrangThai CHECK (
    TrangThai IN (N'ÄÄƒng kÃ½', N'Há»§y')
);

-- Validate tráº¡ng thÃ¡i phÃºc kháº£o
ALTER TABLE PhucKhao
ADD CONSTRAINT CK_PhucKhao_TrangThai CHECK (
    TrangThai IN (
        N'Chá» xá»­ lÃ½',
        N'ÄÃ£ xá»­ lÃ½',
        N'Tá»« chá»‘i'
    )
);

-- Validate káº¿t quáº£ xÃ©t tá»‘t nghiá»‡p
ALTER TABLE XetTotNghiep
ADD CONSTRAINT CK_XetTotNghiep_KetQua CHECK (
    KetQua IN (
        N'Äá»§ Ä‘iá»u kiá»‡n',
        N'ChÆ°a Ä‘á»§ Ä‘iá»u kiá»‡n'
    )
);

-- Validate Ä‘iá»u kiá»‡n tá»‘t nghiá»‡p
ALTER TABLE DieuKienTotNghiep
ADD CONSTRAINT CK_DieuKienTN_TinChi CHECK (SoTinChiToiThieu > 0);

ALTER TABLE DieuKienTotNghiep
ADD CONSTRAINT CK_DieuKienTN_DiemTB CHECK (
    DiemTBTichLuyToiThieu >= 0
    AND DiemTBTichLuyToiThieu <= 4
);

/* ===== End: 9. IMPORTANT - Thiếu CHECK constraints.sql ===== */

/* ===== Begin: Schema_GradeManagement.sql ===== */
USE EduProDb;
GO

-- 1. Add Weight columns to LopHocPhan if not exist
IF NOT EXISTS (
    SELECT 1
    FROM sys.columns
    WHERE
        Name = N'TrongSoCC'
        AND Object_ID = Object_ID (N'LopHocPhan')
) BEGIN
ALTER TABLE LopHocPhan
ADD TrongSoCC DECIMAL(3, 2) NOT NULL DEFAULT 0.1;
-- 10%
ALTER TABLE LopHocPhan
ADD TrongSoGK DECIMAL(3, 2) NOT NULL DEFAULT 0.4;
-- 40%
ALTER TABLE LopHocPhan
ADD TrongSoCK DECIMAL(3, 2) NOT NULL DEFAULT 0.5;
-- 50%

PRINT 'Added Weight columns to LopHocPhan';

END

-- 2. SP: Get Classes for Lecturer
-- Used by: Lecturer Dashboard
IF OBJECT_ID ('sp_Lecturer_GetClasses', 'P') IS NOT NULL
DROP PROC sp_Lecturer_GetClasses;
GO
CREATE PROCEDURE sp_Lecturer_GetClasses
    @MaGV NVARCHAR(10),
    @NamHoc INT = NULL,
    @HocKy INT = NULL
AS
BEGIN
    SELECT 
        lhp.MaLHP,
        hp.TenHP,
        hp.SoTinChi,
        lhp.SiSoToiDa,
        (SELECT COUNT(*) FROM DangKyHocPhan dk WHERE dk.MaLHP = lhp.MaLHP) AS SiSoThucTe,
        lhp.ThuTrongTuan,
        lhp.MaCa,
        lhp.MaPhong,
        lhp.TrongSoCC,
        lhp.TrongSoGK,
        lhp.TrongSoCK
    FROM LopHocPhan lhp
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    WHERE lhp.MaGV = @MaGV
    -- Filter by Year/Semester if needed (For now get all)
    ORDER BY lhp.MaLHP DESC;
END;
GO

-- 3. SP: Get Students in Class (Gradebook)
-- Used by: Lecturer Grade Entry
IF OBJECT_ID (
    'sp_Lecturer_GetClassGrades',
    'P'
) IS NOT NULL
DROP PROC sp_Lecturer_GetClassGrades;
GO
CREATE PROCEDURE sp_Lecturer_GetClassGrades
    @MaLHP NVARCHAR(20)
AS
BEGIN
    SELECT 
        sv.MaSV,
        sv.HoTen,
        sv.LopHanhChinh AS Lop, -- Aliased for frontend consistency
        ISNULL(d.DiemQT, 0) AS DiemTC, -- Re-map CC/QT if needed (DiemQT is Qua Trinh / CC)
        ISNULL(d.DiemGK, 0) AS DiemGK,
        ISNULL(d.DiemCK, 0) AS DiemCK,
        d.DiemTK,
        d.DiemChu,
        d.KetQua
    FROM DangKyHocPhan dk
    JOIN SinhVien sv ON dk.MaSV = sv.MaSV
    LEFT JOIN Diem d ON dk.MaSV = d.MaSV AND dk.MaLHP = d.MaLHP
    WHERE dk.MaLHP = @MaLHP
    ORDER BY sv.HoTen; -- Sort by Full Name
END;
GO

-- 4. SP: Update Student Grade
-- Used by: Lecturer Grade Entry (Save)
IF OBJECT_ID (
    'sp_Lecturer_UpdateGrade',
    'P'
) IS NOT NULL
DROP PROC sp_Lecturer_UpdateGrade;
GO
CREATE PROCEDURE sp_Lecturer_UpdateGrade
    @MaLHP NVARCHAR(20),
    @MaSV NVARCHAR(10),
    @DiemCC DECIMAL(4,2),
    @DiemGK DECIMAL(4,2),
    @DiemCK DECIMAL(4,2),
    @PerformedBy NVARCHAR(50)
AS
BEGIN
    DECLARE @TrongSoCC DECIMAL(3,2), @TrongSoGK DECIMAL(3,2), @TrongSoCK DECIMAL(3,2);
    
    -- Get Weights
    SELECT @TrongSoCC = TrongSoCC, @TrongSoGK = TrongSoGK, @TrongSoCK = TrongSoCK
    FROM LopHocPhan WHERE MaLHP = @MaLHP;

    -- Calculate Final
    DECLARE @DiemTK DECIMAL(4,2);
    SET @DiemTK = (@DiemCC * @TrongSoCC) + (@DiemGK * @TrongSoGK) + (@DiemCK * @TrongSoCK);
    
    -- Rounding rules (Standard: Round to 1 decimal place? Or 2? Let's keep 2 for DB, display 1)
    
    -- Calculate Letter Grade and 4.0 Scale
    DECLARE @DiemChu NVARCHAR(2);
    DECLARE @DiemHe4 DECIMAL(3,2);
    DECLARE @KetQua NVARCHAR(20);

    -- Simple conversion logic (Can be moved to a Function later)
    IF @DiemTK >= 8.5 BEGIN SET @DiemChu = 'A'; SET @DiemHe4 = 4.0; END
    ELSE IF @DiemTK >= 8.0 BEGIN SET @DiemChu = 'B+'; SET @DiemHe4 = 3.5; END
    ELSE IF @DiemTK >= 7.0 BEGIN SET @DiemChu = 'B'; SET @DiemHe4 = 3.0; END
    ELSE IF @DiemTK >= 6.5 BEGIN SET @DiemChu = 'C+'; SET @DiemHe4 = 2.5; END
    ELSE IF @DiemTK >= 5.5 BEGIN SET @DiemChu = 'C'; SET @DiemHe4 = 2.0; END
    ELSE IF @DiemTK >= 5.0 BEGIN SET @DiemChu = 'D+'; SET @DiemHe4 = 1.5; END
    ELSE IF @DiemTK >= 4.0 BEGIN SET @DiemChu = 'D'; SET @DiemHe4 = 1.0; END
    ELSE BEGIN SET @DiemChu = 'F'; SET @DiemHe4 = 0.0; END

    IF @DiemTK >= 4.0 SET @KetQua = N'Äáº¡t' ELSE SET @KetQua = N'KhÃ´ng Ä‘áº¡t';

    -- Upsert Diem
    MERGE Diem AS target
    USING (SELECT @MaSV AS MaSV, @MaLHP AS MaLHP) AS source
    ON (target.MaSV = source.MaSV AND target.MaLHP = source.MaLHP)
    WHEN MATCHED THEN
        UPDATE SET 
            DiemQT = @DiemCC, 
            DiemGK = @DiemGK, 
            DiemCK = @DiemCK,
            DiemTK = @DiemTK,
            DiemChu = @DiemChu,
            DiemHe4 = @DiemHe4,
            KetQua = @KetQua,
            NguoiNhap = @PerformedBy,
            NgayCapNhat = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (MaSV, MaLHP, DiemQT, DiemGK, DiemCK, DiemTK, DiemChu, DiemHe4, KetQua, NguoiNhap)
        VALUES (@MaSV, @MaLHP, @DiemCC, @DiemGK, @DiemCK, @DiemTK, @DiemChu, @DiemHe4, @KetQua, @PerformedBy);
        
END;

PRINT 'Grade Management Schema & SPs Created';
GO

/* ===== End: Schema_GradeManagement.sql ===== */

/* ===== Begin: Schema_StudentGrades.sql ===== */
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

/* ===== End: Schema_StudentGrades.sql ===== */

