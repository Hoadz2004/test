namespace EduPro.Domain.Dtos;

public class StudentProfileDto
{
    public string MaSV { get; set; } = string.Empty;
    public string HoTen { get; set; } = string.Empty;
    public DateTime NgaySinh { get; set; }
    public string GioiTinh { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string DienThoai { get; set; } = string.Empty;
    public string LopHanhChinh { get; set; } = string.Empty;
    public string MaNganh { get; set; } = string.Empty;
    public string TenNganh { get; set; } = string.Empty;
    public string MaKhoaTS { get; set; } = string.Empty;
    public string TenKhoaTS { get; set; } = string.Empty;
    public string TrangThai { get; set; } = string.Empty;
}
