using EduPro.Domain.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace EduPro.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MasterDataController : ControllerBase
{
    private readonly IMasterDataRepository _repository;

    public MasterDataController(IMasterDataRepository repository)
    {
        _repository = repository;
    }

    [HttpGet("faculties")]
    public async Task<IActionResult> GetFaculties()
    {
        return Ok(await _repository.GetFacultiesAsync());
    }

    [HttpGet("majors")]
    public async Task<IActionResult> GetMajors()
    {
        return Ok(await _repository.GetMajorsAsync());
    }

    [HttpGet("semesters")]
    public async Task<IActionResult> GetSemesters()
    {
        return Ok(await _repository.GetSemestersAsync());
    }

    [HttpGet("academic-years")]
    public async Task<IActionResult> GetAcademicYears()
    {
        return Ok(await _repository.GetAcademicYearsAsync());
    }

    [HttpGet("batches")]
    public async Task<IActionResult> GetAdmissionBatches()
    {
        return Ok(await _repository.GetAdmissionBatchesAsync());
    }

    [HttpGet("classrooms")]
    public async Task<IActionResult> GetClassrooms()
    {
        return Ok(await _repository.GetClassroomsAsync());
    }

    [HttpGet("shifts")]
    public async Task<IActionResult> GetShifts()
    {
        return Ok(await _repository.GetShiftsAsync());
    }

    [HttpGet("subjects")]
    public async Task<IActionResult> GetSubjects()
    {
        return Ok(await _repository.GetSubjectsAsync());
    }
}
