namespace EduPro.Domain.Dtos;

public class ClassDto
{
    public string MaLHP { get; set; } = string.Empty;
    public string MaHP { get; set; } = string.Empty;
    public string TenHP { get; set; } = string.Empty;
    public int SoTinChi { get; set; }
    public string MaHK { get; set; } = string.Empty;
    public string TenHK { get; set; } = string.Empty;
    public string MaNam { get; set; } = string.Empty;
    public int? NamBatDau { get; set; }
    public string MaGV { get; set; } = string.Empty;
    public string TenGV { get; set; } = string.Empty;
    public string? MaKhoa { get; set; }
    public string? MaNganh { get; set; }
    public string MaPhong { get; set; } = string.Empty;
    public string TenPhong { get; set; } = string.Empty;
    public string MaCa { get; set; } = string.Empty;
    public string TenCa { get; set; } = string.Empty;
    public int ThuTrongTuan { get; set; }
    public int SiSoToiDa { get; set; }
    public int SiSoHienTai { get; set; }
    public string? GhiChu { get; set; }
    public DateTime? NgayBatDau { get; set; }
    public DateTime? NgayKetThuc { get; set; }
    public int SoBuoiHoc { get; set; } = 13;
    public int SoBuoiTrongTuan { get; set; } = 1;
    public string TrangThaiLop { get; set; } = "Sắp khai giảng";
    public string TrangThaiCode { get; set; } = "PLANNED";
    public int TotalRecords { get; set; }
}

public class CreateClassDto
{
    public string MaLHP { get; set; } = string.Empty;
    public string MaHP { get; set; } = string.Empty;
    public string MaHK { get; set; } = string.Empty;
    public string MaNam { get; set; } = string.Empty;
    public string MaGV { get; set; } = string.Empty;
    public string MaPhong { get; set; } = string.Empty;
    public string MaCa { get; set; } = string.Empty;
    public int ThuTrongTuan { get; set; }
    public int SiSoToiDa { get; set; }
    public string? GhiChu { get; set; }
    public DateTime? NgayBatDau { get; set; }
    public DateTime? NgayKetThuc { get; set; }
    public int SoBuoiHoc { get; set; } = 13;
    public int SoBuoiTrongTuan { get; set; } = 1;
    public string TrangThaiLop { get; set; } = "Sắp khai giảng";
    public string TrangThaiCode { get; set; } = "PLANNED";
}

public class UpdateClassDto
{
    public string MaLHP { get; set; } = string.Empty;
    public string MaHP { get; set; } = string.Empty;
    public string MaHK { get; set; } = string.Empty;
    public string MaNam { get; set; } = string.Empty;
    public string MaGV { get; set; } = string.Empty;
    public string MaPhong { get; set; } = string.Empty;
    public string MaCa { get; set; } = string.Empty;
    public int ThuTrongTuan { get; set; }
    public int SiSoToiDa { get; set; }
    public string? GhiChu { get; set; }
    public DateTime? NgayBatDau { get; set; }
    public DateTime? NgayKetThuc { get; set; }
    public int SoBuoiHoc { get; set; } = 13;
    public int SoBuoiTrongTuan { get; set; } = 1;
    public string? TrangThaiLop { get; set; }
    public string? TrangThaiCode { get; set; }
}

public class ConflictCheckRequest
{
    public string? MaLHP { get; set; }
    public string MaNam { get; set; } = string.Empty;
    public string MaHK { get; set; } = string.Empty;
    public int Thu { get; set; }
    public string MaCa { get; set; } = string.Empty;
    public string? MaPhong { get; set; }
    public string? MaGV { get; set; }
}

public class ConflictCheckResult
{
    public bool IsConflict { get; set; }
    public string ConflictMessage { get; set; } = string.Empty;
}
