namespace EduPro.Domain.Dtos;

public class EligibleSubjectDto
{
    public string MaLHP { get; set; } = string.Empty;
    public string TenHP { get; set; } = string.Empty;
    public decimal? DiemTK { get; set; }
    public DateTime NgayCongBo { get; set; }
}
