using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface IEnrollmentRepository
{
    Task<IEnumerable<CourseOfferingDto>> GetOpenCoursesAsync(string? academicYearId, string? semesterId);
    Task<IEnumerable<RegisteredCourseDto>> GetStudentRegistrationsAsync(string studentId);
    Task RegisterCourseAsync(string studentId, string classId);
    Task CancelRegistrationAsync(string studentId, string classId);
}
