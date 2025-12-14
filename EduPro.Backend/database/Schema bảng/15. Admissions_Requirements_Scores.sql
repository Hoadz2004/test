-- Bảng yêu cầu môn theo ngành/khối thi
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

-- Bảng điểm hồ sơ theo môn
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

-- Lịch sử trạng thái (để log liên hệ/điểm)
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
