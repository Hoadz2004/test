USE EduProDb;
GO

IF OBJECT_ID('sp_Payment_Init', 'P') IS NOT NULL
    DROP PROCEDURE sp_Payment_Init;
GO

CREATE PROCEDURE sp_Payment_Init
    @MaSV NVARCHAR(10),
    @MaHK NVARCHAR(10),
    @Amount DECIMAL(18,2) = NULL, -- nếu null sẽ lấy từ công nợ
    @Method NVARCHAR(30),
    @Provider NVARCHAR(30) = NULL,
    @ProviderRef NVARCHAR(100) = NULL,
    @ReturnUrl NVARCHAR(200) = NULL,
    @AutoRecalc BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    IF @AutoRecalc = 1
    BEGIN
        DECLARE @tmp TABLE(
            SoTinChi INT,
            DonGiaTinChi DECIMAL(18,2),
            PhuPhiThucHanh DECIMAL(18,2),
            GiamTruPercent DECIMAL(18,2),
            SoTienGoc DECIMAL(18,2),
            DaThanhToan DECIMAL(18,2),
            SoTienNo DECIMAL(18,2)
        );
        INSERT INTO @tmp
        EXEC sp_Payment_RecalcDebt @MaSV = @MaSV, @MaHK = @MaHK;
    END;

    IF @Amount IS NULL
    BEGIN
        SELECT @Amount = SoTienNo FROM CongNo WHERE MaSV = @MaSV AND MaHK = @MaHK;
    END;

    IF @Amount IS NULL
    BEGIN
        RAISERROR(N'Không xác định được số tiền cần thanh toán', 16, 1);
        RETURN;
    END;

    INSERT INTO PaymentTransaction (MaSV, MaHK, Amount, Method, Provider, ProviderRef, Status)
    VALUES (@MaSV, @MaHK, @Amount, @Method, @Provider, @ProviderRef, N'Pending');

    DECLARE @PaymentId INT = SCOPE_IDENTITY();
    DECLARE @PaymentUrl NVARCHAR(400) = COALESCE(
        @ReturnUrl,
        N'https://sandbox.vnpayment.vn/tryitnow?txn=' + CAST(@PaymentId AS NVARCHAR(20))
    );

    SELECT @PaymentId AS PaymentId, @Amount AS Amount, @PaymentUrl AS PaymentUrl;
END;
GO
