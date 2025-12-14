USE EduProDb;
GO

-- =============================================
-- MIGRATION 001: Cải tiến schema LopHocPhan
-- Thêm các field: NgayBatDau, NgayKetThuc, SoBuoiHoc, TrangThaiLop, SoBuoiTrongTuan
-- =============================================

-- Step 1: Kiểm tra nếu cột đã tồn tại
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'LopHocPhan' AND COLUMN_NAME = 'NgayBatDau')
BEGIN
    ALTER TABLE LopHocPhan
    ADD 
        NgayBatDau DATE NULL,
        NgayKetThuc DATE NULL,
        SoBuoiHoc INT DEFAULT 13,
        SoBuoiTrongTuan TINYINT DEFAULT 1,
        TrangThaiLop NVARCHAR(50) DEFAULT N'Sắp khai giảng';
    
    PRINT '✓ Columns added successfully';
END
ELSE
BEGIN
    PRINT '⚠ Columns already exist, skipping...';
END

GO

-- Step 2: Tạo constraint check cho TrangThaiLop (nếu chưa có)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE TABLE_NAME = 'LopHocPhan' AND CONSTRAINT_NAME = 'CK_LopHocPhan_TrangThai')
BEGIN
    ALTER TABLE LopHocPhan
    ADD CONSTRAINT CK_LopHocPhan_TrangThai 
    CHECK (TrangThaiLop IN (N'Sắp khai giảng', N'Đang học', N'Kết thúc', N'Hủy'));
    
    PRINT '✓ TrangThai constraint added';
END

GO

-- Step 3: Tạo constraint check cho SoBuoiTrongTuan
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE TABLE_NAME = 'LopHocPhan' AND CONSTRAINT_NAME = 'CK_LopHocPhan_SoBuoi')
BEGIN
    ALTER TABLE LopHocPhan
    ADD CONSTRAINT CK_LopHocPhan_SoBuoi 
    CHECK (SoBuoiTrongTuan IN (1, 2));
    
    PRINT '✓ SoBuoi constraint added';
END

GO

-- Step 4: Tạo constraint check cho ngày
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE TABLE_NAME = 'LopHocPhan' AND CONSTRAINT_NAME = 'CK_LopHocPhan_Ngay')
BEGIN
    ALTER TABLE LopHocPhan
    ADD CONSTRAINT CK_LopHocPhan_Ngay 
    CHECK (NgayBatDau IS NULL OR NgayKetThuc IS NULL OR (NgayBatDau IS NOT NULL AND NgayKetThuc IS NOT NULL AND NgayKetThuc >= NgayBatDau));
    
    PRINT '✓ Ngay constraint added';
END

GO

-- Step 5: Tạo Index
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LopHocPhan_TrangThai')
    CREATE INDEX IX_LopHocPhan_TrangThai ON LopHocPhan(TrangThaiLop);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LopHocPhan_NgayBatDau')
    CREATE INDEX IX_LopHocPhan_NgayBatDau ON LopHocPhan(NgayBatDau);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_LopHocPhan_MaHP')
    CREATE INDEX IX_LopHocPhan_MaHP ON LopHocPhan(MaHP);

PRINT '✓ Indexes created';

GO

-- =============================================
-- Dữ liệu mẫu: Cập nhật các lớp hiện tại
-- =============================================

UPDATE LopHocPhan
SET 
    NgayBatDau = '2024-09-02',
    NgayKetThuc = '2024-12-20',
    SoBuoiHoc = 13,
    SoBuoiTrongTuan = 1,
    TrangThaiLop = N'Sắp khai giảng'
WHERE MaNam = N'NAM2024' AND MaHK = N'HK1';

PRINT '✓ Sample data updated';

GO

PRINT '✓✓✓ Migration 001 completed successfully!';
