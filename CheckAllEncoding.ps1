[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$connectionString = "Server=202.55.135.42;Database=EduProDb;User Id=sa;Password=Aa@0967941364;TrustServerCertificate=True;"
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

Write-Host "`n========== KIEM TRA ENCODING DU LIEU ==========`n" -ForegroundColor Green

# 1. Check VaiTro & Quyen
$command = $connection.CreateCommand()
$command.CommandText = "SELECT MaVaiTro, TenVaiTro FROM VaiTro ORDER BY MaVaiTro;"
$reader = $command.ExecuteReader()
Write-Host "1. VAI TRO (Roles)" -ForegroundColor Cyan
while ($reader.Read()) {
    Write-Host "   $($reader['MaVaiTro']) → $($reader['TenVaiTro'])"
}
$reader.Close()

# 2. Check Khoa
$command = $connection.CreateCommand()
$command.CommandText = "SELECT MaKhoa, TenKhoa FROM Khoa ORDER BY MaKhoa;"
$reader = $command.ExecuteReader()
Write-Host "`n2. KHOA (Faculty)" -ForegroundColor Cyan
while ($reader.Read()) {
    Write-Host "   $($reader['MaKhoa']) → $($reader['TenKhoa'])"
}
$reader.Close()

# 3. Check Nganh
$command = $connection.CreateCommand()
$command.CommandText = "SELECT MaNganh, TenNganh FROM Nganh ORDER BY MaNganh;"
$reader = $command.ExecuteReader()
Write-Host "`n3. NGANH (Major)" -ForegroundColor Cyan
while ($reader.Read()) {
    Write-Host "   $($reader['MaNganh']) → $($reader['TenNganh'])"
}
$reader.Close()

# 4. Check CaHoc
$command = $connection.CreateCommand()
$command.CommandText = "SELECT MaCa, MoTa FROM CaHoc ORDER BY MaCa;"
$reader = $command.ExecuteReader()
Write-Host "`n4. CA HOC (Class Shift)" -ForegroundColor Cyan
while ($reader.Read()) {
    Write-Host "   $($reader['MaCa']) → $($reader['MoTa'])"
}
$reader.Close()

# 5. Check HocKy
$command = $connection.CreateCommand()
$command.CommandText = "SELECT TOP 5 MaHK, TenHK FROM HocKy ORDER BY MaHK;"
$reader = $command.ExecuteReader()
Write-Host "`n5. HOC KY (Semester)" -ForegroundColor Cyan
while ($reader.Read()) {
    Write-Host "   $($reader['MaHK']) → $($reader['TenHK'])"
}
$reader.Close()

# 6. Check HocPhan
$command = $connection.CreateCommand()
$command.CommandText = "SELECT TOP 10 MaHP, TenHP FROM HocPhan ORDER BY MaHP;"
$reader = $command.ExecuteReader()
Write-Host "`n6. HOC PHAN (Subject)" -ForegroundColor Cyan
while ($reader.Read()) {
    Write-Host "   $($reader['MaHP']) → $($reader['TenHP'])"
}
$reader.Close()

# 7. Check GiangVien
$command = $connection.CreateCommand()
$command.CommandText = "SELECT TOP 5 MaGV, HoTen FROM GiangVien ORDER BY MaGV;"
$reader = $command.ExecuteReader()
Write-Host "`n7. GIANG VIEN (Lecturer)" -ForegroundColor Cyan
while ($reader.Read()) {
    Write-Host "   $($reader['MaGV']) → $($reader['HoTen'])"
}
$reader.Close()

# 8. Check DangKyHocPhan - TrangThai
$command = $connection.CreateCommand()
$command.CommandText = "SELECT DISTINCT TrangThai FROM DangKyHocPhan WHERE TrangThai IS NOT NULL;"
$reader = $command.ExecuteReader()
Write-Host "`n8. DANG KY HOC PHAN - TrangThai" -ForegroundColor Cyan
if ($reader.HasRows) {
    while ($reader.Read()) {
        Write-Host "   → $($reader['TrangThai'])"
    }
} else {
    Write-Host "   (Khong co du lieu)"
}
$reader.Close()

# 9. Check Diem - KetQua
$command = $connection.CreateCommand()
$command.CommandText = "SELECT DISTINCT KetQua FROM Diem WHERE KetQua IS NOT NULL;"
$reader = $command.ExecuteReader()
Write-Host "`n9. DIEM - KetQua" -ForegroundColor Cyan
if ($reader.HasRows) {
    while ($reader.Read()) {
        Write-Host "   → $($reader['KetQua'])"
    }
} else {
    Write-Host "   (Khong co du lieu)"
}
$reader.Close()

# 10. Check PhucKhao - TrangThai
$command = $connection.CreateCommand()
$command.CommandText = "SELECT DISTINCT TrangThai FROM PhucKhao WHERE TrangThai IS NOT NULL;"
$reader = $command.ExecuteReader()
Write-Host "`n10. PHUC KHAO - TrangThai" -ForegroundColor Cyan
if ($reader.HasRows) {
    while ($reader.Read()) {
        Write-Host "   → $($reader['TrangThai'])"
    }
} else {
    Write-Host "   (Khong co du lieu)"
}
$reader.Close()

$connection.Close()
Write-Host "`n==========================================`n" -ForegroundColor Green
Write-Host "KIEM TRA XONG!" -ForegroundColor Green
