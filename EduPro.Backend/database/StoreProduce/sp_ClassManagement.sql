USE EduProDb;
GO

-- =============================================
-- GROUP 10: CLASS MANAGEMENT (QUẢN LÝ LỚP HỌC PHẦN)
-- =============================================

-- 25. SP Lấy danh sách Lớp Học Phần (Admin View)
IF OBJECT_ID (
    'sp_LayDanhSachLopHocPhan_Admin',
    'P'
) IS NOT NULL
DROP PROC sp_LayDanhSachLopHocPhan_Admin;
GO
CREATE PROCEDURE sp_LayDanhSachLopHocPhan_Admin
    @MaNam NVARCHAR(10) = NULL,
    @MaHK NVARCHAR(10) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    SELECT 
        lhp.MaLHP,
        lhp.MaHP, hp.TenHP, hp.SoTinChi,
        lhp.MaHK, hk.TenHK,
        lhp.MaNam, nh.NamBatDau,
        lhp.MaGV, gv.HoTen AS TenGV,
        lhp.MaPhong, ph.TenPhong,
        lhp.MaCa, ca.MoTa AS TenCa,
        lhp.ThuTrongTuan,
        lhp.SiSoToiDa,
        (SELECT COUNT(*) FROM DangKyHocPhan dk WHERE dk.MaLHP = lhp.MaLHP) AS SiSoHienTai,
        lhp.GhiChu,
        lhp.NgayBatDau,
        lhp.NgayKetThuc,
        lhp.SoBuoiHoc,
        lhp.SoBuoiTrongTuan,
        lhp.TrangThaiLop,
        COUNT(*) OVER() AS TotalRecords
    FROM LopHocPhan lhp
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    JOIN HocKy hk ON lhp.MaHK = hk.MaHK
    JOIN NamHoc nh ON lhp.MaNam = nh.MaNam
    JOIN GiangVien gv ON lhp.MaGV = gv.MaGV
    JOIN PhongHoc ph ON lhp.MaPhong = ph.MaPhong
    JOIN CaHoc ca ON lhp.MaCa = ca.MaCa
    WHERE (@MaNam IS NULL OR lhp.MaNam = @MaNam)
      AND (@MaHK IS NULL OR lhp.MaHK = @MaHK)
    ORDER BY lhp.MaLHP DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- Index hỗ trợ lọc lớp học phần
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LopHocPhan_Filter' AND object_id = OBJECT_ID('LopHocPhan'))
BEGIN
    CREATE INDEX IX_LopHocPhan_Filter ON LopHocPhan(MaNam, MaHK, TrangThaiLop, NgayBatDau);
END;
GO

-- 26. SP Thêm Lớp Học Phần
IF OBJECT_ID ('sp_ThemLopHocPhan', 'P') IS NOT NULL
DROP PROC sp_ThemLopHocPhan;
GO
CREATE PROCEDURE sp_ThemLopHocPhan
    @MaLHP NVARCHAR(20),
    @MaHP NVARCHAR(10),
    @MaHK NVARCHAR(10),
    @MaNam NVARCHAR(10),
    @MaGV NVARCHAR(10),
    @MaPhong NVARCHAR(10),
    @MaCa NVARCHAR(10),
    @ThuTrongTuan TINYINT,
    @SiSoToiDa INT,
    @NgayBatDau DATE = NULL,
    @NgayKetThuc DATE = NULL,
    @SoBuoiHoc INT = NULL,
    @SoBuoiTrongTuan TINYINT = NULL,
    @TrangThaiLop NVARCHAR(20) = N'Mở',
    @GhiChu NVARCHAR(200) = NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM LopHocPhan WHERE MaLHP = @MaLHP)
    BEGIN
        RAISERROR(N'Mã lớp học phần đã tồn tại.', 16, 1);
        RETURN;
    END

    -- Validate conflict (Room + Shift + Day + Semester + Year)
    IF EXISTS (SELECT 1 FROM LopHocPhan 
               WHERE MaPhong = @MaPhong 
               AND MaCa = @MaCa 
               AND ThuTrongTuan = @ThuTrongTuan 
               AND MaHK = @MaHK
               AND MaNam = @MaNam)
    BEGIN
        RAISERROR(N'Phòng học đã bị trùng lịch trong ngày và ca này.', 16, 1);
        RETURN;
    END

     -- Validate Lecturer conflict (Lecturer + Shift + Day + Semester + Year)
    IF EXISTS (SELECT 1 FROM LopHocPhan 
               WHERE MaGV = @MaGV 
               AND MaCa = @MaCa 
               AND ThuTrongTuan = @ThuTrongTuan 
               AND MaHK = @MaHK
               AND MaNam = @MaNam)
    BEGIN
        RAISERROR(N'Giảng viên đã có lịch dạy trong ngày và ca này.', 16, 1);
        RETURN;
    END

    INSERT INTO LopHocPhan (MaLHP, MaHP, MaHK, MaNam, MaGV, MaPhong, MaCa, ThuTrongTuan, SiSoToiDa, NgayBatDau, NgayKetThuc, SoBuoiHoc, SoBuoiTrongTuan, TrangThaiLop, GhiChu)
    VALUES (@MaLHP, @MaHP, @MaHK, @MaNam, @MaGV, @MaPhong, @MaCa, @ThuTrongTuan, @SiSoToiDa, @NgayBatDau, @NgayKetThuc, @SoBuoiHoc, @SoBuoiTrongTuan, @TrangThaiLop, @GhiChu);
END;
GO

-- 27. SP Sửa Lớp Học Phần
IF OBJECT_ID ('sp_SuaLopHocPhan', 'P') IS NOT NULL
DROP PROC sp_SuaLopHocPhan;
GO
CREATE PROCEDURE sp_SuaLopHocPhan
    @MaLHP NVARCHAR(20),
    @MaHP NVARCHAR(10),
    @MaHK NVARCHAR(10),
    @MaNam NVARCHAR(10),
    @MaGV NVARCHAR(10),
    @MaPhong NVARCHAR(10),
    @MaCa NVARCHAR(10),
    @ThuTrongTuan TINYINT,
    @SiSoToiDa INT,
    @NgayBatDau DATE = NULL,
    @NgayKetThuc DATE = NULL,
    @SoBuoiHoc INT = NULL,
    @SoBuoiTrongTuan TINYINT = NULL,
    @TrangThaiLop NVARCHAR(20) = NULL,
    @GhiChu NVARCHAR(200) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM LopHocPhan WHERE MaLHP = @MaLHP)
    BEGIN
        RAISERROR(N'Mã lớp học phần không tồn tại.', 16, 1);
        RETURN;
    END

    -- Validate Room conflict (exclude current class)
    IF EXISTS (SELECT 1 FROM LopHocPhan 
               WHERE MaPhong = @MaPhong 
               AND MaCa = @MaCa 
               AND ThuTrongTuan = @ThuTrongTuan 
               AND MaHK = @MaHK
               AND MaNam = @MaNam
               AND MaLHP != @MaLHP)
    BEGIN
        RAISERROR(N'Phòng học đã bị trùng lịch trong ngày và ca này.', 16, 1);
        RETURN;
    END

    -- Validate Lecturer conflict (exclude current class)
    IF EXISTS (SELECT 1 FROM LopHocPhan 
               WHERE MaGV = @MaGV 
               AND MaCa = @MaCa 
               AND ThuTrongTuan = @ThuTrongTuan 
               AND MaHK = @MaHK
               AND MaNam = @MaNam
               AND MaLHP != @MaLHP)
    BEGIN
        RAISERROR(N'Giảng viên đã có lịch dạy trong ngày và ca này.', 16, 1);
        RETURN;
    END

    UPDATE LopHocPhan 
    SET MaHP = @MaHP, 
        MaGV = @MaGV, 
        MaPhong = @MaPhong, 
        MaCa = @MaCa, 
        ThuTrongTuan = @ThuTrongTuan, 
        SiSoToiDa = @SiSoToiDa,
        NgayBatDau = ISNULL(@NgayBatDau, NgayBatDau),
        NgayKetThuc = ISNULL(@NgayKetThuc, NgayKetThuc),
        SoBuoiHoc = ISNULL(@SoBuoiHoc, SoBuoiHoc),
        SoBuoiTrongTuan = ISNULL(@SoBuoiTrongTuan, SoBuoiTrongTuan),
        TrangThaiLop = ISNULL(@TrangThaiLop, TrangThaiLop),
        GhiChu = @GhiChu
    WHERE MaLHP = @MaLHP;
END;
GO

-- 28. SP Xóa Lớp Học Phần
IF OBJECT_ID ('sp_XoaLopHocPhan', 'P') IS NOT NULL
DROP PROC sp_XoaLopHocPhan;
GO
CREATE PROCEDURE sp_XoaLopHocPhan
    @MaLHP NVARCHAR(20)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM DangKyHocPhan WHERE MaLHP = @MaLHP)
    BEGIN
        RAISERROR(N'Không thể xóa lớp học phần đã có sinh viên đăng ký.', 16, 1);
        RETURN;
    END

    DELETE FROM LopHocPhan WHERE MaLHP = @MaLHP;
END;
GO
