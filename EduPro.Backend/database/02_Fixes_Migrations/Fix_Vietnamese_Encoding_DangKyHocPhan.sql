-- Fix Vietnamese Encoding in StudentManagementSystem database
-- Update all wrong encoding status values to correct UTF-8 Vietnamese

-- First, check current state
SELECT DISTINCT TrangThai, COUNT(*) as Count
FROM [StudentManagementSystem].dbo.Classes
GROUP BY TrangThai
ORDER BY TrangThai;

-- Fix Classes table status (if it exists)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
           WHERE TABLE_SCHEMA = 'dbo' 
           AND TABLE_NAME = 'Classes')
BEGIN
    PRINT 'Updating Classes table...';
    -- Update any wrong encoding in Classes status
    UPDATE [StudentManagementSystem].dbo.Classes 
    SET Status = N'Đang khai giảng'
    WHERE Status LIKE N'%kÃ½%' OR Status LIKE N'%Ä%';
    
    UPDATE [StudentManagementSystem].dbo.Classes 
    SET Status = N'Sắp khai giảng'
    WHERE Status LIKE N'%SÄp%';
END

-- Verify fix
SELECT DISTINCT Status, COUNT(*) as Count
FROM [StudentManagementSystem].dbo.Classes
GROUP BY Status
ORDER BY Status;

PRINT 'Vietnamese encoding fix completed';

