USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- Bổ sung cột Status/Module cho AuditLog nếu chưa có
IF COL_LENGTH('dbo.AuditLog', 'Status') IS NULL
BEGIN
    ALTER TABLE dbo.AuditLog ADD Status NVARCHAR(20) NULL CONSTRAINT DF_AuditLog_Status DEFAULT ('SUCCESS');
END;
IF COL_LENGTH('dbo.AuditLog', 'Module') IS NULL
BEGIN
    ALTER TABLE dbo.AuditLog ADD Module NVARCHAR(200) NULL;
END;
-- Chuẩn hóa dữ liệu cũ
UPDATE dbo.AuditLog SET Status = ISNULL(Status, 'SUCCESS');
UPDATE dbo.AuditLog SET Module = ISNULL(Module, EntityTable);
GO

-- 1. Get Users (with Filter & Pagination)
IF OBJECT_ID ('sp_GetUsers', 'P') IS NOT NULL DROP PROC sp_GetUsers;
GO
CREATE PROCEDURE sp_GetUsers
    @Keyword NVARCHAR(50) = NULL,
    @Role NVARCHAR(20) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT 
        u.TenDangNhap, 
        u.MaVaiTro, 
        u.TrangThai, 
        u.NgayTao,
        u.HoTenSV,
        u.HoTenGV,
        u.KhoaLuc,
        COUNT(*) OVER() AS TotalRecords
    FROM (
        SELECT tk.*, sv.HoTen AS HoTenSV, gv.HoTen AS HoTenGV
        FROM TaiKhoan tk
        LEFT JOIN SinhVien sv ON tk.MaSV = sv.MaSV
        LEFT JOIN GiangVien gv ON tk.MaGV = gv.MaGV
    ) u
    WHERE (@Keyword IS NULL OR u.TenDangNhap LIKE '%' + @Keyword + '%' OR u.HoTenSV LIKE '%' + @Keyword + '%' OR u.HoTenGV LIKE '%' + @Keyword + '%')
      AND (@Role IS NULL OR u.MaVaiTro = @Role)
    ORDER BY u.NgayTao DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- 2. Get User Detail
IF OBJECT_ID ('sp_GetUserDetail', 'P') IS NOT NULL
DROP PROC sp_GetUserDetail;
GO
CREATE PROCEDURE sp_GetUserDetail
    @TenDangNhap NVARCHAR(50)
AS
BEGIN
    SELECT 
        tk.*,
        sv.HoTen AS HoTenSV, sv.NgaySinh, sv.Email AS EmailSV,
        gv.HoTen AS HoTenGV, gv.Email AS EmailGV
    FROM TaiKhoan tk
    LEFT JOIN SinhVien sv ON tk.MaSV = sv.MaSV
    LEFT JOIN GiangVien gv ON tk.MaGV = gv.MaGV
    WHERE tk.TenDangNhap = @TenDangNhap;
END;
GO

-- 3. Create User (ADMIN Only)
IF OBJECT_ID ('sp_CreateUserAccount', 'P') IS NOT NULL
DROP PROC sp_CreateUserAccount;
GO
CREATE PROCEDURE sp_CreateUserAccount
    @TenDangNhap NVARCHAR(50),
    @MatKhauHash VARBINARY(256),
    @MaVaiTro NVARCHAR(20),
    @HoTen NVARCHAR(100),
    @PerformedBy NVARCHAR(50),
    @IPAddress NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Only allow ADMIN creation via this SP
    IF @MaVaiTro IN ('SINHVIEN', 'GIANGVIEN')
    BEGIN
        RAISERROR(N'SV/GV phải được tạo qua Import hoặc form riêng.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRAN;
            
            INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, MaVaiTro, TrangThai, NgayTao, SoLanDangNhapThatBai)
            VALUES (@TenDangNhap, @MatKhauHash, @MaVaiTro, 1, GETDATE(), 0);

            INSERT INTO AuditLog (Action, EntityTable, EntityId, NewValue, PerformedBy, IPAddress, Status, Module)
            VALUES ('CREATE_USER', 'TaiKhoan', @TenDangNhap, 'Role: ' + @MaVaiTro, @PerformedBy, @IPAddress, 'SUCCESS', 'TaiKhoan');

        COMMIT TRAN;
        SELECT 1 AS Status, N'OK' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;

-- 4. Update User Role
IF OBJECT_ID ('sp_UpdateUserRole', 'P') IS NOT NULL
DROP PROC sp_UpdateUserRole;
GO
CREATE PROCEDURE sp_UpdateUserRole
    @TenDangNhap NVARCHAR(50),
    @NewRole NVARCHAR(20),
    @PerformedBy NVARCHAR(50),
    @IPAddress NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @OldRole NVARCHAR(20);
    SELECT @OldRole = MaVaiTro FROM TaiKhoan WHERE TenDangNhap = @TenDangNhap;

    IF @OldRole IS NULL THROW 50001, 'User not found', 1;

    BEGIN TRAN;
        UPDATE TaiKhoan SET MaVaiTro = @NewRole WHERE TenDangNhap = @TenDangNhap;
        INSERT INTO AuditLog (Action, EntityTable, EntityId, OldValue, NewValue, PerformedBy, IPAddress, Status, Module)
        VALUES ('UPDATE_ROLE', 'TaiKhoan', @TenDangNhap, @OldRole, @NewRole, @PerformedBy, @IPAddress, 'SUCCESS', 'TaiKhoan');
    COMMIT TRAN;
END;

-- 5. Lock/Unlock User
IF OBJECT_ID ('sp_UpdateUserStatus', 'P') IS NOT NULL
DROP PROC sp_UpdateUserStatus;
GO
CREATE PROCEDURE sp_UpdateUserStatus
    @TenDangNhap NVARCHAR(50),
    @IsLocked BIT,
    @Reason NVARCHAR(200),
    @PerformedBy NVARCHAR(50),
    @IPAddress NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @OldStatus BIT;
    SELECT @OldStatus = CASE WHEN KhoaLuc IS NOT NULL AND KhoaLuc > GETDATE() THEN 1 ELSE 0 END 
    FROM TaiKhoan WHERE TenDangNhap = @TenDangNhap;

    BEGIN TRAN;
        IF @IsLocked = 1
            UPDATE TaiKhoan SET KhoaLuc = DATEADD(YEAR, 100, GETDATE()) WHERE TenDangNhap = @TenDangNhap;
        ELSE
            UPDATE TaiKhoan SET KhoaLuc = NULL, SoLanDangNhapThatBai = 0 WHERE TenDangNhap = @TenDangNhap;

        INSERT INTO AuditLog (Action, EntityTable, EntityId, OldValue, NewValue, PerformedBy, IPAddress, Status, Module)
        VALUES (CASE WHEN @IsLocked = 1 THEN 'LOCK_USER' ELSE 'UNLOCK_USER' END, 'TaiKhoan', @TenDangNhap, CAST(@OldStatus AS NVARCHAR), @Reason, @PerformedBy, @IPAddress, 'SUCCESS', 'TaiKhoan');
    COMMIT TRAN;
END;

-- 6. Get Audit Logs
IF OBJECT_ID ('sp_GetAuditLogs', 'P') IS NOT NULL
DROP PROC sp_GetAuditLogs;
GO
CREATE PROCEDURE sp_GetAuditLogs
    @Keyword NVARCHAR(50) = NULL,
    @FromDate DATETIME = NULL,
    @ToDate DATETIME = NULL,
    @Action NVARCHAR(50) = NULL,
    @Status NVARCHAR(20) = NULL,
    @Module NVARCHAR(200) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT *, COUNT(*) OVER() AS TotalRecords
    FROM AuditLog
    WHERE (@Keyword IS NULL OR PerformedBy LIKE '%' + @Keyword + '%' OR Action LIKE '%' + @Keyword + '%')
      AND (@FromDate IS NULL OR Timestamp >= @FromDate)
      AND (@ToDate IS NULL OR Timestamp <= @ToDate)
      AND (@Action IS NULL OR Action = @Action)
      AND (@Status IS NULL OR Status = @Status)
      AND (@Module IS NULL OR Module = @Module)
    ORDER BY Timestamp DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END;
GO

PRINT 'Admin SPs Created Successfully';
GO
