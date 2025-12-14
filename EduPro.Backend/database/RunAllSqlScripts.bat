@echo off
chcp 65001 >nul
echo ========================================
echo Bat dau chay SQL Scripts cho EduProDb
echo Server: 202.55.135.42
echo Database: EduProDb
echo ========================================
echo.

set SERVER=202.55.135.42
set DATABASE=EduProDb
set USERNAME=sa
set PASSWORD=Aa@0967941364

echo [1/12] Chay: 1. Bang danh muc ^& nguoi dung.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "1. Bảng danh mục & người dùng.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [2/12] Chay: 2. Tai khoan ^& phan quyen.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "2. Tài khoản & phân quyền.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [3/12] Chay: 3. Chuong trinh dao tao ^& tien quyet.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "3. Chương trình đào tạo & tiên quyết.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [4/12] Chay: 4. Ke hoach dao tao – Lop hoc phan – Dang ky.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "4. Kế hoạch đào tạo – Lớp học phần – Đăng ký.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [5/12] Chay: 5. Diem, phuc khao, tot nghiep.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "5. Điểm, phúc khảo, tốt nghiệp.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [6/12] Chay: 6. Thong bao ^& log.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "6. Thông báo & log.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [7/12] Chay: 10. MEDIUM - Bo sung truong can thiet.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "10. MEDIUM - Bổ sung trường cần thiết.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [8/12] Chay: 11. MEDIUM - Bo sung bang cho 3 module da de xuat.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "11. MEDIUM - Bổ sung bảng cho 3 module đã đề xuất.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [9/12] Chay: 12. LOW - Van de nho ve data type.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "12. LOW - Vấn đề nhỏ về data type.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [10/12] Chay: 8. IMPORTANT - Thieu UNIQUE constraints.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "8. IMPORTANT - Thiếu UNIQUE constraints.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [11/12] Chay: 9. IMPORTANT - Thieu CHECK constraints.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "9. IMPORTANT - Thiếu CHECK constraints.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo [12/12] Chay: 7. CRITICAL - Thieu Index de toi uu performance.sql
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -i "7. CRITICAL - Thiếu Index để tối ưu performance.sql" -C
if %ERRORLEVEL% NEQ 0 (echo   X Loi!) else (echo   OK Thanh cong!)
echo.

echo ========================================
echo HOAN THANH!
echo ========================================
pause
