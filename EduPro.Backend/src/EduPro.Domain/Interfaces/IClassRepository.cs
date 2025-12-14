using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface IClassRepository
{
    Task<IEnumerable<ClassDto>> GetClassesAsync(string? academicYearId, string? semesterId, int pageNumber, int pageSize);
    Task CreateClassAsync(CreateClassDto classDto);
    Task UpdateClassAsync(UpdateClassDto classDto);
    Task DeleteClassAsync(string classId);
    Task<ConflictCheckResult> CheckConflictAsync(ConflictCheckRequest request);
    Task<bool> IsClassExistsAsync(string classId);
    Task<int> GetCurrentEnrollmentAsync(string classId);
}
