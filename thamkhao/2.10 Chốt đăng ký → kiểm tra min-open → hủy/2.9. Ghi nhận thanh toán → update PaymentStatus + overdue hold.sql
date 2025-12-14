/* 2.9. Ghi nhận thanh toán & Update Status */
CREATE PROCEDURE dbo.sp_Payment_Add
    @InvoiceId INT,
    @PaidAmount DECIMAL(18,2),
    @Method TINYINT,
    @RefNo NVARCHAR(50)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        INSERT dbo.Payments(InvoiceId,PaidAmount,Method,RefNo)
        VALUES(@InvoiceId,@PaidAmount,@Method,@RefNo);

        DECLARE @PaidTotal DECIMAL(18,2) =
            (SELECT SUM(PaidAmount) FROM dbo.Payments WHERE InvoiceId=@InvoiceId);

        DECLARE @Net DECIMAL(18,2) =
            (SELECT NetAmount FROM dbo.Invoices WHERE InvoiceId=@InvoiceId);

        UPDATE dbo.Invoices
        SET Status = CASE 
                        WHEN @PaidTotal >= @Net THEN 2
                        WHEN @PaidTotal > 0 THEN 1
                        ELSE 0 END
        WHERE InvoiceId=@InvoiceId;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH
END

CREATE PROCEDURE dbo.sp_Invoice_CheckOverdueAndHold
    @Today DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- mark overdue
    UPDATE dbo.Invoices
    SET Status=3
    WHERE Status IN (0,1) AND DueDate < @Today;

    -- create financial hold for overdue invoices
    INSERT dbo.StudentHolds(StudentId,HoldType,Reason)
    SELECT i.StudentId, 1, N'Overdue tuition'
    FROM dbo.Invoices i
    WHERE i.Status=3
      AND NOT EXISTS(
            SELECT 1 FROM dbo.StudentHolds h 
            WHERE h.StudentId=i.StudentId AND h.HoldType=1 AND h.IsActive=1
      );
END
GO