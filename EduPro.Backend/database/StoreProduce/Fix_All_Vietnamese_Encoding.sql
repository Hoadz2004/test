USE EduProDb1;
GO
SET NOCOUNT ON;

------------------------------------------------------------
-- Fix tiếng Việt cho các bảng dùng ở frontend Enrollment
-- Chạy an toàn, idempotent
------------------------------------------------------------

-- CaHoc: mô tả ca học
UPDATE CaHoc SET MoTa = N'Ca 1 (Tiết 1-3)' WHERE MaCa IN (N'C1', N'CA1');
UPDATE CaHoc SET MoTa = N'Ca 2 (Tiết 4-6)' WHERE MaCa IN (N'C2', N'CA2');
UPDATE CaHoc SET MoTa = N'Ca 3 (Tiết 7-9)' WHERE MaCa IN (N'C3', N'CA3');
UPDATE CaHoc SET MoTa = N'Ca 4 (Tiết 10-12)' WHERE MaCa IN (N'C4', N'CA4');
UPDATE CaHoc SET MoTa = N'Ca tối 1 (Tiết 13-15)' WHERE MaCa IN (N'C5', N'TOI1');
UPDATE CaHoc SET MoTa = N'Ca tối 2 (Tiết 16-18)' WHERE MaCa IN (N'C6', N'TOI2');

-- HocKy: tên học kỳ
UPDATE HocKy SET TenHK = N'Học kỳ 1' WHERE MaHK LIKE '%1%' AND (TenHK LIKE '%k%' OR TenHK LIKE '%1%');
UPDATE HocKy SET TenHK = N'Học kỳ 2' WHERE MaHK LIKE '%2%' AND (TenHK LIKE '%k%' OR TenHK LIKE '%2%');
UPDATE HocKy SET TenHK = N'Học kỳ Hè' WHERE TenHK LIKE N'%H%' OR MaHK LIKE '%HKH%';

-- Phòng học
UPDATE PhongHoc SET TenPhong = N'Phòng 101' WHERE MaPhong = N'P101';
UPDATE PhongHoc SET TenPhong = N'Phòng 102' WHERE MaPhong = N'P102';
UPDATE PhongHoc SET TenPhong = N'Phòng 103' WHERE MaPhong = N'P103';
UPDATE PhongHoc SET TenPhong = N'Phòng 201' WHERE MaPhong = N'P201';
UPDATE PhongHoc SET TenPhong = N'Phòng thí nghiệm 1' WHERE MaPhong = N'LAB01';
UPDATE PhongHoc SET TenPhong = N'Phòng thí nghiệm 2' WHERE MaPhong = N'LAB02';

-- Học phần
UPDATE HocPhan SET TenHP = N'Nhập môn lập trình' WHERE MaHP = N'CNTT001';
UPDATE HocPhan SET TenHP = N'Cơ sở dữ liệu' WHERE MaHP = N'CNTT002';
UPDATE HocPhan SET TenHP = N'Cấu trúc dữ liệu' WHERE MaHP = N'CNTT003';
UPDATE HocPhan SET TenHP = N'Lập trình hướng đối tượng' WHERE MaHP = N'CNTT004';
UPDATE HocPhan SET TenHP = N'Mạng máy tính' WHERE MaHP = N'CNTT005';
UPDATE HocPhan SET TenHP = N'Giải tích 1' WHERE MaHP = N'MATH001';
UPDATE HocPhan SET TenHP = N'Xác suất thống kê' WHERE MaHP = N'MATH002';
UPDATE HocPhan SET TenHP = N'Tiếng Anh 1' WHERE MaHP = N'ENG001';
UPDATE HocPhan SET TenHP = N'Tiếng Anh 2' WHERE MaHP = N'ENG002';
UPDATE HocPhan SET TenHP = N'Trí tuệ nhân tạo' WHERE MaHP = N'AI01' OR TenHP LIKE '%Trí tuệ nhân tạo%';
UPDATE HocPhan SET TenHP = N'Phân tích thiết kế hệ thống' WHERE MaHP = N'PTTKHT' OR TenHP LIKE '%thiết kế hệ thống%';
UPDATE HocPhan SET TenHP = N'Tiếng Anh chuyên ngành CNTT' WHERE TenHP LIKE N'%Tiếng Anh chuyên ngành%';
UPDATE HocPhan SET TenHP = N'Công nghệ Blockchain' WHERE MaHP = N'BLOCKCHAIN';
UPDATE HocPhan SET TenHP = N'Đề án tốt nghiệp' WHERE MaHP = N'CLOUD';
UPDATE HocPhan SET LoaiHocPhan = N'Lý thuyết' WHERE LoaiHocPhan IS NULL OR LTRIM(RTRIM(LoaiHocPhan)) = '';

-- Đăng ký học phần: trạng thái + constraint
UPDATE DangKyHocPhan SET TrangThai = N'Đăng ký' WHERE TrangThai LIKE N'%ng k%';
UPDATE DangKyHocPhan SET TrangThai = N'Phê duyệt' WHERE TrangThai LIKE N'%phê%' OR TrangThai LIKE N'%duyệt%';
UPDATE DangKyHocPhan SET TrangThai = N'Hủy' WHERE TrangThai LIKE N'%hủy%' OR TrangThai LIKE N'%h%y%';

IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_DangKy_TrangThai')
BEGIN
    ALTER TABLE DangKyHocPhan DROP CONSTRAINT CK_DangKy_TrangThai;
END;

ALTER TABLE DangKyHocPhan WITH CHECK ADD CONSTRAINT CK_DangKy_TrangThai
CHECK ([TrangThai] IN (N'Đăng ký', N'Hủy', N'Phê duyệt'));

-- Điểm: kết quả
UPDATE Diem SET KetQua = N'Đạt' WHERE KetQua LIKE N'%Đa%' OR KetQua LIKE N'%Dat%';
UPDATE Diem SET KetQua = N'Không đạt' WHERE KetQua LIKE N'%không%' OR KetQua LIKE N'%kh%ng%';

-- Phúc khảo: trạng thái
UPDATE PhucKhao SET TrangThai = N'Chờ xử lý' WHERE TrangThai LIKE N'%chờ%' OR TrangThai LIKE N'%cho%';
UPDATE PhucKhao SET TrangThai = N'Đã xử lý' WHERE TrangThai LIKE N'%xử lý%';
UPDATE PhucKhao SET TrangThai = N'Bị từ chối' WHERE TrangThai LIKE N'%từ chối%';

-- Xét tốt nghiệp: kết quả
UPDATE XetTotNghiep SET KetQua = N'Đủ điều kiện' WHERE KetQua LIKE N'%đủ%' OR KetQua LIKE N'%du%';
UPDATE XetTotNghiep SET KetQua = N'Chưa đủ điều kiện' WHERE KetQua LIKE N'%chưa%' OR KetQua LIKE N'%chua%';

-- Log hệ thống: chỉ sửa mẫu phổ biến
UPDATE LogHeThong SET HanhDong = N'Hành động' WHERE HanhDong LIKE N'%hành%' OR HanhDong LIKE N'%h%nh%';
UPDATE LogHeThong SET ChiTiet = N'Chi tiết' WHERE ChiTiet LIKE N'%chi tiết%' OR (ChiTiet IS NOT NULL AND LTRIM(RTRIM(ChiTiet)) = '');

PRINT N'✓ Đã sửa lỗi encoding tiếng Việt cho các bảng chính (Enrollment/Grades)';
GO
