-- Index to speed up AuditLog filters (Keyword/Action/Status/Module/Date range) and pagination
-- Run on EduProDb1
USE EduProDb1;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = N'IX_AuditLog_FilterPaging'
      AND object_id = OBJECT_ID(N'dbo.AuditLog')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_AuditLog_FilterPaging
        ON dbo.AuditLog (Timestamp DESC, Action, Status, Module)
        INCLUDE (PerformedBy, NewValue, EntityTable, EntityId, IPAddress);
END
GO
