using EduPro.Domain.Dtos;

namespace EduPro.Application.Lecturer.Services;

public interface IGradeService
{
    Task<IEnumerable<LecturerClassDto>> GetLecturerClassesAsync(string maGV, int? namHoc = null, int? hocKy = null);
    Task<IEnumerable<StudentGradeDto>> GetClassGradesAsync(string maLHP, string maGV);
    Task UpdateStudentGradeAsync(UpdateGradeRequest request, string maGV);
    Task<IEnumerable<StudentTranscriptDto>> GetStudentGradesAsync(string maSV);
}
