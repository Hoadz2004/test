USE EduProDb;
GO

-- 1. Add Weight columns to LopHocPhan if not exist
IF NOT EXISTS (
    SELECT 1
    FROM sys.columns
    WHERE
        Name = N'TrongSoCC'
        AND Object_ID = Object_ID (N'LopHocPhan')
) BEGIN
ALTER TABLE LopHocPhan
ADD TrongSoCC DECIMAL(3, 2) NOT NULL DEFAULT 0.1;
-- 10%
ALTER TABLE LopHocPhan
ADD TrongSoGK DECIMAL(3, 2) NOT NULL DEFAULT 0.4;
-- 40%
ALTER TABLE LopHocPhan
ADD TrongSoCK DECIMAL(3, 2) NOT NULL DEFAULT 0.5;
-- 50%

PRINT 'Added Weight columns to LopHocPhan';

END

-- 2. SP: Get Classes for Lecturer
-- Used by: Lecturer Dashboard
IF OBJECT_ID ('sp_Lecturer_GetClasses', 'P') IS NOT NULL
DROP PROC sp_Lecturer_GetClasses;
GO
CREATE PROCEDURE sp_Lecturer_GetClasses
    @MaGV NVARCHAR(10),
    @NamHoc INT = NULL,
    @HocKy INT = NULL
AS
BEGIN
    SELECT 
        lhp.MaLHP,
        hp.TenHP,
        hp.SoTinChi,
        lhp.SiSoToiDa,
        (SELECT COUNT(*) FROM DangKyHocPhan dk WHERE dk.MaLHP = lhp.MaLHP) AS SiSoThucTe,
        lhp.ThuTrongTuan,
        lhp.MaCa,
        lhp.MaPhong,
        lhp.TrongSoCC,
        lhp.TrongSoGK,
        lhp.TrongSoCK
    FROM LopHocPhan lhp
    JOIN HocPhan hp ON lhp.MaHP = hp.MaHP
    WHERE lhp.MaGV = @MaGV
    -- Filter by Year/Semester if needed (For now get all)
    ORDER BY lhp.MaLHP DESC;
END;
GO

-- 3. SP: Get Students in Class (Gradebook)
-- Used by: Lecturer Grade Entry
IF OBJECT_ID (
    'sp_Lecturer_GetClassGrades',
    'P'
) IS NOT NULL
DROP PROC sp_Lecturer_GetClassGrades;
GO
CREATE PROCEDURE sp_Lecturer_GetClassGrades
    @MaLHP NVARCHAR(20)
AS
BEGIN
    SELECT 
        sv.MaSV,
        sv.HoTen,
        sv.LopHanhChinh AS Lop, -- Aliased for frontend consistency
        ISNULL(d.DiemQT, 0) AS DiemTC, -- Re-map CC/QT if needed (DiemQT is Qua Trinh / CC)
        ISNULL(d.DiemGK, 0) AS DiemGK,
        ISNULL(d.DiemCK, 0) AS DiemCK,
        d.DiemTK,
        d.DiemChu,
        d.KetQua
    FROM DangKyHocPhan dk
    JOIN SinhVien sv ON dk.MaSV = sv.MaSV
    LEFT JOIN Diem d ON dk.MaSV = d.MaSV AND dk.MaLHP = d.MaLHP
    WHERE dk.MaLHP = @MaLHP
    ORDER BY sv.HoTen; -- Sort by Full Name
END;
GO

-- 4. SP: Update Student Grade
-- Used by: Lecturer Grade Entry (Save)
IF OBJECT_ID (
    'sp_Lecturer_UpdateGrade',
    'P'
) IS NOT NULL
DROP PROC sp_Lecturer_UpdateGrade;
GO
CREATE PROCEDURE sp_Lecturer_UpdateGrade
    @MaLHP NVARCHAR(20),
    @MaSV NVARCHAR(10),
    @DiemCC DECIMAL(4,2),
    @DiemGK DECIMAL(4,2),
    @DiemCK DECIMAL(4,2),
    @PerformedBy NVARCHAR(50)
AS
BEGIN
    DECLARE @TrongSoCC DECIMAL(3,2), @TrongSoGK DECIMAL(3,2), @TrongSoCK DECIMAL(3,2);
    
    -- Get Weights
    SELECT @TrongSoCC = TrongSoCC, @TrongSoGK = TrongSoGK, @TrongSoCK = TrongSoCK
    FROM LopHocPhan WHERE MaLHP = @MaLHP;

    -- Calculate Final
    DECLARE @DiemTK DECIMAL(4,2);
    SET @DiemTK = (@DiemCC * @TrongSoCC) + (@DiemGK * @TrongSoGK) + (@DiemCK * @TrongSoCK);
    
    -- Rounding rules (Standard: Round to 1 decimal place? Or 2? Let's keep 2 for DB, display 1)
    
    -- Calculate Letter Grade and 4.0 Scale
    DECLARE @DiemChu NVARCHAR(2);
    DECLARE @DiemHe4 DECIMAL(3,2);
    DECLARE @KetQua NVARCHAR(20);

    -- Simple conversion logic (Can be moved to a Function later)
    IF @DiemTK >= 8.5 BEGIN SET @DiemChu = 'A'; SET @DiemHe4 = 4.0; END
    ELSE IF @DiemTK >= 8.0 BEGIN SET @DiemChu = 'B+'; SET @DiemHe4 = 3.5; END
    ELSE IF @DiemTK >= 7.0 BEGIN SET @DiemChu = 'B'; SET @DiemHe4 = 3.0; END
    ELSE IF @DiemTK >= 6.5 BEGIN SET @DiemChu = 'C+'; SET @DiemHe4 = 2.5; END
    ELSE IF @DiemTK >= 5.5 BEGIN SET @DiemChu = 'C'; SET @DiemHe4 = 2.0; END
    ELSE IF @DiemTK >= 5.0 BEGIN SET @DiemChu = 'D+'; SET @DiemHe4 = 1.5; END
    ELSE IF @DiemTK >= 4.0 BEGIN SET @DiemChu = 'D'; SET @DiemHe4 = 1.0; END
    ELSE BEGIN SET @DiemChu = 'F'; SET @DiemHe4 = 0.0; END

    IF @DiemTK >= 4.0 SET @KetQua = N'Đạt' ELSE SET @KetQua = N'Không đạt';

    -- Upsert Diem
    MERGE Diem AS target
    USING (SELECT @MaSV AS MaSV, @MaLHP AS MaLHP) AS source
    ON (target.MaSV = source.MaSV AND target.MaLHP = source.MaLHP)
    WHEN MATCHED THEN
        UPDATE SET 
            DiemQT = @DiemCC, 
            DiemGK = @DiemGK, 
            DiemCK = @DiemCK,
            DiemTK = @DiemTK,
            DiemChu = @DiemChu,
            DiemHe4 = @DiemHe4,
            KetQua = @KetQua,
            NguoiNhap = @PerformedBy,
            NgayCapNhat = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (MaSV, MaLHP, DiemQT, DiemGK, DiemCK, DiemTK, DiemChu, DiemHe4, KetQua, NguoiNhap)
        VALUES (@MaSV, @MaLHP, @DiemCC, @DiemGK, @DiemCK, @DiemTK, @DiemChu, @DiemHe4, @KetQua, @PerformedBy);
        
END;

PRINT 'Grade Management Schema & SPs Created';
GO