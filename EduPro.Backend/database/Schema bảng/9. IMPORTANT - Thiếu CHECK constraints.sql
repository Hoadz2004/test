-- IMPORTANT: Thêm CHECK constraints để validate dữ liệu
-- Lưu ý: CK_Diem_DiemQT, CK_Diem_DiemGK, CK_Diem_DiemCK đã được thêm vào file #5

-- Validate điểm số (0-10) - Tiết TK (Tích lũy)
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_Diem_DiemTK' AND TABLE_NAME = 'Diem'
)
BEGIN
    ALTER TABLE Diem
    ADD CONSTRAINT CK_Diem_DiemTK CHECK (
        DiemTK IS NULL
        OR (
            DiemTK >= 0
            AND DiemTK <= 10
        )
    );
END;

-- Validate điểm hệ 4
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_Diem_DiemHe4' AND TABLE_NAME = 'Diem'
)
BEGIN
    ALTER TABLE Diem
    ADD CONSTRAINT CK_Diem_DiemHe4 CHECK (
        DiemHe4 IS NULL
        OR (
            DiemHe4 >= 0
            AND DiemHe4 <= 4
        )
    );
END;

-- Validate điểm chữ
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_Diem_DiemChu' AND TABLE_NAME = 'Diem'
)
BEGIN
    ALTER TABLE Diem
    ADD CONSTRAINT CK_Diem_DiemChu CHECK (
        DiemChu IS NULL
        OR DiemChu IN (
            N'A+',
            N'A',
            N'B+',
            N'B',
            N'C+',
            N'C',
            N'D+',
            N'D',
            N'F'
        )
    );
END;

-- Validate kết quả
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_Diem_KetQua' AND TABLE_NAME = 'Diem'
)
BEGIN
    ALTER TABLE Diem
    ADD CONSTRAINT CK_Diem_KetQua CHECK (
        KetQua IS NULL
        OR KetQua IN (N'Đạt', N'Không đạt')
    );
END;

-- Validate học kỳ (ngày kết thúc phải sau ngày bắt đầu)
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_HocKy_NgayBatDau' AND TABLE_NAME = 'HocKy'
)
BEGIN
    ALTER TABLE HocKy
    ADD CONSTRAINT CK_HocKy_NgayBatDau CHECK (NgayKetThuc > NgayBatDau);
END;

-- Validate năm học
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_NAME = 'CK_NamHoc' AND TABLE_NAME = 'NamHoc'
)
BEGIN
    ALTER TABLE NamHoc
    ADD CONSTRAINT CK_NamHoc CHECK (NamKetThuc = NamBatDau + 1);
END;
GO

-- Validate thứ trong tuần (2=Thứ 2, 7=Chủ nhật)
ALTER TABLE LopHocPhan
ADD CONSTRAINT CK_LHP_ThuTrongTuan CHECK (ThuTrongTuan BETWEEN 2 AND 7);

-- Validate sĩ số
ALTER TABLE LopHocPhan
ADD CONSTRAINT CK_LHP_SiSo CHECK (SiSoToiDa > 0);

ALTER TABLE PhongHoc
ADD CONSTRAINT CK_PhongHoc_SucChua CHECK (SucChua > 0);

-- Validate số tín chỉ
ALTER TABLE HocPhan
ADD CONSTRAINT CK_HocPhan_SoTinChi CHECK (SoTinChi > 0);

-- Validate giờ học
ALTER TABLE CaHoc
ADD CONSTRAINT CK_CaHoc_Gio CHECK (GioKetThuc > GioBatDau);

-- Validate trạng thái sinh viên
ALTER TABLE SinhVien
ADD CONSTRAINT CK_SinhVien_TrangThai CHECK (
    TrangThai IN (
        N'Đang học',
        N'Bảo lưu',
        N'Thôi học',
        N'Tốt nghiệp'
    )
);

-- Validate giới tính
ALTER TABLE SinhVien
ADD CONSTRAINT CK_SinhVien_GioiTinh CHECK (
    GioiTinh IS NULL
    OR GioiTinh IN (N'Nam', N'Nữ', N'Khác')
);

-- Validate trạng thái đăng ký
ALTER TABLE DangKyHocPhan
ADD CONSTRAINT CK_DangKy_TrangThai CHECK (
    TrangThai IN (N'Đăng ký', N'Hủy')
);

-- Validate trạng thái phúc khảo
ALTER TABLE PhucKhao
ADD CONSTRAINT CK_PhucKhao_TrangThai CHECK (
    TrangThai IN (
        N'Chờ xử lý',
        N'Đã xử lý',
        N'Từ chối'
    )
);

-- Validate kết quả xét tốt nghiệp
ALTER TABLE XetTotNghiep
ADD CONSTRAINT CK_XetTotNghiep_KetQua CHECK (
    KetQua IN (
        N'Đủ điều kiện',
        N'Chưa đủ điều kiện'
    )
);

-- Validate điều kiện tốt nghiệp
ALTER TABLE DieuKienTotNghiep
ADD CONSTRAINT CK_DieuKienTN_TinChi CHECK (SoTinChiToiThieu > 0);

ALTER TABLE DieuKienTotNghiep
ADD CONSTRAINT CK_DieuKienTN_DiemTB CHECK (
    DiemTBTichLuyToiThieu >= 0
    AND DiemTBTichLuyToiThieu <= 4
);