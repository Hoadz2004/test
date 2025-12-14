using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class MasterDataRepository : IMasterDataRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public MasterDataRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<MasterDataDto>> GetFacultiesAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<MasterDataDto>("sp_LayDanhSachKhoa", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<MasterDataDto>> GetMajorsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<MasterDataDto>("sp_LayDanhSachNganh", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<MasterDataDto>> GetSemestersAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<MasterDataDto>("sp_LayDanhSachHocKy", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<MasterDataDto>> GetAcademicYearsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<MasterDataDto>("sp_LayDanhSachNamHoc", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<MasterDataDto>> GetAdmissionBatchesAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<MasterDataDto>("sp_LayDanhSachKhoaTuyenSinh", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<MasterDataDto>> GetClassroomsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<MasterDataDto>("sp_LayDanhSachPhongHoc", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<MasterDataDto>> GetShiftsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<MasterDataDto>("sp_LayDanhSachCaHoc", commandType: CommandType.StoredProcedure);
    }

    public async Task<IEnumerable<MasterDataDto>> GetSubjectsAsync()
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<MasterDataDto>("sp_LayDanhSachHocPhan", commandType: CommandType.StoredProcedure);
    }
}
