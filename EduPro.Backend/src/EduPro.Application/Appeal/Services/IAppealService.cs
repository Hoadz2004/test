using EduPro.Domain.Dtos;

namespace EduPro.Application.Appeal.Services;

public interface IAppealService
{
    Task CreateAppealAsync(string studentId, CreateAppealDto appealDto);
    Task<IEnumerable<AppealDto>> GetStudentAppealsAsync(string studentId);
    Task<IEnumerable<EligibleSubjectDto>> GetEligibleSubjectsAsync(string studentId);
}
