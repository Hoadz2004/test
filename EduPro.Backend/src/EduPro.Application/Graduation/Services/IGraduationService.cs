using EduPro.Domain.Dtos;

namespace EduPro.Application.Graduation.Services;

public interface IGraduationService
{
    Task<GraduationResultDto?> GetGraduationResultAsync(string studentId);
}
