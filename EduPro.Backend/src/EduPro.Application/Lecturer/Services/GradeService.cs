using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;

namespace EduPro.Application.Lecturer.Services;

public class GradeService : IGradeService
{
    private readonly IGradeRepository _repository;

    public GradeService(IGradeRepository repository)
    {
        _repository = repository;
    }

    public async Task<IEnumerable<LecturerClassDto>> GetLecturerClassesAsync(string maGV, int? namHoc = null, int? hocKy = null)
    {
        return await _repository.GetLecturerClassesAsync(maGV, namHoc, hocKy);
    }

    public async Task<IEnumerable<StudentGradeDto>> GetClassGradesAsync(string maLHP, string maGV)
    {
        // Security Check: Ensure Lecturer teaches this class
        var isAuthorized = await _repository.IsLecturerTeachingClassAsync(maGV, maLHP);
        if (!isAuthorized)
        {
            throw new UnauthorizedAccessException("You are not authorized to view grades for this class.");
        }

        return await _repository.GetClassGradesAsync(maLHP);
    }

    public async Task UpdateStudentGradeAsync(UpdateGradeRequest request, string maGV)
    {
        // Security Check
        var isAuthorized = await _repository.IsLecturerTeachingClassAsync(maGV, request.MaLHP);
        if (!isAuthorized)
        {
            throw new UnauthorizedAccessException("You are not authorized to update grades for this class.");
        }

        // Logic here: Maybe check if grade entry is locked (deadline)?
        // For now, proceed.
        await _repository.UpdateStudentGradeAsync(request, maGV);
    }

    public async Task<IEnumerable<StudentTranscriptDto>> GetStudentGradesAsync(string maSV)
    {
        return await _repository.GetStudentGradesAsync(maSV);
    }
}
