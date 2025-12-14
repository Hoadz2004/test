@echo off
chcp 65001 >nul
echo ========================================
echo CHAY TOAN BO SAMPLE DATA - EduProDb1
echo Server: 202.55.135.42
echo Database: EduProDb1
echo Encoding: UTF-8 (65001)
echo ========================================
echo.

set SERVER=202.55.135.42
set DATABASE=EduProDb1
set USERNAME=sa
set PASSWORD=Aa@0967941364

REM ==========================================
REM BUOC 1: MASTER DATA
REM ==========================================
echo [BUOC 1] Master Data - Khoa, Nganh, Nam Hoc, Hoc Ky
echo ----------------------------------------
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_01_MasterData.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file 01!) else (echo   OK Thanh cong!)
echo.

REM ==========================================
REM BUOC 2: HOC PHAN
REM ==========================================
echo [BUOC 2] Hoc Phan - Danh sach mon hoc
echo ----------------------------------------
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_02_HocPhan.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file 02!) else (echo   OK Thanh cong!)
echo.

REM ==========================================
REM BUOC 3: USERS & ACCOUNTS
REM ==========================================
echo [BUOC 3] Users & Accounts - Sinh vien, Giang vien, Tai khoan
echo ----------------------------------------
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_03_Users_Fixed.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file 03!) else (echo   OK Thanh cong!)
echo.

REM ==========================================
REM BUOC 4: ADMIN & ACCOUNTS SUPPLEMENT
REM ==========================================
echo [BUOC 4] Admin Accounts - Tai khoan dac biet
echo ----------------------------------------
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\CreateAdminAccounts.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file Admin!) else (echo   OK Thanh cong!)
echo.

sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_04_Accounts_Supplement.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file 04 Supplement!) else (echo   OK Thanh cong!)
echo.

REM ==========================================
REM BUOC 5: ACTIVITY LOG & CURRICULUM
REM ==========================================
echo [BUOC 5] Activity Log va Curriculum
echo ----------------------------------------
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_05_ActivityLog_InitData.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file 05 ActivityLog!) else (echo   OK Thanh cong!)
echo.

sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_05_Curriculum.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file 05 Curriculum!) else (echo   OK Thanh cong!)
echo.

REM ==========================================
REM BUOC 6: LOP HOC PHAN
REM ==========================================
echo [BUOC 6] Lop Hoc Phan - Lop hoc phan cua giang vien
echo ----------------------------------------
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_06_LopHocPhan.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file 06!) else (echo   OK Thanh cong!)
echo.

REM ==========================================
REM BUOC 7: ENROLLMENT & GRADES
REM ==========================================
echo [BUOC 7] Dang ky hoc phan va Diem
echo ----------------------------------------
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\CreateSampleData_Enrollment.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file Enrollment!) else (echo   OK Thanh cong!)
echo.

sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_07_Grades.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file 07!) else (echo   OK Thanh cong!)
echo.

REM ==========================================
REM BUOC 8: OTHER DATA
REM ==========================================
echo [BUOC 8] Du lieu khac - Thong bao, Log, v.v.
echo ----------------------------------------
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_08_Others.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file 08!) else (echo   OK Thanh cong!)
echo.

REM ==========================================
REM BUOC 9: PAYMENT DATA
REM ==========================================
echo [BUOC 9] Payment - Hoc phi va thanh toan
echo ----------------------------------------
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_09_Payment.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file 09!) else (echo   OK Thanh cong!)
echo.

REM ==========================================
REM THEM: LECTURER GRADES
REM ==========================================
echo [THEM] Diem giang vien (Teacher Grades)
echo ----------------------------------------
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -f 65001 -i "04_SampleData\SampleData_LecturerGrades.sql"
if %ERRORLEVEL% NEQ 0 (echo   X LOI tren file LecturerGrades!) else (echo   OK Thanh cong!)
echo.

REM ==========================================
REM HOAN THANH
REM ==========================================
echo.
echo ========================================
echo HOAN THANH! Tat ca du lieu da duoc tai
echo ========================================
echo.
echo Kiem tra:
echo 1. Dang nhap backend vs password 'admin' / '123456'
echo 2. Kiem tra du lieu sinh vien, giang vien
echo 3. Test enrollment va diem
echo.
pause
