using EduPro.Application.Auth.Dtos;
using EduPro.Application.Auth.Services;
using EduPro.Application.Services;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduPro.API.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly IActivityLogService _activityLogService;

    public AuthController(IAuthService authService, IActivityLogService activityLogService)
    {
        _authService = authService;
        _activityLogService = activityLogService;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var tenDangNhap = request?.Username ?? "Unknown";
        var ipAddress = GetClientIpAddress();

        try
        {
            // Kiểm tra thông tin đăng nhập
            var result = await _authService.LoginAsync(request, ipAddress);
            if (result == null)
            {
                await _activityLogService.LogLoginFailureAsync(tenDangNhap, ipAddress, "Invalid credentials");
                return Unauthorized(new { message = "Invalid credentials or account locked" });
            }

            // ✅ Set Claims để request tiếp theo biết user là ai
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, tenDangNhap),
                new Claim(ClaimTypes.Name, tenDangNhap)
            };
            
            var identity = new ClaimsIdentity(claims, "Bearer");
            var principal = new ClaimsPrincipal(identity);
            HttpContext.User = principal;

            await _activityLogService.LogLoginSuccessAsync(tenDangNhap, ipAddress);

            return Ok(new { 
                message = "Login successful",
                username = tenDangNhap,
                data = result 
            });
        }
        catch (Exception ex)
        {
            // Catch Account Locked exception
            if (ex.Message.Contains("locked"))
            {
                await _activityLogService.LogLoginFailureAsync(tenDangNhap, ipAddress, "Account locked");
                return StatusCode(403, new { message = ex.Message });
            }
            await _activityLogService.LogLoginFailureAsync(tenDangNhap, ipAddress, "Server error");
            return StatusCode(500, new { message = "Server error: " + ex.Message });
        }
    }

    [HttpPost("logout")]
    public async Task<IActionResult> Logout()
    {
        try
        {
            // Extract token from header
            var token = Request.Headers["Authorization"].FirstOrDefault()?.Split(" ").Last();
            var username = HttpContext.User?.Identity?.Name ?? "Unknown";
            var ipAddress = GetClientIpAddress();
            
            if (!string.IsNullOrEmpty(token))
            {
                await _authService.LogoutAsync(token);
            }

            await _activityLogService.LogLogoutAsync(username, ipAddress);

            return Ok(new { message = "Logout successful" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "Logout error" });
        }
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
