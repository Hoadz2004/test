using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class LecturerRepository : ILecturerRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public LecturerRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<LecturerProfileDto?> GetLecturerProfileAsync(string lecturerId)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryFirstOrDefaultAsync<LecturerProfileDto>(
            "sp_LayThongTinGiangVien",
            new { MaGV = lecturerId },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<IEnumerable<MasterDataDto>> GetLecturersByFacultyAsync(string? facultyId)
    {
        using var connection = _connectionFactory.CreateConnection();
        // Map result columns to MasterDataDto properties
        // SP returns: MaGV, HoTen, MaKhoa, TenKhoa
        // MasterDataDto has: Ma, Ten, MaKhoa
        var result = await connection.QueryAsync<dynamic>(
            "sp_LayDanhSachGiangVien_ByKhoa",
            new { MaKhoa = facultyId },
            commandType: CommandType.StoredProcedure
        );

        return result.Select(r => new MasterDataDto 
        { 
            Ma = r.MaGV, 
            Ten = r.HoTen, 
            MaKhoa = r.MaKhoa 
        });
    }
}
