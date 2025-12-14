USE EduProDb1;
GO

-- Chỉ sửa encoding/chuỗi tiếng Việt cho các SP liên quan đăng ký học phần

ALTER PROCEDURE sp_SinhVienDangKyHocPhan
    @MaSV NVARCHAR(10),
    @MaLHP NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaHP NVARCHAR(10);
    DECLARE @MaHK NVARCHAR(10);
    DECLARE @SiSoHienTai INT;
    DECLARE @SiSoToiDa INT;
    DECLARE @Thu INT;
    DECLARE @MaCa NVARCHAR(10);
    DECLARE @TrangThaiCode NVARCHAR(20);
    DECLARE @TrangThaiLop NVARCHAR(100);

    -- 1. Lấy thông tin lớp
    SELECT
        @MaHP = MaHP,
        @MaHK = MaHK,
        @Thu = ThuTrongTuan,
        @MaCa = MaCa,
        @SiSoToiDa = SiSoToiDa,
        @TrangThaiCode = NULL, -- fallback nếu có cột code
        @TrangThaiLop = TrangThaiLop
    FROM LopHocPhan
    WHERE MaLHP = @MaLHP;

    IF @MaHP IS NULL
    BEGIN
        RAISERROR(N'Lớp học phần không tồn tại', 16, 1);
        RETURN;
    END;

    -- 1b. Kiểm tra trạng thái lớp cho phép đăng ký
    IF (
        (@TrangThaiCode IS NOT NULL AND UPPER(@TrangThaiCode) <> 'PLANNED')
        OR (@TrangThaiCode IS NULL AND ( @TrangThaiLop IS NULL OR @TrangThaiLop NOT IN (N'Sắp khai giảng', N'Sap khai giang') ))
    )
    BEGIN
        RAISERROR(N'Lớp không mở để đăng ký', 16, 1);
        RETURN;
    END;

    -- 2. Kiểm tra thời gian đăng ký
    IF NOT EXISTS (
        SELECT 1
        FROM HocKy
        WHERE MaHK = @MaHK
          AND ChoPhepDangKy = 1
          AND (NgayBatDauDangKy IS NULL OR NgayBatDauDangKy <= GETDATE())
          AND (NgayKetThucDangKy IS NULL OR NgayKetThucDangKy >= GETDATE())
    )
    BEGIN
        RAISERROR(N'Không trong thời gian đăng ký', 16, 1);
        RETURN;
    END;

    -- 3. Kiểm tra sĩ số
    SELECT @SiSoHienTai = COUNT(*) FROM DangKyHocPhan WHERE MaLHP = @MaLHP AND TrangThai != N'Hủy';
    IF @SiSoHienTai >= @SiSoToiDa
    BEGIN
        RAISERROR(N'Lớp đã đầy', 16, 1);
        RETURN;
    END;

    -- 4. Kiểm tra trùng lịch
    IF EXISTS (
        SELECT 1
        FROM DangKyHocPhan dk
        JOIN LopHocPhan lhp ON dk.MaLHP = lhp.MaLHP
        WHERE dk.MaSV = @MaSV
          AND lhp.MaHK = @MaHK
          AND lhp.ThuTrongTuan = @Thu
          AND lhp.MaCa = @MaCa
          AND dk.TrangThai != N'Hủy'
    )
    BEGIN
        RAISERROR(N'Trùng lịch học với môn khác', 16, 1);
        RETURN;
    END;

    -- 5. Kiểm tra tiên quyết
    IF EXISTS (
        SELECT 1
        FROM TienQuyet tq
        WHERE tq.MaHP = @MaHP
        AND NOT EXISTS (
            SELECT 1
            FROM Diem d
            JOIN LopHocPhan l ON d.MaLHP = l.MaLHP
            WHERE d.MaSV = @MaSV
              AND l.MaHP = tq.MaHP_TienQuyet
              AND d.DiemHe4 >= 1.0
        )
    )
    BEGIN
        RAISERROR(N'Chưa đạt học phần tiên quyết', 16, 1);
        RETURN;
    END;

    -- 6. Insert
    INSERT INTO DangKyHocPhan (MaSV, MaLHP, TrangThai)
    VALUES (@MaSV, @MaLHP, N'Đăng ký');
END;
GO

ALTER PROCEDURE sp_HuyDangKyHocPhan
    @MaSV NVARCHAR(10),
    @MaLHP NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TrangThaiHienTai NVARCHAR(50);
    SELECT @TrangThaiHienTai = TrangThai FROM DangKyHocPhan WHERE MaSV = @MaSV AND MaLHP = @MaLHP;

    IF @TrangThaiHienTai IS NULL
    BEGIN
        RAISERROR(N'Không tìm thấy bản ghi đăng ký', 16, 1);
        RETURN;
    END;

    -- Chỉ cho hủy nếu trạng thái là 'Đăng ký'
    IF @TrangThaiHienTai = N'Đăng ký'
    BEGIN
        DELETE FROM DangKyHocPhan WHERE MaSV = @MaSV AND MaLHP = @MaLHP;
    END
    ELSE
    BEGIN
        RAISERROR(N'Không thể hủy lớp học phần đã chốt hoặc đã có điểm', 16, 1);
    END;
END;
GO

ALTER PROCEDURE sp_LayKetQuaDangKy
    @MaSV NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        dk.MaLHP,
        hp.TenHP,
        hp.SoTinChi,
        lhp.ThuTrongTuan,
        lhp.MaCa,
        lhp.MaPhong,
        dk.TrangThai,
        dk.NgayDangKy
    FROM DangKyHocPhan dk
    JOIN LopHocPhan lhp ON dk.MaLHP = lhp.MaLHP
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    WHERE dk.MaSV = @MaSV AND dk.TrangThai != N'Hủy'
    ORDER BY dk.NgayDangKy DESC;
END;
GO

-- Sửa dữ liệu trạng thái bị lỗi encoding hiện có
UPDATE DangKyHocPhan
SET TrangThai = N'Đăng ký'
WHERE TrangThai NOT IN (N'Đăng ký', N'Hủy', N'Phê duyệt');

IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_DangKy_TrangThai')
BEGIN
    ALTER TABLE DangKyHocPhan DROP CONSTRAINT CK_DangKy_TrangThai;
END;

ALTER TABLE DangKyHocPhan WITH CHECK ADD CONSTRAINT CK_DangKy_TrangThai
CHECK ([TrangThai] IN (N'Đăng ký', N'Hủy', N'Phê duyệt'));
GO
