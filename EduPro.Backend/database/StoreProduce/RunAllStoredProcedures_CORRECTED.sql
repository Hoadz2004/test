-- =============================================
-- MASTER SCRIPT: RUN ALL STORED PROCEDURES
-- Chạy tất cả stored procedures chuẩn
-- UTF-8 Encoding: Chỉ chạy file này với: sqlcmd -f 65001
-- =============================================

USE EduProDb;
GO

PRINT N'===========================================';
PRINT N'BẮT ĐẦU KHỞI TẠO STORED PROCEDURES';
PRINT N'===========================================';
GO

-- 1. Stored Procedures chính - Enrollment & Class Management
PRINT N'';
PRINT N'[1/12] Creating sp_GetEnrollmentStatus...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_GetEnrollmentStatus.sql"
GO

PRINT N'[2/12] Creating sp_GetClassManagement...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_GetClassManagement.sql"
GO

PRINT N'[3/12] Creating sp_UpdateClassStatus...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_UpdateClassStatus.sql"
GO

PRINT N'[4/12] Creating sp_GetLecturerClasses...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_GetLecturerClasses.sql"
GO

PRINT N'[5/12] Creating sp_RegisterCourse...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_RegisterCourse.sql"
GO

PRINT N'[6/12] Creating sp_CheckTienQuyet...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_CheckTienQuyet.sql"
GO

PRINT N'[7/12] Creating sp_GetStudentInfo...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_GetStudentInfo.sql"
GO

PRINT N'[8/12] Creating sp_Payment_RecalcDebt...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_Payment_RecalcDebt.sql"
GO

PRINT N'[9/12] Creating sp_Payment_Init...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_Payment_Init.sql"
GO

PRINT N'[10/12] Creating sp_Payment_Confirm & GetDebt...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_Payment_Confirm.sql"
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_Payment_GetDebt.sql"
GO

PRINT N'[11/12] Creating sp_Admissions...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_Admissions.sql"
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_Admissions_Score.sql"
GO
PRINT N'[12/12] Creating sp_Admissions_GetRequirement...';
GO
:r "d:\EduPro\EduPro.Backend\database\StoreProduce\sp_Admissions_GetRequirement.sql"
GO

-- 2. Optional: Khác (cần verify/update)
-- PRINT N'[7/7] Creating sp_Check_Conflict...';
-- GO
-- :r sp_Check_Conflict.sql
-- GO

PRINT N'';
PRINT N'===========================================';
PRINT N'✓✓✓ ALL STORED PROCEDURES CREATED!';
PRINT N'===========================================';
GO

-- =============================================
-- NOTES:
-- =============================================
-- - Chạy script này với: 
--   sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 -i RunAllStoredProcedures.sql
--
-- - Encoding: -f 65001 là UTF-8, bắt buộc cho tiếng Việt
--
-- - File Fix Encoding (không được xóa!):
--   * Fix_All_Encoding_Direct.sql
--   * Fix_Encoding_*.sql (1-6)
--   Chạy riêng khi cần fix encoding data trong database
-- =============================================
GO
