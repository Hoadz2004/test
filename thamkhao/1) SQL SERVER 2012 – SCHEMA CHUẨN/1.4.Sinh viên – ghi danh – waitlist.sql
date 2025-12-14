CREATE TABLE dbo.Students (
    StudentId INT IDENTITY PRIMARY KEY,
    StudentCode NVARCHAR (20) NOT NULL UNIQUE,
    FullName NVARCHAR (200) NOT NULL,
    DepartmentId INT NOT NULL,
    Status TINYINT NOT NULL DEFAULT 1 --1=Active,2=OnHold,3=Dropout,4=Graduated
);
GO

CREATE TABLE dbo.Enrollments (
    EnrollmentId INT IDENTITY PRIMARY KEY,
    StudentId INT NOT NULL,
    SectionId INT NOT NULL,
    Status TINYINT NOT NULL DEFAULT 0,
    --0=TEMP_ENROLL,1=ENROLLED,2=PENDING_CANCEL,3=CANCEL_BY_FINANCE,4=CANCELED_BY_ADMIN
    EnrolledAt DATETIME NOT NULL DEFAULT GETDATE (),
    ConfirmedAt DATETIME NULL,
    CanceledAt DATETIME NULL,
    CancelReason NVARCHAR (200) NULL,
    CONSTRAINT FK_Enroll_Student FOREIGN KEY (StudentId) REFERENCES dbo.Students (StudentId),
    CONSTRAINT FK_Enroll_Section FOREIGN KEY (SectionId) REFERENCES dbo.Sections (SectionId),
    UNIQUE (StudentId, SectionId)
);
GO

CREATE TABLE dbo.Waitlists (
    WaitlistId INT IDENTITY PRIMARY KEY,
    StudentId INT NOT NULL,
    SectionId INT NOT NULL,
    PriorityNo INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE (),
    Status TINYINT NOT NULL DEFAULT 0, --0=Waiting,1=Promoted,2=Removed
    CONSTRAINT FK_Wait_Student FOREIGN KEY (StudentId) REFERENCES dbo.Students (StudentId),
    CONSTRAINT FK_Wait_Section FOREIGN KEY (SectionId) REFERENCES dbo.Sections (SectionId)
);
GO

CREATE INDEX IX_Waitlist_Section ON dbo.Waitlists (SectionId, Status, PriorityNo);
GO