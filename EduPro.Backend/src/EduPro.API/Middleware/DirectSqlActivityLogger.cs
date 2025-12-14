using System;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;

namespace EduPro.API.Middleware
{
    /// <summary>
    /// Simple Direct SQL Activity Logger - Ghi log trực tiếp vào SQL Server
    /// Không phụ thuộc vào DI hoặc Service - chỉ dùng SQL connection string
    /// </summary>
    public class DirectSqlActivityLogger
    {
        private readonly string _connectionString;

        public DirectSqlActivityLogger(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task LogActivityDirectAsync(string tenDangNhap, string loaiHoatDong, string moDun, string moTa, string diaChiIP, string trangThai)
        {
            try
            {
                // Bỏ qua "Anonymous" - chỉ ghi log cho user thực tế
                if (string.IsNullOrEmpty(tenDangNhap) || tenDangNhap == "Anonymous")
                {
                    Console.WriteLine($"⏭️  Skipped logging for Anonymous user");
                    return;
                }

                using (var connection = new SqlConnection(_connectionString))
                {
                    await connection.OpenAsync();

                    // Ghi log trực tiếp bằng INSERT vào NhatKyHoatDong
                    var query = @"
INSERT INTO dbo.NhatKyHoatDong (TenDangNhap, LoaiHoatDong, MoDun, MoTa, DiaChiIP, TrangThai, NgayGio)
VALUES (@TenDangNhap, @LoaiHoatDong, @MoDun, @MoTa, @DiaChiIP, @TrangThai, GETDATE())
";

                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@TenDangNhap", tenDangNhap ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@LoaiHoatDong", loaiHoatDong ?? "VIEW");
                        command.Parameters.AddWithValue("@MoDun", moDun ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@MoTa", moTa ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@DiaChiIP", diaChiIP ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@TrangThai", trangThai ?? "SUCCESS");

                        int rowsAffected = await command.ExecuteNonQueryAsync();
                        Console.WriteLine($"✅ [Direct SQL] Logged: {tenDangNhap} - {loaiHoatDong} - {moDun}");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Lỗi ghi log trực tiếp: {ex.Message}");
            }
        }
    }
}
