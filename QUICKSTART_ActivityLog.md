# 🚀 QUICKSTART - Real-Time Activity Logging

## Bước 1️⃣: Chạy API Server

**Cách 1: Dùng .bat file**
```bash
cd d:\EduPro\EduPro.Backend
.\Start-RealTime-ActivityLog.bat
```

**Cách 2: Dùng PowerShell**
```bash
cd "d:\EduPro\EduPro.Backend\src\EduPro.API"
dotnet run
```

Bạn sẽ thấy API chạy tại: `http://localhost:5000`

---

## Bước 2️⃣: Mở Cửa Sổ PowerShell Thứ 2

Giữ cửa sổ API chạy, mở PowerShell mới:

```bash
cd d:\EduPro\EduPro.Backend
.\Test-ActivityLogRealTime.ps1
```

Script sẽ:
- ✅ Gọi API login
- ✅ Gọi API logout  
- ✅ Gọi API view
- ✅ Kiểm tra database real-time
- ✅ Hiển thị thống kê

---

## Bước 3️⃣: Kiểm Tra Dữ Liệu Trong Database

Mở PowerShell khác:

```bash
sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 `
  -Q "SELECT TOP 20 MaNhatKy, TenDangNhap, LoaiHoatDong, TrangThai, NgayGio FROM dbo.NhatKyHoatDong ORDER BY MaNhatKy DESC;"
```

Bạn sẽ thấy dữ liệu REAL-TIME được ghi khi API được gọi!

---

## Ví Dụ Kết Quả

```
MaNhatKy  TenDangNhap  LoaiHoatDong  TrangThai  NgayGio
--------  -----------  -----------  ---------  ------------------
    100  admin        LOGIN        SUCCESS    2025-12-11 14:30:45
     99  admin        VIEW         SUCCESS    2025-12-11 14:32:10
     98  admin        LOGOUT       SUCCESS    2025-12-11 14:35:20
```

---

## 🔍 Thay Vì PowerShell, Dùng Postman?

1. **Login:**
```
POST http://localhost:5000/api/auth/login
Content-Type: application/json

{
  "tenDangNhap": "admin",
  "matKhau": "password123"
}
```

2. **View Data:**
```
GET http://localhost:5000/api/student/list
```

3. **Logout:**
```
POST http://localhost:5000/api/auth/logout
```

4. **Kiểm tra Database:**
```bash
sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 `
  -Q "SELECT TOP 10 * FROM NhatKyHoatDong ORDER BY MaNhatKy DESC;"
```

---

## 📊 Xem Thống Kê

```bash
sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 `
  -Q "SELECT LoaiHoatDong, COUNT(*) as SoLan FROM dbo.NhatKyHoatDong GROUP BY LoaiHoatDong ORDER BY SoLan DESC;"
```

Kết quả:
```
LoaiHoatDong  SoLan
-----------  -----
LOGIN          65
VIEW           22
LOGOUT          5
```

---

## 🛠️ Troubleshooting

**Q: API không chạy?**
- Chạy: `dotnet build` trước
- Kiểm tra port 5000 có bị dùng không: `netstat -ano | find "5000"`

**Q: Không thấy dữ liệu trong NhatKyHoatDong?**
- Kiểm tra Middleware đã được đăng ký trong Program.cs
- Kiểm tra Connection String trong appsettings.json
- Xem logs trong API console

**Q: Connection String sai?**
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=202.55.135.42;User Id=sa;Password=Aa@0967941364;Database=EduProDb;TrustServerCertificate=True;"
}
```

---

## ✅ Checklist

- [ ] Database schema tạo (NhatKyHoatDong, SPs)
- [ ] Sample data loaded (41 records)
- [ ] C# code đã tạo (Middleware, Service, AuthController)
- [ ] Program.cs đã cấu hình (DI, Middleware)
- [ ] API server chạy được
- [ ] Dữ liệu ghi real-time vào NhatKyHoatDong

---

✅ **Hệ thống sẵn sàng!**
