namespace EduPro.Domain.Dtos;

public class CreateAdmissionRequest
{
    public string FullName { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? CCCD { get; set; }
    public DateTime? NgaySinh { get; set; }
    public string? DiaChi { get; set; }
    public string? MaNam { get; set; }
    public string? MaHK { get; set; }
    public string? MaNganh { get; set; }
    public string? GhiChu { get; set; }
    public string? Mon1 { get; set; }
    public string? Mon2 { get; set; }
    public string? Mon3 { get; set; }
    public decimal? Diem1 { get; set; }
    public decimal? Diem2 { get; set; }
    public decimal? Diem3 { get; set; }
}

public class AdmissionDto
{
    public int Id { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? MaHK { get; set; }
    public string? MaNganh { get; set; }
    public string TrangThai { get; set; } = string.Empty;
    public string MaTraCuu { get; set; } = string.Empty;
    public DateTime NgayNop { get; set; }
    public DateTime NgayCapNhat { get; set; }
    public string? GhiChu { get; set; }
    public string? Mon1 { get; set; }
    public string? Mon2 { get; set; }
    public string? Mon3 { get; set; }
    public decimal? Diem1 { get; set; }
    public decimal? Diem2 { get; set; }
    public decimal? Diem3 { get; set; }
    public int TotalRecords { get; set; }
}

public class UpdateAdmissionStatusRequest
{
    public int Id { get; set; }
    public string TrangThai { get; set; } = string.Empty;
    public string? GhiChu { get; set; }
}

public class AdmissionFilter
{
    public string? MaHK { get; set; }
    public string? MaNganh { get; set; }
    public string? TrangThai { get; set; }
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 20;
}

public class SaveScoresRequest
{
    public int AdmissionId { get; set; }
    public string Mon1 { get; set; } = string.Empty;
    public decimal Diem1 { get; set; }
    public string Mon2 { get; set; } = string.Empty;
    public decimal Diem2 { get; set; }
    public string Mon3 { get; set; } = string.Empty;
    public decimal Diem3 { get; set; }
    public string? GhiChu { get; set; }
}

public class ScoreResult
{
    public decimal TongDiem { get; set; }
    public string TrangThai { get; set; } = string.Empty;
}

public class AdmissionRequirementDto
{
    public string MaNganh { get; set; } = string.Empty;
    public string? Mon1 { get; set; }
    public string? Mon2 { get; set; }
    public string? Mon3 { get; set; }
    public decimal HeSo1 { get; set; }
    public decimal HeSo2 { get; set; }
    public decimal HeSo3 { get; set; }
    public decimal? DiemChuan { get; set; }
    public DateTime? HieuLucTu { get; set; }
    public DateTime? HieuLucDen { get; set; }
}
