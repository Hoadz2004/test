@echo off
chcp 65001 >nul
echo ========================================
echo CHAY TU DONG TAT CA SQL SCRIPTS - ORDERED
echo Server: 202.55.135.42
echo Database: EduProDb
echo ========================================
echo.

set SERVER=202.55.135.42
set DATABASE=EduProDb
set USERNAME=sa
set PASSWORD=Aa@0967941364

set STEP=0

REM ============================================
REM BUOC 1: TAO CAU TRUC SCHEMA (01_Schema)
REM ============================================
echo.
echo [BUOC 1] SCHEMA - Tao cau truc co so du lieu
echo ----------------------------------------

set /a STEP+=1
echo [%STEP%/3] Chay: Schema_GradeManagement.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "01_Schema\Schema_GradeManagement.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: Schema_StudentGrades.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "01_Schema\Schema_StudentGrades.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

REM ============================================
REM BUOC 2: CHAY CAC FIX VA MIGRATIONS (02_Fixes_Migrations)
REM ============================================
echo.
echo [BUOC 2] FIXES & MIGRATIONS - Su ly loi va cap nhat du lieu
echo ----------------------------------------

set /a STEP+=1
echo [%STEP%/3] Chay: FixSinhVienConstraint.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "02_Fixes_Migrations\FixSinhVienConstraint.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: Fix_CTDT_Encoding.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "02_Fixes_Migrations\Fix_CTDT_Encoding.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: Fix_Grade_Logic.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "02_Fixes_Migrations\Fix_Grade_Logic.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: Fix_Vietnamese_Encoding_DangKyHocPhan.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "02_Fixes_Migrations\Fix_Vietnamese_Encoding_DangKyHocPhan.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

REM ============================================
REM BUOC 3: TAO STORED PROCEDURES (03_StoredProcedures)
REM ============================================
echo.
echo [BUOC 3] STORED PROCEDURES - Tao cac ham va thu tuc
echo ----------------------------------------

set /a STEP+=1
echo [%STEP%/3] Chay: CreateStoredProcedures.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "03_StoredProcedures\CreateStoredProcedures.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: EnrollmentSPs.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "03_StoredProcedures\EnrollmentSPs.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: GradeSPs.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "03_StoredProcedures\GradeSPs.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: sp_CreateUserFull.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "03_StoredProcedures\sp_CreateUserFull.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: sp_LoginFirstLogin.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "03_StoredProcedures\sp_LoginFirstLogin.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: sp_Profile.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "03_StoredProcedures\sp_Profile.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

REM ============================================
REM BUOC 4: TAI DU LIEU MAU (04_SampleData)
REM ============================================
echo.
echo [BUOC 4] SAMPLE DATA - Tao du lieu mau test
echo ----------------------------------------

set /a STEP+=1
echo [%STEP%/3] Chay: CreateAdminAccounts.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "04_SampleData\CreateAdminAccounts.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: CreateSampleData_Enrollment.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "04_SampleData\CreateSampleData_Enrollment.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

set /a STEP+=1
echo [%STEP%/3] Chay: SampleData_LecturerGrades.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "04_SampleData\SampleData_LecturerGrades.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

REM ============================================
REM HOAN THANH
REM ============================================
echo.
echo ========================================
echo HOAN THANH! Tất cả script đã được chạy.
echo ========================================
echo.
pause
