using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;

namespace EduPro.Application.Graduation.Services;

public class GraduationService : IGraduationService
{
    private readonly IGraduationRepository _graduationRepository;

    public GraduationService(IGraduationRepository graduationRepository)
    {
        _graduationRepository = graduationRepository;
    }

    public async Task<GraduationResultDto?> GetGraduationResultAsync(string studentId)
    {
        return await _graduationRepository.GetGraduationResultAsync(studentId);
    }
}
