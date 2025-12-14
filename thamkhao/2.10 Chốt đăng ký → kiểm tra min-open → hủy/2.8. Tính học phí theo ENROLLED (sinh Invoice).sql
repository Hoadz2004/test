CREATE PROCEDURE dbo.sp_Invoice_GenerateForStudent
    @StudentId INT,
    @SemesterId INT,
    @UnitPrice DECIMAL(18,2),
    @DueDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @Total DECIMAL(18,2)=0;

        SELECT @Total = SUM(c.Credits * @UnitPrice)
        FROM dbo.Enrollments e
        JOIN dbo.Sections s ON e.SectionId=s.SectionId
        JOIN dbo.Courses c ON s.CourseId=c.CourseId
        WHERE e.StudentId=@StudentId AND e.Status=1 AND s.SemesterId=@SemesterId;

        IF @Total IS NULL SET @Total=0;

        INSERT dbo.Invoices(StudentId,SemesterId,TotalAmount,DueDate)
        VALUES(@StudentId,@SemesterId,@Total,@DueDate);

        DECLARE @InvoiceId INT=SCOPE_IDENTITY();

        INSERT dbo.InvoiceItems(InvoiceId,SectionId,CourseId,Credits,UnitPrice,Amount)
        SELECT @InvoiceId, s.SectionId, c.CourseId, c.Credits, @UnitPrice, c.Credits*@UnitPrice
        FROM dbo.Enrollments e
        JOIN dbo.Sections s ON e.SectionId=s.SectionId
        JOIN dbo.Courses c ON s.CourseId=c.CourseId
        WHERE e.StudentId=@StudentId AND e.Status=1 AND s.SemesterId=@SemesterId;

        COMMIT;
        SELECT @InvoiceId AS InvoiceId, @Total AS TotalAmount;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH
END