using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Entities;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class AuthRepository : IAuthRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public AuthRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<User?> LoginAsync(string username, string password)
    {
        using var connection = _connectionFactory.CreateConnection();
        
        // Call Stored Procedure
        var user = await connection.QueryFirstOrDefaultAsync<User>(
            "sp_KiemTraDangNhap",
            new { TenDangNhap = username },
            commandType: CommandType.StoredProcedure
        );

        return user;
    }

    public async Task ResetLoginAttemptsAsync(string username)
    {
        using var connection = _connectionFactory.CreateConnection();
        string sql = "UPDATE TaiKhoan SET SoLanDangNhapThatBai = 0, KhoaLuc = NULL WHERE TenDangNhap = @Username";
        await connection.ExecuteAsync(sql, new { Username = username });
    }

    public async Task IncrementLoginAttemptsAsync(string username)
    {
        using var connection = _connectionFactory.CreateConnection();
        // Increment fails. If fails >= 5, lock for 15 minutes.
        string sql = @"
            UPDATE TaiKhoan 
            SET SoLanDangNhapThatBai = SoLanDangNhapThatBai + 1,
                KhoaLuc = CASE 
                            WHEN SoLanDangNhapThatBai + 1 >= 5 THEN DATEADD(MINUTE, 15, GETDATE()) 
                            ELSE KhoaLuc 
                          END
            WHERE TenDangNhap = @Username";
        await connection.ExecuteAsync(sql, new { Username = username });
    }

    public async Task LogLoginAttemptAsync(string username, bool isSuccess, string? ipAddress, string? reason)
    {
        using var connection = _connectionFactory.CreateConnection();
        string sql = "INSERT INTO LoginAttempt (UserName, IPAddress, IsSuccess, FailureReason) VALUES (@UserName, @IPAddress, @IsSuccess, @Reason)";
        await connection.ExecuteAsync(sql, new { UserName = username, IPAddress = ipAddress, IsSuccess = isSuccess, Reason = reason });
    }

    public async Task AddTokenToBlacklistAsync(string tokenId, DateTime expiryDate, string reason)
    {
        using var connection = _connectionFactory.CreateConnection();
        string sql = "INSERT INTO TokenBlacklist (TokenId, ExpiryDate, Reason) VALUES (@TokenId, @ExpiryDate, @Reason)";
        await connection.ExecuteAsync(sql, new { TokenId = tokenId, ExpiryDate = expiryDate, Reason = reason });
    }

    public async Task<bool> IsTokenBlacklistedAsync(string tokenId)
    {
        using var connection = _connectionFactory.CreateConnection();
        var count = await connection.ExecuteScalarAsync<int>("SELECT COUNT(1) FROM TokenBlacklist WHERE TokenId = @TokenId", new { TokenId = tokenId });
        return count > 0;
    }
}
