[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$connectionString = "Server=202.55.135.42;Database=EduProDb;User Id=sa;Password=Aa@0967941364;TrustServerCertificate=True;"
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

$updates = @(
    @("GV006", "ThS. Vũ Thị Phương"),
    @("GV007", "TS. Đặng Minh Giang"),
    @("GV008", "ThS. Bùi Thị Hà"),
    @("GV009", "TS. Ngô Văn Khánh"),
    @("GV010", "ThS. Phan Thái Lan")
)

foreach ($update in $updates) {
    $maGV = $update[0]
    $hoTen = $update[1]
    
    $command = $connection.CreateCommand()
    $command.CommandText = "UPDATE GiangVien SET HoTen = @HoTen WHERE MaGV = @MaGV"
    $command.Parameters.AddWithValue("@HoTen", $hoTen)
    $command.Parameters.AddWithValue("@MaGV", $maGV)
    
    $result = $command.ExecuteNonQuery()
    Write-Host "Fixed: $maGV → $hoTen"
}

Write-Host "`nXem lai danh sach:" -ForegroundColor Cyan
$command = $connection.CreateCommand()
$command.CommandText = "SELECT MaGV, HoTen FROM GiangVien ORDER BY MaGV"
$reader = $command.ExecuteReader()

while ($reader.Read()) {
    $ma = $reader["MaGV"]
    $ten = $reader["HoTen"]
    Write-Host "$ma → $ten"
}

$reader.Close()
$connection.Close()
