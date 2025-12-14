# Test Real-Time Activity Logging
Write-Host "=== Testing Real-Time Activity Logging ===" -ForegroundColor Green
Write-Host "API URL: http://localhost:5265" -ForegroundColor Yellow
Write-Host ""

# Goi Login API  
Write-Host ">>> Calling Login API with admin account..." -ForegroundColor Cyan
$loginBody = @{
    tenDangNhap = "admin"
    matKhau = "password"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:5265/api/Auth/login" `
        -Method Post -ContentType "application/json" -Body $loginBody `
        -ErrorAction SilentlyContinue
    Write-Host "[OK] Response: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Login response: $_" -ForegroundColor Yellow
}

Start-Sleep -Seconds 2

# Goi mot so API khac
Write-Host ""
Write-Host ">>> Calling other APIs..." -ForegroundColor Cyan
try {
    Invoke-RestMethod -Uri "http://localhost:5265/api/Class" -Method Get -ErrorAction SilentlyContinue | Out-Null
    Write-Host "[OK] Called /api/Class" -ForegroundColor Green
} catch { }

Start-Sleep -Seconds 1

# Kiem tra database
Write-Host ""
Write-Host ">>> Checking NhatKyHoatDong for new records..." -ForegroundColor Cyan
Write-Host ""

sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 `
  -Q "SELECT COUNT(*) AS 'Total Records' FROM dbo.NhatKyHoatDong; SELECT TOP 15 MaNhatKy, TenDangNhap, LoaiHoatDong, MoDun, NgayGio FROM dbo.NhatKyHoatDong ORDER BY MaNhatKy DESC;"

Write-Host ""
Write-Host "[OK] Check complete!" -ForegroundColor Green
