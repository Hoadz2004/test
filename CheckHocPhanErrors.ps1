[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$connectionString = "Server=202.55.135.42;Database=EduProDb;User Id=sa;Password=Aa@0967941364;TrustServerCertificate=True;"
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# Find corrupted entries
$command = $connection.CreateCommand()
$command.CommandText = @"
SELECT MaHP, TenHP FROM HocPhan 
WHERE TenHP LIKE '%Ã%' OR TenHP LIKE '%â†'%' OR TenHP LIKE '%á»%' 
   OR TenHP LIKE '%Ä%' OR TenHP LIKE '%Æ%'
ORDER BY MaHP;
"@

$reader = $command.ExecuteReader()

Write-Host "DANH SACH MON HOC CON LOI ENCODING" -ForegroundColor Red
Write-Host "===================================" -ForegroundColor Red

$count = 0
while ($reader.Read()) {
    $ma = $reader["MaHP"]
    $ten = $reader["TenHP"]
    Write-Host "$ma → $ten" -ForegroundColor Yellow
    $count++
}

if ($count -eq 0) {
    Write-Host "KHONG CO MON HOC NAO CON LOI!" -ForegroundColor Green
} else {
    Write-Host "`nTONG CONG: $count mon hoc bi loi encoding" -ForegroundColor Red
}

$reader.Close()
$connection.Close()
