CREATE PROCEDURE dbo.sp_Schedule_PublishOfficial
    @SemesterId INT,
    @ActorId INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.SectionSchedules
    SET IsOfficial=1
    WHERE SectionId IN (SELECT SectionId FROM dbo.Sections WHERE SemesterId=@SemesterId)
      AND IsOfficial=0;

    UPDATE dbo.Sections
    SET Status=1, UpdatedAt=GETDATE()
    WHERE SemesterId=@SemesterId AND Status=0;

    INSERT dbo.AuditLogs(EntityName,EntityId,Action,NewValue,ActorId)
    VALUES('SectionSchedules',@SemesterId,'UPDATE','Publish official timetable',@ActorId);
END
GO