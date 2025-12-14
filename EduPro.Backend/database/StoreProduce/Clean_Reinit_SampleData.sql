USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- CLEAN & REINIT ALL SAMPLE DATA WITH CORRECT UTF-8 ENCODING
-- =============================================================

-- Clean dependent tables first
DELETE FROM DangKyHocPhan;
DELETE FROM LopHocPhan;
DELETE FROM Diem;
DELETE FROM PhucKhao;
DELETE FROM XetTotNghiep;
DELETE FROM SinhVien_TrangThai;
DELETE FROM SinhVien;
DELETE FROM TaiKhoan;
DELETE FROM CaHoc;
DELETE FROM HocPhan;
DELETE FROM HocKy;
DELETE FROM NamHoc;
DELETE FROM PhongHoc;

-- Reinit NamHoc
INSERT INTO NamHoc (MaNam, NamBatDau, NamKetThuc)
VALUES
    (N'NAM2424', 2024, 2025),
    (N'NAM2325', 2023, 2024),
    (N'NAM2526', 2025, 2026);

-- Reinit HocKy
INSERT INTO HocKy (MaHK, TenHK, MaNam, NgayBatDau, NgayKetThuc, ChoPhepDangKy, NgayBatDauDangKy, NgayKetThucDangKy)
VALUES
    (N'HK1-2025', N'Học kỳ 1', N'NAM2424', CAST('2024-09-01' AS DATE), CAST('2024-12-20' AS DATE), 1, CAST('2024-08-15' AS DATE), CAST('2024-09-30' AS DATE)),
    (N'HK2-2025', N'Học kỳ 2', N'NAM2424', CAST('2025-01-15' AS DATE), CAST('2025-05-15' AS DATE), 1, CAST('2025-01-01' AS DATE), CAST('2025-02-15' AS DATE)),
    (N'HKH-2025', N'Học kỳ Hè', N'NAM2425', CAST('2025-06-01' AS DATE), CAST('2025-08-15' AS DATE), 0, NULL, NULL);

-- Reinit PhongHoc
INSERT INTO PhongHoc (MaPhong, TenPhong, SucChua)
VALUES
    (N'P101', N'Phòng 101', 40),
    (N'P102', N'Phòng 102', 40),
    (N'P103', N'Phòng 103', 50),
    (N'P201', N'Phòng 201', 35),
    (N'LAB01', N'Phòng thí nghiệm 1', 30),
    (N'LAB02', N'Phòng thí nghiệm 2', 30);

-- Reinit CaHoc
INSERT INTO CaHoc (MaCa, MoTa, GioBatDau, GioKetThuc)
VALUES
    (N'C1', N'Ca 1 (Tiết 1-3)', CAST('07:00' AS TIME), CAST('09:30' AS TIME)),
    (N'C2', N'Ca 2 (Tiết 4-6)', CAST('10:00' AS TIME), CAST('12:30' AS TIME)),
    (N'C3', N'Ca 3 (Tiết 7-9)', CAST('13:00' AS TIME), CAST('15:30' AS TIME)),
    (N'C4', N'Ca 4 (Tiết 10-12)', CAST('16:00' AS TIME), CAST('18:30' AS TIME)),
    (N'C5', N'Ca tối 1 (Tiết 13-15)', CAST('18:30' AS TIME), CAST('21:00' AS TIME));

-- Reinit HocPhan
DELETE FROM HocPhan;
INSERT INTO HocPhan (MaHP, TenHP, SoTinChi, SoTietLT, SoTietTH, BatBuoc, LoaiHocPhan)
VALUES
    (N'CNTT001', N'Nhập môn lập trình', 3, 30, 30, 1, N'Lý thuyết'),
    (N'CNTT002', N'Cơ sở dữ liệu', 3, 30, 30, 1, N'Lý thuyết'),
    (N'CNTT003', N'Cấu trúc dữ liệu', 3, 30, 30, 1, N'Lý thuyết'),
    (N'CNTT004', N'Lập trình hướng đối tượng', 4, 40, 40, 1, N'Lý thuyết'),
    (N'CNTT005', N'Mạng máy tính', 3, 30, 30, 1, N'Lý thuyết'),
    (N'MATH001', N'Giải tích 1', 3, 40, 0, 1, N'Lý thuyết'),
    (N'MATH002', N'Xác suất thống kê', 3, 30, 15, 1, N'Lý thuyết'),
    (N'ENG001', N'Tiếng Anh 1', 2, 30, 15, 1, N'Lý thuyết'),
    (N'ENG002', N'Tiếng Anh 2', 2, 30, 15, 1, N'Lý thuyết');

PRINT N'✓ Sample Data Reinitialized with Correct UTF-8 Encoding';
GO
