CREATE PROCEDURE dbo.sp_Course_Upsert
    @CourseCode NVARCHAR(20),
    @CourseName NVARCHAR(200),
    @Credits TINYINT,
    @LectureHours SMALLINT,
    @LabHours SMALLINT,
    @CourseType TINYINT,
    @DepartmentId INT,
    @ActorId INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CourseId INT;

    IF EXISTS (SELECT 1 FROM dbo.Courses WHERE CourseCode=@CourseCode)
    BEGIN
        SELECT @CourseId=CourseId FROM dbo.Courses WHERE CourseCode=@CourseCode;
        UPDATE dbo.Courses
        SET CourseName=@CourseName, Credits=@Credits, LectureHours=@LectureHours,
            LabHours=@LabHours, CourseType=@CourseType, DepartmentId=@DepartmentId,
            UpdatedAt=GETDATE()
        WHERE CourseId=@CourseId;

        INSERT dbo.AuditLogs(EntityName,EntityId,Action,NewValue,ActorId)
        VALUES('Courses',@CourseId,'UPDATE',@CourseName,@ActorId);
    END
    ELSE
    BEGIN
        INSERT dbo.Courses(CourseCode,CourseName,Credits,LectureHours,LabHours,CourseType,DepartmentId)
        VALUES(@CourseCode,@CourseName,@Credits,@LectureHours,@LabHours,@CourseType,@DepartmentId);
        SET @CourseId=SCOPE_IDENTITY();

        INSERT dbo.AuditLogs(EntityName,EntityId,Action,NewValue,ActorId)
        VALUES('Courses',@CourseId,'INSERT',@CourseName,@ActorId);
    END

    SELECT @CourseId AS CourseId;
END
GO

CREATE TYPE dbo.IntList AS TABLE (Value INT NOT NULL);
GO