using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using EduPro.Application.Services;

namespace EduPro.API.Middleware
{
    /// <summary>
    /// Middleware ghi nhật ký hoạt động REAL-TIME cho mọi request.
    /// Ghi DB qua service/fallback SQL và đẩy sự kiện qua SignalR.
    /// </summary>
    public class ActivityLogMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IServiceProvider _serviceProvider;
        private readonly DirectSqlActivityLogger _directLogger;

        public ActivityLogMiddleware(RequestDelegate next, IServiceProvider serviceProvider, IConfiguration configuration)
        {
            _next = next;
            _serviceProvider = serviceProvider;

            var connectionString = configuration.GetConnectionString("DefaultConnection");
            _directLogger = new DirectSqlActivityLogger(connectionString);
        }

        public async Task InvokeAsync(HttpContext context)
        {
            if (context.Request.Path.StartsWithSegments("/health") ||
                context.Request.Path.StartsWithSegments("/api/health"))
            {
                await _next(context);
                return;
            }

            try
            {
                var method = context.Request.Method;
                var path = context.Request.Path.Value;
                var ipAddress = GetClientIpAddress(context);

                string tenDangNhap = context.User?.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value
                    ?? context.User?.FindFirst("nameid")?.Value
                    ?? context.User?.Identity?.Name
                    ?? "Anonymous";

                if ((tenDangNhap == "Anonymous" || string.IsNullOrEmpty(tenDangNhap)) &&
                    path.Contains("login", StringComparison.OrdinalIgnoreCase))
                {
                    tenDangNhap = ExtractUsernameFromRequest(context) ?? "Anonymous";
                }

                await _next(context);

                await LogActivityAsync(context, tenDangNhap, method, path, ipAddress);
            }
            catch (Exception ex)
            {
                using (var scope = _serviceProvider.CreateScope())
                {
                    var activityLogService = scope.ServiceProvider.GetRequiredService<IActivityLogService>();

                    var tenDangNhap = context.User?.Identity?.Name ?? "Anonymous";
                    var ipAddress = GetClientIpAddress(context);

                    await activityLogService.LogActivityAsync(
                        tenDangNhap,
                        "ERROR",
                        context.Request.Path.Value,
                        $"Lỗi: {ex.Message}",
                        ipAddress,
                        "ERROR"
                    );
                }
                throw;
            }
        }

        private async Task LogActivityAsync(HttpContext context, string tenDangNhap, string method, string path, string ipAddress)
        {
            if (string.IsNullOrEmpty(tenDangNhap) || tenDangNhap == "Anonymous")
            {
                tenDangNhap = ExtractUsernameFromRequest(context) ?? "Anonymous";
            }

            if (path.Contains("swagger") || path.Contains("health") || path.Contains("api-docs"))
                return;

            var loaiHoatDong = DetermineActivityType(method, path);
            var moTa = GenerateDescription(method, path, context.Response.StatusCode);
            var trangThai = context.Response.StatusCode >= 200 && context.Response.StatusCode < 400 ? "SUCCESS" : "FAILED";
            var timestamp = DateTime.UtcNow;

            try
            {
                using (var scope = _serviceProvider.CreateScope())
                {
                    try
                    {
                        var activityLogService = scope.ServiceProvider.GetRequiredService<IActivityLogService>();
                        await activityLogService.LogActivityAsync(tenDangNhap, loaiHoatDong, path, moTa, ipAddress, trangThai);
                    }
                    catch
                    {
                        await _directLogger.LogActivityDirectAsync(tenDangNhap, loaiHoatDong, path, moTa, ipAddress, trangThai);
                    }
                }
            }
            catch (Exception exDirect)
            {
                Console.WriteLine($"Ghi log thất bại: {exDirect.Message}");
            }
        }

        private string ExtractUsernameFromRequest(HttpContext context)
        {
            try
            {
                if (context.Request.Path.Value.Contains("login"))
                {
                    context.Request.EnableBuffering();
                    var reader = new System.IO.StreamReader(context.Request.Body);
                    var body = reader.ReadToEndAsync().Result;

                    if (body.Contains("\"username\""))
                    {
                        var startIdx = body.IndexOf("\"username\"");
                        var valueStart = body.IndexOf("\"", startIdx + 10) + 1;
                        var valueEnd = body.IndexOf("\"", valueStart);
                        if (valueStart > 0 && valueEnd > valueStart)
                        {
                            var username = body.Substring(valueStart, valueEnd - valueStart);
                            context.Request.Body.Position = 0;
                            return username;
                        }
                    }
                    if (body.Contains("\"tenDangNhap\""))
                    {
                        var startIdx = body.IndexOf("\"tenDangNhap\"");
                        var valueStart = body.IndexOf("\"", startIdx + 13) + 1;
                        var valueEnd = body.IndexOf("\"", valueStart);
                        if (valueStart > 0 && valueEnd > valueStart)
                        {
                            var username = body.Substring(valueStart, valueEnd - valueStart);
                            context.Request.Body.Position = 0;
                            return username;
                        }
                    }
                    context.Request.Body.Position = 0;
                }
            }
            catch { }
            return null;
        }

        private string DetermineActivityType(string method, string path)
        {
            path = path.ToLower();

            if (path.Contains("/auth/login"))
                return "LOGIN";

            if (path.Contains("/auth/logout"))
                return "LOGOUT";

            if (method == "GET")
                return "VIEW";

            if (method == "POST" && !path.Contains("/auth"))
                return "CREATE";

            if (method == "PUT" || method == "PATCH")
                return "UPDATE";

            if (method == "DELETE")
                return "DELETE";

            return "VIEW";
        }

        private string GenerateDescription(string method, string path, int statusCode)
        {
            var resource = ExtractResourceFromPath(path);

            return method switch
            {
                "GET" => $"Xem {resource}",
                "POST" => $"Tạo mới {resource}",
                "PUT" => $"Cập nhật {resource}",
                "PATCH" => $"Sửa {resource}",
                "DELETE" => $"Xóa {resource}",
                _ => $"{method} {path}"
            };
        }

        private string ExtractResourceFromPath(string path)
        {
            var segments = path.Split('/').Where(s => !string.IsNullOrEmpty(s)).ToList();
            if (segments.Count >= 2)
                return segments[^1];

            return path;
        }

        private string GetClientIpAddress(HttpContext context)
        {
            if (context.Request.Headers.TryGetValue("X-Forwarded-For", out var forwardedFor))
                return forwardedFor.ToString().Split(',')[0].Trim();

            if (context.Request.Headers.TryGetValue("CF-Connecting-IP", out var cfConnectingIp))
                return cfConnectingIp.ToString();

            return context.Connection.RemoteIpAddress?.ToString() ?? "Unknown";
        }

       
    }
}
