using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduPro.API.Controllers;

[Route("api/admin/tuition")]
[ApiController]
public class TuitionAdminController : ControllerBase
{
    private readonly ITuitionAdminRepository _repo;

    public TuitionAdminController(ITuitionAdminRepository repo)
    {
        _repo = repo;
    }

    [HttpGet("courses")]
    public async Task<IActionResult> GetCourses([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 20) =>
        Ok(await _repo.GetCoursesAsync(pageNumber, pageSize));

    [HttpPost("courses")]
    public async Task<IActionResult> UpsertCourse([FromBody] HocPhanAdminDto dto)
    {
        await _repo.UpsertCourseAsync(dto);
        return Ok();
    }

    [HttpDelete("courses/{maHP}")]
    public async Task<IActionResult> DeleteCourse(string maHP)
    {
        await _repo.DeleteCourseAsync(maHP);
        return Ok();
    }

    [HttpGet("fees")]
    public async Task<IActionResult> GetFees([FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 20) =>
        Ok(await _repo.GetFeeCatalogAsync(pageNumber, pageSize));

    [HttpGet("fees/by-major-semester")]
    public async Task<IActionResult> GetFeeByMajorSemester([FromQuery] string maNganh, [FromQuery] string maHK)
    {
        if (string.IsNullOrWhiteSpace(maNganh) || string.IsNullOrWhiteSpace(maHK))
            return BadRequest(new { message = "maNganh và maHK là bắt buộc" });

        var fee = await _repo.GetFeeByMajorSemesterAsync(maNganh, maHK);
        if (fee == null) return NotFound();
        return Ok(fee);
    }

    [HttpPost("fees")]
    public async Task<IActionResult> UpsertFee([FromBody] HocPhiCatalogDto dto)
    {
        var id = await _repo.UpsertFeeCatalogAsync(dto);
        return Ok(new { id });
    }

    [HttpDelete("fees/{id:int}")]
    public async Task<IActionResult> DeleteFee(int id)
    {
        await _repo.DeleteFeeCatalogAsync(id);
        return Ok();
    }
}
