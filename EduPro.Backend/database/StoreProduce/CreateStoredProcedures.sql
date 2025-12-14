USE EduProDb1;
GO

-- =============================================
-- GROUP 1: AUTH & USER MANAGEMENT
-- =============================================

-- 1. SP Tạo tài khoản Sinh viên tự động
IF OBJECT_ID ('sp_TaoTaiKhoanSinhVien', 'P') IS NOT NULL
DROP PROC sp_TaoTaiKhoanSinhVien;
GO
CREATE PROCEDURE sp_TaoTaiKhoanSinhVien
    @MaSV NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @DummyHash VARBINARY(256) = CAST('123456' AS VARBINARY(256)); 

        IF NOT EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = @MaSV)
        BEGIN
            INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, MaVaiTro, MaSV, TrangThai)
            VALUES (@MaSV, @DummyHash, 'SinhVien', @MaSV, 1);
        END
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- 1.1 SP Tạo tài khoản Giảng viên tự động
IF OBJECT_ID (
    'sp_TaoTaiKhoanGiangVien',
    'P'
) IS NOT NULL
DROP PROC sp_TaoTaiKhoanGiangVien;
GO
CREATE PROCEDURE sp_TaoTaiKhoanGiangVien
    @MaGV NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @DummyHash VARBINARY(256) = CAST('123456' AS VARBINARY(256)); 

        IF NOT EXISTS (SELECT 1 FROM TaiKhoan WHERE TenDangNhap = @MaGV)
        BEGIN
            INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, MaVaiTro, MaGV, TrangThai)
            VALUES (@MaGV, @DummyHash, 'GiangVien', @MaGV, 1);
        END
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- 2. SP Thêm Sinh viên mới (Wrapper)
IF OBJECT_ID ('sp_ThemSinhVien', 'P') IS NOT NULL
DROP PROC sp_ThemSinhVien;
GO
CREATE PROCEDURE sp_ThemSinhVien
    @MaSV NVARCHAR(10),
    @HoTen NVARCHAR(100),
    @NgaySinh DATE,
    @MaNganh NVARCHAR(10),
    @MaKhoaTS NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM SinhVien WHERE MaSV = @MaSV)
        BEGIN
             UPDATE SinhVien SET HoTen = @HoTen, NgaySinh = @NgaySinh, MaNganh = @MaNganh, MaKhoaTS = @MaKhoaTS WHERE MaSV = @MaSV;
        END
        ELSE
        BEGIN
            INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, MaNganh, MaKhoaTS, TrangThai)
            VALUES (@MaSV, @HoTen, @NgaySinh, @MaNganh, @MaKhoaTS, N'Đang học');

            INSERT INTO SinhVien_TrangThai (MaSV, TrangThai, GhiChu)
            VALUES (@MaSV, N'Đang học', N'Nhập học mới');

            EXEC sp_TaoTaiKhoanSinhVien @MaSV;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- 3. SP Kiểm tra đăng nhập
IF OBJECT_ID ('sp_KiemTraDangNhap', 'P') IS NOT NULL
DROP PROC sp_KiemTraDangNhap;
GO
CREATE PROCEDURE sp_KiemTraDangNhap
    @TenDangNhap NVARCHAR(50)
AS
BEGIN
    SELECT 
        tk.TenDangNhap, 
        tk.MatKhauHash, 
        tk.MaVaiTro, 
        tk.MaSV, 
        tk.MaGV,
        sv.HoTen AS HoTenSV,
        gv.HoTen AS HoTenGV,
        -- Security Columns
        tk.SoLanDangNhapThatBai,
        tk.KhoaLuc,
        tk.DiaChiIPCuoi
    FROM TaiKhoan tk
    LEFT JOIN SinhVien sv ON tk.MaSV = sv.MaSV
    LEFT JOIN GiangVien gv ON tk.MaGV = gv.MaGV
    WHERE tk.TenDangNhap = @TenDangNhap AND tk.TrangThai = 1;
END;
GO

-- =============================================
-- GROUP 2: ENROLLMENT (ĐĂNG KÝ HỌC PHẦN)
-- =============================================

-- 4. SP Mở Học kỳ
IF OBJECT_ID ('sp_MoHocKy', 'P') IS NOT NULL DROP PROC sp_MoHocKy;
GO
CREATE PROCEDURE sp_MoHocKy
    @MaHK NVARCHAR(10),
    @TenHK NVARCHAR(50),
    @MaNam NVARCHAR(10),
    @NgayBatDau DATE,
    @NgayKetThuc DATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM HocKy WHERE MaHK = @MaHK)
    BEGIN
        UPDATE HocKy 
        SET TenHK = @TenHK, MaNam = @MaNam, NgayBatDau = @NgayBatDau, NgayKetThuc = @NgayKetThuc
        WHERE MaHK = @MaHK;
    END
    ELSE
    BEGIN
        INSERT INTO HocKy (MaHK, TenHK, MaNam, NgayBatDau, NgayKetThuc, ChoPhepDangKy)
        VALUES (@MaHK, @TenHK, @MaNam, @NgayBatDau, @NgayKetThuc, 0);
    END
END;
GO

-- 5. SP Đăng ký học phần (CORE LOGIC)
IF OBJECT_ID (
    'sp_SinhVienDangKyHocPhan',
    'P'
) IS NOT NULL
DROP PROC sp_SinhVienDangKyHocPhan;
GO
CREATE PROCEDURE sp_SinhVienDangKyHocPhan
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
    
    -- 1. Lấy thông tin lớp
    SELECT 
        @MaHP = MaHP, 
        @MaHK = MaHK, 
        @Thu = ThuTrongTuan, 
        @MaCa = MaCa,
        @SiSoToiDa = SiSoToiDa 
    FROM LopHocPhan WHERE MaLHP = @MaLHP;

    IF @MaHP IS NULL
    BEGIN
        RAISERROR(N'Lớp học phần không tồn tại', 16, 1);
        RETURN;
    END

    -- 2. Kiểm tra thời gian đăng ký
    IF NOT EXISTS (
        SELECT 1 FROM HocKy 
        WHERE MaHK = @MaHK 
        AND ChoPhepDangKy = 1 
        AND (NgayBatDauDangKy IS NULL OR NgayBatDauDangKy <= GETDATE())
        AND (NgayKetThucDangKy IS NULL OR NgayKetThucDangKy >= GETDATE())
    )
    BEGIN
        RAISERROR(N'Không trong thời gian đăng ký', 16, 1);
        RETURN;
    END

    -- 3. Kiểm tra sĩ số
    SELECT @SiSoHienTai = COUNT(*) FROM DangKyHocPhan WHERE MaLHP = @MaLHP AND TrangThai != N'Hủy';
    IF @SiSoHienTai >= @SiSoToiDa
    BEGIN
        RAISERROR(N'Lớp đã đầy', 16, 1);
        RETURN;
    END

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
    END

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
    END

    -- 6. Insert
    INSERT INTO DangKyHocPhan (MaSV, MaLHP, TrangThai)
    VALUES (@MaSV, @MaLHP, N'Đăng ký');
END;
GO

-- 5.1 SP Hủy Đăng ký học phần
IF OBJECT_ID ('sp_HuyDangKyHocPhan', 'P') IS NOT NULL
DROP PROC sp_HuyDangKyHocPhan;
GO
CREATE PROCEDURE sp_HuyDangKyHocPhan
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
    END

    -- Chỉ cho hủy nếu trạng thái là 'Đăng ký' (chưa chốt, chưa có điểm)
    IF @TrangThaiHienTai = N'Đăng ký'
    BEGIN
        DELETE FROM DangKyHocPhan WHERE MaSV = @MaSV AND MaLHP = @MaLHP;
    END
    ELSE
    BEGIN
        RAISERROR(N'Không thể hủy lớp học phần đã chốt hoặc đã có điểm', 16, 1);
    END
END;
GO

-- =============================================
-- GROUP 3: GRADING (ĐIỂM)
-- =============================================

-- 6. Nhập điểm sinh viên
IF OBJECT_ID ('sp_NhapDiemSinhVien', 'P') IS NOT NULL
DROP PROC sp_NhapDiemSinhVien;
GO
CREATE PROCEDURE sp_NhapDiemSinhVien
    @MaSV NVARCHAR(10),
    @MaLHP NVARCHAR(20),
    @DiemQT DECIMAL(4,2),
    @DiemGK DECIMAL(4,2),
    @DiemCK DECIMAL(4,2)
AS
BEGIN
    DECLARE @DiemTK DECIMAL(4,2);
    SET @DiemTK = (@DiemQT * 0.1) + (@DiemGK * 0.2) + (@DiemCK * 0.7);

    DECLARE @DiemChu NVARCHAR(2);
    DECLARE @DiemHe4 DECIMAL(3,2);
    DECLARE @KetQua NVARCHAR(20);

    IF @DiemTK >= 8.5 BEGIN SET @DiemChu = 'A'; SET @DiemHe4 = 4.0; END
    ELSE IF @DiemTK >= 7.0 BEGIN SET @DiemChu = 'B'; SET @DiemHe4 = 3.0; END
    ELSE IF @DiemTK >= 5.5 BEGIN SET @DiemChu = 'C'; SET @DiemHe4 = 2.0; END
    ELSE IF @DiemTK >= 4.0 BEGIN SET @DiemChu = 'D'; SET @DiemHe4 = 1.0; END
    ELSE BEGIN SET @DiemChu = 'F'; SET @DiemHe4 = 0.0; END

    IF @DiemHe4 >= 1.0 SET @KetQua = N'Đạt' ELSE SET @KetQua = N'Không đạt';

    MERGE Diem AS target
    USING (SELECT @MaSV AS MaSV, @MaLHP AS MaLHP) AS source
    ON (target.MaSV = source.MaSV AND target.MaLHP = source.MaLHP)
    WHEN MATCHED THEN
        UPDATE SET 
            DiemQT = @DiemQT, DiemGK = @DiemGK, DiemCK = @DiemCK,
            DiemTK = @DiemTK, DiemChu = @DiemChu, DiemHe4 = @DiemHe4,
            KetQua = @KetQua, NgayCapNhat = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (MaSV, MaLHP, DiemQT, DiemGK, DiemCK, DiemTK, DiemChu, DiemHe4, KetQua)
        VALUES (@MaSV, @MaLHP, @DiemQT, @DiemGK, @DiemCK, @DiemTK, @DiemChu, @DiemHe4, @KetQua);
END;

-- 6.1 Lấy danh sách sinh viên của Lớp học phần (để nhập điểm)
IF OBJECT_ID (
    'sp_LayDanhSachSV_CuaLHP',
    'P'
) IS NOT NULL
DROP PROC sp_LayDanhSachSV_CuaLHP;

CREATE PROCEDURE sp_LayDanhSachSV_CuaLHP
    @MaLHP NVARCHAR(20)
AS
BEGIN
    SELECT 
        dk.MaSV,
        sv.HoTen,
        sv.LopHanhChinh,
        d.DiemQT,
        d.DiemGK,
        d.DiemCK,
        d.DiemTK,
        d.KetQua
    FROM DangKyHocPhan dk
    JOIN SinhVien sv ON dk.MaSV = sv.MaSV
    LEFT JOIN Diem d ON dk.MaSV = d.MaSV AND dk.MaLHP = d.MaLHP
    WHERE dk.MaLHP = @MaLHP AND dk.TrangThai != N'Hủy'
    ORDER BY sv.HoTen;
END;

-- =============================================
-- GROUP 4: GRADUATION (TỐT NGHIỆP)
-- =============================================

-- 7. Xét tốt nghiệp (Simplified Version)
IF OBJECT_ID (
    'sp_XetTotNghiep_NganhKhoa',
    'P'
) IS NOT NULL
DROP PROC sp_XetTotNghiep_NganhKhoa;
GO
CREATE PROCEDURE sp_XetTotNghiep_NganhKhoa
    @MaNganh NVARCHAR(10),
    @MaKhoaTS NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Lấy tiêu chuẩn xét
    DECLARE @TinChiMin INT;
    DECLARE @GPA_Min DECIMAL(3,2);
    
    SELECT @TinChiMin = SoTinChiToiThieu, @GPA_Min = DiemTBTichLuyToiThieu
    FROM DieuKienTotNghiep 
    WHERE MaNganh = @MaNganh AND MaKhoaTS = @MaKhoaTS;

    IF @TinChiMin IS NULL 
    BEGIN
        -- Default values if not configured
        SET @TinChiMin = 120;
        SET @GPA_Min = 2.0;
    END

    -- Tìm SV đủ điều kiện
    INSERT INTO XetTotNghiep (MaSV, LanXet, KetQua, LyDo)
    SELECT 
        sv.MaSV,
        1 AS LanXet, -- Hardcode lần 1
        CASE 
            WHEN SUM(hp.SoTinChi) >= @TinChiMin AND AVG(d.DiemHe4) >= @GPA_Min THEN N'Đủ điều kiện'
            ELSE N'Chưa đủ điều kiện'
        END AS KetQua,
        CONCAT(N'TC: ', SUM(hp.SoTinChi), N'/', @TinChiMin, N', GPA: ', CAST(AVG(d.DiemHe4) AS DECIMAL(3,2))) AS LyDo
    FROM SinhVien sv
    JOIN Diem d ON sv.MaSV = d.MaSV
    JOIN LopHocPhan lhp ON d.MaLHP = lhp.MaLHP
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    WHERE sv.MaNganh = @MaNganh 
      AND sv.MaKhoaTS = @MaKhoaTS
      AND d.DiemHe4 >= 1.0 -- Chỉ tính môn đạt
    GROUP BY sv.MaSV;
END;
GO

-- 10. SP Xem bảng điểm cá nhân của sinh viên
IF OBJECT_ID ('sp_XemBangDiemSinhVien', 'P') IS NOT NULL
DROP PROC sp_XemBangDiemSinhVien;
GO
CREATE PROCEDURE sp_XemBangDiemSinhVien
    @MaSV NVARCHAR(10)
AS
BEGIN
    SELECT 
        hk.TenHK,
        lhp.MaLHP,
        hp.TenHP,
        hp.SoTinChi,
        d.DiemQT,
        d.DiemGK,
        d.DiemCK,
        d.DiemTK,
        d.DiemChu,
        d.DiemHe4,
        d.KetQua
    FROM Diem d
    JOIN LopHocPhan lhp ON d.MaLHP = lhp.MaLHP
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    JOIN HocKy hk ON lhp.MaHK = hk.MaHK
    WHERE d.MaSV = @MaSV
    ORDER BY hk.MaNam DESC, hk.MaHK DESC, hp.TenHP;
END;
-- =============================================
GO -- =============================================
-- GROUP 5: APPEAL (PHÚC KHẢO) - ENHANCED
-- =============================================

-- 11. SP Tạo yêu cầu phúc khảo (Update: Add 7-day Validation)
IF OBJECT_ID ('sp_TaoYeuCauPhucKhao', 'P') IS NOT NULL
DROP PROC sp_TaoYeuCauPhucKhao;
GO
CREATE PROCEDURE sp_TaoYeuCauPhucKhao
    @MaSV NVARCHAR(10),
    @MaLHP NVARCHAR(20),
    @LyDo NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Check Registration
    IF NOT EXISTS (SELECT 1 FROM DangKyHocPhan WHERE MaSV = @MaSV AND MaLHP = @MaLHP AND TrangThai != N'Hủy')
    BEGIN
        RAISERROR(N'Sinh viên không đăng ký lớp học phần này', 16, 1);
        RETURN;
    END

    -- 2. Check Grade Existence
    DECLARE @NgayCapNhat DATETIME;
    SELECT @NgayCapNhat = NgayCapNhat FROM Diem WHERE MaSV = @MaSV AND MaLHP = @MaLHP;

    IF @NgayCapNhat IS NULL
    BEGIN
        RAISERROR(N'Chưa có điểm, không thể phúc khảo', 16, 1);
        RETURN;
    END

    -- 3. Check 7-Day Rule (New)
    -- If today > NgayCapNhat + 7 days
    IF GETDATE() > DATEADD(DAY, 7, @NgayCapNhat)
    BEGIN
        RAISERROR(N'Đã quá thời hạn phúc khảo (7 ngày kể từ ngày công bố điểm)', 16, 1);
        RETURN;
    END

    -- 4. Check Pending Appeal
    IF EXISTS (SELECT 1 FROM PhucKhao WHERE MaSV = @MaSV AND MaLHP = @MaLHP AND TrangThai = N'Chờ xử lý')
    BEGIN
        RAISERROR(N'Đã có đơn phúc khảo đang chờ xử lý cho môn này', 16, 1);
        RETURN;
    END

    INSERT INTO PhucKhao (MaSV, MaLHP, LyDo, TrangThai, NgayGui)
    VALUES (@MaSV, @MaLHP, @LyDo, N'Chờ xử lý', GETDATE());
END;
GO

-- 12. SP Lấy danh sách phúc khảo của sinh viên
IF OBJECT_ID (
    'sp_LayDanhSachPhucKhao_SinhVien',
    'P'
) IS NOT NULL
DROP PROC sp_LayDanhSachPhucKhao_SinhVien;
GO
CREATE PROCEDURE sp_LayDanhSachPhucKhao_SinhVien
    @MaSV NVARCHAR(10)
AS
BEGIN
    SELECT 
        pk.Id,
        pk.MaLHP,
        hp.TenHP,
        pk.LyDo,
        pk.TrangThai,
        pk.NgayGui,
        pk.GhiChuXuLy
    FROM PhucKhao pk
    JOIN LopHocPhan lhp ON pk.MaLHP = lhp.MaLHP
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    WHERE pk.MaSV = @MaSV
    ORDER BY pk.NgayGui DESC;
END;
GO

-- 14. SP Lấy danh sách môn được phép phúc khảo (New)
IF OBJECT_ID ('sp_LayMonDuocPhucKhao', 'P') IS NOT NULL
DROP PROC sp_LayMonDuocPhucKhao;
GO
CREATE PROCEDURE sp_LayMonDuocPhucKhao
    @MaSV NVARCHAR(10)
AS
BEGIN
    SELECT 
        d.MaLHP,
        hp.TenHP,
        d.DiemTK,
        d.NgayCapNhat AS NgayCongBo
    FROM Diem d
    JOIN LopHocPhan lhp ON d.MaLHP = lhp.MaLHP
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    WHERE d.MaSV = @MaSV
      AND d.DiemTK IS NOT NULL 
      AND GETDATE() <= DATEADD(DAY, 7, d.NgayCapNhat)
      AND NOT EXISTS (
          SELECT 1 
          FROM PhucKhao pk 
          WHERE pk.MaSV = @MaSV 
            AND pk.MaLHP = d.MaLHP 
            AND pk.TrangThai = N'Chờ xử lý'
      )
    ORDER BY d.NgayCapNhat DESC;
END;
GO

-- =============================================
-- GROUP 6: GRADUATION (TỐT NGHIỆP)
-- =============================================

-- 13. SP Lấy kết quả xét tốt nghiệp của sinh viên
IF OBJECT_ID (
    'sp_LayKetQuaTotNghiep_SinhVien',
    'P'
) IS NOT NULL
DROP PROC sp_LayKetQuaTotNghiep_SinhVien;
GO
CREATE PROCEDURE sp_LayKetQuaTotNghiep_SinhVien
    @MaSV NVARCHAR(10)
AS
BEGIN
    -- Kiểm tra xem đã được xét chưa
    IF NOT EXISTS (SELECT 1 FROM XetTotNghiep WHERE MaSV = @MaSV)
    BEGIN
        -- Nếu chưa xét, thử chạy xét tự động
        DECLARE @MaNganh NVARCHAR(10), @MaKhoaTS NVARCHAR(10);
        SELECT @MaNganh = MaNganh, @MaKhoaTS = MaKhoaTS FROM SinhVien WHERE MaSV = @MaSV;
        
        IF @MaNganh IS NOT NULL
        BEGIN
            EXEC sp_XetTotNghiep_NganhKhoa @MaNganh, @MaKhoaTS;
        END
    END

    -- Trả về kết quả mới nhất
    SELECT TOP 1
        xtn.LanXet,
        xtn.KetQua,
        xtn.LyDo,
        xtn.NgayXet
    FROM XetTotNghiep xtn
    WHERE xtn.MaSV = @MaSV
    ORDER BY xtn.NgayXet DESC;
END;
GO