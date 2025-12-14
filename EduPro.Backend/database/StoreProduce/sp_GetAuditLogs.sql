SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.sp_GetAuditLogs', N'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetAuditLogs;
GO

CREATE PROCEDURE dbo.sp_GetAuditLogs
    @Keyword    NVARCHAR(200) = NULL,
    @FromDate   DATETIME      = NULL,
    @ToDate     DATETIME      = NULL,
    @Action     NVARCHAR(50)  = NULL,
    @Status     NVARCHAR(50)  = NULL,
    @Module     NVARCHAR(100) = NULL,
    @PageNumber INT = 1,
    @PageSize   INT = 20
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT LogId,
           Action,
           EntityTable,
           EntityId,
           OldValue,
           NewValue,
           PerformedBy,
           [Timestamp],
           IPAddress,
           Status,
           Module,
           COUNT(*) OVER() AS TotalRecords
    FROM AuditLog WITH (NOLOCK)
    WHERE (@Keyword IS NULL
           OR PerformedBy LIKE '%' + @Keyword + '%'
           OR NewValue LIKE '%' + @Keyword + '%'
           OR Module LIKE '%' + @Keyword + '%'
           OR Action LIKE '%' + @Keyword + '%')
      AND (@FromDate IS NULL OR [Timestamp] >= @FromDate)
      AND (@ToDate   IS NULL OR [Timestamp] <= @ToDate)
      AND (@Action   IS NULL OR Action = @Action)
      AND (@Status   IS NULL OR Status = @Status)
      AND (@Module   IS NULL OR Module = @Module)
    ORDER BY [Timestamp] DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO
