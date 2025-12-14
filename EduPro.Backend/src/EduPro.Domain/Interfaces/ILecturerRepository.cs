using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface ILecturerRepository
{
    Task<LecturerProfileDto?> GetLecturerProfileAsync(string lecturerId);
    Task<IEnumerable<MasterDataDto>> GetLecturersByFacultyAsync(string? facultyId);
}
