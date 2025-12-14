using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Entities;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class AdminRepository : IAdminRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public AdminRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<UserDto>> GetUsersAsync(string? keyword, string? role, int pageNumber, int pageSize)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<UserDto>(
            "sp_GetUsers",
            new { Keyword = keyword, Role = role, PageNumber = pageNumber, PageSize = pageSize },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task CreateUserAsync(CreateUserRequest request, byte[] passwordHash, string performedBy, string ipAddress)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_CreateUserAccount",
            new { 
                TenDangNhap = request.TenDangNhap, 
                MatKhauHash = passwordHash, 
                MaVaiTro = request.MaVaiTro, 
                HoTen = request.HoTen,
                Email = request.Email,
                DienThoai = request.DienThoai,
                NgaySinh = request.NgaySinh,
                GioiTinh = request.GioiTinh,
                MaNganh = request.MaNganh,
                MaKhoa = request.MaKhoa,
                PerformedBy = performedBy, 
                IPAddress = ipAddress 
            },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task UpdateUserRoleAsync(string username, string newRole, string performedBy, string ipAddress)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_UpdateUserRole",
            new { TenDangNhap = username, NewRole = newRole, PerformedBy = performedBy, IPAddress = ipAddress },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task UpdateUserStatusAsync(string username, bool isLocked, string reason, string performedBy, string ipAddress)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_UpdateUserStatus",
            new { TenDangNhap = username, IsLocked = isLocked, Reason = reason, PerformedBy = performedBy, IPAddress = ipAddress },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<IEnumerable<AuditLogDto>> GetAuditLogsAsync(string? keyword, DateTime? fromDate, DateTime? toDate, string? action, string? status, string? module, int pageNumber, int pageSize)
    {
        using var connection = _connectionFactory.CreateConnection();

        var offset = (pageNumber - 1) * pageSize;
        var parameters = new
        {
            Keyword = keyword,
            FromDate = fromDate,
            ToDate = toDate,
            Action = action,
            Status = status,
            Module = module,
            Offset = offset,
            PageSize = pageSize
        };

        try
        {
            return await connection.QueryAsync<AuditLogDto>(
                "sp_GetAuditLogs",
                parameters,
                commandType: CommandType.StoredProcedure);
        }
        catch
        {
            // Fallback inline if SP missing
            var sql = @"
                SELECT LogId, Action, EntityTable, EntityId, OldValue, NewValue, PerformedBy, Timestamp, IPAddress, Status, Module,
                       COUNT(*) OVER() AS TotalRecords
                FROM AuditLog WITH (NOLOCK)
                WHERE (@Keyword IS NULL OR (PerformedBy LIKE '%' + @Keyword + '%' OR NewValue LIKE '%' + @Keyword + '%' OR Module LIKE '%' + @Keyword + '%' OR Action LIKE '%' + @Keyword + '%'))
                  AND (@FromDate IS NULL OR Timestamp >= @FromDate)
                  AND (@ToDate IS NULL OR Timestamp <= @ToDate)
                  AND (@Action IS NULL OR Action = @Action)
                  AND (@Status IS NULL OR Status = @Status)
                  AND (@Module IS NULL OR Module = @Module)
                ORDER BY Timestamp DESC
                OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";

            return await connection.QueryAsync<AuditLogDto>(sql, parameters);
        }
    }

    public async Task LogAuditAsync(AuditLog log)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            @"INSERT INTO AuditLog (Action, EntityTable, EntityId, NewValue, PerformedBy, Timestamp, IPAddress) 
              VALUES (@Action, @EntityName, @EntityId, @Details, @PerformedBy, @PerformedAt, @IpAddress)",
            log
        );
    }
}
