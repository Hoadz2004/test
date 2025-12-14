using System.Threading.Tasks;

namespace EduPro.Application.Services
{
    /// <summary>
    /// Interface cho dịch vụ nhật ký hoạt động
    /// Ghi log tất cả hoạt động của người dùng vào database REAL-TIME
    /// </summary>
    public interface IActivityLogService
    {
        /// <summary>
        /// Ghi nhật ký hoạt động
        /// </summary>
        /// <param name="tenDangNhap">Tên đăng nhập người dùng</param>
        /// <param name="loaiHoatDong">Loại hoạt động (LOGIN, LOGOUT, VIEW, CREATE, UPDATE, DELETE, ERROR)</param>
        /// <param name="moDun">Module/Đường dẫn API</param>
        /// <param name="moTa">Mô tả chi tiết hoạt động</param>
        /// <param name="diaChiIP">Địa chỉ IP của người dùng</param>
        /// <param name="trangThai">Trạng thái (SUCCESS, FAILED, ERROR)</param>
        Task LogActivityAsync(string tenDangNhap, string loaiHoatDong, string moDun, string moTa, string diaChiIP, string trangThai);

        /// <summary>
        /// Ghi nhật ký đăng nhập thành công
        /// Cập nhật thông tin tài khoản: LanDangNhapCuoi, DiaChiIPCuoi, SoLanDangNhapThatBai
        /// </summary>
        Task LogLoginSuccessAsync(string tenDangNhap, string diaChiIP);

        /// <summary>
        /// Ghi nhật ký đăng nhập thất bại
        /// Tăng SoLanDangNhapThatBai, khóa tài khoản nếu >= 5 lần
        /// </summary>
        Task LogLoginFailureAsync(string tenDangNhap, string diaChiIP, string lyDo);

        /// <summary>
        /// Ghi nhật ký đăng xuất
        /// </summary>
        Task LogLogoutAsync(string tenDangNhap, string diaChiIP);
    }
}
