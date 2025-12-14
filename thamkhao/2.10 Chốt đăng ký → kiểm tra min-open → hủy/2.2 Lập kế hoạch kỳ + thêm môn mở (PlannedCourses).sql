CREATE PROCEDURE dbo.sp_SemesterPlan_Create
    @SemesterId INT,
    @DepartmentId INT = NULL,
    @CreatedBy INT
AS
BEGIN
    INSERT dbo.SemesterPlans(SemesterId,DepartmentId,CreatedBy)
    VALUES(@SemesterId,@DepartmentId,@CreatedBy);

    SELECT SCOPE_IDENTITY() AS PlanId;
END
GO

CREATE PROCEDURE dbo.sp_SemesterPlan_AddCourse
    @PlanId INT,
    @CourseId INT,
    @ExpectedSections INT,
    @MinCapacity INT,
    @MaxCapacity INT,
    @DeliveryMode TINYINT,
    @ProposedFacultyId INT = NULL
AS
BEGIN
    INSERT dbo.PlannedCourses(PlanId,CourseId,ExpectedSections,MinCapacity,MaxCapacity,DeliveryMode,ProposedFacultyId)
    VALUES(@PlanId,@CourseId,@ExpectedSections,@MinCapacity,@MaxCapacity,@DeliveryMode,@ProposedFacultyId);

    SELECT SCOPE_IDENTITY() AS PlanCourseId;
END
GO