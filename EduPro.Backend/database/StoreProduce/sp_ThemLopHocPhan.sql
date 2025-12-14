USE EduProDb;
GO

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
    @TrangThaiLop NVARCHAR(20) = N'Sắp khai giảng',
    @GhiChu NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM LopHocPhan WHERE MaLHP = @MaLHP)
    BEGIN
        RAISERROR(N'Mã lớp học phần đã tồn tại.', 16, 1);
        RETURN;
    END

    -- Room conflict
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

    -- Lecturer conflict
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

    INSERT INTO LopHocPhan (MaLHP, MaHP, MaHK, MaNam, MaGV, MaPhong, MaCa, ThuTrongTuan, SiSoToiDa,
                            NgayBatDau, NgayKetThuc, SoBuoiHoc, SoBuoiTrongTuan, TrangThaiLop, GhiChu)
    VALUES (@MaLHP, @MaHP, @MaHK, @MaNam, @MaGV, @MaPhong, @MaCa, @ThuTrongTuan, @SiSoToiDa,
            @NgayBatDau, @NgayKetThuc, @SoBuoiHoc, @SoBuoiTrongTuan, @TrangThaiLop, @GhiChu);
END;
GO
