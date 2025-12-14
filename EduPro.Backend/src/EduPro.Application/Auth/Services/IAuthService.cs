using EduPro.Application.Auth.Dtos;

namespace EduPro.Application.Auth.Services;

public interface IAuthService
{
    Task<LoginResponse?> LoginAsync(LoginRequest request, string? ipAddress);
    Task LogoutAsync(string token);
}
