using Dapper;
using EduPro.Application.Common.Interfaces;
using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Data;

namespace EduPro.Infrastructure.Repositories;

public class GradeRepository : IGradeRepository
{
    private readonly ISqlConnectionFactory _connectionFactory;

    public GradeRepository(ISqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<IEnumerable<LecturerClassDto>> GetLecturerClassesAsync(string maGV, int? namHoc = null, int? hocKy = null)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<LecturerClassDto>(
            "sp_Lecturer_GetClasses",
            new { MaGV = maGV, NamHoc = namHoc, HocKy = hocKy },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<IEnumerable<StudentGradeDto>> GetClassGradesAsync(string maLHP)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<StudentGradeDto>(
            "sp_Lecturer_GetClassGrades",
            new { MaLHP = maLHP },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task UpdateStudentGradeAsync(UpdateGradeRequest request, string performedBy)
    {
        using var connection = _connectionFactory.CreateConnection();
        await connection.ExecuteAsync(
            "sp_Lecturer_UpdateGrade",
            new 
            { 
                MaLHP = request.MaLHP, 
                MaSV = request.MaSV, 
                DiemCC = request.DiemCC, 
                DiemGK = request.DiemGK, 
                DiemCK = request.DiemCK,
                PerformedBy = performedBy
            },
            commandType: CommandType.StoredProcedure
        );
    }

    public async Task<bool> IsLecturerTeachingClassAsync(string maGV, string maLHP)
    {
        using var connection = _connectionFactory.CreateConnection();
        var count = await connection.ExecuteScalarAsync<int>(
            "SELECT COUNT(1) FROM LopHocPhan WHERE MaLHP = @MaLHP AND MaGV = @MaGV",
            new { MaLHP = maLHP, MaGV = maGV }
        );
        return count > 0;
    }

    public async Task<IEnumerable<StudentTranscriptDto>> GetStudentGradesAsync(string maSV)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QueryAsync<StudentTranscriptDto>(
            "sp_Student_GetGrades",
            new { MaSV = maSV },
            commandType: CommandType.StoredProcedure
        );
    }
}
