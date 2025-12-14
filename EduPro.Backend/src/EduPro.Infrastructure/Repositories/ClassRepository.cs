using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class ClassRepository : IClassRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public ClassRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<ClassDto>> GetClassesAsync(string? academicYearId, string? semesterId, int pageNumber, int pageSize)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<ClassDto>(
            "sp_LayDanhSachLopHocPhan_Admin",
            new { MaNam = academicYearId, MaHK = semesterId, PageNumber = pageNumber, PageSize = pageSize },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task CreateClassAsync(CreateClassDto classDto)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_ThemLopHocPhan",
            new
            {
                classDto.MaLHP,
                classDto.MaHP,
                classDto.MaHK,
                classDto.MaNam,
                classDto.MaGV,
                classDto.MaPhong,
                classDto.MaCa,
                classDto.ThuTrongTuan,
                classDto.SiSoToiDa,
                classDto.GhiChu,
                classDto.NgayBatDau,
                classDto.NgayKetThuc,
                classDto.SoBuoiHoc,
                classDto.SoBuoiTrongTuan,
                classDto.TrangThaiLop
            },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task UpdateClassAsync(UpdateClassDto classDto)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_SuaLopHocPhan",
            new
            {
                classDto.MaLHP,
                classDto.MaHP,
                classDto.MaHK,
                classDto.MaNam,
                classDto.MaGV,
                classDto.MaPhong,
                classDto.MaCa,
                classDto.ThuTrongTuan,
                classDto.SiSoToiDa,
                classDto.GhiChu,
                classDto.NgayBatDau,
                classDto.NgayKetThuc,
                classDto.SoBuoiHoc,
                classDto.SoBuoiTrongTuan,
                classDto.TrangThaiLop
            },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task DeleteClassAsync(string classId)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_XoaLopHocPhan",
            new { MaLHP = classId },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<ConflictCheckResult> CheckConflictAsync(ConflictCheckRequest request)
    {
        using var connection = _connectionFactory.CreateConnection();
        var result = await connection.QueryFirstOrDefaultAsync<ConflictCheckResult>(
            "sp_CheckTrungLich",
            new 
            { 
                MaNam = request.MaNam, 
                MaHK = request.MaHK, 
                Thu = request.Thu, 
                MaCa = request.MaCa, 
                MaPhong = request.MaPhong,
                MaGV = request.MaGV,
                MaLHP = request.MaLHP
            },
            commandType: CommandType.StoredProcedure
        );
        return result ?? new ConflictCheckResult();
    }

    public async Task<bool> IsClassExistsAsync(string classId)
    {
        using var connection = _connectionFactory.CreateConnection();
        var count = await connection.ExecuteScalarAsync<int>(
            "SELECT COUNT(1) FROM LopHocPhan WHERE MaLHP = @MaLHP",
            new { MaLHP = classId }
        );
        return count > 0;
    }

    public async Task<int> GetCurrentEnrollmentAsync(string classId)
    {
        using var connection = _connectionFactory.CreateConnection();
        var count = await connection.ExecuteScalarAsync<int>(
            @"SELECT COUNT(*) 
              FROM DangKyHocPhan 
              WHERE MaLHP = @MaLHP AND (TrangThai IS NULL OR TrangThai != N'Hủy')",
            new { MaLHP = classId }
        );
        return count;
    }
}
