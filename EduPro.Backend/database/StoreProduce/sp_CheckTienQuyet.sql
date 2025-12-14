USE EduProDb;
GO

IF OBJECT_ID('sp_CheckTienQuyet', 'P') IS NOT NULL
    DROP PROC sp_CheckTienQuyet;
GO

CREATE PROCEDURE sp_CheckTienQuyet
    @MaSV NVARCHAR(20),
    @MaLHP NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaHP NVARCHAR(10);
    SELECT @MaHP = MaHP FROM LopHocPhan WHERE MaLHP = @MaLHP;

    IF @MaHP IS NULL
    BEGIN
        SELECT 0 AS Result, N'Lớp học phần không tồn tại' AS Message;
        RETURN;
    END;

    DECLARE @Prerequisites TABLE (MaHP_TienQuyet NVARCHAR(10));

    INSERT INTO @Prerequisites (MaHP_TienQuyet)
    SELECT MaHP_TienQuyet FROM TienQuyet WHERE MaHP = @MaHP;

    IF NOT EXISTS (SELECT 1 FROM @Prerequisites)
    BEGIN
        SELECT 1 AS Result, N'OK' AS Message;
        RETURN;
    END;

    DECLARE @MissingPrerequisites NVARCHAR(MAX);

    SELECT @MissingPrerequisites = COALESCE(@MissingPrerequisites + ', ', '') + p.MaHP_TienQuyet
    FROM @Prerequisites p
    WHERE NOT EXISTS (
        SELECT 1
        FROM Diem d
        INNER JOIN LopHocPhan lhp ON d.MaLHP = lhp.MaLHP
        WHERE lhp.MaHP = p.MaHP_TienQuyet
          AND d.MaSV = @MaSV
          AND (d.KetQua LIKE N'%Đạt%' OR d.DiemTK >= 4.0)
    );

    IF @MissingPrerequisites IS NOT NULL
    BEGIN
        SELECT 0 AS Result, N'Bạn chưa hoàn thành môn tiên quyết: ' + @MissingPrerequisites AS Message;
    END
    ELSE
    BEGIN
        SELECT 1 AS Result, N'OK' AS Message;
    END
END;
GO
