using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface IAppealRepository
{
    Task CreateAppealAsync(string studentId, CreateAppealDto appealDto);
    Task<IEnumerable<AppealDto>> GetStudentAppealsAsync(string studentId);
    Task<IEnumerable<EligibleSubjectDto>> GetEligibleSubjectsAsync(string studentId);
}
