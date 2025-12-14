using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;

namespace EduPro.Application.Enrollment.Services;

public class EnrollmentService : IEnrollmentService
{
    private readonly IEnrollmentRepository _repository;

    public EnrollmentService(IEnrollmentRepository repository)
    {
        _repository = repository;
    }

    public async Task<IEnumerable<CourseOfferingDto>> GetOpenCoursesAsync(string? academicYearId, string? semesterId)
    {
        return await _repository.GetOpenCoursesAsync(academicYearId, semesterId);
    }

    public async Task<IEnumerable<RegisteredCourseDto>> GetStudentRegistrationsAsync(string studentId)
    {
        return await _repository.GetStudentRegistrationsAsync(studentId);
    }

    public async Task RegisterCourseAsync(string studentId, string classId)
    {
        await _repository.RegisterCourseAsync(studentId, classId);
    }

    public async Task CancelRegistrationAsync(string studentId, string classId)
    {
        await _repository.CancelRegistrationAsync(studentId, classId);
    }
}
