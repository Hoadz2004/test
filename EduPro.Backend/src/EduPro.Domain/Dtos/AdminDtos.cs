namespace EduPro.Domain.Dtos;

public class CreateUserRequest
{
    public string TenDangNhap { get; set; } = null!;
    public string MatKhau { get; set; } = null!;
    public string MaVaiTro { get; set; } = null!; // ADMIN, SINHVIEN, GIANGVIEN
    public string HoTen { get; set; } = null!;
    
    // Optional fields for SV/GV
    public string? Email { get; set; }
    public string? DienThoai { get; set; }
    public DateTime? NgaySinh { get; set; }
    public string? GioiTinh { get; set; }
    public string? MaNganh { get; set; }  // Required for SV
    public string? MaKhoa { get; set; }   // Required for SV, GV
}

public class UpdateUserStatusRequest
{
    public string TenDangNhap { get; set; } = null!;
    public bool IsLocked { get; set; }
    public string Reason { get; set; } = null!;
}

public class UpdateUserRoleRequest
{
    public string TenDangNhap { get; set; } = null!;
    public string NewRole { get; set; } = null!;
}

public class UserDto
{
    public string TenDangNhap { get; set; } = null!;
    public string MaVaiTro { get; set; } = null!;
    public bool TrangThai { get; set; }
    public DateTime NgayTao { get; set; }
    public string? HoTenSV { get; set; }
    public string? HoTenGV { get; set; }
    public DateTime? KhoaLuc { get; set; }
    public int TotalRecords { get; set; } // For Pagination
}

public class AuditLogDto
{
    public int LogId { get; set; }
    public string Action { get; set; } = null!;
    public string EntityTable { get; set; } = null!;
    public string EntityId { get; set; } = null!;
    public string? OldValue { get; set; }
    public string? NewValue { get; set; }
    public string PerformedBy { get; set; } = null!;
    public DateTime Timestamp { get; set; }
    public string? IPAddress { get; set; }
    public string? Status { get; set; }
    public string? Module { get; set; }
    public int TotalRecords { get; set; }
}
