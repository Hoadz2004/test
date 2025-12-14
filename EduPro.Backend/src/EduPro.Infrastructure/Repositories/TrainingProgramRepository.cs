using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class TrainingProgramRepository : ITrainingProgramRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public TrainingProgramRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<CTDTDto>> GetCTDTsAsync(string? keyword, int page, int pageSize)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<CTDTDto>(
            "sp_Admin_GetCTDT",
            new { Keyword = keyword, Page = page, PageSize = pageSize },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<int> CreateCTDTAsync(CreateCTDTRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleAsync<int>(
            "sp_Admin_CreateCTDT",
            request,
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<CTDTDetailDto?> GetCTDTDetailAsync(int maCTDT)
    {
        using var connection = _connectionFactory.CreateConnection();
        
        using var multi = await connection.QueryMultipleAsync(
            "sp_Admin_GetCTDTDetail",
            new { MaCTDT = maCTDT },
            commandType: CommandType.StoredProcedure
        );

        var ctdt = await multi.ReadFirstOrDefaultAsync<CTDTDetailDto>();
        if (ctdt != null)
        {
            ctdt.Subjects = (await multi.ReadAsync<CTDTSubjectDto>()).ToList();
        }

        return ctdt;
    }

    public async Task AddSubjectToCTDTAsync(AddSubjectRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_Admin_AddChiTietCTDT",
            request,
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task RemoveSubjectFromCTDTAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_Admin_RemoveChiTietCTDT",
            new { Id = id },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task AddPrerequisiteAsync(AddPrerequisiteRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_Admin_AddTienQuyet",
            request,
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<StudentCurriculumDto?> GetStudentCurriculumAsync(string maSV)
    {
        using var connection = _connectionFactory.CreateConnection();
        using var multi = await connection.QueryMultipleAsync(
            "sp_Student_GetMyCurriculum",
            new { MaSV = maSV },
            commandType: CommandType.StoredProcedure
        );

        var overview = await multi.ReadFirstOrDefaultAsync<dynamic>();
        if (overview == null) return null;

        var result = new StudentCurriculumDto
        {
            MaCTDT = overview.MaCTDT,
            TenCTDT = overview.TenCTDT
        };

        var subjects = await multi.ReadAsync<StudentSubjectStatusDto>();
        result.Subjects = subjects.ToList();

        return result;
    }
}
