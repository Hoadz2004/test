using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;

namespace EduPro.Application.Lecturer.Services;

public class LecturerService : ILecturerService
{
    private readonly ILecturerRepository _lecturerRepository;

    public LecturerService(ILecturerRepository lecturerRepository)
    {
        _lecturerRepository = lecturerRepository;
    }

    public async Task<LecturerProfileDto?> GetLecturerProfileAsync(string lecturerId)
    {
        return await _lecturerRepository.GetLecturerProfileAsync(lecturerId);
    }

    public async Task<IEnumerable<MasterDataDto>> GetLecturersByFacultyAsync(string? facultyId)
    {
        return await _lecturerRepository.GetLecturersByFacultyAsync(facultyId);
    }

}
