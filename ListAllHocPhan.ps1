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

Write-Host "`nDANH SACH MON HOC:" -ForegroundColor Cyan
Write-Host "=================" -ForegroundColor Cyan

$errorCount = 0
while ($reader.Read()) {
    $ma = $reader["MaHP"]
    $ten = $reader["TenHP"]
    Write-Host "$ma → $ten"
}

$reader.Close()
$connection.Close()
Write-Host "`nXong!" -ForegroundColor Green
