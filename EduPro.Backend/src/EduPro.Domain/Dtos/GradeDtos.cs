using EduPro.Domain.Entities;

namespace EduPro.Domain.Dtos;

public class LecturerClassDto
{
    public string MaLHP { get; set; } = null!;
    public string TenHP { get; set; } = null!;
    public int SoTinChi { get; set; }
    public int SiSoToiDa { get; set; }
    public int SiSoThucTe { get; set; }
    public byte ThuTrongTuan { get; set; }
    public string MaCa { get; set; } = null!;
    public string MaPhong { get; set; } = null!;
    public decimal TrongSoCC { get; set; }
    public decimal TrongSoGK { get; set; }
    public decimal TrongSoCK { get; set; }
}

public class StudentGradeDto
{
    public string MaSV { get; set; } = null!;
    public string HoTen { get; set; } = null!;
    public string Lop { get; set; } = null!; // Class name
    public decimal DiemCC { get; set; } // DiemQT/CC
    public decimal DiemGK { get; set; }
    public decimal DiemCK { get; set; }
    public decimal? DiemTK { get; set; }
    public string? DiemChu { get; set; }
    public string? KetQua { get; set; }
}

public class UpdateGradeRequest
{
    public string MaLHP { get; set; } = null!;
    public string MaSV { get; set; } = null!;
    public decimal DiemCC { get; set; }
    public decimal DiemGK { get; set; }
    public decimal DiemCK { get; set; }
}
