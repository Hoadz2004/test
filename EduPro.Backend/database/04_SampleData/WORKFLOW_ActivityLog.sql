-- =============================================
-- QUY TRÌNH (WORKFLOW) NHẬT KÝ HOẠT ĐỘNG
-- =============================================

/*
┌─────────────────────────────────────────────────────────────────────────────┐
│                   WORKFLOW NHẬT KÝ HOẠT ĐỘNG (Activity Log)                 │
└─────────────────────────────────────────────────────────────────────────────┘

=== 1. BẢNG DỮ LIỆU ===

Bảng: TaiKhoan (Tài khoản)
├─ Cột: TenDangNhap (Tên đăng nhập)
├─ Cột: LanDangNhapCuoi (Lần đăng nhập cuối) ← Cập nhật từ nhật ký hoạt động
├─ Cột: DangNhapLanCuoi (Thời gian đăng nhập cuối cùng)
├─ Cột: DiaChiIPCuoi (IP lần đăng nhập cuối) ← Cập nhật từ nhật ký hoạt động
└─ Cột: SoLanDangNhapThatBai (Số lần đăng nhập thất bại)

Bảng: NhatKyHoatDong (Nhật ký hoạt động)
├─ Cột: MaNhatKy (ID, khóa chính)
├─ Cột: TenDangNhap (Ai thực hiện - FK tới TaiKhoan)
├─ Cột: LoaiHoatDong (LOGIN, LOGOUT, VIEW, CREATE, UPDATE, DELETE)
├─ Cột: MoDun (Module nào - Dashboard, Courses, Grades, etc.)
├─ Cột: MoTa (Mô tả chi tiết hoạt động)
├─ Cột: DiaChiIP (Địa chỉ IP của người dùng)
├─ Cột: TrangThai (SUCCESS, FAILED, ERROR)
└─ Cột: NgayGio (Khi nào xảy ra - GETDATE())


=== 2. QUY TRÌNH ĐĂNG NHẬP (LOGIN WORKFLOW) ===

┌──────────────────────────────────────────────────────────────┐
│                    NGƯỜI DÙNG ĐĂNG NHẬP                      │
│                (Frontend/Mobile App)                         │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│   Backend API: Controller.cs (AuthController)                │
│   POST /api/auth/login                                       │
│   - Nhận: TenDangNhap, MatKhau, DiaChiIP                    │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
        ┌─────────────────────────────────────┐
        │  Kiểm tra TenDangNhap có tồn tại?   │
        └────┬──────────────────────────┬──────┘
       KHÔNG │                          │ CÓ
             │                          ▼
             │      ┌──────────────────────────────────┐
             │      │  Kiểm tra Mật khẩu + TrangThai   │
             │      │  của TaiKhoan                    │
             │      └────┬────────────────┬─────────────┘
             │          │                 │
             │    FAILED│                 │SUCCESS
             │          │                 ▼
             │          │   ┌────────────────────────────────┐
             │          │   │  GỌCI SP: sp_DangNhapThanhCong │
             │          │   │  - Update LanDangNhapCuoi      │
             │          │   │  - Update DiaChiIPCuoi         │
             │          │   │  - Reset SoLanDangNhapThatBai  │
             │          │   │  - INSERT NhatKyHoatDong       │
             │          │   │    (LoaiHoatDong='LOGIN',      │
             │          │   │     TrangThai='SUCCESS')       │
             │          │   └────────┬─────────────────────────┘
             │          │            │
             │          ▼            ▼
             │   ┌──────────────────────────────┐
             │   │  GỌCI SP: sp_DangNhapThatBai │
             │   │  - Tăng SoLanDangNhapThatBai │
             │   │  - INSERT NhatKyHoatDong     │
             │   │    (LoaiHoatDong='LOGIN',    │
             │   │     TrangThai='FAILED')      │
             │   │  - Nếu >= 5 lần: Khóa TK    │
             │   └──────────┬───────────────────┘
             │              │
             └──────────────┼──────────────────┐
                            │                  │
                            ▼                  ▼
                    ┌──────────────┐  ┌─────────────────┐
                    │ Trả về Token │  │ Trả về Error    │
                    │ JWT/Bearer   │  │ + Lý do         │
                    └──────────────┘  └─────────────────┘


=== 3. QUY TRÌNH ĐĂNG XUẤT (LOGOUT WORKFLOW) ===

┌──────────────────────────────────────────────────────────────┐
│                    NGƯỜI DÙNG ĐĂNG XUẤT                      │
│                (Frontend/Mobile App)                         │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│   Backend API: AuthController.cs                             │
│   POST /api/auth/logout                                      │
│   - Nhận: TenDangNhap, DiaChiIP, Token                      │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
        ┌─────────────────────────────────────┐
        │   Xác thực Token (JWT Verify)       │
        └────┬──────────────────────────┬──────┘
     FAILED │                          │ VALID
             │                          ▼
             │      ┌──────────────────────────────┐
             │      │  GỌCI SP: sp_DangXuat        │
             │      │  - INSERT NhatKyHoatDong     │
             │      │    (LoaiHoatDong='LOGOUT',   │
             │      │     TrangThai='SUCCESS')     │
             │      │  - Xóa Session/Token         │
             │      └────────┬─────────────────────┘
             │               │
             ▼               ▼
        ┌─────────────┐  ┌──────────────────┐
        │ Trả Error   │  │ Trả SUCCESS      │
        └─────────────┘  │ Đã đăng xuất     │
                         └──────────────────┘


=== 4. QUY TRÌNH XEM DỮ LIỆU (VIEW WORKFLOW) ===

┌──────────────────────────────────────────────────────────────┐
│        NGƯỜI DÙNG XEM/TRUY CẬP TÍNH NĂNG                    │
│   (Dashboard, Courses, Grades, etc.)                         │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│   Backend API: Bất kỳ Controller nào                         │
│   GET/POST /api/{resource}                                   │
│   - Nhận Token, TenDangNhap, IP                              │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
        ┌─────────────────────────────────────┐
        │   Xác thực Token (Middleware)       │
        └────┬──────────────────────────┬──────┘
     FAILED │                          │ VALID
             │                          ▼
             │      ┌──────────────────────────────────┐
             │      │  Kiểm tra Quyền (Authorization) │
             │      └────┬────────────────┬────────────┘
             │          │                 │
             │    DENIED│                 │ALLOW
             │          │                 ▼
             │          │   ┌────────────────────────────────┐
             │          │   │  GỌCI SP: sp_GhiNhatKyHoatDong │
             │          │   │  - Lưu LoaiHoatDong = 'VIEW'   │
             │          │   │  - Lưu MoDun = 'Dashboard'...  │
             │          │   │  - Lưu TrangThai = 'SUCCESS'   │
             │          │   └────────┬─────────────────────────┘
             │          │            │
             │          ▼            ▼
             │   ┌──────────────┐  ┌─────────────────┐
             │   │ Trả Error    │  │ Trả Dữ liệu     │
             │   │ 403/401      │  │ + Headers       │
             │   └──────────────┘  └─────────────────┘
             │
             └────────────────► INSERT NhatKyHoatDong
                                 (TrangThai='FAILED')


=== 5. STORED PROCEDURES CHÍNH ===

1️⃣ sp_DangNhapThanhCong
   • Được gọi: Khi login SUCCESS
   • Tác vụ:
     - UPDATE TaiKhoan: LanDangNhapCuoi, DangNhapLanCuoi, DiaChiIPCuoi
     - INSERT NhatKyHoatDong: Ghi nhật ký
   • SQL: EXEC sp_DangNhapThanhCong @TenDangNhap='admin', @DiaChiIP='192.168.1.100'

2️⃣ sp_DangNhapThatBai
   • Được gọi: Khi login FAILED
   • Tác vụ:
     - UPDATE TaiKhoan: Tăng SoLanDangNhapThatBai
     - INSERT NhatKyHoatDong: Ghi nhật ký
     - Nếu >= 5 lần: Khóa tài khoản
   • SQL: EXEC sp_DangNhapThatBai @TenDangNhap='admin', @LyDo=N'Sai mật khẩu'

3️⃣ sp_DangXuat
   • Được gọi: Khi logout
   • Tác vụ:
     - INSERT NhatKyHoatDong: Ghi nhật ký logout
   • SQL: EXEC sp_DangXuat @TenDangNhap='admin'

4️⃣ sp_GhiNhatKyHoatDong
   • Được gọi: Khi có hoạt động bất kỳ (VIEW, CREATE, UPDATE, DELETE)
   • Tác vụ:
     - INSERT NhatKyHoatDong với tất cả thông tin
   • SQL: EXEC sp_GhiNhatKyHoatDong @TenDangNhap='admin', @LoaiHoatDong='VIEW'

5️⃣ sp_LayNhatKyHoatDong
   • Được gọi: Khi lấy nhật ký (admin xem log)
   • Tác vụ:
     - SELECT từ NhatKyHoatDong với filter
   • SQL: EXEC sp_LayNhatKyHoatDong @TenDangNhap='admin', @SoLuong=100

6️⃣ sp_LayThongTinTaiKhoan
   • Được gọi: Khi lấy thông tin tài khoản + lịch sử
   • Tác vụ:
     - SELECT từ TaiKhoan
     - SELECT từ NhatKyHoatDong (10 bản ghi cuối)
   • SQL: EXEC sp_LayThongTinTaiKhoan @TenDangNhap='admin'


=== 6. DÒNG DỮ LIỆU (DATA FLOW) ===

Frontend (UI)
    │
    ├─► POST /api/auth/login (TenDangNhap, MatKhau, DiaChiIP)
    │       │
    │       ▼
    │   Backend API (AuthService.Login)
    │       │
    │       ├─► Validate TenDangNhap + MatKhau
    │       │
    │       ├─► SUCCESS
    │       │   └─► EXEC sp_DangNhapThanhCong
    │       │       └─► UPDATE TaiKhoan
    │       │       └─► INSERT NhatKyHoatDong (LOGIN, SUCCESS)
    │       │
    │       └─► FAILED
    │           └─► EXEC sp_DangNhapThatBai
    │               └─► UPDATE TaiKhoan (Tăng lần thất bại)
    │               └─► INSERT NhatKyHoatDong (LOGIN, FAILED)
    │
    ▼
Frontend (Nhận Token hoặc Error)


=== 7. VÍ DỤ THỰC TẾ ===

Sự kiện: Admin đăng nhập lúc 2025-12-11 11:05:00 từ IP 192.168.1.100

Bước 1: Frontend gửi:
   POST /api/auth/login
   Body: { "TenDangNhap": "admin", "MatKhau": "123456", "DiaChiIP": "192.168.1.100" }

Bước 2: Backend xác thực:
   - Kiểm tra admin tồn tại: ✓
   - Kiểm tra mật khẩu: ✓
   - Kiểm tra TrangThai: ✓ (Hoạt động)

Bước 3: Backend gọi:
   EXEC sp_DangNhapThanhCong 
       @TenDangNhap = 'admin', 
       @DiaChiIP = '192.168.1.100'

Bước 4: Database thực hiện:
   UPDATE TaiKhoan SET
       LanDangNhapCuoi = '2025-12-11 11:05:00',
       DangNhapLanCuoi = '2025-12-11 11:05:00',
       DiaChiIPCuoi = '192.168.1.100',
       SoLanDangNhapThatBai = 0
   WHERE TenDangNhap = 'admin'

Bước 5: Database ghi nhật ký:
   INSERT INTO NhatKyHoatDong (
       TenDangNhap, LoaiHoatDong, MoDun, MoTa, 
       DiaChiIP, TrangThai, NgayGio
   ) VALUES (
       'admin', 'LOGIN', 'Authentication', 
       'Đăng nhập hệ thống',
       '192.168.1.100', 'SUCCESS', '2025-12-11 11:05:00'
   )

Bước 6: Backend trả về:
   { 
       "success": true, 
       "token": "eyJhbGc...", 
       "expiresIn": 3600,
       "user": { "TenDangNhap": "admin", "MaVaiTro": "ADMIN" }
   }

Bước 7: Frontend nhận token:
   - Lưu token vào localStorage/sessionStorage
   - Chuyển hướng tới Dashboard

Bước 8: Query kiểm tra:
   SELECT TenDangNhap, LanDangNhapCuoi, DiaChiIPCuoi 
   FROM TaiKhoan WHERE TenDangNhap = 'admin'
   
   Kết quả:
   admin | 2025-12-11 11:05:00 | 192.168.1.100


=== 8. LỢI ÍCH CỦA WORKFLOW NÀY ===

✅ Bảo mật:
   • Theo dõi tất cả hoạt động của người dùng
   • Phát hiện đăng nhập bất thường
   • Khóa tài khoản sau 5 lần thất bại

✅ Quản lý:
   • Biết ai làm gì vào lúc nào
   • Kiểm tra lịch sử truy cập
   • Dùng cho audit trail

✅ Hiệu suất:
   • Cập nhật TaiKhoan mỗi lần login (real-time)
   • Tìm nhanh lần đăng nhập cuối mà không cần query NhatKyHoatDong
   • Index trên NhatKyHoatDong(TenDangNhap, NgayGio)

✅ Truy vấn dễ:
   • Admin có thể: EXEC sp_LayNhatKyHoatDong @TenDangNhap='admin'
   • Để xem tất cả hoạt động của một user
*/

USE EduProDb;
GO

-- Ví dụ: Xem nhất ký hoạt động của admin
PRINT N'=== VÍ DỤ: LẤY NHẬT KÝ CỦA ADMIN ===';
EXEC sp_LayNhatKyHoatDong @TenDangNhap = 'admin', @SoLuong = 10;

-- Ví dụ: Xem thông tin tài khoản + nhật ký gần đây
PRINT N'=== VÍ DỤ: THÔNG TIN TÀI KHOẢN ADMIN ===';
EXEC sp_LayThongTinTaiKhoan @TenDangNhap = 'admin';

-- Ví dụ: Lấy tất cả LOGIN thất bại
PRINT N'=== VÍ DỤ: LẤY TẤT CẢ LOGIN THẤT BẠI ===';
SELECT TOP 20
    MaNhatKy, TenDangNhap, LoaiHoatDong, MoTa, DiaChiIP, NgayGio
FROM NhatKyHoatDong
WHERE LoaiHoatDong = 'LOGIN' AND TrangThai = 'FAILED'
ORDER BY NgayGio DESC;

-- Ví dụ: Thống kê hoạt động theo loại
PRINT N'=== VÍ DỤ: THỐNG KÊ HOẠT ĐỘNG ===';
SELECT
    LoaiHoatDong,
    COUNT(*) AS SoLanThucHien,
    COUNT(CASE WHEN TrangThai = 'SUCCESS' THEN 1 END) AS ThanhCong,
    COUNT(CASE WHEN TrangThai = 'FAILED' THEN 1 END) AS ThatBai
FROM NhatKyHoatDong
GROUP BY LoaiHoatDong
ORDER BY SoLanThucHien DESC;

GO
