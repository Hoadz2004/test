namespace EduPro.API.Settings;

public class VnPaySettings
{
    public string TmnCode { get; set; } = string.Empty;
    public string HashSecret { get; set; } = string.Empty;
    public string PayUrl { get; set; } = string.Empty;
    public string ReturnUrl { get; set; } = string.Empty; // server callback
    public string ClientReturnUrl { get; set; } = string.Empty; // frontend redirect
}
