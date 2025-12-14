using EduPro.Application.Admin.Services;
using EduPro.Domain.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduPro.API.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize(Roles = "ADMIN")] // Ensure only Admin access
public class AdminController : ControllerBase
{
    private readonly IAdminService _service;

    public AdminController(IAdminService service)
    {
        _service = service;
    }

    [HttpGet("users")]
    public async Task<IActionResult> GetUsers([FromQuery] string? keyword, [FromQuery] string? role, [FromQuery] int page = 1, [FromQuery] int pageSize = 20)
    {
        var result = await _service.GetUsersAsync(keyword, role, page, pageSize);
        return Ok(result);
    }

    [HttpPost("users")]
    public async Task<IActionResult> CreateUser([FromBody] CreateUserRequest request)
    {
        try
        {
            await _service.CreateUserAsync(request, GetCurrentUsername(), GetClientIpAddress());
            return Ok(new { message = "User created successfully" });
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPut("users/role")]
    public async Task<IActionResult> UpdateRole([FromBody] UpdateUserRoleRequest request)
    {
        await _service.UpdateUserRoleAsync(request, GetCurrentUsername(), GetClientIpAddress());
        return Ok(new { message = "User role updated successfully" });
    }

    [HttpPut("users/status")]
    public async Task<IActionResult> UpdateStatus([FromBody] UpdateUserStatusRequest request)
    {
        await _service.UpdateUserStatusAsync(request, GetCurrentUsername(), GetClientIpAddress());
        return Ok(new { message = "User status updated successfully" });
    }

    [HttpGet("logs")]
    public async Task<IActionResult> GetLogs([FromQuery] string? keyword, [FromQuery] DateTime? from, [FromQuery] DateTime? to, [FromQuery] string? action, [FromQuery] string? status, [FromQuery] string? module, [FromQuery] int page = 1, [FromQuery] int pageSize = 20)
    {
        var result = await _service.GetAuditLogsAsync(keyword, from, to, action, status, module, page, pageSize);
        return Ok(result);
    }

    private string GetCurrentUsername() => User.Identity?.Name ?? "System";

    private string GetClientIpAddress()
    {
        if (Request.Headers.TryGetValue("X-Forwarded-For", out var forwardedFor))
            return forwardedFor.ToString().Split(',')[0].Trim();
        return HttpContext.Connection.RemoteIpAddress?.ToString() ?? "Unknown";
    }
}
