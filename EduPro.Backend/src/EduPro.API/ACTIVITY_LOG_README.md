# REAL-TIME Activity Logging System

## 📋 Giới Thiệu

Hệ thống **REAL-TIME Activity Logging** ghi nhật ký tất cả hoạt động của người dùng khi họ tương tác với API:

- ✅ **LOGIN**: Ghi khi người dùng đăng nhập (thành công/thất bại)
- ✅ **LOGOUT**: Ghi khi người dùng đăng xuất
- ✅ **VIEW**: Ghi khi người dùng xem dữ liệu (GET request)
- ✅ **CREATE**: Ghi khi tạo dữ liệu mới (POST request)
- ✅ **UPDATE**: Ghi khi sửa dữ liệu (PUT/PATCH request)
- ✅ **DELETE**: Ghi khi xóa dữ liệu (DELETE request)
- ✅ **ERROR**: Ghi khi có lỗi

## 🏗️ Kiến Trúc

### 1. **Middleware** (`ActivityLogMiddleware.cs`)
```
Mỗi HTTP Request
    ↓
[ActivityLogMiddleware] ← Chặn request
    ↓
Xác định loại hoạt động (LOGIN, VIEW, CREATE, ...)
    ↓
Lấy địa chỉ IP của client
    ↓
Gọi IActivityLogService.LogActivityAsync()
    ↓
[Ghi vào NhatKyHoatDong]
    ↓
Response trả về client
```

### 2. **Service Layer** (`IActivityLogService`)
- `LogActivityAsync()` - Ghi log chung
- `LogLoginSuccessAsync()` - Ghi login thành công, cập nhật TaiKhoan
- `LogLoginFailureAsync()` - Ghi login thất bại, tăng đếm lỗi
- `LogLogoutAsync()` - Ghi logout

### 3. **Controller** (`AuthController.cs`)
Gọi `_activityLogService` trực tiếp khi xử lý login/logout.

### 4. **Database** (`NhatKyHoatDong` table)
Lưu trữ tất cả hoạt động với:
- MaNhatKy (Identity PK)
- TenDangNhap (người dùng)
- LoaiHoatDong (LOGIN, VIEW, CREATE, ...)
- MoDun (API endpoint)
- MoTa (mô tả chi tiết)
- DiaChiIP (IP address)
- TrangThai (SUCCESS, FAILED, ERROR)
- NgayGio (timestamp)

## 🚀 Cách Sử Dụng

### Bước 1: Đảm bảo Database Schema đã chuẩn bị
```bash
sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 `
  -i "d:\EduPro\EduPro.Backend\database\data dữ liệu\SampleData_05_ActivityLog.sql" ; `
sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 `
  -i "d:\EduPro\EduPro.Backend\database\data dữ liệu\SampleData_05_ActivityLog_RealTime.sql"
```

### Bước 2: Kiểm tra Middleware đã được đăng ký
Mở `EduPro.API/Program.cs`:
```csharp
// Dòng 1-16: Import
using EduPro.Application.Services;
using EduPro.Application.Services.Implementations;
using EduPro.API.Middleware;

// Dòng ~65: DI Registration
builder.Services.AddScoped<IActivityLogService, ActivityLogService>();

// Dòng ~75: Middleware
app.UseMiddleware<ActivityLogMiddleware>();
```

### Bước 3: Build & Run API
```bash
cd "d:\EduPro\EduPro.Backend\src\EduPro.API"
dotnet build
dotnet run
```

### Bước 4: Gọi API từ Postman hoặc Frontend
```
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "tenDangNhap": "admin",
  "matKhau": "password123"
}
```

### Bước 5: Kiểm tra dữ liệu trong Database
```bash
sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 `
  -i "d:\EduPro\EduPro.Backend\database\data dữ liệu\VERIFY_RealTime_ActivityLog.sql"
```

Bạn sẽ thấy:
- ✅ NhatKyHoatDong mới nhất
- ✅ Thống kê theo loại hoạt động
- ✅ Danh sách người dùng hoạt động nhất
- ✅ IP address mỗi lần truy cập

## 📊 Ví Dụ Dữ Liệu Real-Time

Khi người dùng admin gọi login API:
```
MaNhatKy     = 1001
TenDangNhap  = admin
LoaiHoatDong = LOGIN
MoDun        = /api/auth/login
MoTa         = Đăng nhập hệ thống
DiaChiIP     = 192.168.1.50
TrangThai    = SUCCESS
NgayGio      = 2025-12-11 14:30:45.123
```

Khi cùng người dùng đó xem danh sách học phần:
```
MaNhatKy     = 1002
TenDangNhap  = admin
LoaiHoatDong = VIEW
MoDun        = /api/class/list
MoTa         = Xem class
DiaChiIP     = 192.168.1.50
TrangThai    = SUCCESS
NgayGio      = 2025-12-11 14:32:10.456
```

## 🔒 Bảo Mật

- **Khóa tài khoản**: Tự động khóa sau 5 lần đăng nhập thất bại
- **IP Tracking**: Theo dõi tất cả IP address truy cập
- **Audit Trail**: Lưu lịch sử đầy đủ mọi hoạt động
- **Real-Time**: Không có delay giữa hành động và ghi log

## ⚙️ Cấu Hình

### Lấy IP Address từ Headers
Nếu API phía sau proxy (IIS, Nginx, Cloudflare):
```csharp
// Tự động kiểm tra theo thứ tự:
1. X-Forwarded-For (Nginx, Apache)
2. CF-Connecting-IP (Cloudflare)
3. RemoteIpAddress (Direct connection)
```

### Bỏ qua một số Endpoint
Sửa `ActivityLogMiddleware.InvokeAsync()`:
```csharp
if (context.Request.Path.StartsWithSegments("/health") ||
    context.Request.Path.StartsWithSegments("/api/health") ||
    context.Request.Path.StartsWithSegments("/api/auth/refresh-token"))
{
    await _next(context);
    return;
}
```

## 🐛 Troubleshooting

### Q: Không thấy dữ liệu trong NhatKyHoatDong?
- ✅ Kiểm tra Middleware đã được thêm vào Program.cs
- ✅ Kiểm tra Connection String trong appsettings.json
- ✅ Kiểm tra sp_GhiNhatKyHoatDong tồn tại trên database
- ✅ Xem logs API console để debug

### Q: Tại sao login thất bại được ghi nhưng login thành công không?
- ✅ Kiểm tra AuthController đã gọi `LogLoginSuccessAsync()`
- ✅ Kiểm tra logic ValidateCredentials()

### Q: IP lúc nào hiển thị "Unknown"?
- ✅ Máy client có thể không gửi X-Forwarded-For header
- ✅ Hoặc api chạy trên localhost với ngrok/tunneling

## 📈 Dashboard (Tương Lai)

Frontend có thể:
1. Gọi API `/api/activitylog/user/{username}` để xem lịch sử người dùng
2. Gọi API `/api/activitylog/stats` để xem thống kê hoạt động
3. Hiển thị real-time dashboard với SignalR

## 🔗 Liên Quan

- `SampleData_05_ActivityLog.sql` - Database schema
- `SampleData_05_ActivityLog_RealTime.sql` - Stored Procedures
- `VERIFY_RealTime_ActivityLog.sql` - Query kiểm tra
- `WORKFLOW_ActivityLog.sql` - Workflow documentation

---

✅ **Hệ thống REAL-TIME Activity Logging đã sẵn sàng để deploy!**
