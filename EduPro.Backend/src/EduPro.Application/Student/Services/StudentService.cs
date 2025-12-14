using EduPro.Application.Student.Services;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;

namespace EduPro.Application.Student.Services;

public class StudentService : IStudentService
{
    private readonly IStudentRepository _studentRepository;

    public StudentService(IStudentRepository studentRepository)
    {
        _studentRepository = studentRepository;
    }

    public async Task<StudentProfileDto?> GetStudentProfileAsync(string studentId)
    {
        return await _studentRepository.GetStudentProfileAsync(studentId);
    }
}
