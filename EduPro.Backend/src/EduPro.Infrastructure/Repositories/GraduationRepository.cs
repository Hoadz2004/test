using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class GraduationRepository : IGraduationRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public GraduationRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<GraduationResultDto?> GetGraduationResultAsync(string studentId)
    {
        using var connection = _connectionFactory.CreateConnection();
        var result = await connection.QueryFirstOrDefaultAsync<GraduationResultDto>(
            "sp_LayKetQuaTotNghiep_SinhVien",
            new { MaSV = studentId },
            commandType: CommandType.StoredProcedure
        );
        return result;
    }
}
