# DATABASE FILE ORGANIZATION - EduPro

## Cấu trúc mới (New Structure)

```
database/
├── 01_Schema/                          # BUOC 1: Tạo cấu trúc cơ sở dữ liệu
│   ├── Schema_GradeManagement.sql      # Bảng quản lý điểm
│   └── Schema_StudentGrades.sql        # Bảng điểm sinh viên
│
├── 02_Fixes_Migrations/                # BUOC 2: Fix lỗi và Migration
│   ├── FixSinhVienConstraint.sql       # Fix ràng buộc sinh viên
│   ├── Fix_CTDT_Encoding.sql           # Fix mã hóa CTDT (Chương trình đào tạo)
│   ├── Fix_Grade_Logic.sql             # Fix logic điểm
│   └── Fix_Vietnamese_Encoding_DangKyHocPhan.sql  # Fix mã hóa đăng ký học phần
│
├── 03_StoredProcedures/                # BUOC 3: Tạo Stored Procedures
│   ├── CreateStoredProcedures.sql      # Tạo tất cả stored procedures chính
│   ├── EnrollmentSPs.sql               # SP cho đăng ký học phần
│   ├── GradeSPs.sql                    # SP cho điểm
│   ├── sp_CreateUserFull.sql           # SP tạo người dùng
│   ├── sp_LoginFirstLogin.sql          # SP xử lý login lần đầu
│   └── sp_Profile.sql                  # SP quản lý hồ sơ
│
├── 04_SampleData/                      # BUOC 4: Tải dữ liệu mẫu
│   ├── CreateAdminAccounts.sql         # Tạo tài khoản admin
│   ├── CreateSampleData_Enrollment.sql # Dữ liệu mẫu đăng ký
│   └── SampleData_LecturerGrades.sql   # Dữ liệu mẫu điểm giảng viên
│
├── 05_Archive/                         # BUOC 5: Tối ưu (cần review trước khi chạy)
│   ├── OpenMoreClasses.sql
│   └── OptimizeEnrollment.sql
│
├── RunAllSqlScripts_NEW.bat            # Script chạy tất cả theo đúng thứ tự
├── RunSampleData.bat                   # Script chạy chỉ dữ liệu mẫu
└── README.md (tài liệu này)
```

## Thứ tự chạy (Execution Order)

**BƯỚC 1: Schema**
- Tạo bảng cơ sở dữ liệu cần thiết
- Đặt ràng buộc (constraints) và index

**BƯỚC 2: Fixes & Migrations**
- Fix các lỗi từ lần chạy trước
- Cập nhật dữ liệu đã tồn tại

**BƯỚC 3: Stored Procedures**
- Tạo các hàm và thủ tục cho ứng dụng

**BƯỚC 4: Sample Data**
- Tạo dữ liệu mẫu để test

**BƯỚC 5: Archive** (Chạy thủ công nếu cần)
- Những script tối ưu cần review trước

## Cách sử dụng

### Chạy tất cả (khuyên dùng lần đầu tiên):
```bash
RunAllSqlScripts_NEW.bat
```

### Chạy chỉ dữ liệu mẫu:
```bash
RunSampleData.bat
```

### Chạy một file cụ thể:
```bash
sqlcmd -S 202.55.135.42 -d EduProDb -U sa -P "Your_Password" -i "01_Schema\Schema_GradeManagement.sql" -C
```

## Lưu ý quan trọng

1. **Sao lưu database** trước khi chạy scripts
2. **Kiểm tra kết nối** SQL Server trước khi chạy
3. **Xem logs** để debug nếu có lỗi
4. **Không chạy 05_Archive** nếu bạn không hiểu những file đó làm gì
5. Nếu có lỗi, hãy xóa dữ liệu và chạy lại từ bước 1

---
*Cập nhật: 14/12/2025*
