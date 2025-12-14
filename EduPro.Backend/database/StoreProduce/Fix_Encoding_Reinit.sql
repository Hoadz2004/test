USE EduProDb1;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- =============================================================
-- CLEAR & REINIT ENCODING FOR ALL DATA (VIETNAMESE CHARACTERS)
-- SQL SERVER 2012 COMPATIBLE
-- =============================================================

-- 1. CLEAR & REINIT KHOA (FACULTY)
DELETE FROM Khoa WHERE MaKhoa IN ('CNTT', 'KT', 'NNA', 'QTKD', 'KTTT', 'NN', 'QT', 'SU');

INSERT INTO Khoa (MaKhoa, TenKhoa, TrangThai)
VALUES
    (N'CNTT', N'Công Nghệ Thông Tin', 1),
    (N'KTTT', N'Kinh Tế - Tài Chính', 1),
    (N'NN', N'Ngoại Ngữ', 1),
    (N'QT', N'Quản Trị Kinh Doanh', 1),
    (N'SU', N'Sư Phạm', 1);

-- 2. CLEAR & REINIT NGANH (MAJOR)
DELETE FROM Nganh WHERE MaNganh IN ('CNTT01', 'KTPM01', 'HTTT01', 'ANH01', 'NHAT01', 'QTKD01', 'KT01', 'TCNH01', 'ATTT01', 'KHMT01', 'TMDT01');

INSERT INTO Nganh (MaNganh, TenNganh, MaKhoa, TrangThai)
VALUES
    (N'CNTT01', N'Công Nghệ Thông Tin', N'CNTT', 1),
    (N'KTPM01', N'Kỹ Thuật Phần Mềm', N'CNTT', 1),
    (N'HTTT01', N'Hệ Thống Thông Tin', N'CNTT', 1),
    (N'KHMT01', N'Khoa Học Máy Tính', N'CNTT', 1),
    (N'ATTT01', N'An Toàn Thông Tin', N'CNTT', 1),
    (N'QTKD01', N'Quản Trị Kinh Doanh', N'QT', 1),
    (N'TCNH01', N'Tài Chính - Ngân Hàng', N'KTTT', 1),
    (N'TMDT01', N'Thương Mại Điện Tử', N'KTTT', 1),
    (N'ANH01', N'Ngôn Ngữ Anh', N'NN', 1),
    (N'NHAT01', N'Ngôn Ngữ Nhật', N'NN', 1);

-- 3. CLEAR & REINIT VAI TRO (ROLE)
DELETE FROM VaiTro WHERE MaVaiTro IN ('ADMIN', 'LECTURER', 'STUDENT', 'DEAN', 'ASSISTANT', 'BANGIAMHIEU', 'GIANGVIEN', 'PHONGDAOTAO', 'SINHVIEN');

INSERT INTO VaiTro (MaVaiTro, TenVaiTro)
VALUES
    (N'ADMIN', N'Quản Trị Viên'),
    (N'DEAN', N'Trưởng Khoa'),
    (N'LECTURER', N'Giảng Viên'),
    (N'STUDENT', N'Sinh Viên'),
    (N'ASSISTANT', N'Trợ Lý'),
    (N'BANGIAMHIEU', N'Ban Giám Hiệu'),
    (N'PHONGDAOTAO', N'Phòng Đào Tạo');

-- 4. CLEAR & REINIT QUYEN (PERMISSION)
DELETE FROM Quyen;

INSERT INTO Quyen (MaQuyen, TenQuyen)
VALUES
    (N'STUDENT_VIEW', N'Xem Danh Sách Sinh Viên'),
    (N'STUDENT_CREATE', N'Thêm Sinh Viên'),
    (N'STUDENT_EDIT', N'Sửa Thông Tin Sinh Viên'),
    (N'STUDENT_DELETE', N'Xóa Sinh Viên'),
    (N'LECTURER_VIEW', N'Xem Danh Sách Giảng Viên'),
    (N'LECTURER_MANAGE', N'Quản Lý Giảng Viên'),
    (N'COURSE_VIEW', N'Xem Danh Sách Học Phần'),
    (N'COURSE_MANAGE', N'Quản Lý Học Phần'),
    (N'GRADE_VIEW', N'Xem Điểm'),
    (N'GRADE_INPUT', N'Nhập Điểm'),
    (N'GRADE_EDIT', N'Sửa Điểm'),
    (N'REGISTER_VIEW', N'Xem Đăng Ký Học Phần'),
    (N'REGISTER_MANAGE', N'Quản Lý Đăng Ký Học Phần'),
    (N'REGISTER_STUDENT', N'Đăng Ký Học Phần (Sinh Viên)'),
    (N'NOTIFICATION_SEND', N'Gửi Thông Báo'),
    (N'CURRICULUM_MANAGE', N'Quản Lý Chương Trình Đào Tạo'),
    (N'REPORT_VIEW', N'Xem Báo Cáo'),
    (N'REPORT_EXPORT', N'Xuất Báo Cáo');

PRINT N'✓ Data Reinitialized with Correct UTF-8 Encoding';
GO
