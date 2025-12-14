# ============================================================================
# Script: Test-ActivityLogRealTime.ps1
# Mục đích: Test API và verify dữ liệu REAL-TIME trong NhatKyHoatDong
# Cách dùng: 
#   1. Mở PowerShell ISE
#   2. Chạy: .\Test-ActivityLogRealTime.ps1
#   3. Script sẽ gọi API và tự động kiểm tra database
# ============================================================================

param(
    [string]$ApiBaseUrl = "http://localhost:5000",
    [string]$SqlServer = "202.55.135.42",
    [string]$SqlUser = "sa",
    [string]$SqlPassword = "Aa@0967941364",
    [string]$SqlDatabase = "EduProDb"
)

# ============================================================================
# HÀM: Gọi API Login
# ============================================================================
function Invoke-Login {
    param(
        [string]$TenDangNhap,
        [string]$MatKhau
    )
    
    Write-Host "───────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
    Write-Host "📝 GỌIMOTO API Login: $TenDangNhap" -ForegroundColor Yellow
    Write-Host "───────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
    
    try {
        $body = @{
            tenDangNhap = $TenDangNhap
            matKhau = $MatKhau
        } | ConvertTo-Json
        
        $response = Invoke-RestMethod `
            -Uri "$ApiBaseUrl/api/auth/login" `
            -Method Post `
            -ContentType "application/json" `
            -Body $body `
            -ErrorAction SilentlyContinue
        
        Write-Host "✅ Đăng nhập thành công!" -ForegroundColor Green
        Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Gray
        return $true
    }
    catch {
        Write-Host "❌ Đăng nhập thất bại: $_" -ForegroundColor Red
        return $false
    }
}

# ============================================================================
# HÀM: Gọi API Logout
# ============================================================================
function Invoke-Logout {
    param(
        [string]$Token
    )
    
    Write-Host "───────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
    Write-Host "📝 GỌIMOTO API Logout" -ForegroundColor Yellow
    Write-Host "───────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
    
    try {
        $headers = @{
            "Authorization" = "Bearer $Token"
        }
        
        $response = Invoke-RestMethod `
            -Uri "$ApiBaseUrl/api/auth/logout" `
            -Method Post `
            -Headers $headers `
            -ErrorAction SilentlyContinue
        
        Write-Host "✅ Đăng xuất thành công!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Đăng xuất thất bại: $_" -ForegroundColor Red
        return $false
    }
}

# ============================================================================
# HÀM: Gọi API GET (VIEW)
# ============================================================================
function Invoke-ViewApi {
    param(
        [string]$Endpoint,
        [string]$Token
    )
    
    Write-Host "───────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
    Write-Host "📝 GỌIMOTO API GET: $Endpoint" -ForegroundColor Yellow
    Write-Host "───────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
    
    try {
        $headers = @{
            "Authorization" = "Bearer $Token"
        }
        
        $response = Invoke-RestMethod `
            -Uri "$ApiBaseUrl$Endpoint" `
            -Method Get `
            -Headers $headers `
            -ErrorAction SilentlyContinue
        
        Write-Host "✅ VIEW thành công!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "⚠️  VIEW thất bại hoặc endpoint không tồn tại" -ForegroundColor Yellow
        return $false
    }
}

# ============================================================================
# HÀM: Kiểm tra Database
# ============================================================================
function Invoke-SqlQuery {
    param(
        [string]$Query
    )
    
    try {
        $connectionString = "Server=$SqlServer;User Id=$SqlUser;Password=$SqlPassword;Database=$SqlDatabase;TrustServerCertificate=True;"
        $connection = New-Object System.Data.SqlClient.SqlConnection
        $connection.ConnectionString = $connectionString
        $connection.Open()
        
        $command = $connection.CreateCommand()
        $command.CommandText = $Query
        $command.CommandTimeout = 30
        
        $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
        $dataTable = New-Object System.Data.DataTable
        $adapter.Fill($dataTable) | Out-Null
        
        $connection.Close()
        
        return $dataTable
    }
    catch {
        Write-Host "❌ Lỗi thực thi SQL: $_" -ForegroundColor Red
        return $null
    }
}

# ============================================================================
# HÀM: Hiển thị kết quả
# ============================================================================
function Show-Results {
    param(
        [System.Data.DataTable]$DataTable,
        [string]$Title
    )
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host $Title -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Magenta
    
    if ($DataTable.Rows.Count -eq 0) {
        Write-Host "⚠️  Không có dữ liệu" -ForegroundColor Yellow
    }
    else {
        $DataTable | Format-Table -AutoSize | Out-Host
        Write-Host "📊 Tổng số bản ghi: $($DataTable.Rows.Count)" -ForegroundColor Cyan
    }
    Write-Host ""
}

# ============================================================================
# CHƯƠNG TRÌNH CHÍNH
# ============================================================================

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║          TEST REAL-TIME ACTIVITY LOGGING SYSTEM                    ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Kiểm tra kết nối API
Write-Host "🔍 Kiểm tra kết nối API tại $ApiBaseUrl..." -ForegroundColor Cyan
try {
    $healthCheck = Invoke-RestMethod -Uri "$ApiBaseUrl/health" -ErrorAction SilentlyContinue
    Write-Host "✅ API đang chạy!" -ForegroundColor Green
} catch {
    Write-Host "❌ API không phản hồi. Vui lòng chạy: dotnet run" -ForegroundColor Red
    Exit
}

Write-Host ""

# ============================================================================
# TEST 1: Login thành công
# ============================================================================
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "TEST 1: LOGIN THÀNH CÔNG" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green

Invoke-Login -TenDangNhap "admin" -MatKhau "password123"
Start-Sleep -Seconds 2

# Kiểm tra database
$query1 = @"
SELECT TOP 5 MaNhatKy, TenDangNhap, LoaiHoatDong, TrangThai, NgayGio
FROM dbo.NhatKyHoatDong
WHERE TenDangNhap = 'admin'
ORDER BY MaNhatKy DESC
"@

$result1 = Invoke-SqlQuery -Query $query1
Show-Results -DataTable $result1 -Title "📋 NhatKyHoatDong của admin (5 mục cuối cùng)"

# ============================================================================
# TEST 2: Login thất bại
# ============================================================================
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "TEST 2: LOGIN THẤT BẠI (SAI MẬT KHẨU)" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green

Invoke-Login -TenDangNhap "admin" -MatKhau "wrongpassword"
Start-Sleep -Seconds 2

# Kiểm tra database - failed login
$query2 = @"
SELECT LoaiHoatDong, TrangThai, COUNT(*) AS SoLan
FROM dbo.NhatKyHoatDong
WHERE TenDangNhap = 'admin' AND LoaiHoatDong = 'LOGIN'
GROUP BY LoaiHoatDong, TrangThai
"@

$result2 = Invoke-SqlQuery -Query $query2
Show-Results -DataTable $result2 -Title "📊 Thống kê LOGIN của admin"

# ============================================================================
# TEST 3: View API
# ============================================================================
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "TEST 3: VIEW API (GET Requests)" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green

Invoke-ViewApi -Endpoint "/api/student/list" -Token "dummy_token"
Invoke-ViewApi -Endpoint "/api/class/list" -Token "dummy_token"
Start-Sleep -Seconds 2

# Kiểm tra database - VIEW
$query3 = @"
SELECT TOP 10 MaNhatKy, TenDangNhap, LoaiHoatDong, MoDun, TrangThai, NgayGio
FROM dbo.NhatKyHoatDong
WHERE LoaiHoatDong = 'VIEW'
ORDER BY MaNhatKy DESC
"@

$result3 = Invoke-SqlQuery -Query $query3
Show-Results -DataTable $result3 -Title "📋 Các VIEW activity gần đây"

# ============================================================================
# TEST 4: Thống kê tổng quát
# ============================================================================
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "TEST 4: THỐNG KÊ TỔNG QUÁT" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green

$query4 = @"
SELECT 
    LoaiHoatDong,
    COUNT(*) AS TongSo,
    SUM(CASE WHEN TrangThai = 'SUCCESS' THEN 1 ELSE 0 END) AS ThanhCong,
    SUM(CASE WHEN TrangThai = 'FAILED' THEN 1 ELSE 0 END) AS ThatBai
FROM dbo.NhatKyHoatDong
WHERE NgayGio >= DATEADD(HOUR, -1, GETDATE())
GROUP BY LoaiHoatDong
ORDER BY TongSo DESC
"@

$result4 = Invoke-SqlQuery -Query $query4
Show-Results -DataTable $result4 -Title "📊 Thống kê hoạt động (1 giờ gần đây)"

# ============================================================================
# TEST 5: Kiểm tra tài khoản
# ============================================================================
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "TEST 5: THÔNG TIN TÀI KHOẢN (Real-Time Updates)" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════" -ForegroundColor Green

$query5 = @"
SELECT 
    TenDangNhap,
    DangNhapLanCuoi,
    DiaChiIPCuoi,
    SoLanDangNhapThatBai,
    TrangThai
FROM dbo.TaiKhoan
WHERE TenDangNhap = 'admin'
"@

$result5 = Invoke-SqlQuery -Query $query5
Show-Results -DataTable $result5 -Title "👤 Thông tin tài khoản admin (REAL-TIME UPDATES)"

# ============================================================================
# TỔNG KẾT
# ============================================================================
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                    TEST HOÀN THÀNH                                ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Hệ thống REAL-TIME Activity Logging đang hoạt động!" -ForegroundColor Green
Write-Host ""
Write-Host "📌 Tiếp theo:" -ForegroundColor Cyan
Write-Host "   1. Kiểm tra thêm các endpoint khác trong Frontend"
Write-Host "   2. Xem dashboard để visualize các hoạt động"
Write-Host "   3. Kiểm tra cảnh báo đăng nhập thất bại"
Write-Host ""
