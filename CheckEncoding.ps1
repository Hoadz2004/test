[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$connectionString = "Server=202.55.135.42;Database=EduProDb;User Id=sa;Password=Aa@0967941364;TrustServerCertificate=True;"
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

Write-Host "KIEM TRA ENCODING TIENG VIET" -ForegroundColor Green

# Query VaiTro
$command = $connection.CreateCommand()
$command.CommandText = "SELECT MaVaiTro, TenVaiTro FROM VaiTro ORDER BY MaVaiTro;"
$reader = $command.ExecuteReader()

Write-Host "`nBANG VAI TRO (VaiTro)" -ForegroundColor Cyan
while ($reader.Read()) {
    $ma = $reader["MaVaiTro"]
    $ten = $reader["TenVaiTro"]
    Write-Host "$ma : $ten"
}
$reader.Close()

# Query Khoa
$command = $connection.CreateCommand()
$command.CommandText = "SELECT MaKhoa, TenKhoa FROM Khoa ORDER BY MaKhoa;"
$reader = $command.ExecuteReader()

Write-Host "`nBANG KHOA" -ForegroundColor Cyan
while ($reader.Read()) {
    $ma = $reader["MaKhoa"]
    $ten = $reader["TenKhoa"]
    Write-Host "$ma : $ten"
}
$reader.Close()

# Query Nganh
$command = $connection.CreateCommand()
$command.CommandText = "SELECT MaNganh, TenNganh FROM Nganh ORDER BY MaNganh;"
$reader = $command.ExecuteReader()

Write-Host "`nBANG NGANH" -ForegroundColor Cyan
while ($reader.Read()) {
    $ma = $reader["MaNganh"]
    $ten = $reader["TenNganh"]
    Write-Host "$ma : $ten"
}
$reader.Close()

$connection.Close()
Write-Host "`nXong!" -ForegroundColor Green
