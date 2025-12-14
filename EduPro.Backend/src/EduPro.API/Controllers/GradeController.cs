using EduPro.Application.Lecturer.Services;
using EduPro.Domain.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduPro.API.Controllers;

[Route("api/[controller]")]
[ApiController]
public class GradeController : ControllerBase
{
    private readonly IGradeService _service;

    public GradeController(IGradeService service)
    {
        _service = service;
    }

    private string GetCurrentLecturerId()
    {
        return User.FindFirst("MaGV")?.Value ?? "";
    }

    private string GetCurrentStudentId()
    {
        return User.FindFirst("MaSV")?.Value ?? "";
    }

    [Authorize(Roles = "GIANGVIEN")]
    [HttpGet("lecturer/classes")]
    public async Task<IActionResult> GetMyClasses([FromQuery] int? namHoc, [FromQuery] int? hocKy)
    {
        var maGV = GetCurrentLecturerId();
        if (string.IsNullOrEmpty(maGV)) return Unauthorized();

        var result = await _service.GetLecturerClassesAsync(maGV, namHoc, hocKy);
        return Ok(new { data = result });
    }

    [Authorize(Roles = "GIANGVIEN")]
    [HttpGet("lecturer/grades/{maLHP}")]
    public async Task<IActionResult> GetClassGrades(string maLHP)
    {
        var maGV = GetCurrentLecturerId();
        try
        {
            var result = await _service.GetClassGradesAsync(maLHP, maGV);
            return Ok(new { data = result });
        }
        catch (UnauthorizedAccessException)
        {
            return Forbid();
        }
    }

    [Authorize(Roles = "GIANGVIEN")]
    [HttpPost("lecturer/update-grade")]
    public async Task<IActionResult> UpdateGrade([FromBody] UpdateGradeRequest request)
    {
        var maGV = GetCurrentLecturerId();
        Console.WriteLine($"[UpdateGrade] Request - LHP: {request.MaLHP}, SV: {request.MaSV}, GV: {maGV}");
        Console.WriteLine($"[UpdateGrade] Scores - CC: {request.DiemCC}, GK: {request.DiemGK}, CK: {request.DiemCK}");

        try
        {
            await _service.UpdateStudentGradeAsync(request, maGV);
            Console.WriteLine("[UpdateGrade] Success");
            return Ok(new { message = "Grade updated successfully" });
        }
        catch (UnauthorizedAccessException)
        {
            Console.WriteLine("[UpdateGrade] Unauthorized");
            return Forbid();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[UpdateGrade] Error: {ex.Message}");
            return BadRequest(new { message = ex.Message });
        }
    }

    [Authorize(Roles = "SINHVIEN,GIANGVIEN,ADMIN")] // Allow student to see own, maybe others too? Strict to SINHVIEN for now.
    [HttpGet("my-grades/{maSV}")]
    public async Task<IActionResult> GetMyGrades(string maSV)
    {
        // Always prefer the MaSV in token to avoid mismatch (e.g. username != MaSV)
        var currentUserSV = GetCurrentStudentId();
        var targetMaSV = !string.IsNullOrEmpty(currentUserSV) ? currentUserSV : maSV;

        var result = await _service.GetStudentGradesAsync(targetMaSV);
        return Ok(result); // Return list directly as per frontend expectation
    }
}
