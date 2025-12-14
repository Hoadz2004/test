-- Schema: Payment / Học phí / Thanh toán
USE EduProDb;
GO

-- Bảng đơn giá học phí theo ngành + học kỳ
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
        GiamTruPercent DECIMAL(5,2) NOT NULL DEFAULT 0, -- giảm trừ %
        NgayHetHan DATE NULL, -- hạn nộp
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_HocPhi_Nganh FOREIGN KEY (MaNganh) REFERENCES Nganh(MaNganh),
        CONSTRAINT FK_HocPhi_HK FOREIGN KEY (MaHK) REFERENCES HocKy(MaHK),
        CONSTRAINT CK_HocPhi_HieuLuc CHECK (HieuLucDen IS NULL OR HieuLucDen >= HieuLucTu)
    );

    CREATE UNIQUE INDEX UQ_HocPhi_Nganh_HK_Effective
        ON HocPhiCatalog (MaNganh, MaHK, HieuLucTu);
END;
GO

-- Bảng giao dịch thanh toán
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

-- Bảng ledger thanh toán (audit + hoàn/điều chỉnh)
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
