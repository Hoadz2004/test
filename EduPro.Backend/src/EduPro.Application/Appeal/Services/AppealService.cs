using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;

namespace EduPro.Application.Appeal.Services;

public class AppealService : IAppealService
{
    private readonly IAppealRepository _appealRepository;

    public AppealService(IAppealRepository appealRepository)
    {
        _appealRepository = appealRepository;
    }

    public async Task CreateAppealAsync(string studentId, CreateAppealDto appealDto)
    {
        await _appealRepository.CreateAppealAsync(studentId, appealDto);
    }

    public async Task<IEnumerable<AppealDto>> GetStudentAppealsAsync(string studentId)
    {
        return await _appealRepository.GetStudentAppealsAsync(studentId);
    }

    public async Task<IEnumerable<EligibleSubjectDto>> GetEligibleSubjectsAsync(string studentId)
    {
        return await _appealRepository.GetEligibleSubjectsAsync(studentId);
    }
}
