using EduPro.Domain.Dtos;

namespace EduPro.Domain.Interfaces;

public interface ITuitionAdminRepository
{
    Task<IEnumerable<HocPhanAdminDto>> GetCoursesAsync(int pageNumber, int pageSize);
    Task UpsertCourseAsync(HocPhanAdminDto dto);
    Task DeleteCourseAsync(string maHP);

    Task<IEnumerable<HocPhiCatalogDto>> GetFeeCatalogAsync(int pageNumber, int pageSize);
    Task<HocPhiCatalogDto?> GetFeeByMajorSemesterAsync(string maNganh, string maHK);
    Task<int> UpsertFeeCatalogAsync(HocPhiCatalogDto dto);
    Task DeleteFeeCatalogAsync(int id);
}
