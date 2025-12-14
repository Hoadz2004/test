using EduPro.Application.Student.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EduPro.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class StudentController : ControllerBase
{
    private readonly IStudentService _studentService;

    public StudentController(IStudentService studentService)
    {
        _studentService = studentService;
    }

    [HttpGet("profile/{studentId}")]
    public async Task<IActionResult> GetProfile(string studentId)
    {
        var profile = await _studentService.GetStudentProfileAsync(studentId);
        if (profile == null)
            return NotFound(new { message = "Student not found" });
            
        return Ok(profile);
    }
}
