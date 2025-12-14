using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface IMasterDataRepository
{
    Task<IEnumerable<MasterDataDto>> GetFacultiesAsync();
    Task<IEnumerable<MasterDataDto>> GetMajorsAsync();
    Task<IEnumerable<MasterDataDto>> GetSemestersAsync();
    
    Task<IEnumerable<MasterDataDto>> GetAcademicYearsAsync();
    Task<IEnumerable<MasterDataDto>> GetAdmissionBatchesAsync();
    Task<IEnumerable<MasterDataDto>> GetClassroomsAsync();
    Task<IEnumerable<MasterDataDto>> GetShiftsAsync();
    Task<IEnumerable<MasterDataDto>> GetSubjectsAsync();
}
