using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class AppealRepository : IAppealRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public AppealRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task CreateAppealAsync(string studentId, CreateAppealDto appealDto)
    {
        using var connection = _connectionFactory.CreateConnection();
        var parameters = new DynamicParameters();
        parameters.Add("@MaSV", studentId);
        parameters.Add("@MaLHP", appealDto.MaLHP);
        parameters.Add("@LyDo", appealDto.LyDo);

        await connection.ExecuteAsync("sp_TaoYeuCauPhucKhao", parameters, commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<AppealDto>> GetStudentAppealsAsync(string studentId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<AppealDto>(
            "sp_LayDanhSachPhucKhao_SinhVien",
            new { MaSV = studentId },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<IEnumerable<EligibleSubjectDto>> GetEligibleSubjectsAsync(string studentId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<EligibleSubjectDto>(
            "sp_LayMonDuocPhucKhao",
            new { MaSV = studentId },
            commandType: CommandType.StoredProcedure
        );
    }
}
