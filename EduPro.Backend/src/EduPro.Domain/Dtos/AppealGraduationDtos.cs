namespace EduPro.Domain.Dtos;

public class CreateAppealDto
{
    public string MaLHP { get; set; } = string.Empty;
    public string LyDo { get; set; } = string.Empty;
}

public class AppealDto
{
    public int Id { get; set; }
    public string MaLHP { get; set; } = string.Empty;
    public string TenHP { get; set; } = string.Empty;
    public string LyDo { get; set; } = string.Empty;
    public string TrangThai { get; set; } = string.Empty;
    public DateTime NgayGui { get; set; }
    public string? GhiChuXuLy { get; set; }
}

public class GraduationResultDto
{
    public int LanXet { get; set; }
    public string KetQua { get; set; } = string.Empty;
    public string? LyDo { get; set; }
    public DateTime NgayXet { get; set; }
}
