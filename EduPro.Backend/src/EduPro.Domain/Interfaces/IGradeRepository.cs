using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface IGradeRepository
{
    Task<IEnumerable<LecturerClassDto>> GetLecturerClassesAsync(string maGV, int? namHoc = null, int? hocKy = null);
    Task<IEnumerable<StudentGradeDto>> GetClassGradesAsync(string maLHP);
    Task UpdateStudentGradeAsync(UpdateGradeRequest request, string performedBy);
    Task<bool> IsLecturerTeachingClassAsync(string maGV, string maLHP);
    Task<IEnumerable<StudentTranscriptDto>> GetStudentGradesAsync(string maSV);
}
