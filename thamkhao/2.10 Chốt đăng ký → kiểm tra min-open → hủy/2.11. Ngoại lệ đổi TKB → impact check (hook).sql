CREATE PROCEDURE dbo.sp_Schedule_ImpactCheck
    @SemesterId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- trả về DS SV bị trùng lịch mới sau khi đổi official schedule
    SELECT DISTINCT e.StudentId
    FROM dbo.Enrollments e
    JOIN dbo.SectionSchedules sch1 ON sch1.SectionId=e.SectionId AND sch1.IsOfficial=1
    JOIN dbo.SectionSchedules sch2 ON sch2.IsOfficial=1
    JOIN dbo.Sections s2 ON sch2.SectionId=s2.SectionId AND s2.SemesterId=@SemesterId
    WHERE e.Status=1
      AND sch1.SectionId <> sch2.SectionId
      AND sch1.WeekDay=sch2.WeekDay
      AND sch1.StartTime < sch2.EndTime AND sch1.EndTime > sch2.StartTime;
END
GO