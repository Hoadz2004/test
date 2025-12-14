using EduPro.Application.Class.Services;
using EduPro.Domain.Dtos;
using Microsoft.AspNetCore.Mvc;

namespace EduPro.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ClassController : ControllerBase
{
    private readonly IClassService _classService;

    public ClassController(IClassService classService)
    {
        _classService = classService;
    }

    [HttpGet]
    public async Task<IActionResult> GetClasses([FromQuery] string? maNam, [FromQuery] string? maHK, [FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 20)
    {
        try
        {
            var classes = await _classService.GetClassesAsync(maNam, maHK, pageNumber, pageSize);
            return Ok(classes);
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost]
    public async Task<IActionResult> CreateClass([FromBody] CreateClassDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);
        
        try
        {
            await _classService.CreateClassAsync(dto);
            return Ok(new { message = "Class created successfully" });
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateClass(string id, [FromBody] UpdateClassDto dto)
    {
        if (!ModelState.IsValid) return BadRequest(ModelState);
        
        if (id != dto.MaLHP)
            return BadRequest(new { message = "Class ID mismatch" });

        try
        {
            await _classService.UpdateClassAsync(dto);
            return Ok(new { message = "Class updated successfully" });
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("check-conflict")]
    public async Task<IActionResult> CheckConflict([FromBody] ConflictCheckRequest request)
    {
        try
        {
            var result = await _classService.CheckConflictAsync(request);
            return Ok(result);
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteClass(string id)
    {
        try
        {
            await _classService.DeleteClassAsync(id);
            return Ok(new { message = "Class deleted successfully" });
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }
}
