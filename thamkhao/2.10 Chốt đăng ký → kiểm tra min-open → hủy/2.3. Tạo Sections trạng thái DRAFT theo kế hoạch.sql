CREATE PROCEDURE dbo.sp_Sections_CreateFromPlan
    @PlanId INT,
    @SemesterId INT,
    @ActorId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CourseId INT, @Expected INT, @MinCap INT, @MaxCap INT, @Mode TINYINT, @FacultyId INT;
    DECLARE cur CURSOR FOR
        SELECT CourseId, ExpectedSections, MinCapacity, MaxCapacity, DeliveryMode, ProposedFacultyId
        FROM dbo.PlannedCourses WHERE PlanId=@PlanId;

    OPEN cur;
    FETCH NEXT FROM cur INTO @CourseId,@Expected,@MinCap,@MaxCap,@Mode,@FacultyId;

    WHILE @@FETCH_STATUS=0
    BEGIN
        DECLARE @i INT=1;
        WHILE @i<=@Expected
        BEGIN
            DECLARE @SecCode NVARCHAR(30)=CONCAT(
                (SELECT CourseCode FROM dbo.Courses WHERE CourseId=@CourseId), 
                '-', @i, '-', @SemesterId
            );

            INSERT dbo.Sections(SemesterId,CourseId,SectionCode,Status,MinCapacity,MaxCapacity,FacultyId,DeliveryMode)
            VALUES(@SemesterId,@CourseId,@SecCode,0,@MinCap,@MaxCap,@FacultyId,@Mode);

            SET @i=@i+1;
        END

        FETCH NEXT FROM cur INTO @CourseId,@Expected,@MinCap,@MaxCap,@Mode,@FacultyId;
    END

    CLOSE cur; DEALLOCATE cur;

    INSERT dbo.AuditLogs(EntityName,EntityId,Action,NewValue,ActorId)
    VALUES('Sections',@SemesterId,'INSERT','Create sections from plan',@ActorId);
END
GO