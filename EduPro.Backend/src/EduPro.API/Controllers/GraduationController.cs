using EduPro.Application.Graduation.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduPro.API.Controllers;

[Route("api/[controller]")]
[ApiController]
// [Authorize] // Temporarily disabled for testing
public class GraduationController : ControllerBase
{
    private readonly IGraduationService _graduationService;

    public GraduationController(IGraduationService graduationService)
    {
        _graduationService = graduationService;
    }

    [HttpGet("check-status/{studentId}")]
    public async Task<IActionResult> CheckStatus(string studentId)
    {
        var result = await _graduationService.GetGraduationResultAsync(studentId);
        if (result == null)
        {
            return Ok(new { Message = "Chưa xét tốt nghiệp" });
        }
        return Ok(result);
    }
}
