using EduPro.Application.Appeal.Services;
using EduPro.Domain.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduPro.API.Controllers;

[Route("api/[controller]")]
[ApiController]
// [Authorize] // Temporarily disabled for testing until JWT is fixed
public class AppealController : ControllerBase
{
    private readonly IAppealService _appealService;

    public AppealController(IAppealService appealService)
    {
        _appealService = appealService;
    }

    [HttpPost("create/{studentId}")]
    public async Task<IActionResult> CreateAppeal(string studentId, [FromBody] CreateAppealDto appealDto)
    {
        try
        {
            await _appealService.CreateAppealAsync(studentId, appealDto);
            return Ok(new { Message = "Appeal created successfully" });
        }
        catch (Exception ex)
        {
            return BadRequest(new { Message = ex.Message });
        }
    }

    [HttpGet("my-appeals/{studentId}")]
    public async Task<IActionResult> GetMyAppeals(string studentId)
    {
        var result = await _appealService.GetStudentAppealsAsync(studentId);
        return Ok(result);
    }

    [HttpGet("eligible-subjects/{studentId}")]
    public async Task<IActionResult> GetEligibleSubjects(string studentId)
    {
        var result = await _appealService.GetEligibleSubjectsAsync(studentId);
        return Ok(result);
    }
}
