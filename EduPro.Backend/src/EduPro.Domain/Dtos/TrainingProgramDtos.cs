namespace EduPro.Domain.Dtos;

public class CreateCTDTRequest
{
    public string MaNganh { get; set; } = null!;
    public string MaKhoaTS { get; set; } = null!;
    public string TenCTDT { get; set; } = null!;
    public int NamBanHanh { get; set; }
    public int TrangThai { get; set; }
}

public class AddSubjectRequest
{
    public int MaCTDT { get; set; }
    public string MaHP { get; set; } = null!;
    public int HocKyDuKien { get; set; }
    public bool BatBuoc { get; set; }
    public string? NhomTuChon { get; set; }
}

public class AddPrerequisiteRequest
{
    public string MaHP { get; set; } = null!;
    public string MaHP_TienQuyet { get; set; } = null!;
}

public class CTDTDto
{
    public int MaCTDT { get; set; }
    public string MaNganh { get; set; } = null!;
    public string TenNganh { get; set; } = null!;
    public string MaKhoaTS { get; set; } = null!;
    public string TenKhoaTS { get; set; } = null!;
    public string TenCTDT { get; set; } = null!;
    public int NamBanHanh { get; set; }
    public int TrangThai { get; set; } // 1: Active, 0: Draft
    public int TotalRecords { get; set; }
}

public class CTDTDetailDto : CTDTDto
{
    public List<CTDTSubjectDto> Subjects { get; set; } = new();
}

public class CTDTSubjectDto
{
    public int Id { get; set; }
    public int MaCTDT { get; set; }
    public string MaHP { get; set; } = null!;
    public string TenHP { get; set; } = null!;
    public int SoTinChi { get; set; }
    public int HocKyDuKien { get; set; }
    public bool BatBuoc { get; set; }
    public string? NhomTuChon { get; set; }
    public string? MonTienQuyet { get; set; } // Comma separated IDs
}

public class StudentCurriculumDto
{
    public int MaCTDT { get; set; }
    public string TenCTDT { get; set; } = null!;
    public List<StudentSubjectStatusDto> Subjects { get; set; } = new();
}

public class StudentSubjectStatusDto
{
    public string MaHP { get; set; } = null!;
    public string TenHP { get; set; } = null!;
    public int SoTinChi { get; set; }
    public int HocKyDuKien { get; set; }
    public bool BatBuoc { get; set; }
    public double Diem { get; set; }
    public string Status { get; set; } = null!; // Passed, Failed, NotTaken
}
