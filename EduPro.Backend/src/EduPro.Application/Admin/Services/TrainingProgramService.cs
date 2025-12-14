using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using EduPro.Domain.Entities;

namespace EduPro.Application.Admin.Services;

public class TrainingProgramService : ITrainingProgramService
{
    private readonly ITrainingProgramRepository _repository;
    private readonly IAdminRepository _adminRepository; // To log audit

    public TrainingProgramService(ITrainingProgramRepository repository, IAdminRepository adminRepository)
    {
        _repository = repository;
        _adminRepository = adminRepository;
    }

    public async Task<IEnumerable<CTDTDto>> GetCTDTsAsync(string? keyword, int page, int pageSize)
    {
        return await _repository.GetCTDTsAsync(keyword, page, pageSize);
    }

    public async Task<int> CreateCTDTAsync(CreateCTDTRequest request, string performedBy)
    {
        var id = await _repository.CreateCTDTAsync(request);
        await _adminRepository.LogAuditAsync(new AuditLog
        {
            Action = "CreateCTDT",
            EntityName = "CTDT",
            EntityId = id.ToString(),
            Details = $"Created CTDT: {request.TenCTDT}",
            PerformedBy = performedBy,
            PerformedAt = DateTime.UtcNow
        });
        return id;
    }

    public async Task<CTDTDetailDto?> GetCTDTDetailAsync(int maCTDT)
    {
        return await _repository.GetCTDTDetailAsync(maCTDT);
    }

    public async Task AddSubjectToCTDTAsync(AddSubjectRequest request, string performedBy)
    {
        await _repository.AddSubjectToCTDTAsync(request);
        await _adminRepository.LogAuditAsync(new AuditLog
        {
            Action = "AddSubjectToCTDT",
            EntityName = "CTDT_ChiTiet",
            EntityId = $"{request.MaCTDT}-{request.MaHP}",
            Details = $"Added subject {request.MaHP} to CTDT {request.MaCTDT}",
            PerformedBy = performedBy,
            PerformedAt = DateTime.UtcNow
        });
    }

    public async Task RemoveSubjectFromCTDTAsync(int id, string performedBy)
    {
        await _repository.RemoveSubjectFromCTDTAsync(id);
        await _adminRepository.LogAuditAsync(new AuditLog
        {
            Action = "RemoveSubjectFromCTDT",
            EntityName = "CTDT_ChiTiet",
            EntityId = id.ToString(),
            Details = $"Removed subject link ID {id}",
            PerformedBy = performedBy,
            PerformedAt = DateTime.UtcNow
        });
    }

    public async Task AddPrerequisiteAsync(AddPrerequisiteRequest request, string performedBy)
    {
        await _repository.AddPrerequisiteAsync(request);
        await _adminRepository.LogAuditAsync(new AuditLog
        {
            Action = "AddPrerequisite",
            EntityName = "TienQuyet",
            EntityId = $"{request.MaHP}-{request.MaHP_TienQuyet}",
            Details = $"Added prerequisite: {request.MaHP} requires {request.MaHP_TienQuyet}",
            PerformedBy = performedBy,
            PerformedAt = DateTime.UtcNow
        });
    }

    public async Task<StudentCurriculumDto?> GetStudentCurriculumAsync(string maSV)
    {
        return await _repository.GetStudentCurriculumAsync(maSV);
    }
}
