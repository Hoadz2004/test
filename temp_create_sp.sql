DROP PROCEDURE IF EXISTS sp_SuaLopHocPhan;
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
    @GhiChu NVARCHAR(200) = NULL
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM LopHocPhan WHERE MaLHP = @MaLHP)
    BEGIN
        RAISERROR(N'Mã lớp học phần không tồn tại.', 16, 1);
        RETURN;
    END

    UPDATE LopHocPhan 
    SET MaHP = @MaHP, 
        MaGV = @MaGV, 
        MaPhong = @MaPhong, 
        MaCa = @MaCa, 
        ThuTrongTuan = @ThuTrongTuan, 
        SiSoToiDa = @SiSoToiDa, 
        GhiChu = @GhiChu
    WHERE MaLHP = @MaLHP;
END;
GO
