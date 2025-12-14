using EduPro.Domain.Dtos;

namespace EduPro.Application.Enrollment.Services;

public interface IEnrollmentService
{
    Task<IEnumerable<CourseOfferingDto>> GetOpenCoursesAsync(string? academicYearId, string? semesterId);
    Task<IEnumerable<RegisteredCourseDto>> GetStudentRegistrationsAsync(string studentId);
    Task RegisterCourseAsync(string studentId, string classId);
    Task CancelRegistrationAsync(string studentId, string classId);
}
