-- Sửa data type cho DiemTBTichLuyToiThieu
-- Từ DECIMAL(3,2) -> DECIMAL(4,2) để có thể lưu 10.00

ALTER TABLE DieuKienTotNghiep
ALTER COLUMN DiemTBTichLuyToiThieu DECIMAL(4, 2) NOT NULL;