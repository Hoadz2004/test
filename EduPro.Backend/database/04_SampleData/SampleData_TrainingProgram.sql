USE EduProDb;
GO

-- Create Sample CTDT for 'An Toàn Thông Tin' - K2025
DECLARE @MaNganh NVARCHAR(10) = (SELECT TOP 1 MaNganh FROM Nganh WHERE TenNganh LIKE N'%An Toàn Thông Tin%');
IF @MaNganh IS NULL SET @MaNganh = '7480202'; -- Fallback ID

DECLARE @MaKhoaTS NVARCHAR(10) = 'K2025';

IF NOT EXISTS (SELECT 1 FROM KhoaTuyenSinh WHERE MaKhoaTS = @MaKhoaTS)
    INSERT INTO KhoaTuyenSinh (MaKhoaTS, NamBatDau, TenKhoaTS) VALUES ('K2025', 2025, N'Khóa tuyển sinh 2025');

IF NOT EXISTS (SELECT 1 FROM CTDT WHERE MaNganh = @MaNganh AND MaKhoaTS = @MaKhoaTS)
BEGIN
    INSERT INTO CTDT (MaNganh, MaKhoaTS, TenCTDT, NamBanHanh, TrangThai)
    VALUES (@MaNganh, @MaKhoaTS, N'Chương trình đào tạo ATTT 2025', 2025, 1);
    
    DECLARE @MaCTDT INT = SCOPE_IDENTITY();
    
    -- Add subjects (Using existing MaHP from SampleData_03_Courses.sql or similar)
    -- Assuming basics exist: LTR001 (Tin đại cương), LTR002 (C++), LTR003 (CTDL)
    
    -- HK1
    IF EXISTS (SELECT 1 FROM HocPhan WHERE MaHP = 'INT1001') -- Tin đại cương
        INSERT INTO CTDT_ChiTiet (MaCTDT, MaHP, HocKyDuKien, BatBuoc) VALUES (@MaCTDT, 'INT1001', 1, 1);
        
    IF EXISTS (SELECT 1 FROM HocPhan WHERE MaHP = 'MAT1001') -- Giải tích 1
        INSERT INTO CTDT_ChiTiet (MaCTDT, MaHP, HocKyDuKien, BatBuoc) VALUES (@MaCTDT, 'MAT1001', 1, 1);

    -- HK2
    IF EXISTS (SELECT 1 FROM HocPhan WHERE MaHP = 'INT1002') -- Lập trình C++
        INSERT INTO CTDT_ChiTiet (MaCTDT, MaHP, HocKyDuKien, BatBuoc) VALUES (@MaCTDT, 'INT1002', 2, 1);

    -- HK3
    IF EXISTS (SELECT 1 FROM HocPhan WHERE MaHP = 'INT1006') -- CTDL & GT
        INSERT INTO CTDT_ChiTiet (MaCTDT, MaHP, HocKyDuKien, BatBuoc) VALUES (@MaCTDT, 'INT1006', 3, 1);
        
    -- Add Prerequisite: Tin đại cương -> Lập trình C++
    IF EXISTS (SELECT 1 FROM HocPhan WHERE MaHP = 'INT1002') AND EXISTS (SELECT 1 FROM HocPhan WHERE MaHP = 'INT1001')
        INSERT INTO TienQuyet (MaHP, MaHP_TienQuyet) VALUES ('INT1002', 'INT1001');

    -- Add Prerequisite: Lập trình C++ -> CTDL & GT
    IF EXISTS (SELECT 1 FROM HocPhan WHERE MaHP = 'INT1006') AND EXISTS (SELECT 1 FROM HocPhan WHERE MaHP = 'INT1002')
        INSERT INTO TienQuyet (MaHP, MaHP_TienQuyet) VALUES ('INT1006', 'INT1002');
END
GO