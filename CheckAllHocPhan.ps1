[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$connectionString = "Server=202.55.135.42;Database=EduProDb;User Id=sa;Password=Aa@0967941364;TrustServerCertificate=True;"
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

$command = $connection.CreateCommand()
$command.CommandText = "SELECT COUNT(*) as Total FROM HocPhan;"
$total = $command.ExecuteScalar()

Write-Host "TONG SO MON HOC: $total" -ForegroundColor Cyan

$command = $connection.CreateCommand()
$command.CommandText = "SELECT MaHP, TenHP FROM HocPhan ORDER BY MaHP;"
$reader = $command.ExecuteReader()

Write-Host "`nDANH SACH TOAN BO MON HOC:" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

$errorCount = 0
while ($reader.Read()) {
    $ma = $reader["MaHP"]
    $ten = $reader["TenHP"]
    
    # Check if text contains encoding errors
    if ($ten -match '[\u0080-\u009F\u00AD\u0091-\u009F]' -or $ten -like '*Ã*' -or $ten -like '*á»*' -or $ten -like '*Ä*' -or $ten -like '*Æ*') {
        Write-Host "$ma → $ten" -ForegroundColor Red
        $errorCount++
    } else {
        Write-Host "$ma → $ten"
    }
}

Write-Host "`n=========================" -ForegroundColor Cyan
if ($errorCount -eq 0) {
    Write-Host "✓ TOAN BO MON HOC DANG CHUAN!" -ForegroundColor Green
} else {
    Write-Host "⚠ CON $errorCount MON HOC BI LOI" -ForegroundColor Red
}

$reader.Close()
$connection.Close()
