USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- FIX ENCODING FOR ALL DATA (WITHOUT DELETE - Direct UPDATE)
-- SQL SERVER 2012 COMPATIBLE
-- =============================================================

-- 1. FIX KHOA (FACULTY)
UPDATE Khoa SET TenKhoa = N'Công Nghệ Thông Tin' WHERE MaKhoa = N'CNTT';
UPDATE Khoa SET TenKhoa = N'Kinh Tế - Tài Chính' WHERE MaKhoa = N'KTTT';
UPDATE Khoa SET TenKhoa = N'Ngoại Ngữ' WHERE MaKhoa = N'NN';
UPDATE Khoa SET TenKhoa = N'Quản Trị Kinh Doanh' WHERE MaKhoa = N'QT';
UPDATE Khoa SET TenKhoa = N'Sư Phạm' WHERE MaKhoa = N'SU';

-- 2. FIX NGANH (MAJOR)
UPDATE Nganh SET TenNganh = N'Công Nghệ Thông Tin' WHERE MaNganh = N'CNTT01';
UPDATE Nganh SET TenNganh = N'Kỹ Thuật Phần Mềm' WHERE MaNganh = N'KTPM01';
UPDATE Nganh SET TenNganh = N'Hệ Thống Thông Tin' WHERE MaNganh = N'HTTT01';
UPDATE Nganh SET TenNganh = N'Khoa Học Máy Tính' WHERE MaNganh = N'KHMT01';
UPDATE Nganh SET TenNganh = N'An Toàn Thông Tin' WHERE MaNganh = N'ATTT01';
UPDATE Nganh SET TenNganh = N'Quản Trị Kinh Doanh' WHERE MaNganh = N'QTKD01';
UPDATE Nganh SET TenNganh = N'Tài Chính - Ngân Hàng' WHERE MaNganh = N'TCNH01';
UPDATE Nganh SET TenNganh = N'Thương Mại Điện Tử' WHERE MaNganh = N'TMDT01';
UPDATE Nganh SET TenNganh = N'Ngôn Ngữ Anh' WHERE MaNganh = N'ANH01';
UPDATE Nganh SET TenNganh = N'Ngôn Ngữ Nhật' WHERE MaNganh = N'NHAT01';

-- 3. FIX VAI TRO (ROLE)
UPDATE VaiTro SET TenVaiTro = N'Quản Trị Viên' WHERE MaVaiTro = N'ADMIN';
UPDATE VaiTro SET TenVaiTro = N'Trưởng Khoa' WHERE MaVaiTro = N'DEAN';
UPDATE VaiTro SET TenVaiTro = N'Giảng Viên' WHERE MaVaiTro = N'LECTURER';
UPDATE VaiTro SET TenVaiTro = N'Sinh Viên' WHERE MaVaiTro = N'STUDENT';
UPDATE VaiTro SET TenVaiTro = N'Trợ Lý' WHERE MaVaiTro = N'ASSISTANT';
UPDATE VaiTro SET TenVaiTro = N'Ban Giám Hiệu' WHERE MaVaiTro = N'BANGIAMHIEU';
UPDATE VaiTro SET TenVaiTro = N'Phòng Đào Tạo' WHERE MaVaiTro = N'PHONGDAOTAO';

-- 4. FIX QUYEN (PERMISSION)
UPDATE Quyen SET TenQuyen = N'Xem Danh Sách Sinh Viên' WHERE MaQuyen = N'STUDENT_VIEW';
UPDATE Quyen SET TenQuyen = N'Thêm Sinh Viên' WHERE MaQuyen = N'STUDENT_CREATE';
UPDATE Quyen SET TenQuyen = N'Sửa Thông Tin Sinh Viên' WHERE MaQuyen = N'STUDENT_EDIT';
UPDATE Quyen SET TenQuyen = N'Xóa Sinh Viên' WHERE MaQuyen = N'STUDENT_DELETE';
UPDATE Quyen SET TenQuyen = N'Xem Danh Sách Giảng Viên' WHERE MaQuyen = N'LECTURER_VIEW';
UPDATE Quyen SET TenQuyen = N'Quản Lý Giảng Viên' WHERE MaQuyen = N'LECTURER_MANAGE';
UPDATE Quyen SET TenQuyen = N'Xem Danh Sách Học Phần' WHERE MaQuyen = N'COURSE_VIEW';
UPDATE Quyen SET TenQuyen = N'Quản Lý Học Phần' WHERE MaQuyen = N'COURSE_MANAGE';
UPDATE Quyen SET TenQuyen = N'Xem Điểm' WHERE MaQuyen = N'GRADE_VIEW';
UPDATE Quyen SET TenQuyen = N'Nhập Điểm' WHERE MaQuyen = N'GRADE_INPUT';
UPDATE Quyen SET TenQuyen = N'Sửa Điểm' WHERE MaQuyen = N'GRADE_EDIT';
UPDATE Quyen SET TenQuyen = N'Xem Đăng Ký Học Phần' WHERE MaQuyen = N'REGISTER_VIEW';
UPDATE Quyen SET TenQuyen = N'Quản Lý Đăng Ký Học Phần' WHERE MaQuyen = N'REGISTER_MANAGE';
UPDATE Quyen SET TenQuyen = N'Đăng Ký Học Phần (Sinh Viên)' WHERE MaQuyen = N'REGISTER_STUDENT';
UPDATE Quyen SET TenQuyen = N'Gửi Thông Báo' WHERE MaQuyen = N'NOTIFICATION_SEND';
UPDATE Quyen SET TenQuyen = N'Quản Lý Chương Trình Đào Tạo' WHERE MaQuyen = N'CURRICULUM_MANAGE';
UPDATE Quyen SET TenQuyen = N'Xem Báo Cáo' WHERE MaQuyen = N'REPORT_VIEW';
UPDATE Quyen SET TenQuyen = N'Xuất Báo Cáo' WHERE MaQuyen = N'REPORT_EXPORT';

PRINT N'✓ All Encoding Fixed Successfully - Direct UPDATE';
GO
