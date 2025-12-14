USE EduProDb1;
GO

-- 1. Index cho DangKyHocPhan để đếm sĩ số lớp học phần nhanh hơn (tránh Scan toàn bảng)
-- Giúp: SELECT COUNT(*) FROM DangKyHocPhan WHERE MaLHP = @Id AND TrangThai = 1
IF NOT EXISTS (
    SELECT *
    FROM sys.indexes
    WHERE
        name = 'IX_DangKyHocPhan_MaLHP_TrangThai'
) CREATE NONCLUSTERED INDEX IX_DangKyHocPhan_MaLHP_TrangThai ON dbo.DangKyHocPhan (MaLHP, TrangThai) INCLUDE (MaSV);

-- 2. Index cho DangKyHocPhan để lấy lịch học của sinh viên nhanh hơn (tránh Scan khi check trùng lịch)
-- Giúp: SELECT * FROM DangKyHocPhan WHERE MaSV = @Id AND TrangThai = 1
IF NOT EXISTS (
    SELECT *
    FROM sys.indexes
    WHERE
        name = 'IX_DangKyHocPhan_MaSV_TrangThai'
) CREATE NONCLUSTERED INDEX IX_DangKyHocPhan_MaSV_TrangThai ON dbo.DangKyHocPhan (MaSV, TrangThai) INCLUDE (MaLHP);

-- 3. Index cho LichHoc để join lịch học nhanh hơn
-- Giúp: JOIN LichHoc lh1 ... WHERE lh1.MaCa = lh2.MaCa
IF NOT EXISTS (
    SELECT *
    FROM sys.indexes
    WHERE
        name = 'IX_LichHoc_MaLHP_MaCa'
) CREATE NONCLUSTERED INDEX IX_LichHoc_MaLHP_MaCa ON dbo.LichHoc (MaLHP, MaCa);

-- 4. Index cho Diem để check môn tiên quyết (Prerequisite)
-- Giúp: EXISTS (SELECT 1 FROM Diem WHERE MaSV = @Id AND MaHP = @PreId AND KetQua = N'Đạt')
IF NOT EXISTS (
    SELECT *
    FROM sys.indexes
    WHERE
        name = 'IX_Diem_MaSV_MaHP_KetQua'
) CREATE NONCLUSTERED INDEX IX_Diem_MaSV_MaHP_KetQua ON dbo.Diem (MaSV, MaHP, KetQua);

-- 5. Index cho TienQuyet để tìm môn tiên quyết của môn đang đăng ký
-- Giúp: SELECT * FROM TienQuyet WHERE MaHP = @Id ...
IF NOT EXISTS (
    SELECT *
    FROM sys.indexes
    WHERE
        name = 'IX_TienQuyet_MaHP'
) CREATE NONCLUSTERED INDEX IX_TienQuyet_MaHP ON dbo.TienQuyet (MaHP) INCLUDE (MaHPTruoc);

PRINT '✅ Database Optimized: Added 5 High-Performance Indexes.';
GO