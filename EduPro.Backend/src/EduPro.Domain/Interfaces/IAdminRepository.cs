using EduPro.Domain.Dtos;
using EduPro.Domain.Entities;

namespace EduPro.Domain.Interfaces;

public interface IAdminRepository
{
    Task<IEnumerable<UserDto>> GetUsersAsync(string? keyword, string? role, int pageNumber, int pageSize);
    Task CreateUserAsync(CreateUserRequest request, byte[] passwordHash, string performedBy, string ipAddress);
    Task UpdateUserRoleAsync(string username, string newRole, string performedBy, string ipAddress);
    Task UpdateUserStatusAsync(string username, bool isLocked, string reason, string performedBy, string ipAddress);
    Task<IEnumerable<AuditLogDto>> GetAuditLogsAsync(string? keyword, DateTime? fromDate, DateTime? toDate, string? action, string? status, string? module, int pageNumber, int pageSize);
    Task LogAuditAsync(AuditLog log);
}
