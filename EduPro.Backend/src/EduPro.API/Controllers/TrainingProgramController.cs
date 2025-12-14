using EduPro.Application.Admin.Services;
using EduPro.Domain.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EduPro.API.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize]
public class TrainingProgramController : ControllerBase
{
    private readonly ITrainingProgramService _service;

    public TrainingProgramController(ITrainingProgramService service)
    {
        _service = service;
    }

    private string GetCurrentUsername()
    {
        return User.FindFirst(ClaimTypes.Name)?.Value ?? "Unknown";
    }

    private string GetCurrentUserId() // MaSV or AdminID
    {
        // Assuming 'sub' or specific claim holds the ID. 
        // For simplicity, let's assume 'sub' is username, and maybe we have another claim or look it up.
        // Actually, for Student, 'sub' usually is correct ID (MaSV) in previous implementation logic ?
        // Let's check AuthService logic later. For now, use Name as ID if roles match
        return User.FindFirst(ClaimTypes.Name)?.Value ?? "";
    }


    [HttpGet("admin/list")]
    [Authorize(Roles = "ADMIN,GIANGVIEN")] // Allow GV to view?
    public async Task<IActionResult> GetCTDTs([FromQuery] string? keyword, [FromQuery] int page = 1, [FromQuery] int pageSize = 20)
    {
        var result = await _service.GetCTDTsAsync(keyword, page, pageSize);
        return Ok(new { data = result });
    }

    [HttpPost("admin/create")]
    [Authorize(Roles = "ADMIN")]
    public async Task<IActionResult> CreateCTDT([FromBody] CreateCTDTRequest request)
    {
        try
        {
            var id = await _service.CreateCTDTAsync(request, GetCurrentUsername());
            return Ok(new { message = "Created successfully", id });
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet("admin/detail/{maCTDT}")]
    [Authorize(Roles = "ADMIN,GIANGVIEN")]
    public async Task<IActionResult> GetCTDTDetail(int maCTDT)
    {
        var result = await _service.GetCTDTDetailAsync(maCTDT);
        if (result == null) return NotFound(new { message = "CTDT not found" });
        return Ok(new { data = result });
    }

    [HttpPost("admin/add-subject")]
    [Authorize(Roles = "ADMIN")]
    public async Task<IActionResult> AddSubject([FromBody] AddSubjectRequest request)
    {
        try
        {
            await _service.AddSubjectToCTDTAsync(request, GetCurrentUsername());
            return Ok(new { message = "Subject added to CTDT" });
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpDelete("admin/remove-subject/{id}")]
    [Authorize(Roles = "ADMIN")]
    public async Task<IActionResult> RemoveSubject(int id)
    {
        await _service.RemoveSubjectFromCTDTAsync(id, GetCurrentUsername());
        return Ok(new { message = "Subject removed from CTDT" });
    }

    [HttpPost("admin/add-prerequisite")]
    [Authorize(Roles = "ADMIN")]
    public async Task<IActionResult> AddPrerequisite([FromBody] AddPrerequisiteRequest request)
    {
        await _service.AddPrerequisiteAsync(request, GetCurrentUsername());
        return Ok(new { message = "Prerequisite added" });
    }

    [HttpGet("student/my-curriculum")]
    [Authorize(Roles = "SINHVIEN")]
    public async Task<IActionResult> GetMyCurriculum()
    {
        var maSV = User.FindFirst("MaSV")?.Value;
        if (string.IsNullOrEmpty(maSV))
        {
             // Fallback or error if MaSV claim is missing
             return BadRequest(new { message = "Student ID not found in token" });
        }

        var result = await _service.GetStudentCurriculumAsync(maSV);
        if (result == null) return NotFound(new { message = "Curriculum not found for this student" });
        return Ok(new { data = result });
    }
}
