# EduPro Test Accounts & Role-Based Routing Summary

## ✅ Completed Tasks

### 1. Test Accounts Created (SampleData_04_TestAccounts.sql)
```
✓ 3 test accounts inserted into TaiKhoan table with SHA256 hashed passwords

Account 1: ADMIN
  - Username: admin
  - Password: admin123
  - Role: ADMIN
  - Hash: HASHBYTES('SHA2_256', 'admin123')
  - Status: Active (1)

Account 2: LECTURER (Giảng viên)
  - Username: gv001
  - Password: gv123
  - Role: GIANGVIEN
  - MaGV: GV001 (linked to GiangVien table)
  - Hash: HASHBYTES('SHA2_256', 'gv123')
  - Status: Active (1)

Account 3: STUDENT (Sinh viên)
  - Username: sv2022001
  - Password: sv123
  - Role: SINHVIEN
  - MaSV: 2022001 (linked to SinhVien table)
  - Hash: HASHBYTES('SHA2_256', 'sv123')
  - Status: Active (1)
```

### 2. Role-Based Guards Implemented (app.routes.ts)

#### authGuard - Basic Authentication Check
- Validates user is logged in
- Redirects to login if not authenticated

#### adminGuard - Admin-Only Routes
- Checks: `currentUserValue?.role === 'ADMIN'`
- Redirect: To `/dashboard` if unauthorized
- Protected Routes:
  - `/master-data` - Master Data Management
  - `/class-management` - Class Management Interface

#### lecturerGuard - Lecturer-Only Routes
- Checks: `currentUserValue?.role === 'GIANGVIEN'`
- Redirect: To `/dashboard` if unauthorized
- Protected Routes:
  - `/lecturer-profile` - Lecturer Profile & Class Management

#### studentGuard - Student-Only Routes
- Checks: `currentUserValue?.role === 'SINHVIEN'`
- Redirect: To `/dashboard` if unauthorized
- Protected Routes:
  - `/enrollment` - Course Registration
  - `/grades` - View Grades
  - `/grade-appeal` - Grade Appeal
  - `/graduation` - Graduation Status
  - `/profile` - Student Profile

### 3. Route Structure

```
/login                    → Public (no auth required)
/dashboard                → Protected (authGuard only)

Student Routes (authGuard + studentGuard):
  /enrollment             → Đăng ký học phần
  /grades                 → Xem điểm
  /grade-appeal           → Phúc khảo
  /graduation             → Tốt nghiệp
  /profile                → Thông tin sinh viên

Lecturer Routes (authGuard + lecturerGuard):
  /lecturer-profile       → Thông tin giảng viên

Admin Routes (authGuard + adminGuard):
  /master-data            → Quản lý dữ liệu tham chiếu
  /class-management       → Quản lý lớp học phần

Default Routes:
  /                       → Redirect to /login
  **                      → Wildcard (any unknown) → /login
```

## 📝 Test Cases

### Test Case 1: Admin Login
```
Username: admin
Password: admin123
Expected Result: 
  - Login successful
  - Redirect to /dashboard
  - Can access: /master-data, /class-management
  - Cannot access: /enrollment, /grades, /lecturer-profile
```

### Test Case 2: Lecturer Login
```
Username: gv001
Password: gv123
Expected Result:
  - Login successful
  - Redirect to /dashboard
  - Can access: /lecturer-profile
  - Cannot access: /enrollment, /class-management, /master-data
```

### Test Case 3: Student Login
```
Username: sv2022001
Password: sv123
Expected Result:
  - Login successful
  - Redirect to /dashboard
  - Can access: /enrollment, /grades, /grade-appeal, /graduation, /profile
  - Cannot access: /class-management, /master-data
```

## 🔧 Technical Details

### Password Hashing
- Algorithm: SHA2_256 (HASHBYTES in SQL Server)
- Example: `HASHBYTES('SHA2_256', 'admin123')`
- Location: TaiKhoan.MatKhauHash (VARBINARY(256))

### Authentication Flow
1. User submits login form (username + password)
2. Backend AuthService calls LoginAsync
3. Backend queries sp_Login or similar to verify credentials
4. Returns LoginResponse with: username, role, token, fullName, maSV
5. Frontend stores user data in localStorage
6. AuthService updates BehaviorSubject (currentUser)
7. Routes check guards before navigation

### Role Values in Database
- ADMIN - Quản trị viên
- GIANGVIEN - Giảng viên (note: not GIAO_VIEN or GIAOVIÊN)
- SINHVIEN - Sinh viên (note: not SINHVIEN or STUDENT)
- PHONGDAOTAO - Phòng Đào tạo
- BANGIAMHIEU - Ban Giám hiệu

## ⚠️ Important Notes

### Password Security
- Current implementation: Plain text passwords in SQL then hashed with SHA256
- Production requirement: Use bcrypt, PBKDF2, or similar with salt
- Frontend: Should hash password before sending (HTTPS required)
- Backend: Must validate hash, not compare plain text

### Frontend Storage
- User data stored in localStorage (JSON serialized)
- Not ideal for production (XSS vulnerability)
- Better approach: HttpOnly cookies with JWT

### Role String Matching
- Database: ADMIN, GIANGVIEN, SINHVIEN (uppercase)
- Frontend checks: role === 'ADMIN', role === 'GIANGVIEN', role === 'SINHVIEN'
- Must match exactly (case-sensitive)

## 🎯 Next Steps

1. ✅ Test admin login → verify can access admin routes
2. ✅ Test lecturer login → verify can access lecturer routes
3. ✅ Test student login → verify can access student routes
4. ✅ Verify role-based access restriction (403/redirect on unauthorized)
5. Test enrollment page displays correct student data
6. Test status badges render with correct colors
7. Verify navigation menu shows only accessible routes per role

## 📦 Files Modified

1. **SampleData_04_TestAccounts.sql** - Test account data
2. **app.routes.ts** - Role-based routing with guards

## 🗄️ Database Query to Verify

```sql
-- Check inserted accounts
SELECT TenDangNhap, MaVaiTro, MaGV, MaSV, TrangThai
FROM TaiKhoan
WHERE TenDangNhap IN ('admin', 'gv001', 'sv2022001')
ORDER BY TenDangNhap;

-- Expected: 3 rows with correct role codes
```

---
**Last Updated:** 2025-12-11
**Status:** ✅ Role-based routing implemented and test accounts created
