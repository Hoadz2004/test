using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class EnrollmentRepository : IEnrollmentRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public EnrollmentRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<CourseOfferingDto>> GetOpenCoursesAsync(string? academicYearId, string? semesterId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<CourseOfferingDto>(
            "sp_LayDanhSachLopMo", 
            new { MaNam = academicYearId, MaHK = semesterId }, 
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<IEnumerable<RegisteredCourseDto>> GetStudentRegistrationsAsync(string studentId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<RegisteredCourseDto>(
            "sp_LayKetQuaDangKy",
            new { MaSV = studentId },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task RegisterCourseAsync(string studentId, string classId)
    {
        using var connection = _connectionFactory.CreateConnection();
        
        // 1. Check Prerequisites
        var checkResult = await connection.QueryFirstOrDefaultAsync<dynamic>(
            "sp_CheckTienQuyet",
            new { MaSV = studentId, MaLHP = classId },
            commandType: CommandType.StoredProcedure
        );

        if (checkResult != null && (checkResult?.Result ?? 1) == 0)
        {
            throw new Exception(checkResult?.Message ?? "Không thể đăng ký");
        }

        // 2. Register
        await connection.ExecuteAsync(
            "sp_SinhVienDangKyHocPhan",
            new { MaSV = studentId, MaLHP = classId },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task CancelRegistrationAsync(string studentId, string classId)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_HuyDangKyHocPhan",
            new { MaSV = studentId, MaLHP = classId },
            commandType: CommandType.StoredProcedure
        );
    }
}
