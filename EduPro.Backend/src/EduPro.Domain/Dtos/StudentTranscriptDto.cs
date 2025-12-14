namespace EduPro.Domain.Dtos;

public class StudentTranscriptDto
{
    public string TenHK { get; set; } = string.Empty;
    public string MaLHP { get; set; } = string.Empty;
    public string TenHP { get; set; } = string.Empty;
    public int SoTinChi { get; set; }
    public decimal? DiemQT { get; set; }
    public decimal? DiemGK { get; set; }
    public decimal? DiemCK { get; set; }
    public decimal? DiemTK { get; set; }
    public string? DiemChu { get; set; }
    public decimal? DiemHe4 { get; set; }
    public string? KetQua { get; set; }
}
