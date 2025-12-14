USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- 1. Fix Check Constraint for KetQua (Drop and Recreate to ensure correct UTF-8/NVARCHAR)
IF OBJECT_ID ('CK_Diem_KetQua', 'C') IS NOT NULL
ALTER TABLE Diem
DROP CONSTRAINT CK_Diem_KetQua;
GO

ALTER TABLE Diem
WITH
    CHECK
ADD CONSTRAINT CK_Diem_KetQua CHECK (
    KetQua IN (N'Đạt', N'Không đạt')
);
GO

-- 2. Update SP to include new Rule (DiemCK < 4 => Fail)
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
    
    -- Calculate Letter Grade and 4.0 Scale
    DECLARE @DiemChu NVARCHAR(2);
    DECLARE @DiemHe4 DECIMAL(3,2);
    DECLARE @KetQua NVARCHAR(20);

    -- Simple conversion logic
    IF @DiemTK >= 8.5 BEGIN SET @DiemChu = 'A'; SET @DiemHe4 = 4.0; END
    ELSE IF @DiemTK >= 8.0 BEGIN SET @DiemChu = 'B+'; SET @DiemHe4 = 3.5; END
    ELSE IF @DiemTK >= 7.0 BEGIN SET @DiemChu = 'B'; SET @DiemHe4 = 3.0; END
    ELSE IF @DiemTK >= 6.5 BEGIN SET @DiemChu = 'C+'; SET @DiemHe4 = 2.5; END
    ELSE IF @DiemTK >= 5.5 BEGIN SET @DiemChu = 'C'; SET @DiemHe4 = 2.0; END
    ELSE IF @DiemTK >= 5.0 BEGIN SET @DiemChu = 'D+'; SET @DiemHe4 = 1.5; END
    ELSE IF @DiemTK >= 4.0 BEGIN SET @DiemChu = 'D'; SET @DiemHe4 = 1.0; END
    ELSE BEGIN SET @DiemChu = 'F'; SET @DiemHe4 = 0.0; END

    -- NEW RULE: Final Score < 4.0 => Fail regardless of Total Score
    IF @DiemTK >= 4.0 AND @DiemCK >= 4.0 
    BEGIN
        SET @KetQua = N'Đạt';
    END
    ELSE 
    BEGIN
        SET @KetQua = N'Không đạt';
        -- Optional: Should we downgrade DiemChu to F? 
        -- Usually if you fail, DiemChu is F, and DiemHe4 is 0.
        -- Let's enforce F if failed by this rule, even if DiemTK >= 4.0
        IF @DiemCK < 4.0
        BEGIN
             SET @DiemChu = 'F';
             SET @DiemHe4 = 0.0;
        END
    END

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
GO
PRINT 'Fixed Grade Constraints and SP Logic';
GO