using System;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace EduPro.Application.Services.Implementations
{
    /// <summary>
    /// Dịch vụ nhật ký hoạt động
    /// Ghi log REAL-TIME bằng cách gọi Stored Procedures từ SQL Server
    /// </summary>
    public class ActivityLogService : IActivityLogService
    {
        private readonly string _connectionString;

        public ActivityLogService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        /// <summary>
        /// Ghi nhật ký hoạt động chung
        /// Gọi sp_GhiNhatKyHoatDong
        /// </summary>
        public async Task LogActivityAsync(string tenDangNhap, string loaiHoatDong, string moDun, string moTa, string diaChiIP, string trangThai)
        {
            try
            {
                using (var connection = new SqlConnection(_connectionString))
                {
                    await connection.OpenAsync();

                    using (var command = new SqlCommand("sp_GhiNhatKyHoatDong", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        
                        command.Parameters.AddWithValue("@TenDangNhap", tenDangNhap ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@LoaiHoatDong", loaiHoatDong ?? "VIEW");
                        command.Parameters.AddWithValue("@MoDun", moDun ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@MoTa", moTa ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@DiaChiIP", diaChiIP ?? (object)DBNull.Value);
                        command.Parameters.AddWithValue("@TrangThai", trangThai ?? "SUCCESS");

                        await command.ExecuteNonQueryAsync();
                    }
                }
            }
            catch (Exception ex)
            {
                // Log lỗi nhưng không throw để không làm gián đoạn request chính
                Console.WriteLine($"Lỗi ghi nhật ký hoạt động: {ex.Message}");
            }
        }

        /// <summary>
        /// Ghi nhật ký đăng nhập thành công
        /// Cập nhật TaiKhoan.LanDangNhapCuoi, DiaChiIPCuoi, SoLanDangNhapThatBai = 0
        /// Gọi sp_DangNhapThanhCong
        /// </summary>
        public async Task LogLoginSuccessAsync(string tenDangNhap, string diaChiIP)
        {
            try
            {
                using (var connection = new SqlConnection(_connectionString))
                {
                    await connection.OpenAsync();

                    using (var command = new SqlCommand("sp_DangNhapThanhCong", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        
                        command.Parameters.AddWithValue("@TenDangNhap", tenDangNhap);
                        command.Parameters.AddWithValue("@DiaChiIP", diaChiIP ?? "Unknown");

                        await command.ExecuteNonQueryAsync();
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi ghi nhật ký đăng nhập thành công: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Ghi nhật ký đăng nhập thất bại
        /// Tăng SoLanDangNhapThatBai, khóa tài khoản nếu >= 5 lần
        /// Gọi sp_DangNhapThatBai
        /// </summary>
        public async Task LogLoginFailureAsync(string tenDangNhap, string diaChiIP, string lyDo)
        {
            try
            {
                using (var connection = new SqlConnection(_connectionString))
                {
                    await connection.OpenAsync();

                    using (var command = new SqlCommand("sp_DangNhapThatBai", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        
                        command.Parameters.AddWithValue("@TenDangNhap", tenDangNhap);
                        command.Parameters.AddWithValue("@DiaChiIP", diaChiIP ?? "Unknown");
                        command.Parameters.AddWithValue("@LyDo", lyDo ?? "Sai mật khẩu");

                        await command.ExecuteNonQueryAsync();
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi ghi nhật ký đăng nhập thất bại: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Ghi nhật ký đăng xuất
        /// Gọi sp_DangXuat
        /// </summary>
        public async Task LogLogoutAsync(string tenDangNhap, string diaChiIP)
        {
            try
            {
                using (var connection = new SqlConnection(_connectionString))
                {
                    await connection.OpenAsync();

                    using (var command = new SqlCommand("sp_DangXuat", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        
                        command.Parameters.AddWithValue("@TenDangNhap", tenDangNhap);
                        command.Parameters.AddWithValue("@DiaChiIP", diaChiIP ?? "Unknown");

                        await command.ExecuteNonQueryAsync();
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi ghi nhật ký đăng xuất: {ex.Message}");
                // Không throw - đăng xuất vẫn thành công ngay cả khi log thất bại
            }
        }
    }
}
