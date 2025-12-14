namespace EduPro.Domain.Dtos;

public class CourseOfferingDto
{
    public string MaLHP { get; set; } = string.Empty;
    public string TenHP { get; set; } = string.Empty;
    public int SoTinChi { get; set; }
    public int SiSoToiDa { get; set; }
    public int SiSoHienTai { get; set; }
    public string? GiangVien { get; set; }
    public string? LichHoc { get; set; }
    public int ThuTrongTuan { get; set; }
    public string MaCa { get; set; } = string.Empty;
    public string MaPhong { get; set; } = string.Empty;
    public string? TrangThaiLop { get; set; }
    public string? TrangThaiCode { get; set; }
    public bool CoTheDangKy { get; set; }
    public string? LyDoKhongDangKy { get; set; }
}

public class RegisteredCourseDto
{
    public string MaLHP { get; set; } = string.Empty;
    public string TenHP { get; set; } = string.Empty;
    public int SoTinChi { get; set; }
    public int ThuTrongTuan { get; set; }
    public string MaCa { get; set; } = string.Empty;
    public string MaPhong { get; set; } = string.Empty;
    public string TrangThai { get; set; } = string.Empty;
    public DateTime? NgayDangKy { get; set; }
}

public class EnrollmentRequest
{
    public string MaSV { get; set; } = string.Empty;
    public string MaLHP { get; set; } = string.Empty;
}
