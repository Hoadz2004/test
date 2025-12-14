using System.Threading.Tasks;

namespace EduPro.Application.Services
{
    public interface IActivityLogService
    {
        Task LogActivityAsync(string tenDangNhap, string loaiHoatDong, string moDun, string moTa, string diaChiIP, string trangThai);
        Task LogLoginSuccessAsync(string tenDangNhap, string diaChiIP);
        Task LogLoginFailureAsync(string tenDangNhap, string diaChiIP, string lyDo);
        Task LogLogoutAsync(string tenDangNhap, string diaChiIP);
    }
}
