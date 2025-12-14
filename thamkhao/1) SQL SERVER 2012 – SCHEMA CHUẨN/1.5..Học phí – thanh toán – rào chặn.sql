CREATE TABLE dbo.Invoices (
    InvoiceId INT IDENTITY PRIMARY KEY,
    StudentId INT NOT NULL,
    SemesterId INT NOT NULL,
    TotalAmount DECIMAL(18, 2) NOT NULL,
    DiscountAmount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    NetAmount AS (TotalAmount - DiscountAmount) PERSISTED,
    DueDate DATE NOT NULL,
    Status TINYINT NOT NULL DEFAULT 0, --0=Unpaid,1=Partial,2=Paid,3=Overdue,4=Cancelled
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE (),
    CONSTRAINT FK_Inv_Student FOREIGN KEY (StudentId) REFERENCES dbo.Students (StudentId),
    CONSTRAINT FK_Inv_Sem FOREIGN KEY (SemesterId) REFERENCES dbo.Semesters (SemesterId)
);
GO

CREATE TABLE dbo.InvoiceItems (
    ItemId INT IDENTITY PRIMARY KEY,
    InvoiceId INT NOT NULL,
    SectionId INT NOT NULL,
    CourseId INT NOT NULL,
    Credits TINYINT NOT NULL,
    UnitPrice DECIMAL(18, 2) NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    CONSTRAINT FK_Item_Inv FOREIGN KEY (InvoiceId) REFERENCES dbo.Invoices (InvoiceId),
    CONSTRAINT FK_Item_Sec FOREIGN KEY (SectionId) REFERENCES dbo.Sections (SectionId)
);
GO

CREATE TABLE dbo.Payments (
    PaymentId INT IDENTITY PRIMARY KEY,
    InvoiceId INT NOT NULL,
    PaidAmount DECIMAL(18, 2) NOT NULL,
    PaidAt DATETIME NOT NULL DEFAULT GETDATE (),
    Method TINYINT NOT NULL, --1=Cash,2=Bank,3=Online
    RefNo NVARCHAR (50) NULL,
    CONSTRAINT FK_Pay_Inv FOREIGN KEY (InvoiceId) REFERENCES dbo.Invoices (InvoiceId)
);
GO

CREATE TABLE dbo.StudentHolds (
    HoldId INT IDENTITY PRIMARY KEY,
    StudentId INT NOT NULL,
    HoldType TINYINT NOT NULL, --1=Financial,2=Academic
    Reason NVARCHAR (200) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE (),
    ReleasedAt DATETIME NULL,
    CONSTRAINT FK_Hold_Student FOREIGN KEY (StudentId) REFERENCES dbo.Students (StudentId)
);
GO

CREATE INDEX IX_Hold_Active ON dbo.StudentHolds (StudentId, HoldType, IsActive);
GO