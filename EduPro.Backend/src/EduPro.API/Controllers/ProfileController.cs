using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace EduPro.API.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize]
public class ProfileController : ControllerBase
{
    private readonly ISqlConnectionFactory _connectionFactory;
    private readonly IActivityLogService _activityLogService;

    public ProfileController(ISqlConnectionFactory connectionFactory, IActivityLogService activityLogService)
    {
        _connectionFactory = connectionFactory;
        _activityLogService = activityLogService;
    }

    [HttpPost("change-password")]
    public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequest request)
    {
        try
        {
            var username = User.FindFirst(ClaimTypes.Name)?.Value ?? User.Identity?.Name;
            if (string.IsNullOrEmpty(username))
                return Unauthorized(new { message = "User not authenticated" });

            var oldHash = HashPassword(request.OldPassword);
            var newHash = HashPassword(request.NewPassword);

            using var connection = _connectionFactory.CreateConnection();
            await connection.ExecuteAsync(
                "sp_DoiMatKhau",
                new { TenDangNhap = username, MatKhauCuHash = oldHash, MatKhauMoiHash = newHash },
                commandType: CommandType.StoredProcedure
            );

            await _activityLogService.LogActivityAsync(username, "CHANGE_PASSWORD", "Auth", "Đổi mật khẩu thành công", GetClientIpAddress(), "SUCCESS");
            return Ok(new { message = "Đổi mật khẩu thành công!" });
        }
        catch (Exception ex)
        {
            var username = User.FindFirst(ClaimTypes.Name)?.Value ?? User.Identity?.Name ?? "Unknown";
            await _activityLogService.LogActivityAsync(username, "CHANGE_PASSWORD", "Auth", $"Đổi mật khẩu thất bại: {ex.Message}", GetClientIpAddress(), "FAILED");
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet("my-profile")]
    public async Task<IActionResult> GetMyProfile()
    {
        try
        {
            var maSV = User.FindFirst("MaSV")?.Value;
            if (string.IsNullOrEmpty(maSV))
                return BadRequest(new { message = "Chỉ sinh viên mới có profile" });

            using var connection = _connectionFactory.CreateConnection();
            var profile = await connection.QueryFirstOrDefaultAsync<SinhVienProfileDto>(
                "sp_GetSinhVienProfile",
                new { MaSV = maSV },
                commandType: CommandType.StoredProcedure
            );

            if (profile == null)
                return NotFound(new { message = "Không tìm thấy profile" });

            return Ok(profile);
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPut("update")]
    public async Task<IActionResult> UpdateProfile([FromBody] UpdateProfileRequest request)
    {
        try
        {
            var maSV = User.FindFirst("MaSV")?.Value;
            if (string.IsNullOrEmpty(maSV))
                return BadRequest(new { message = "Chỉ sinh viên mới có thể cập nhật profile" });

            using var connection = _connectionFactory.CreateConnection();
            await connection.ExecuteAsync(
                "sp_UpdateSinhVienProfile",
                new { 
                    MaSV = maSV, 
                    request.Email, 
                    request.DienThoai, 
                    request.DiaChi,
                    request.NgaySinh,
                    request.GioiTinh
                },
                commandType: CommandType.StoredProcedure
            );

            return Ok(new { message = "Cập nhật profile thành công!" });
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    private byte[] HashPassword(string password)
    {
        using var sha256 = SHA256.Create();
        return sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
    }

    private string GetClientIpAddress()
    {
        if (Request.Headers.TryGetValue("X-Forwarded-For", out var forwardedFor))
            return forwardedFor.ToString().Split(',')[0].Trim();

        if (Request.Headers.TryGetValue("CF-Connecting-IP", out var cfConnectingIp))
            return cfConnectingIp.ToString();

        return HttpContext.Connection.RemoteIpAddress?.ToString() ?? "Unknown";
    }
}
