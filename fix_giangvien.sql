UPDATE GiangVien SET HoTen = N'ThS. Vũ Thị Phương' WHERE MaGV = N'GV006';
UPDATE GiangVien SET HoTen = N'TS. Đặng Minh Giang' WHERE MaGV = N'GV007';
UPDATE GiangVien SET HoTen = N'ThS. Bùi Thị Hà' WHERE MaGV = N'GV008';
UPDATE GiangVien SET HoTen = N'TS. Ngô Văn Khánh' WHERE MaGV = N'GV009';
UPDATE GiangVien SET HoTen = N'ThS. Phan Thái Lan' WHERE MaGV = N'GV010';
SELECT MaGV, HoTen FROM GiangVien WHERE MaGV >= N'GV006' ORDER BY MaGV;
