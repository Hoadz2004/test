using EduPro.Domain.Dtos;

namespace EduPro.Application.Admin.Services;

public interface ITrainingProgramService
{
    Task<IEnumerable<CTDTDto>> GetCTDTsAsync(string? keyword, int page, int pageSize);
    Task<int> CreateCTDTAsync(CreateCTDTRequest request, string performedBy);
    Task<CTDTDetailDto?> GetCTDTDetailAsync(int maCTDT);
    Task AddSubjectToCTDTAsync(AddSubjectRequest request, string performedBy);
    Task RemoveSubjectFromCTDTAsync(int id, string performedBy);
    Task AddPrerequisiteAsync(AddPrerequisiteRequest request, string performedBy);
    Task<StudentCurriculumDto?> GetStudentCurriculumAsync(string maSV);
}
