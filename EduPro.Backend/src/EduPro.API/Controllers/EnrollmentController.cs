using EduPro.Domain.Dtos;
using EduPro.Application.Enrollment.Services;
using Microsoft.AspNetCore.Mvc;

namespace EduPro.API.Controllers;

[Route("api/[controller]")]
[ApiController]
public class EnrollmentController : ControllerBase
{
    private readonly IEnrollmentService _service;

    public EnrollmentController(IEnrollmentService service)
    {
        _service = service;
    }

    [HttpGet("open-courses")]
    public async Task<IActionResult> GetOpenCourses([FromQuery] string? maNam, [FromQuery] string? maHK)
    {
        var result = await _service.GetOpenCoursesAsync(maNam, maHK);
        return Ok(result);
    }

    [HttpGet("my-courses/{studentId}")]
    public async Task<IActionResult> GetMyCourses(string studentId)
    {
        var result = await _service.GetStudentRegistrationsAsync(studentId);
        return Ok(result);
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] EnrollmentRequest request)
    {
        try
        {
            await _service.RegisterCourseAsync(request.MaSV, request.MaLHP);
            return Ok(new { message = "Đăng ký thành công" });
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("cancel")]
    public async Task<IActionResult> Cancel([FromBody] EnrollmentRequest request)
    {
        try
        {
            await _service.CancelRegistrationAsync(request.MaSV, request.MaLHP);
            return Ok(new { message = "Hủy đăng ký thành công" });
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }
}
