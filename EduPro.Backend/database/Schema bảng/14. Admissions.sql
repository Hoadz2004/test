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
        TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Đã nộp',
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
        TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Chưa kiểm tra',
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
