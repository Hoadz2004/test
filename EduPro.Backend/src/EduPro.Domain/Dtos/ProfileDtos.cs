namespace EduPro.Domain.Dtos;

public class ChangePasswordRequest
{
    public string OldPassword { get; set; } = null!;
    public string NewPassword { get; set; } = null!;
}

public class UpdateProfileRequest
{
    public string? Email { get; set; }
    public string? DienThoai { get; set; }
    public string? DiaChi { get; set; }
    public DateTime? NgaySinh { get; set; }
    public string? GioiTinh { get; set; }
}

public class SinhVienProfileDto
{
    public string MaSV { get; set; } = null!;
    public string HoTen { get; set; } = null!;
    public DateTime? NgaySinh { get; set; }
    public string? GioiTinh { get; set; }
    public string? Email { get; set; }
    public string? DienThoai { get; set; }
    public string? DiaChi { get; set; }
    public string? MaNganh { get; set; }
    public string? TenNganh { get; set; }
    public string? TenKhoa { get; set; }
    public string? MaKhoaTS { get; set; }
    public string? TenKhoaTS { get; set; }
    public string? TrangThai { get; set; }
}
