using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class StudentRepository : IStudentRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public StudentRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<StudentProfileDto?> GetStudentProfileAsync(string studentId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryFirstOrDefaultAsync<StudentProfileDto>(
            "sp_LayThongTinSinhVien",
            new { MaSV = studentId },
            commandType: CommandType.StoredProcedure
        );
    }
}
