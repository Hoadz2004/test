using EduPro.Application.Lecturer.Services;
using Microsoft.AspNetCore.Mvc;

namespace EduPro.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class LecturerController : ControllerBase
{
    private readonly ILecturerService _lecturerService;

    public LecturerController(ILecturerService lecturerService)
    {
        _lecturerService = lecturerService;
    }

    [HttpGet("list")]
    public async Task<IActionResult> GetLecturers([FromQuery] string? facultyId)
    {
        var result = await _lecturerService.GetLecturersByFacultyAsync(facultyId);
        return Ok(result);
    }

    [HttpGet("profile/{lecturerId}")]
    public async Task<IActionResult> GetProfile(string lecturerId)
    {
        var profile = await _lecturerService.GetLecturerProfileAsync(lecturerId);
        if (profile == null)
            return NotFound(new { message = "Lecturer not found" });
            
        return Ok(profile);
    }
}
