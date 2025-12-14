CREATE PROCEDURE dbo.sp_Enrollment_Check
    @StudentId INT,
    @SectionId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CourseId INT, @SemesterId INT;
    SELECT @CourseId=CourseId, @SemesterId=SemesterId FROM dbo.Sections WHERE SectionId=@SectionId;

    -- 1) Section must be OPEN
    IF NOT EXISTS (SELECT 1 FROM dbo.Sections WHERE SectionId=@SectionId AND Status=1)
    BEGIN SELECT 0 AS Pass, N'Section not open' AS Reason; RETURN; END

    -- 2) Financial / Academic holds
    IF EXISTS (SELECT 1 FROM dbo.StudentHolds WHERE StudentId=@StudentId AND IsActive=1)
    BEGIN SELECT 0 AS Pass, N'Student hold active' AS Reason; RETURN; END

    -- 3) Prerequisite check (simple: must pass prereq)
    IF EXISTS (
        SELECT 1
        FROM dbo.CoursePrerequisites p
        WHERE p.CourseId=@CourseId
          AND NOT EXISTS (
              SELECT 1 FROM dbo.Enrollments e
              JOIN dbo.Sections s ON e.SectionId=s.SectionId
              WHERE e.StudentId=@StudentId AND e.Status=1
                AND s.CourseId=p.PrereqCourseId
          )
    )
    BEGIN SELECT 0 AS Pass, N'Prerequisite not satisfied' AS Reason; RETURN; END

    -- 4) Schedule conflict check vs official schedules already ENROLLED
    IF EXISTS(
        SELECT 1
        FROM dbo.SectionSchedules schNew
        JOIN dbo.Enrollments e ON e.StudentId=@StudentId AND e.Status IN (0,1)
        JOIN dbo.SectionSchedules schOld ON schOld.SectionId=e.SectionId AND schOld.IsOfficial=1
        WHERE schNew.SectionId=@SectionId AND schNew.IsOfficial=1
          AND schNew.WeekDay=schOld.WeekDay
          AND schNew.StartTime < schOld.EndTime AND schNew.EndTime > schOld.StartTime
    )
    BEGIN SELECT 0 AS Pass, N'Schedule conflict' AS Reason; RETURN; END

    SELECT 1 AS Pass, NULL AS Reason;
END
GO