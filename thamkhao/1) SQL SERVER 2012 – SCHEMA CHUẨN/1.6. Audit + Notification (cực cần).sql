CREATE PROCEDURE dbo.sp_Course_SetPrerequisites
    @CourseId INT,
    @ActorId INT,
    @PrereqList dbo.IntList READONLY  -- user-defined table type
AS
BEGIN
    SET NOCOUNT ON;
    DELETE dbo.CoursePrerequisites WHERE CourseId=@CourseId;

    INSERT dbo.CoursePrerequisites(CourseId,PrereqCourseId)
    SELECT @CourseId, Value FROM @PrereqList;

    INSERT dbo.AuditLogs(EntityName,EntityId,Action,NewValue,ActorId)
    VALUES('CoursePrerequisites',@CourseId,'UPDATE','Reset prereq list',@ActorId);
END
GO