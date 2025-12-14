namespace EduPro.Domain.Dtos;

public class MasterDataDto
{
    public string Ma { get; set; } = string.Empty;
    public string Ten { get; set; } = string.Empty;
    public string? MaKhoa { get; set; } // Optional: For Majors belonging to a Faculty
}
