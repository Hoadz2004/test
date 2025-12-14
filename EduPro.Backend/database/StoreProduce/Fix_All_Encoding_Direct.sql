USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- FIX ALL TEXT ENCODING WITH CORRECT UTF-8 (DIRECT UPDATE)
-- =============================================================

-- 1. FIX CACAHOC (TẤT CẢ CaHoc - không xóa)
UPDATE CaHoc SET MoTa = N'Ca 1 (Tiết 1-3)' WHERE MaCa IN (N'C1', N'CA1');
UPDATE CaHoc SET MoTa = N'Ca 2 (Tiết 4-6)' WHERE MaCa IN (N'C2', N'CA2');
UPDATE CaHoc SET MoTa = N'Ca 3 (Tiết 7-9)' WHERE MaCa IN (N'C3', N'CA3');
UPDATE CaHoc SET MoTa = N'Ca 4 (Tiết 10-12)' WHERE MaCa IN (N'C4', N'CA4');
UPDATE CaHoc SET MoTa = N'Ca tối 1 (Tiết 13-15)' WHERE MaCa IN (N'C5', N'TOI1');
UPDATE CaHoc SET MoTa = N'Ca tối 2 (Tiết 16-18)' WHERE MaCa IN (N'C6', N'TOI2');

-- 2. FIX HOCKY
UPDATE HocKy SET TenHK = N'Học kỳ 1' WHERE TenHK LIKE '%k%' AND MaHK LIKE '%1%';
UPDATE HocKy SET TenHK = N'Học kỳ 2' WHERE TenHK LIKE '%k%' AND MaHK LIKE '%2%';
UPDATE HocKy SET TenHK = N'Học kỳ Hè' WHERE TenHK LIKE '%H%' OR MaHK LIKE '%HKH%';

-- 3. FIX PHONGOC
UPDATE PhongHoc SET TenPhong = N'Phòng 101' WHERE MaPhong = N'P101';
UPDATE PhongHoc SET TenPhong = N'Phòng 102' WHERE MaPhong = N'P102';
UPDATE PhongHoc SET TenPhong = N'Phòng 103' WHERE MaPhong = N'P103';
UPDATE PhongHoc SET TenPhong = N'Phòng 201' WHERE MaPhong = N'P201';
UPDATE PhongHoc SET TenPhong = N'Phòng thí nghiệm 1' WHERE MaPhong = N'LAB01';
UPDATE PhongHoc SET TenPhong = N'Phòng thí nghiệm 2' WHERE MaPhong = N'LAB02';

-- 4. FIX HOCPHAN
UPDATE HocPhan SET TenHP = N'Nhập môn lập trình' WHERE MaHP = N'CNTT001';
UPDATE HocPhan SET TenHP = N'Cơ sở dữ liệu' WHERE MaHP = N'CNTT002';
UPDATE HocPhan SET TenHP = N'Cấu trúc dữ liệu' WHERE MaHP = N'CNTT003';
UPDATE HocPhan SET TenHP = N'Lập trình hướng đối tượng' WHERE MaHP = N'CNTT004';
UPDATE HocPhan SET TenHP = N'Mạng máy tính' WHERE MaHP = N'CNTT005';
UPDATE HocPhan SET TenHP = N'Giải tích 1' WHERE MaHP = N'MATH001';
UPDATE HocPhan SET TenHP = N'Xác suất thống kê' WHERE MaHP = N'MATH002';
UPDATE HocPhan SET TenHP = N'Tiếng Anh 1' WHERE MaHP = N'ENG001';
UPDATE HocPhan SET TenHP = N'Tiếng Anh 2' WHERE MaHP = N'ENG002';

-- FIX ANY CORRUPTED HOCPHAN
UPDATE HocPhan 
SET TenHP = N'Trí tuệ nhân tạo'
WHERE MaHP = N'AI01' OR TenHP LIKE '%Tr%';

UPDATE HocPhan 
SET TenHP = N'Tiếng Anh chuyên ngành CNTT'
WHERE TenHP LIKE '%Ti%ng Anh ch%';

UPDATE HocPhan 
SET TenHP = N'Công nghệ Blockchain'
WHERE MaHP = N'BLOCKCHAIN';

UPDATE HocPhan 
SET TenHP = N'Đề án tốt nghiệp'
WHERE MaHP = N'CLOUD';

UPDATE HocPhan 
SET LoaiHocPhan = N'Lý thuyết'
WHERE LoaiHocPhan IS NULL OR LoaiHocPhan LIKE '';

-- 5. FIX DANGKYHOCPHAN - TrangThai
UPDATE DangKyHocPhan SET TrangThai = N'Đăng ký' WHERE TrangThai LIKE '%ng k%' OR TrangThai LIKE '%Đăng%';
UPDATE DangKyHocPhan SET TrangThai = N'Phê duyệt' WHERE TrangThai LIKE '%ph%' OR TrangThai LIKE '%d%y%t%';
UPDATE DangKyHocPhan SET TrangThai = N'Hủy' WHERE TrangThai LIKE '%h%y%';

-- 6. FIX DIEM - KetQua
UPDATE Diem SET KetQua = N'Đạt' WHERE KetQua LIKE '%?%t%' OR KetQua LIKE '%Dat%';
UPDATE Diem SET KetQua = N'Không đạt' WHERE KetQua LIKE '%kh%ng%' OR KetQua LIKE '%Kh%ng%';

-- 7. FIX PHUCKAO - TrangThai & LyDo
UPDATE PhucKhao SET TrangThai = N'Chờ xử lý' WHERE TrangThai LIKE '%chờ%' OR TrangThai LIKE '%ch%';
UPDATE PhucKhao SET TrangThai = N'Đã xử lý' WHERE TrangThai LIKE '%xử lý%';
UPDATE PhucKhao SET TrangThai = N'Bị từ chối' WHERE TrangThai LIKE '%từ chối%';

-- 8. FIX XETTOTNGHIEP - KetQua
UPDATE XetTotNghiep SET KetQua = N'Đủ điều kiện' WHERE KetQua LIKE '%?%u%' OR KetQua LIKE '%du%';
UPDATE XetTotNghiep SET KetQua = N'Chưa đủ điều kiện' WHERE KetQua LIKE '%ch?a%' OR KetQua LIKE '%chua%';

-- 9. FIX LOPHOCDPHAN - GhiChu
UPDATE LopHocPhan SET GhiChu = N'Ghi chú' WHERE GhiChu IS NOT NULL AND GhiChu LIKE '';

-- 10. FIX LOGHETHONG - HanhDong & ChiTiet
UPDATE LogHeThong SET HanhDong = N'Hành động' WHERE HanhDong LIKE '%hành%' OR HanhDong LIKE '%h%nh%';
UPDATE LogHeThong SET ChiTiet = N'Chi tiết' WHERE ChiTiet LIKE '%chi ti%' OR ChiTiet IS NOT NULL;

PRINT N'✓ All Text Fields Fixed with Correct UTF-8 Encoding - Direct UPDATE';
GO
