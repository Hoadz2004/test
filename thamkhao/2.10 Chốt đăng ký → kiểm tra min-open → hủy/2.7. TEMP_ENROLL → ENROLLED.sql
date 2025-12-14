/* 2.7. Ghi danh TEMP -> ENROLLED */
CREATE PROCEDURE dbo.sp_Enrollment_TempEnroll
    @StudentId INT,
    @SectionId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        -- capacity check
        DECLARE @MaxCap INT;
        SELECT @MaxCap=MaxCapacity FROM dbo.Sections WHERE SectionId=@SectionId;

        IF (SELECT COUNT(*) FROM dbo.Enrollments WHERE SectionId=@SectionId AND Status IN (0,1)) >= @MaxCap
        BEGIN
            -- waitlist
            INSERT dbo.Waitlists(StudentId,SectionId,PriorityNo)
            VALUES(@StudentId,@SectionId,
               ISNULL((SELECT MAX(PriorityNo)+1 FROM dbo.Waitlists WHERE SectionId=@SectionId),1));

            COMMIT;
            SELECT 0 AS IsTempEnrolled, 1 AS IsWaitlisted;
            RETURN;
        END

        INSERT dbo.Enrollments(StudentId,SectionId,Status)
        VALUES(@StudentId,@SectionId,0);

        COMMIT;
        SELECT 1 AS IsTempEnrolled, 0 AS IsWaitlisted;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH
END

CREATE PROCEDURE dbo.sp_Enrollment_Confirm
    @StudentId INT,
    @SectionId INT
AS
BEGIN
    UPDATE dbo.Enrollments
    SET Status=1, ConfirmedAt=GETDATE()
    WHERE StudentId=@StudentId AND SectionId=@SectionId AND Status=0;
END
GO