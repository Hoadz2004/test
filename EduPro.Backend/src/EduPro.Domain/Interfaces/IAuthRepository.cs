using EduPro.Domain.Entities;

namespace EduPro.Domain.Interfaces;

public interface IAuthRepository
{
    Task<User?> LoginAsync(string username, string password);
    Task ResetLoginAttemptsAsync(string username);
    Task IncrementLoginAttemptsAsync(string username);
    Task LogLoginAttemptAsync(string username, bool isSuccess, string? ipAddress, string? reason);
    Task AddTokenToBlacklistAsync(string tokenId, DateTime expiryDate, string reason);
    Task<bool> IsTokenBlacklistedAsync(string tokenId);
}
