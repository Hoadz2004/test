using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface IStudentRepository
{
    Task<StudentProfileDto?> GetStudentProfileAsync(string studentId);
}
