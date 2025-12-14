using EduPro.Application.Admissions;
using EduPro.Domain.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Net.Mail;
using System.Text;

namespace EduPro.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AdmissionsController : ControllerBase
{
    private readonly IAdmissionsService _service;
    private readonly IConfiguration _config;

    public AdmissionsController(IAdmissionsService service, IConfiguration config)
    {
        _service = service;
        _config = config;
    }

    // Public: create admission
    [HttpPost]
    [AllowAnonymous]
    public async Task<IActionResult> Create([FromBody] CreateAdmissionRequest request)
    {
        var result = await _service.CreateAsync(request);
        return Ok(new { id = result.Id, maTraCuu = result.MaTraCuu });
    }

    // Public: lookup by code
    [HttpGet("lookup/{code}")]
    [AllowAnonymous]
    public async Task<IActionResult> GetByCode(string code)
    {
        var admission = await _service.GetByCodeAsync(code);
        if (admission == null) return NotFound();
        return Ok(admission);
    }

    // Admin: list
    [HttpGet]
    [Authorize(Roles = "ADMIN")]
    public async Task<IActionResult> List([FromQuery] string? maHK, [FromQuery] string? maNganh, [FromQuery] string? trangThai, [FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 20)
    {
        var list = await _service.ListAsync(new AdmissionFilter { MaHK = maHK, MaNganh = maNganh, TrangThai = trangThai, PageNumber = pageNumber, PageSize = pageSize });
        return Ok(list);
    }

    [HttpGet("requirements/{maNganh}")]
    [AllowAnonymous]
    public async Task<IActionResult> GetRequirement(string maNganh)
    {
        var req = await _service.GetRequirementAsync(maNganh);
        if (req == null) return NotFound();
        return Ok(req);
    }

    // Admin: update status
    [HttpPut("status")]
    [Authorize(Roles = "ADMIN")]
    public async Task<IActionResult> UpdateStatus([FromBody] UpdateAdmissionStatusRequest request)
    {
        var updated = await _service.UpdateStatusAsync(request);
        if (updated == null) return NotFound();
        TrySendEmail(updated, request);
        return Ok(updated);
    }

    [HttpPost("scores")]
    [Authorize(Roles = "ADMIN")]
    public async Task<IActionResult> SaveScores([FromBody] SaveScoresRequest request)
    {
        var result = await _service.SaveScoresAsync(request);
        return Ok(result);
    }

    private void TrySendEmail(AdmissionDto admission, UpdateAdmissionStatusRequest request)
    {
        try
        {
            var smtpSection = _config.GetSection("Smtp");
            var host = smtpSection["Host"];
            var port = int.Parse(smtpSection["Port"] ?? "0");
            var user = smtpSection["User"];
            var pass = smtpSection["Pass"];
            var from = smtpSection["From"];

            if (string.IsNullOrWhiteSpace(host) || port == 0 || string.IsNullOrWhiteSpace(from))
                return;

            var to = admission.Email ?? user;
            if (string.IsNullOrWhiteSpace(to) || string.IsNullOrWhiteSpace(user) || string.IsNullOrWhiteSpace(pass)) return;

            using var client = new SmtpClient(host, port)
            {
                EnableSsl = true,
                Credentials = new NetworkCredential(user, pass)
            };
            var mail = new MailMessage(from, to)
            {
                Subject = $"Cập nhật hồ sơ tuyển sinh {admission.MaTraCuu}",
                Body = $"Chào {admission.FullName},\n\nTrạng thái hồ sơ của bạn đã được cập nhật: {request.TrangThai}.\nGhi chú: {request.GhiChu}\nMã tra cứu: {admission.MaTraCuu}\n\nTrân trọng.",
                SubjectEncoding = Encoding.UTF8,
                BodyEncoding = Encoding.UTF8
            };
            client.Send(mail);
        }
        catch
        {
            // ignore email errors for now
        }
    }
}
