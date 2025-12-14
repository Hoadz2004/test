[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$connectionString = "Server=202.55.135.42;Database=EduProDb;User Id=sa;Password=Aa@0967941364;TrustServerCertificate=True;"
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

$command = $connection.CreateCommand()
$command.CommandText = "SELECT MaHP, TenHP FROM HocPhan ORDER BY MaHP;"
$reader = $command.ExecuteReader()

Write-Host "MỤC DANH SACH MON HOC (HocPhan)" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan
while ($reader.Read()) {
    $ma = $reader["MaHP"]
    $ten = $reader["TenHP"]
    Write-Host "$ma → $ten"
}

$reader.Close()
$connection.Close()
