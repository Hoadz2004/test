using EduPro.Domain.Dtos;

namespace EduPro.Application.Student.Services;

public interface IStudentService
{
    Task<StudentProfileDto?> GetStudentProfileAsync(string studentId);
}
