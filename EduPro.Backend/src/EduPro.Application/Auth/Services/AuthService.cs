using EduPro.Application.Auth.Dtos;
using EduPro.Domain.Entities;
using EduPro.Domain.Interfaces;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace EduPro.Application.Auth.Services;

public class AuthService : IAuthService
{
    private readonly IAuthRepository _authRepository;
    private readonly IConfiguration _configuration;

    public AuthService(IAuthRepository authRepository, IConfiguration configuration)
    {
        _authRepository = authRepository;
        _configuration = configuration;
    }

    public async Task<LoginResponse?> LoginAsync(LoginRequest request, string? ipAddress)
    {
        // 1. Call Repo to get user
        var user = await _authRepository.LoginAsync(request.Username, request.Password);

        // User not found
        if (user == null) 
        {
            await _authRepository.LogLoginAttemptAsync(request.Username, false, ipAddress, "User not found");
            return null;
        }

        // 2. Check Account Locking
        if (user.KhoaLuc.HasValue && user.KhoaLuc.Value > DateTime.Now)
        {
            await _authRepository.LogLoginAttemptAsync(request.Username, false, ipAddress, "Account Locked");
            throw new Exception($"Account is locked until {user.KhoaLuc.Value}");
        }

        // 3. Validate Password
        if (!VerifyPassword(request.Password, user.MatKhauHash)) 
        {
            await _authRepository.IncrementLoginAttemptsAsync(request.Username);
            await _authRepository.LogLoginAttemptAsync(request.Username, false, ipAddress, "Invalid Password");
            return null;
        }

        // 4. Success -> Reset Fails & Log
        await _authRepository.ResetLoginAttemptsAsync(request.Username);
        await _authRepository.LogLoginAttemptAsync(request.Username, true, ipAddress, "Success");

        // 5. Generate Real JWT Token
        var token = GenerateJwtToken(user);

        return new LoginResponse
        {
            Username = user.TenDangNhap,
            Role = user.MaVaiTro,
            Token = token,
            FullName = user.HoTenSV ?? user.HoTenGV ?? "Admin",
            MaSV = user.MaSV,
            FirstLogin = user.LanDauDangNhap
        };
    }

    public async Task LogoutAsync(string token)
    {
        // Add to Blacklist (Expire in 4 hours)
        await _authRepository.AddTokenToBlacklistAsync(token, DateTime.UtcNow.AddHours(4), "Logout");
    }

    private bool VerifyPassword(string inputPassword, byte[] storedHash)
    {
        if (storedHash == null || storedHash.Length == 0) return false;

        using (var sha256 = System.Security.Cryptography.SHA256.Create())
        {
            var inputBytes = Encoding.UTF8.GetBytes(inputPassword);
            var computedHash = sha256.ComputeHash(inputBytes);
            
            return computedHash.SequenceEqual(storedHash);
        }
    }

    private string GenerateJwtToken(User user)
    {
        var jwtSettings = _configuration.GetSection("Jwt");
        var key = Encoding.UTF8.GetBytes(jwtSettings["Key"]!);

        var claims = new List<Claim>
        {
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()), // Unique Token ID
            new Claim(ClaimTypes.Name, user.TenDangNhap),
            new Claim(ClaimTypes.Role, user.MaVaiTro),
            new Claim("FullName", user.HoTenSV ?? user.HoTenGV ?? "User")
        };
        
        if (!string.IsNullOrEmpty(user.MaSV)) claims.Add(new Claim("MaSV", user.MaSV));
        if (!string.IsNullOrEmpty(user.MaGV)) claims.Add(new Claim("MaGV", user.MaGV));

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Expires = DateTime.UtcNow.AddHours(4),
            Issuer = jwtSettings["Issuer"],
            Audience = jwtSettings["Audience"],
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var tokenHandler = new JwtSecurityTokenHandler();
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}
