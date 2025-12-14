USE EduProDb;
GO

SET QUOTED_IDENTIFIER ON;
GO

-- 1. SP Get CTDT List
IF OBJECT_ID ('sp_Admin_GetCTDT', 'P') IS NOT NULL
DROP PROC sp_Admin_GetCTDT;
GO
CREATE PROCEDURE sp_Admin_GetCTDT
    @Keyword NVARCHAR(100) = NULL,
    @Page INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@Page - 1) * @PageSize;

    SELECT c.*, n.TenNganh, k.TenKhoaTS,
           COUNT(*) OVER() AS TotalRecords
    FROM CTDT c
    JOIN Nganh n ON c.MaNganh = n.MaNganh
    JOIN KhoaTuyenSinh k ON c.MaKhoaTS = k.MaKhoaTS
    WHERE (@Keyword IS NULL OR c.TenCTDT LIKE N'%' + @Keyword + N'%' OR c.MaNganh LIKE N'%' + @Keyword + N'%')
    ORDER BY c.NamBanHanh DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- 2. SP Create CTDT
IF OBJECT_ID ('sp_Admin_CreateCTDT', 'P') IS NOT NULL
DROP PROC sp_Admin_CreateCTDT;
GO
CREATE PROCEDURE sp_Admin_CreateCTDT
    @MaNganh NVARCHAR(10),
    @MaKhoaTS NVARCHAR(10),
    @TenCTDT NVARCHAR(200),
    @NamBanHanh INT,
    @TrangThai INT
AS
BEGIN
    INSERT INTO CTDT (MaNganh, MaKhoaTS, TenCTDT, NamBanHanh, TrangThai)
    VALUES (@MaNganh, @MaKhoaTS, @TenCTDT, @NamBanHanh, @TrangThai);
    
    SELECT SCOPE_IDENTITY() AS Id;
END;
GO

-- 3. SP Get CTDT Detail with Subjects
IF OBJECT_ID ('sp_Admin_GetCTDTDetail', 'P') IS NOT NULL
DROP PROC sp_Admin_GetCTDTDetail;
GO
CREATE PROCEDURE sp_Admin_GetCTDTDetail
    @MaCTDT INT
AS
BEGIN
    -- Get Info
    SELECT c.*, n.TenNganh, k.TenKhoaTS
    FROM CTDT c
    JOIN Nganh n ON c.MaNganh = n.MaNganh
    JOIN KhoaTuyenSinh k ON c.MaKhoaTS = k.MaKhoaTS
    WHERE c.MaCTDT = @MaCTDT;

    -- Get Subjects
    SELECT cd.Id, cd.MaCTDT, cd.MaHP, hp.TenHP, hp.SoTinChi, cd.HocKyDuKien, cd.BatBuoc, cd.NhomTuChon,
           STUFF((SELECT ',' + tq.MaHP_TienQuyet 
                  FROM TienQuyet tq 
                  WHERE tq.MaHP = cd.MaHP 
                  FOR XML PATH('')), 1, 1, '') AS MonTienQuyet
    FROM CTDT_ChiTiet cd
    JOIN HocPhan hp ON cd.MaHP = hp.MaHP
    WHERE cd.MaCTDT = @MaCTDT
    ORDER BY cd.HocKyDuKien, cd.MaHP;
END;
GO

-- 4. SP Add Subject to CTDT
IF OBJECT_ID (
    'sp_Admin_AddChiTietCTDT',
    'P'
) IS NOT NULL
DROP PROC sp_Admin_AddChiTietCTDT;
GO
CREATE PROCEDURE sp_Admin_AddChiTietCTDT
    @MaCTDT INT,
    @MaHP NVARCHAR(10),
    @HocKyDuKien INT,
    @BatBuoc BIT,
    @NhomTuChon NVARCHAR(50) = NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM CTDT_ChiTiet WHERE MaCTDT = @MaCTDT AND MaHP = @MaHP)
    BEGIN
        RAISERROR(N'Học phần đã tồn tại trong chương trình đào tạo', 16, 1);
        RETURN;
    END

    INSERT INTO CTDT_ChiTiet (MaCTDT, MaHP, HocKyDuKien, BatBuoc, NhomTuChon)
    VALUES (@MaCTDT, @MaHP, @HocKyDuKien, @BatBuoc, @NhomTuChon);
END;
GO

-- 5. SP Remove Subject from CTDT
IF OBJECT_ID (
    'sp_Admin_RemoveChiTietCTDT',
    'P'
) IS NOT NULL
DROP PROC sp_Admin_RemoveChiTietCTDT;
GO
CREATE PROCEDURE sp_Admin_RemoveChiTietCTDT
    @Id INT
AS
BEGIN
    DELETE FROM CTDT_ChiTiet WHERE Id = @Id;
END;
GO

-- 6. SP Add Prerequisite
IF OBJECT_ID ('sp_Admin_AddTienQuyet', 'P') IS NOT NULL
DROP PROC sp_Admin_AddTienQuyet;
GO
CREATE PROCEDURE sp_Admin_AddTienQuyet
    @MaHP NVARCHAR(10),
    @MaHP_TienQuyet NVARCHAR(10)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM TienQuyet WHERE MaHP = @MaHP AND MaHP_TienQuyet = @MaHP_TienQuyet)
        RETURN;

    INSERT INTO TienQuyet (MaHP, MaHP_TienQuyet)
    VALUES (@MaHP, @MaHP_TienQuyet);
END;
GO

-- 7. SP Get Student Curriculum (MyCurriculum)
IF OBJECT_ID (
    'sp_Student_GetMyCurriculum',
    'P'
) IS NOT NULL
DROP PROC sp_Student_GetMyCurriculum;
GO
CREATE PROCEDURE sp_Student_GetMyCurriculum
    @MaSV NVARCHAR(20)
AS
BEGIN
    DECLARE @MaNganh NVARCHAR(20);
    DECLARE @MaKhoaTS NVARCHAR(20);

    SELECT @MaNganh = MaNganh, @MaKhoaTS = MaKhoaTS FROM SinhVien WHERE MaSV = @MaSV;

    -- Find CTDT matching student's Major and Cohort (Active only)
    DECLARE @MaCTDT INT;
    SELECT TOP 1 @MaCTDT = MaCTDT 
    FROM CTDT 
    WHERE MaNganh = @MaNganh AND MaKhoaTS = @MaKhoaTS AND TrangThai = 1
    ORDER BY NamBanHanh DESC;

    IF @MaCTDT IS NULL 
    BEGIN
        -- Fallback to latest active CTDT for the Major
        SELECT TOP 1 @MaCTDT = MaCTDT 
        FROM CTDT 
        WHERE MaNganh = @MaNganh AND TrangThai = 1
        ORDER BY NamBanHanh DESC;
    END
    
    -- Return Curriculum Info
    SELECT MaCTDT, TenCTDT FROM CTDT WHERE MaCTDT = @MaCTDT;

    -- Return Subjects with Status
    SELECT 
        hp.MaHP, hp.TenHP, hp.SoTinChi, cd.HocKyDuKien, cd.BatBuoc,
        ISNULL(d.DiemTK, 0) AS Diem,
        CASE 
            WHEN d.MaLHP IS NOT NULL AND (d.KetQua like N'%Đạt%' OR d.DiemTK >= 4.0) THEN N'Passed'
            WHEN d.MaLHP IS NOT NULL THEN N'Failed'
            ELSE N'NotTaken'
        END AS Status
    FROM CTDT_ChiTiet cd
    JOIN HocPhan hp ON cd.MaHP = hp.MaHP
    OUTER APPLY (
        SELECT TOP 1 d.DiemTK, d.KetQua, d.MaLHP
        FROM Diem d
        JOIN LopHocPhan lhp ON d.MaLHP = lhp.MaLHP
        WHERE d.MaSV = @MaSV AND lhp.MaHP = cd.MaHP
        ORDER BY d.DiemTK DESC
    ) d
    WHERE cd.MaCTDT = @MaCTDT
    ORDER BY cd.HocKyDuKien, cd.MaHP;
END;
GO

PRINT N'Training Program SPs Created';
GO