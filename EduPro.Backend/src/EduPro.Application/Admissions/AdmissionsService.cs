using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;

namespace EduPro.Application.Admissions;

public interface IAdmissionsService
{
    Task<(int Id, string MaTraCuu)> CreateAsync(CreateAdmissionRequest request);
    Task<IEnumerable<AdmissionDto>> ListAsync(AdmissionFilter filter);
    Task<AdmissionDto?> GetByCodeAsync(string code);
    Task<AdmissionDto?> UpdateStatusAsync(UpdateAdmissionStatusRequest request);
    Task<ScoreResult> SaveScoresAsync(SaveScoresRequest request);
    Task<AdmissionRequirementDto?> GetRequirementAsync(string maNganh);
}

public class AdmissionsService : IAdmissionsService
{
    private readonly IAdmissionsRepository _repo;

    public AdmissionsService(IAdmissionsRepository repo)
    {
        _repo = repo;
    }

    public Task<(int Id, string MaTraCuu)> CreateAsync(CreateAdmissionRequest request)
        => _repo.CreateAsync(request);

    public Task<IEnumerable<AdmissionDto>> ListAsync(AdmissionFilter filter)
        => _repo.ListAsync(filter);

    public Task<AdmissionDto?> GetByCodeAsync(string code)
        => _repo.GetByCodeAsync(code);

    public Task<AdmissionDto?> UpdateStatusAsync(UpdateAdmissionStatusRequest request)
        => _repo.UpdateStatusAsync(request);

    public Task<ScoreResult> SaveScoresAsync(SaveScoresRequest request)
        => _repo.SaveScoresAsync(request);

    public Task<AdmissionRequirementDto?> GetRequirementAsync(string maNganh)
        => _repo.GetRequirementAsync(maNganh);
}
