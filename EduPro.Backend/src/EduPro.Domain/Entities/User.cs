namespace EduPro.Domain.Entities;

public class User
{
    public string TenDangNhap { get; set; } = null!;
    public byte[] MatKhauHash { get; set; } = null!;
    public string MaVaiTro { get; set; } = null!;
    public string? MaSV { get; set; }
    public string? MaGV { get; set; }
    public string? HoTenSV { get; set; }
    public string? HoTenGV { get; set; }

    // Security Columns
    public int SoLanDangNhapThatBai { get; set; }
    public DateTime? KhoaLuc { get; set; }
    public string? DiaChiIPCuoi { get; set; }
    
    // First Login Flag
    public bool LanDauDangNhap { get; set; }
}

