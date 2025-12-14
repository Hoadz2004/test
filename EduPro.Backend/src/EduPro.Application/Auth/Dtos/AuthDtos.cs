namespace EduPro.Application.Auth.Dtos;

public class LoginRequest
{
    public string Username { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}

public class LoginResponse
{
    public string Username { get; set; } = string.Empty;
    public string Role { get; set; } = string.Empty;
    public string Token { get; set; } = string.Empty; // JWT simplified
    public string FullName { get; set; } = string.Empty;
    public string? MaSV { get; set; }
    public bool FirstLogin { get; set; }  // true if first login, needs password change
}
