using EduPro.Domain.Dtos;
using EduPro.Domain.Interfaces;
using System.Security.Cryptography;
using System.Text;

namespace EduPro.Application.Admin.Services;

public class AdminService : IAdminService
{
    private readonly IAdminRepository _repository;

    public AdminService(IAdminRepository repository)
    {
        _repository = repository;
    }

    public async Task<IEnumerable<UserDto>> GetUsersAsync(string? keyword, string? role, int pageNumber, int pageSize)
    {
        return await _repository.GetUsersAsync(keyword, role, pageNumber, pageSize);
    }

    public async Task CreateUserAsync(CreateUserRequest request, string performedBy, string ipAddress)
    {
        // Hash Password
        byte[] hashBytes;
        using (var sha256 = SHA256.Create())
        {
            var inputBytes = Encoding.UTF8.GetBytes(request.MatKhau);
            hashBytes = sha256.ComputeHash(inputBytes);
        }

        await _repository.CreateUserAsync(request, hashBytes, performedBy, ipAddress);
    }

    public async Task UpdateUserRoleAsync(UpdateUserRoleRequest request, string performedBy, string ipAddress)
    {
        await _repository.UpdateUserRoleAsync(request.TenDangNhap, request.NewRole, performedBy, ipAddress);
    }

    public async Task UpdateUserStatusAsync(UpdateUserStatusRequest request, string performedBy, string ipAddress)
    {
        await _repository.UpdateUserStatusAsync(request.TenDangNhap, request.IsLocked, request.Reason, performedBy, ipAddress);
    }

    public async Task<IEnumerable<AuditLogDto>> GetAuditLogsAsync(string? keyword, DateTime? fromDate, DateTime? toDate, string? action, string? status, string? module, int pageNumber, int pageSize)
    {
        return await _repository.GetAuditLogsAsync(keyword, fromDate, toDate, action, status, module, pageNumber, pageSize);
    }
}
