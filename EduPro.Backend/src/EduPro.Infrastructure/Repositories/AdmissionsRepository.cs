using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class AdmissionsRepository : IAdmissionsRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public AdmissionsRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<(int Id, string MaTraCuu)> CreateAsync(CreateAdmissionRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        var result = await connection.QuerySingleAsync<(int Id, string MaTraCuu)>(
            "sp_Admissions_Create",
            new
            {
                request.FullName,
                request.Email,
                request.Phone,
                request.CCCD,
                request.NgaySinh,
                request.DiaChi,
                request.MaNam,
                request.MaHK,
                request.MaNganh,
                request.GhiChu
            },
            commandType: CommandType.StoredProcedure
        );

        // Nếu có điểm nhập từ phía thí sinh, lưu điểm và tính trạng thái
        if (request.Diem1.HasValue || request.Diem2.HasValue || request.Diem3.HasValue || !string.IsNullOrWhiteSpace(request.Mon1))
        {
            await connection.QuerySingleAsync<ScoreResult>(
                "sp_Admissions_SaveScores",
                new
                {
                    AdmissionId = result.Id,
                    Mon1 = request.Mon1 ?? string.Empty,
                    Diem1 = request.Diem1 ?? 0,
                    Mon2 = request.Mon2 ?? string.Empty,
                    Diem2 = request.Diem2 ?? 0,
                    Mon3 = request.Mon3 ?? string.Empty,
                    Diem3 = request.Diem3 ?? 0,
                    GhiChu = request.GhiChu
                },
                commandType: CommandType.StoredProcedure
            );
        }

        return result;
    }

    public async Task<IEnumerable<AdmissionDto>> ListAsync(AdmissionFilter filter)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<AdmissionDto>(
            "sp_Admissions_List",
            new { filter.MaHK, filter.MaNganh, filter.TrangThai, filter.PageNumber, filter.PageSize },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<AdmissionDto?> GetByCodeAsync(string code)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryFirstOrDefaultAsync<AdmissionDto>(
            "sp_Admissions_GetByCode",
            new { MaTraCuu = code },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<AdmissionDto?> UpdateStatusAsync(UpdateAdmissionStatusRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryFirstOrDefaultAsync<AdmissionDto>(
            "sp_Admissions_UpdateStatus",
            new { request.Id, request.TrangThai, request.GhiChu },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<ScoreResult> SaveScoresAsync(SaveScoresRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleAsync<ScoreResult>(
            "sp_Admissions_SaveScores",
            new
            {
                request.AdmissionId,
                request.Mon1,
                request.Diem1,
                request.Mon2,
                request.Diem2,
                request.Mon3,
                request.Diem3,
                request.GhiChu
            },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<AdmissionRequirementDto?> GetRequirementAsync(string maNganh)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryFirstOrDefaultAsync<AdmissionRequirementDto>(
            "sp_Admissions_GetRequirement",
            new { MaNganh = maNganh },
            commandType: CommandType.StoredProcedure
        );
    }
}
