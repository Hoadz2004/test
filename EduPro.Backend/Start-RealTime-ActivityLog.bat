@echo off
REM ============================================================================
REM Script: Start-RealTime-ActivityLog.bat
REM Mục đích: Start API server và tự động kiểm tra real-time activity log
REM ============================================================================

echo.
echo ╔════════════════════════════════════════════════════════════════════╗
echo ║     START REAL-TIME ACTIVITY LOGGING SYSTEM                        ║
echo ╚════════════════════════════════════════════════════════════════════╝
echo.

REM Kiểm tra nếu API đang chạy
tasklist | find /i "dotnet" >nul
if not errorlevel 1 (
    echo ⚠️  API server đang chạy. Hãy dừng bằng Ctrl+C
    echo.
)

REM Vào thư mục API
cd /d "d:\EduPro\EduPro.Backend\src\EduPro.API"

REM Build
echo 🔨 Building API...
dotnet build

REM Run
echo.
echo 🚀 Starting API server...
echo.
echo ==========================================
echo ✅ API đang chạy trên http://localhost:5000
echo ==========================================
echo.
echo 📝 Trong một cửa sổ PowerShell khác, chạy:
echo    cd d:\EduPro\EduPro.Backend
echo    .\Test-ActivityLogRealTime.ps1
echo.
echo 💡 Hoặc gọi API bằng Postman:
echo    POST http://localhost:5000/api/auth/login
echo    GET http://localhost:5000/api/student/list
echo.
echo ⏸️  Nhấn Ctrl+C để dừng server
echo.

REM Run API
dotnet run
