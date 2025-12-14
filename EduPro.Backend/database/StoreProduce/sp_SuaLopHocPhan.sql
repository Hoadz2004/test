USE EduProDb;
GO

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
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM LopHocPhan WHERE MaLHP = @MaLHP)
    BEGIN
        RAISERROR(N'Mã lớp học phần không tồn tại.', 16, 1);
        RETURN;
    END

    -- Room conflict (exclude current)
    IF EXISTS (SELECT 1 FROM LopHocPhan 
               WHERE MaPhong = @MaPhong 
                 AND MaCa = @MaCa 
                 AND ThuTrongTuan = @ThuTrongTuan 
                 AND MaHK = @MaHK
                 AND MaNam = @MaNam
                 AND MaLHP <> @MaLHP)
    BEGIN
        RAISERROR(N'Phòng học đã bị trùng lịch trong ngày và ca này.', 16, 1);
        RETURN;
    END

    -- Lecturer conflict (exclude current)
    IF EXISTS (SELECT 1 FROM LopHocPhan 
               WHERE MaGV = @MaGV 
                 AND MaCa = @MaCa 
                 AND ThuTrongTuan = @ThuTrongTuan 
                 AND MaHK = @MaHK
                 AND MaNam = @MaNam
                 AND MaLHP <> @MaLHP)
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
