using System;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using EduPro.Application.Services;

namespace EduPro.API.Services
{
    /// <summary>
    /// Dịch vụ nhật ký hoạt động
    /// Ghi log REAL-TIME bằng cách gọi Stored Procedures từ SQL Server
    /// </summary>
    public class ActivityLogService : IActivityLogService
    {
        private readonly string _connectionString;

        public ActivityLogService(string connectionString)
        {
            _connectionString = connectionString;
        }

        /// <summary>
        /// Ghi nhật ký hoạt động chung
        /// Gọi sp_GhiNhatKyHoatDong
        /// </summary>
        public async Task LogActivityAsync(string tenDangNhap, string loaiHoatDong, string moDun, string moTa, string diaChiIP, string trangThai)
        {
            try
            {
                if (string.IsNullOrEmpty(tenDangNhap) || tenDangNhap == "Anonymous") return;
                await InsertAuditLogAsync(loaiHoatDong ?? "VIEW", moDun ?? "General", tenDangNhap, null, moTa, tenDangNhap, diaChiIP, trangThai ?? "SUCCESS");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi ghi nhật ký hoạt động: {ex.Message}");
            }
        }

        public async Task LogLoginSuccessAsync(string tenDangNhap, string diaChiIP)
        {
            try
            {
                await InsertAuditLogAsync("LOGIN", "Auth", tenDangNhap, null, "Đăng nhập hệ thống", tenDangNhap, diaChiIP, "SUCCESS");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi ghi nhật ký đăng nhập thành công: {ex.Message}");
                throw;
            }
        }

        public async Task LogLoginFailureAsync(string tenDangNhap, string diaChiIP, string lyDo)
        {
            try
            {
                await InsertAuditLogAsync("LOGIN", "Auth", tenDangNhap, null, $"Đăng nhập thất bại: {lyDo ?? "Sai mật khẩu"}", tenDangNhap, diaChiIP, "FAILED");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi ghi nhật ký đăng nhập thất bại: {ex.Message}");
                throw;
            }
        }

        public async Task LogLogoutAsync(string tenDangNhap, string diaChiIP)
        {
            try
            {
                await InsertAuditLogAsync("LOGOUT", "Auth", tenDangNhap, null, "Đăng xuất", tenDangNhap, diaChiIP, "SUCCESS");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi ghi nhật ký đăng xuất: {ex.Message}");
            }
        }

        private async Task InsertAuditLogAsync(string action, string module, string entityId, string? oldValue, string? newValue, string performedBy, string? ipAddress, string status)
        {
            using var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync();

            using var command = new SqlCommand(@"
                INSERT INTO AuditLog (Action, EntityTable, EntityId, OldValue, NewValue, PerformedBy, IPAddress, Status, Module, Timestamp)
                VALUES (@Action, @EntityTable, @EntityId, @OldValue, @NewValue, @PerformedBy, @IPAddress, @Status, @Module, GETDATE());
            ", connection);

            command.Parameters.AddWithValue("@Action", action);
            command.Parameters.AddWithValue("@EntityTable", module);
            command.Parameters.AddWithValue("@EntityId", entityId ?? (object)DBNull.Value);
            command.Parameters.AddWithValue("@OldValue", (object?)oldValue ?? DBNull.Value);
            command.Parameters.AddWithValue("@NewValue", (object?)newValue ?? DBNull.Value);
            command.Parameters.AddWithValue("@PerformedBy", performedBy ?? "Unknown");
            command.Parameters.AddWithValue("@IPAddress", (object?)ipAddress ?? DBNull.Value);
            command.Parameters.AddWithValue("@Status", status ?? "SUCCESS");
            command.Parameters.AddWithValue("@Module", module ?? (object)DBNull.Value);

            await command.ExecuteNonQueryAsync();
        }
    }
}
