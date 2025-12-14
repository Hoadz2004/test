using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class TuitionAdminRepository : ITuitionAdminRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public TuitionAdminRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<HocPhanAdminDto>> GetCoursesAsync(int pageNumber, int pageSize)
    {
        using var connection = _connectionFactory.CreateConnection();
        var sql = @"
            SELECT MaHP, TenHP, SoTinChi, LoaiHocPhan, BatBuoc, SoTietLT, SoTietTH,
                   COUNT(*) OVER() AS TotalRecords
            FROM HocPhan
            ORDER BY MaHP
            OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";
        var offset = (pageNumber - 1) * pageSize;
        return await connection.QueryAsync<HocPhanAdminDto>(sql, new { Offset = offset, PageSize = pageSize });
    }

    public async Task UpsertCourseAsync(HocPhanAdminDto dto)
    {
        using var connection = _connectionFactory.CreateConnection();
        var exists = await connection.ExecuteScalarAsync<int>(
            "SELECT COUNT(1) FROM HocPhan WHERE MaHP = @MaHP", new { dto.MaHP });
        if (exists > 0)
        {
            await connection.ExecuteAsync(
                @"UPDATE HocPhan SET TenHP=@TenHP, SoTinChi=@SoTinChi, LoaiHocPhan=@LoaiHocPhan, BatBuoc=@BatBuoc,
                          SoTietLT=@SoTietLT, SoTietTH=@SoTietTH
                  WHERE MaHP=@MaHP",
                dto);
        }
        else
        {
            await connection.ExecuteAsync(
                @"INSERT INTO HocPhan (MaHP, TenHP, SoTinChi, LoaiHocPhan, BatBuoc, SoTietLT, SoTietTH)
                  VALUES (@MaHP, @TenHP, @SoTinChi, @LoaiHocPhan, @BatBuoc, @SoTietLT, @SoTietTH)",
                dto);
        }
    }

    public async Task DeleteCourseAsync(string maHP)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync("DELETE FROM HocPhan WHERE MaHP=@MaHP", new { MaHP = maHP });
    }

    public async Task<IEnumerable<HocPhiCatalogDto>> GetFeeCatalogAsync(int pageNumber, int pageSize)
    {
        using var connection = _connectionFactory.CreateConnection();
        var sql = @"
            SELECT Id, MaNganh, MaHK, DonGiaTinChi, PhuPhiThucHanh, GiamTruPercent, HieuLucTu, HieuLucDen, NgayHetHan,
                   COUNT(*) OVER() AS TotalRecords
            FROM HocPhiCatalog
            ORDER BY HieuLucTu DESC
            OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";
        var offset = (pageNumber - 1) * pageSize;
        return await connection.QueryAsync<HocPhiCatalogDto>(sql, new { Offset = offset, PageSize = pageSize });
    }

    public async Task<HocPhiCatalogDto?> GetFeeByMajorSemesterAsync(string maNganh, string maHK)
    {
        using var connection = _connectionFactory.CreateConnection();
        var sql = @"
            SELECT TOP 1 Id, MaNganh, MaHK, DonGiaTinChi, PhuPhiThucHanh, GiamTruPercent, HieuLucTu, HieuLucDen, NgayHetHan
            FROM HocPhiCatalog
            WHERE MaNganh = @MaNganh AND MaHK = @MaHK
            ORDER BY HieuLucTu DESC";
        return await connection.QueryFirstOrDefaultAsync<HocPhiCatalogDto>(sql, new { MaNganh = maNganh, MaHK = maHK });
    }

    public async Task<int> UpsertFeeCatalogAsync(HocPhiCatalogDto dto)
    {
        using var connection = _connectionFactory.CreateConnection();
        if (dto.Id > 0)
        {
            await connection.ExecuteAsync(
                @"UPDATE HocPhiCatalog
                  SET MaNganh=@MaNganh, MaHK=@MaHK, DonGiaTinChi=@DonGiaTinChi, PhuPhiThucHanh=@PhuPhiThucHanh,
                      GiamTruPercent=@GiamTruPercent, HieuLucTu=@HieuLucTu, HieuLucDen=@HieuLucDen, NgayHetHan=@NgayHetHan
                  WHERE Id=@Id",
                dto);
            await RecalcForSemesterAsync(connection, dto.MaHK);
            return dto.Id;
        }
        else
        {
            var newId = await connection.ExecuteScalarAsync<int>(
                @"INSERT INTO HocPhiCatalog (MaNganh, MaHK, DonGiaTinChi, PhuPhiThucHanh, GiamTruPercent, HieuLucTu, HieuLucDen, NgayHetHan)
                  VALUES (@MaNganh, @MaHK, @DonGiaTinChi, @PhuPhiThucHanh, @GiamTruPercent, @HieuLucTu, @HieuLucDen, @NgayHetHan);
                  SELECT CAST(SCOPE_IDENTITY() as int);",
                dto);
            await RecalcForSemesterAsync(connection, dto.MaHK);
            return newId;
        }
    }

    public async Task DeleteFeeCatalogAsync(int id)
    {
        using var connection = _connectionFactory.CreateConnection();
        var maHK = await connection.ExecuteScalarAsync<string>("SELECT MaHK FROM HocPhiCatalog WHERE Id=@Id", new { Id = id });
        await connection.ExecuteAsync("DELETE FROM HocPhiCatalog WHERE Id=@Id", new { Id = id });
        if (!string.IsNullOrWhiteSpace(maHK))
        {
            await RecalcForSemesterAsync(connection, maHK);
        }
    }

    private async Task RecalcForSemesterAsync(IDbConnection connection, string maHK)
    {
        var students = await connection.QueryAsync<string>(
            @"SELECT DISTINCT dk.MaSV 
              FROM DangKyHocPhan dk 
              JOIN LopHocPhan lhp ON dk.MaLHP = lhp.MaLHP
              WHERE lhp.MaHK = @MaHK AND dk.TrangThai != N'Hủy'",
            new { MaHK = maHK });

        foreach (var sv in students)
        {
            await connection.ExecuteAsync("sp_Payment_RecalcDebt", new { MaSV = sv, MaHK = maHK }, commandType: CommandType.StoredProcedure);
        }
    }
}
