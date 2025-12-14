USE EduProDb1;
GO

-- Logic: Duyệt qua danh sách Học Phần có sẵn, tự động tạo Lớp Học Phần tương ứng cho kỳ HK1_2425
-- Chỉ tạo nếu chưa có lớp nào mở cho môn đó trong kỳ này.

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
SELECT
    'LHP_' + MaHP, -- Mã lớp tự sinh: LHP_ + Mã môn
    MaHP, -- Mã môn lấy từ HocPhan
    'HK1_2425', -- Kỳ hiện tại
    '2024-2025', -- Năm hiện tại
    'GV001', -- Giảng viên mặc định (Demo)
    60, -- Sĩ số mặc định
    (ABS(CHECKSUM (NEWID ())) % 6) + 2, -- Random Thứ (2-7)
    CASE
        WHEN (ABS(CHECKSUM (NEWID ())) % 2) = 0 THEN 'C1'
        ELSE 'C2'
    END, -- Random Ca (C1/C2)
    CASE
        WHEN LoaiHocPhan LIKE N'%Thực hành%'
        OR LoaiHocPhan LIKE N'%Đồ án%' THEN 'LAB01'
        ELSE 'P101'
    END -- Phòng học dựa theo loại
FROM HocPhan
WHERE
    MaHP NOT IN(
        SELECT MaHP
        FROM LopHocPhan
        WHERE
            MaHK = 'HK1_2425'
    );