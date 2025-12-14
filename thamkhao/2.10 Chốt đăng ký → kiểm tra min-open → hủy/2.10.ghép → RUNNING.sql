CREATE PROCEDURE dbo.sp_Sections_FinalizeAfterReg
    @SemesterId INT,
    @ActorId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- cancel sections below min-open
    UPDATE s
    SET Status=3, UpdatedAt=GETDATE()
    FROM dbo.Sections s
    WHERE s.SemesterId=@SemesterId
      AND s.Status=1
      AND (SELECT COUNT(*) FROM dbo.Enrollments e WHERE e.SectionId=s.SectionId AND e.Status=1) < s.MinCapacity;

    -- running sections
    UPDATE s
    SET Status=2, UpdatedAt=GETDATE()
    FROM dbo.Sections s
    WHERE s.SemesterId=@SemesterId
      AND s.Status=1;

    INSERT dbo.AuditLogs(EntityName,EntityId,Action,NewValue,ActorId)
    VALUES('Sections',@SemesterId,'UPDATE','Finalize sections after registration',@ActorId);
END
GO