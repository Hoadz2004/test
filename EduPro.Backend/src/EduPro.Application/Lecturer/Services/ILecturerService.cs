using EduPro.Domain.Dtos;

namespace EduPro.Application.Lecturer.Services;

public interface ILecturerService
{
    Task<LecturerProfileDto?> GetLecturerProfileAsync(string lecturerId);
    Task<IEnumerable<MasterDataDto>> GetLecturersByFacultyAsync(string? facultyId);
}
