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

PRINT '✅ Created AuditLog Table with Indexes';
GO