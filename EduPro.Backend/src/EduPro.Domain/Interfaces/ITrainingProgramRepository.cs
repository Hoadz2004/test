using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface ITrainingProgramRepository
{
    Task<IEnumerable<CTDTDto>> GetCTDTsAsync(string? keyword, int page, int pageSize);
    Task<int> CreateCTDTAsync(CreateCTDTRequest request);
    Task<CTDTDetailDto?> GetCTDTDetailAsync(int maCTDT);
    Task AddSubjectToCTDTAsync(AddSubjectRequest request);
    Task RemoveSubjectFromCTDTAsync(int id);
    Task AddPrerequisiteAsync(AddPrerequisiteRequest request);
    Task<StudentCurriculumDto?> GetStudentCurriculumAsync(string maSV);
}
