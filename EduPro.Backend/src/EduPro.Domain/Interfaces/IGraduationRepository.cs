using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface IGraduationRepository
{
    Task<GraduationResultDto?> GetGraduationResultAsync(string studentId);
}
