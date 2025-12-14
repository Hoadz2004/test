using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface IAdmissionsRepository
{
    Task<(int Id, string MaTraCuu)> CreateAsync(CreateAdmissionRequest request);
    Task<IEnumerable<AdmissionDto>> ListAsync(AdmissionFilter filter);
    Task<AdmissionDto?> GetByCodeAsync(string code);
    Task<AdmissionDto?> UpdateStatusAsync(UpdateAdmissionStatusRequest request);
    Task<ScoreResult> SaveScoresAsync(SaveScoresRequest request);
    Task<AdmissionRequirementDto?> GetRequirementAsync(string maNganh);
}
