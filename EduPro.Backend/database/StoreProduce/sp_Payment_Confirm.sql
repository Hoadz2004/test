USE EduProDb;
GO

IF OBJECT_ID('sp_Payment_Confirm', 'P') IS NOT NULL
    DROP PROCEDURE sp_Payment_Confirm;
GO

CREATE PROCEDURE sp_Payment_Confirm
    @PaymentId INT,
    @Status NVARCHAR(20), -- Succeeded / Failed / Canceled
    @ProviderTransId NVARCHAR(100) = NULL,
    @Note NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaSV NVARCHAR(10);
    DECLARE @MaHK NVARCHAR(10);
    DECLARE @Amount DECIMAL(18,2);
    DECLARE @CurrentStatus NVARCHAR(20);

    SELECT @MaSV = MaSV, @MaHK = MaHK, @Amount = Amount, @CurrentStatus = Status
    FROM PaymentTransaction
    WHERE Id = @PaymentId;

    IF @MaSV IS NULL
    BEGIN
        RAISERROR(N'Không tìm thấy giao dịch', 16, 1);
        RETURN;
    END;

    -- Idempotent: nếu đã thành công thì không ghi đè
    IF @CurrentStatus = N'Succeeded'
    BEGIN
        SELECT Id AS PaymentId, Status, ConfirmedAt FROM PaymentTransaction WHERE Id = @PaymentId;
        RETURN;
    END;

    UPDATE PaymentTransaction
    SET Status = @Status,
        ProviderTransId = @ProviderTransId,
        Note = @Note,
        ConfirmedAt = CASE WHEN @Status = N'Succeeded' THEN GETDATE() ELSE ConfirmedAt END
    WHERE Id = @PaymentId;

    IF @Status = N'Succeeded'
    BEGIN
        INSERT INTO PaymentLedger (PaymentId, Amount, Type, Description)
        VALUES (@PaymentId, @Amount, N'Credit', N'Thanh toán thành công');

        -- Trừ công nợ
        UPDATE CongNo
        SET SoTienNo = CASE WHEN SoTienNo - @Amount < 0 THEN 0 ELSE SoTienNo - @Amount END,
            NgayCapNhat = GETDATE()
        WHERE MaSV = @MaSV AND MaHK = @MaHK;
    END;

    SELECT Id AS PaymentId, Status, ConfirmedAt FROM PaymentTransaction WHERE Id = @PaymentId;
END;
GO
