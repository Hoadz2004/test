using EduPro.Domain.Dtos;

namespace EduPro.Application.Admin.Services;

public interface IAdminService
{
    Task<IEnumerable<UserDto>> GetUsersAsync(string? keyword, string? role, int pageNumber, int pageSize);
    Task CreateUserAsync(CreateUserRequest request, string performedBy, string ipAddress);
    Task UpdateUserRoleAsync(UpdateUserRoleRequest request, string performedBy, string ipAddress);
    Task UpdateUserStatusAsync(UpdateUserStatusRequest request, string performedBy, string ipAddress);
    Task<IEnumerable<AuditLogDto>> GetAuditLogsAsync(string? keyword, DateTime? fromDate, DateTime? toDate, string? action, string? status, string? module, int pageNumber, int pageSize);
}
