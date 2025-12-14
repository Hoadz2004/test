USE EduProDb1;
GO

-- Fix encoding issues (Mojibake) for existing records
UPDATE CTDT
SET
    TenCTDT = N'Chương trình đào tạo Công nghệ Thông tin - Khóa 2024'
WHERE
    TenCTDT LIKE 'ChÆ°Æ¡ng trÃ¬nh Ä‘Ã o táº¡o CÃ´ng nghá»‡ ThÃ´ng tin - KhÃ³a 2024%';

UPDATE CTDT
SET
    TenCTDT = N'Chương trình đào tạo Công nghệ Thông tin - Khóa 2023'
WHERE
    TenCTDT LIKE 'ChÆ°Æ¡ng trÃ¬nh Ä‘Ã o táº¡o CÃ´ng nghá»‡ ThÃ´ng tin - KhÃ³a 2023%';

UPDATE CTDT
SET
    TenCTDT = N'Chương trình đào tạo Kỹ thuật Phần mềm - Khóa 2023'
WHERE
    TenCTDT LIKE 'ChÆ°Æ¡ng trÃ¬nh Ä‘Ã o táº¡o Ká»¹ thuáºt Pháº§n má»ƒm - KhÃ³a 2023%';

UPDATE CTDT
SET
    TenCTDT = N'Chương trình đào tạo Công nghệ Thông tin - Khóa 2022'
WHERE
    TenCTDT LIKE 'ChÆ°Æ¡ng trÃ¬nh Ä‘Ã o táº¡o CÃ´ng nghá»‡ ThÃ´ng tin - KhÃ³a 2022%';

UPDATE CTDT
SET
    TenCTDT = N'Chương trình đào tạo Kỹ thuật Phần mềm - Khóa 2022'
WHERE
    TenCTDT LIKE 'ChÆ°Æ¡ng trÃ¬nh Ä‘Ã o táº¡o Ká»¹ thuáºt Pháº§n má»ƒm - KhÃ³a 2022%';

PRINT 'Dat fix encoding complete';
GO