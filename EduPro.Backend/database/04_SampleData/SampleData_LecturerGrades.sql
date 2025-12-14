USE EduProDb;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- 1. Create Lecturer
IF NOT EXISTS (
    SELECT 1
    FROM GiangVien
    WHERE
        MaGV = 'GV001'
) BEGIN
INSERT INTO
    GiangVien (
        MaGV,
        HoTen,
        Email,
        DienThoai,
        MaKhoa
    )
VALUES (
        'GV001',
        N'Nguyễn Văn Giảng',
        'gv001@edu.vn',
        '0901234567',
        'CNTT'
    );

END

-- 2. Create User Account for Lecturer
IF NOT EXISTS (
    SELECT 1
    FROM TaiKhoan
    WHERE
        TenDangNhap = 'gv001'
) BEGIN
-- Borrow hash from admin
DECLARE @Hash VARBINARY(256);

SELECT TOP 1 @Hash = MatKhauHash
FROM TaiKhoan
WHERE
    TenDangNhap = 'admin';

INSERT INTO
    TaiKhoan (
        TenDangNhap,
        MatKhauHash,
        MaVaiTro,
        MaGV,
        TrangThai
    )
VALUES (
        'gv001',
        @Hash,
        'GIANGVIEN',
        'GV001',
        1
    );

END

-- 3. Create Classes (LopHocPhan)
-- CSDL (CNTT002) - Semester 1
IF NOT EXISTS (
    SELECT 1
    FROM LopHocPhan
    WHERE
        MaLHP = 'LHP_CSDL_01'
) BEGIN
INSERT INTO
    LopHocPhan (
        MaLHP,
        MaHP,
        MaHK,
        MaNam,
        MaGV,
        MaPhong,
        MaCa,
        ThuTrongTuan,
        SiSoToiDa
    )
VALUES (
        'LHP_CSDL_01',
        'CNTT002',
        'HK1-2025',
        '2025-2026',
        'GV001',
        'A101',
        'CA1',
        2,
        50
    );
-- Mon, Shift 1
END

-- CTDL (CTDL) - Semester 1
IF NOT EXISTS (
    SELECT 1
    FROM LopHocPhan
    WHERE
        MaLHP = 'LHP_CTDL_01'
) BEGIN
INSERT INTO
    LopHocPhan (
        MaLHP,
        MaHP,
        MaHK,
        MaNam,
        MaGV,
        MaPhong,
        MaCa,
        ThuTrongTuan,
        SiSoToiDa
    )
VALUES (
        'LHP_CTDL_01',
        'CTDL',
        'HK1-2025',
        '2025-2026',
        'GV001',
        'A102',
        'CA2',
        3,
        50
    );
-- Tue, Shift 2
END

-- 4. Register Students
-- Register 'duong123' (2025002) to these classes
IF NOT EXISTS (
    SELECT 1
    FROM DangKyHocPhan
    WHERE
        MaSV = '2025002'
        AND MaLHP = 'LHP_CSDL_01'
) BEGIN
INSERT INTO
    DangKyHocPhan (MaSV, MaLHP)
VALUES ('2025002', 'LHP_CSDL_01');

END IF NOT EXISTS (
    SELECT 1
    FROM DangKyHocPhan
    WHERE
        MaSV = '2025002'
        AND MaLHP = 'LHP_CTDL_01'
) BEGIN
INSERT INTO
    DangKyHocPhan (MaSV, MaLHP)
VALUES ('2025002', 'LHP_CTDL_01');

END

PRINT 'Sample Data for Lecturer Grades Created Successfully';
GO