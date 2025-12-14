namespace EduPro.Domain.Constants;

/// <summary>
/// Class Management Error Messages
/// Tuân theo chuẩn tiếng Việt của SQL Server (N'text')
/// </summary>
public static class ClassManagementErrors
{
    // Validation Errors - Match with SQL Server RAISERROR messages
    public const string CLASS_CODE_ALREADY_EXISTS = "Mã lớp học phần đã tồn tại.";
    public const string CLASSROOM_CONFLICT = "Phòng học đã bị trùng lịch trong ngày và ca này.";
    public const string LECTURER_CONFLICT = "Giảng viên đã có lịch dạy trong ngày và ca này.";
    public const string CLASS_CODE_NOT_FOUND = "Mã lớp học phần không tồn tại.";
    public const string CANNOT_DELETE_CLASS_WITH_STUDENTS = "Không thể xóa lớp học phần đã có sinh viên đăng ký.";
    
    // Generic Errors
    public const string GENERIC_ERROR = "Có lỗi xảy ra. Vui lòng thử lại.";
    public const string CREATE_ERROR = "Không thể mở lớp. Vui lòng thử lại.";
    public const string UPDATE_ERROR = "Không thể cập nhật lớp. Vui lòng thử lại.";
    public const string DELETE_ERROR = "Không thể xóa lớp. Vui lòng thử lại.";
}

/// <summary>
/// Class Status Constants
/// Tuân theo chuẩn từ database và frontend
/// </summary>
public static class ClassStatus
{
    public const string NEW = "Sắp khai giảng";           // Chưa bắt đầu
    public const string ACTIVE = "Đang khai giảng";       // Đang diễn ra
    public const string CLOSED = "Kết thúc";              // Đã kết thúc
    public const string CANCELLED = "Hủy";                // Đã hủy
}

/// <summary>
/// Success Messages
/// </summary>
public static class SuccessMessages
{
    public const string CLASS_CREATED = "Mở lớp thành công!";
    public const string CLASS_UPDATED = "Cập nhật lớp thành công!";
    public const string CLASS_DELETED = "Xóa lớp thành công!";
}
