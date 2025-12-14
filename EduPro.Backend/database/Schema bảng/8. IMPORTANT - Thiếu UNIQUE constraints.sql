-- IMPORTANT: Thêm UNIQUE constraints để tránh duplicate data
-- Sử dụng FILTERED INDEX cho các cột cho phép NULL (SQL Server specific)

SET QUOTED_IDENTIFIER ON;
GO

-- TaiKhoan: 1 sinh viên chỉ có 1 tài khoản (bỏ qua nếu MaSV là NULL)
CREATE UNIQUE
INDEX UIX_TaiKhoan_MaSV ON TaiKhoan (MaSV)
WHERE
    MaSV IS NOT NULL;

-- TaiKhoan: 1 giảng viên chỉ có 1 tài khoản (bỏ qua nếu MaGV là NULL)
CREATE UNIQUE
INDEX UIX_TaiKhoan_MaGV ON TaiKhoan (MaGV)
WHERE
    MaGV IS NOT NULL;

-- Email không được trùng (bỏ qua nếu Email là NULL)
CREATE UNIQUE
INDEX UIX_SinhVien_Email ON SinhVien (Email)
WHERE
    Email IS NOT NULL;

CREATE UNIQUE
INDEX UIX_GiangVien_Email ON GiangVien (Email)
WHERE
    Email IS NOT NULL;

-- DangKyHocPhan: Sinh viên không đăng ký trùng lớp học phần
-- (MaSV, MaLHP không nullable nên dùng Constraint thường ok, nhưng Index cũng tốt)
ALTER TABLE DangKyHocPhan
ADD CONSTRAINT UQ_DangKy_SV_LHP UNIQUE (MaSV, MaLHP);

-- Diem: 1 sinh viên chỉ có 1 bản điểm cho 1 lớp học phần
ALTER TABLE Diem ADD CONSTRAINT UQ_Diem_SV_LHP UNIQUE (MaSV, MaLHP);

-- TienQuyet: Không định nghĩa trùng điều kiện tiên quyết
ALTER TABLE TienQuyet
ADD CONSTRAINT UQ_TienQuyet_HP UNIQUE (MaHP, MaHP_TienQuyet);

-- CTDT: Mỗi ngành-khóa chỉ có 1 CTĐT chính thức
ALTER TABLE CTDT
ADD CONSTRAINT UQ_CTDT_Nganh_Khoa UNIQUE (MaNganh, MaKhoaTS);

-- CongNo: Mỗi sinh viên chỉ có 1 dòng công nợ cho 1 học kỳ
-- (Đã có trong file 11, nhưng nhắc lại logic ở đây để rõ ràng - không chạy lại lệnh này nếu file 11 đã chạy)
-- ALTER TABLE CongNo ADD CONSTRAINT UQ_CongNo_SV_HK UNIQUE(MaSV, MaHK);