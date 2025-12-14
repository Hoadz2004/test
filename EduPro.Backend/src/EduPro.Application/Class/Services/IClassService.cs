using EduPro.Domain.Dtos;

namespace EduPro.Application.Class.Services;

public interface IClassService
{
    Task<IEnumerable<ClassDto>> GetClassesAsync(string? academicYearId, string? semesterId, int pageNumber, int pageSize);
    Task CreateClassAsync(CreateClassDto classDto);
    Task UpdateClassAsync(UpdateClassDto classDto);
    Task DeleteClassAsync(string classId);
    Task<ConflictCheckResult> CheckConflictAsync(ConflictCheckRequest request);
}
