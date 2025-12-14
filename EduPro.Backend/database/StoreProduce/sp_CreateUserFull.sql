USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- SP Create User - Fixed MaGV format (GV001 not GV0001)
IF OBJECT_ID ('sp_CreateUserAccount', 'P') IS NOT NULL
DROP PROC sp_CreateUserAccount;
GO
CREATE PROCEDURE sp_CreateUserAccount
    @TenDangNhap NVARCHAR(50),
    @MatKhauHash VARBINARY(256),
    @MaVaiTro NVARCHAR(20),
    @HoTen NVARCHAR(100),
    @Email NVARCHAR(100) = NULL,
    @DienThoai NVARCHAR(20) = NULL,
    @NgaySinh DATE = NULL,
    @GioiTinh NVARCHAR(10) = NULL,
    @MaNganh NVARCHAR(20) = NULL, -- REQUIRED for SINHVIEN, defaulted if missing
    @MaKhoa NVARCHAR(20) = NULL,
    @PerformedBy NVARCHAR(50),
    @IPAddress NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MaSV NVARCHAR(20) = NULL;
    DECLARE @MaGV NVARCHAR(20) = NULL;
    DECLARE @MaKhoaTS NVARCHAR(20) = NULL;

    BEGIN TRY
        BEGIN TRAN;
        
        IF @MaVaiTro = 'SINHVIEN'
        BEGIN
            -- Bắt buộc có ngành; nếu không truyền, lấy ngành đầu tiên hiện có để tránh thiếu dữ liệu công nợ
            IF @MaNganh IS NULL SET @MaNganh = (SELECT TOP 1 MaNganh FROM Nganh ORDER BY MaNganh);
            IF @MaNganh IS NULL
            BEGIN
                RAISERROR(N'Chưa cấu hình bảng Nganh, không thể tạo sinh viên', 16, 1);
                ROLLBACK TRAN; RETURN;
            END

            -- Generate MaSV: Year + Sequential Number
            DECLARE @Year CHAR(4) = CAST(YEAR(GETDATE()) AS CHAR(4));
            DECLARE @MaxSV INT;
            SELECT @MaxSV = ISNULL(MAX(CAST(RIGHT(MaSV, 3) AS INT)), 0) + 1 
            FROM SinhVien WHERE MaSV LIKE @Year + '%';
            SET @MaSV = @Year + RIGHT('000' + CAST(@MaxSV AS VARCHAR), 3);
            
            -- MaKhoaTS format: K + Year
            SET @MaKhoaTS = 'K' + @Year;
            
            -- Default values
            IF @NgaySinh IS NULL SET @NgaySinh = '2000-01-01';
            
            INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh, Email, DienThoai, MaNganh, MaKhoaTS, TrangThai)
            VALUES (@MaSV, @HoTen, @NgaySinh, ISNULL(@GioiTinh, N'Nam'), @Email, @DienThoai, @MaNganh, @MaKhoaTS, N'Đang học');
        END
        ELSE IF @MaVaiTro = 'GIANGVIEN'
        BEGIN
            -- Generate MaGV: GV + 3-digit sequential (GV001, GV002...)
            DECLARE @MaxGV INT;
            SELECT @MaxGV = ISNULL(MAX(CAST(SUBSTRING(MaGV, 3, LEN(MaGV)-2) AS INT)), 0) + 1 
            FROM GiangVien WHERE MaGV LIKE 'GV%' AND ISNUMERIC(SUBSTRING(MaGV, 3, LEN(MaGV)-2)) = 1;
            SET @MaGV = 'GV' + RIGHT('000' + CAST(@MaxGV AS VARCHAR), 3);
            
            IF @MaKhoa IS NULL SET @MaKhoa = (SELECT TOP 1 MaKhoa FROM Khoa);
            
            INSERT INTO GiangVien (MaGV, HoTen, Email, DienThoai, MaKhoa)
            VALUES (@MaGV, @HoTen, @Email, @DienThoai, @MaKhoa);
        END
        
        -- Insert TaiKhoan with LanDauDangNhap = 1
        INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, MaVaiTro, MaSV, MaGV, TrangThai, NgayTao, SoLanDangNhapThatBai, LanDauDangNhap)
        VALUES (@TenDangNhap, @MatKhauHash, @MaVaiTro, @MaSV, @MaGV, 1, GETDATE(), 0, 1);

        -- Audit Log
        INSERT INTO AuditLog (Action, EntityTable, EntityId, NewValue, PerformedBy, IPAddress)
        VALUES ('CREATE_USER', 'TaiKhoan', @TenDangNhap, 
                'Role: ' + @MaVaiTro + ', Name: ' + @HoTen + ISNULL(', MaSV: ' + @MaSV, '') + ISNULL(', MaGV: ' + @MaGV, ''), 
                @PerformedBy, @IPAddress);

        COMMIT TRAN;
        SELECT 1 AS Status, N'OK' AS Message, @MaSV AS MaSV, @MaGV AS MaGV;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;

PRINT N'SP Updated - Fixed MaGV format + FirstLogin';
GO
