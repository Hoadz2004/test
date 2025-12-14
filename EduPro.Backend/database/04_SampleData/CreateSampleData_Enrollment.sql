USE EduProDb;
GO

-- 1. Đảm bảo có Năm học và Học kỳ
IF NOT EXISTS (
    SELECT 1
    FROM NamHoc
    WHERE
        MaNam = '2024-2025'
) BEGIN
INSERT INTO
    NamHoc (MaNam, NamBatDau, NamKetThuc)
VALUES ('2024-2025', 2024, 2025);

END IF EXISTS (
    SELECT 1
    FROM HocKy
    WHERE
        MaHK = 'HK1_2425'
) BEGIN
UPDATE HocKy
SET
    ChoPhepDangKy = 1,
    NgayBatDauDangKy = GETDATE () - 1,
    NgayKetThucDangKy = GETDATE () + 30
WHERE
    MaHK = 'HK1_2425';

END ELSE BEGIN
INSERT INTO
    HocKy (
        MaHK,
        TenHK,
        MaNam,
        NgayBatDau,
        NgayKetThuc,
        ChoPhepDangKy,
        NgayBatDauDangKy,
        NgayKetThucDangKy
    )
VALUES (
        'HK1_2425',
        N'Học kỳ 1',
        '2024-2025',
        '2024-09-01',
        '2025-01-31',
        1,
        GETDATE () - 1,
        GETDATE () + 30
    );

END

-- 2. Tạo Phòng học & Ca học
IF NOT EXISTS (
    SELECT 1
    FROM PhongHoc
    WHERE
        MaPhong = 'P101'
)
INSERT INTO
    PhongHoc (MaPhong, TenPhong, SucChua)
VALUES ('P101', N'Phòng 101', 50);

IF NOT EXISTS (
    SELECT 1
    FROM PhongHoc
    WHERE
        MaPhong = 'LAB01'
)
INSERT INTO
    PhongHoc (MaPhong, TenPhong, SucChua)
VALUES ('LAB01', N'Phòng Lab 01', 30);

IF NOT EXISTS (
    SELECT 1
    FROM CaHoc
    WHERE
        MaCa = 'C1'
)
INSERT INTO
    CaHoc (
        MaCa,
        MoTa,
        GioBatDau,
        GioKetThuc
    )
VALUES (
        'C1',
        N'Sáng 1',
        '07:00',
        '09:25'
    );

IF NOT EXISTS (
    SELECT 1
    FROM CaHoc
    WHERE
        MaCa = 'C2'
)
INSERT INTO
    CaHoc (
        MaCa,
        MoTa,
        GioBatDau,
        GioKetThuc
    )
VALUES (
        'C2',
        N'Sáng 2',
        '09:35',
        '12:00'
    );

-- 3. Tạo Học phần
IF NOT EXISTS (
    SELECT 1
    FROM Khoa
    WHERE
        MaKhoa = 'CNTT'
)
INSERT INTO
    Khoa (MaKhoa, TenKhoa)
VALUES (
        'CNTT',
        N'Công nghệ thông tin'
    );

IF NOT EXISTS (
    SELECT 1
    FROM HocPhan
    WHERE
        MaHP = 'IT001'
)
INSERT INTO
    HocPhan (
        MaHP,
        TenHP,
        SoTinChi,
        SoTietLT,
        SoTietTH,
        BatBuoc,
        LoaiHocPhan
    )
VALUES (
        'IT001',
        N'Lập trình .NET',
        3,
        30,
        15,
        1,
        N'Cơ sở ngành'
    );

IF NOT EXISTS (
    SELECT 1
    FROM HocPhan
    WHERE
        MaHP = 'IT002'
)
INSERT INTO
    HocPhan (
        MaHP,
        TenHP,
        SoTinChi,
        SoTietLT,
        SoTietTH,
        BatBuoc,
        LoaiHocPhan
    )
VALUES (
        'IT002',
        N'Cấu trúc dữ liệu',
        3,
        30,
        15,
        1,
        N'Cơ sở ngành'
    );

IF NOT EXISTS (
    SELECT 1
    FROM HocPhan
    WHERE
        MaHP = 'IT003'
)
INSERT INTO
    HocPhan (
        MaHP,
        TenHP,
        SoTinChi,
        SoTietLT,
        SoTietTH,
        BatBuoc,
        LoaiHocPhan
    )
VALUES (
        'IT003',
        N'Cơ sở dữ liệu',
        4,
        45,
        15,
        1,
        N'Cơ sở ngành'
    );

-- 4. Tạo Lớp học phần (Đang mở)
-- Lớp 1: .NET
IF NOT EXISTS (
    SELECT 1
    FROM LopHocPhan
    WHERE
        MaLHP = 'LHP001'
)
INSERT INTO
    LopHocPhan (
        MaLHP,
        MaHP,
        MaHK,
        MaNam,
        MaGV,
        SiSoToiDa,
        ThuTrongTuan,
        MaCa,
        MaPhong
    )
VALUES (
        'LHP001',
        'IT001',
        'HK1_2425',
        '2024-2025',
        'GV001',
        60,
        2,
        'C1',
        'P101'
    );

-- Lớp 2: CTDL
IF NOT EXISTS (
    SELECT 1
    FROM LopHocPhan
    WHERE
        MaLHP = 'LHP002'
)
INSERT INTO
    LopHocPhan (
        MaLHP,
        MaHP,
        MaHK,
        MaNam,
        MaGV,
        SiSoToiDa,
        ThuTrongTuan,
        MaCa,
        MaPhong
    )
VALUES (
        'LHP002',
        'IT002',
        'HK1_2425',
        '2024-2025',
        'GV001',
        50,
        4,
        'C2',
        'P101'
    );

-- Lớp 3: CSDL
IF NOT EXISTS (
    SELECT 1
    FROM LopHocPhan
    WHERE
        MaLHP = 'LHP003'
)
INSERT INTO
    LopHocPhan (
        MaLHP,
        MaHP,
        MaHK,
        MaNam,
        MaGV,
        SiSoToiDa,
        ThuTrongTuan,
        MaCa,
        MaPhong
    )
VALUES (
        'LHP003',
        'IT003',
        'HK1_2425',
        '2024-2025',
        'GV001',
        30,
        6,
        'C1',
        'LAB01'
    );