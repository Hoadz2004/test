GO
CREATE PROCEDURE dbo.sp_Schedule_SaveDraft
    @SectionId INT,
    @WeekDay TINYINT,
    @StartTime TIME,
    @EndTime TIME,
    @RoomId INT = NULL
AS
BEGIN
    INSERT dbo.SectionSchedules(SectionId,WeekDay,StartTime,EndTime,RoomId,IsOfficial)
    VALUES(@SectionId,@WeekDay,@StartTime,@EndTime,@RoomId,0);
END
GO