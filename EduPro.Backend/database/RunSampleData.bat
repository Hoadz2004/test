@echo off
chcp 65001 >nul
echo ========================================
echo CHAY DU LIEU MAU CHO DATABASE EduProDb
echo Server: 202.55.135.42
echo ========================================
echo.

set SERVER=202.55.135.42
set DATABASE=EduProDb
set USERNAME=sa
set PASSWORD=Aa@0967941364

echo [1/8] Chay: SampleData_01_MasterData.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "SampleData_01_MasterData.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [2/8] Chay: SampleData_02_HocPhan.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "SampleData_02_HocPhan.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [3/8] Chay: SampleData_03_Users.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "SampleData_03_Users.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [4/8] Chay: SampleData_04_Accounts.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "SampleData_04_Accounts.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [5/8] Chay: SampleData_05_Curriculum.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "SampleData_05_Curriculum.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [6/8] Chay: SampleData_06_LopHocPhan.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "SampleData_06_LopHocPhan.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [7/8] Chay: SampleData_07_Grades.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "SampleData_07_Grades.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [8/8] Chay: SampleData_08_Others.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "SampleData_08_Others.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo ========================================
echo HOAN THANH!
echo ========================================
echo.
echo TAI KHOAN DEMO:
echo   - Admin: admin / 123456
echo   - Dao tao: daotao01 / 123456
echo   - Giang vien: GV001 / 123456
echo   - Sinh vien: 2022001 / 123456
echo.
pause
