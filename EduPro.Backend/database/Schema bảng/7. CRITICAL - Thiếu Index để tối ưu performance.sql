-- CRITICAL: Thêm Index để tối ưu performance
-- Index cho các trường thường query

-- Index cho SinhVien
CREATE INDEX IX_SinhVien_MaNganh ON SinhVien (MaNganh);

CREATE INDEX IX_SinhVien_MaKhoaTS ON SinhVien (MaKhoaTS);

CREATE INDEX IX_SinhVien_TrangThai ON SinhVien (TrangThai);

-- Index cho DangKyHocPhan
CREATE INDEX IX_DangKyHocPhan_MaSV ON DangKyHocPhan (MaSV);

CREATE INDEX IX_DangKyHocPhan_MaLHP ON DangKyHocPhan (MaLHP);

CREATE INDEX IX_DangKyHocPhan_TrangThai ON DangKyHocPhan (TrangThai);

-- Index cho Diem
CREATE INDEX IX_Diem_MaSV ON Diem (MaSV);

CREATE INDEX IX_Diem_MaLHP ON Diem (MaLHP);

-- Index cho TaiKhoan
CREATE INDEX IX_TaiKhoan_MaSV ON TaiKhoan (MaSV);

CREATE INDEX IX_TaiKhoan_MaGV ON TaiKhoan (MaGV);

CREATE INDEX IX_TaiKhoan_MaVaiTro ON TaiKhoan (MaVaiTro);

-- Index cho LopHocPhan
CREATE INDEX IX_LopHocPhan_MaHP ON LopHocPhan (MaHP);

CREATE INDEX IX_LopHocPhan_MaHK ON LopHocPhan (MaHK);

CREATE INDEX IX_LopHocPhan_MaGV ON LopHocPhan (MaGV);

-- Index cho GiangVien
CREATE INDEX IX_GiangVien_MaKhoa ON GiangVien (MaKhoa);

-- Index cho Nganh
CREATE INDEX IX_Nganh_MaKhoa ON Nganh (MaKhoa);

-- Index cho CTDT_ChiTiet
CREATE INDEX IX_CTDT_ChiTiet_MaCTDT ON CTDT_ChiTiet (MaCTDT);

CREATE INDEX IX_CTDT_ChiTiet_MaHP ON CTDT_ChiTiet (MaHP);

-- Index cho ThongBao_NguoiNhan
CREATE INDEX IX_ThongBao_NguoiNhan_TenDangNhap ON ThongBao_NguoiNhan (TenDangNhap);

CREATE INDEX IX_ThongBao_NguoiNhan_DaDoc ON ThongBao_NguoiNhan (DaDoc);

-- Index cho LogHeThong
CREATE INDEX IX_LogHeThong_TenDangNhap ON LogHeThong (TenDangNhap);

CREATE INDEX IX_LogHeThong_ThoiGian ON LogHeThong (ThoiGian);