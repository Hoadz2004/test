# PHÂN TÍCH FILE SQL - TÌM LOGIC TRÙNG LẬP

## 🔴 CẢNH BÁO: CÓ CÁC FILE LOGIC TRÙNG NHAU!

---

## 1. ⚠️ GiẢI ĐỀ QUAN TRỌNG - FILE TRÙ LẬP CẦN XỬ LÝ

### A. **XUNG ĐỘT TRONG LOGIC ĐIỂM (Grade Logic)**

#### File bị ảnh hưởng:
1. **Schema_GradeManagement.sql** (01_Schema/)
   - Định nghĩa SP: `sp_Lecturer_UpdateGrade` (Dòng ~100)
   - Logic: Tính điểm tổng = (CC × 0.1) + (GK × 0.4) + (CK × 0.5)
   
2. **Fix_Grade_Logic.sql** (02_Fixes_Migrations/)
   - **ĐỊNH NGHĨA LẠI** SP: `sp_Lecturer_UpdateGrade` 
   - Logic: Cùng công thức + **THÊM RULE mới**: Nếu CK < 4.0 → FAIL
   - Status: **GHI ĐÈ file cũ**

**🚨 VẤN ĐỀ:** 
- `sp_Lecturer_UpdateGrade` được định nghĩa **2 lần**
- File `Fix_Grade_Logic.sql` sẽ ghi đè phiên bản cũ trong `Schema_GradeManagement.sql`
- SQL sẽ không báo lỗi, nhưng nếu chạy `Schema_GradeManagement.sql` SAU `Fix_Grade_Logic.sql` → SẼ QUAY LẠI LOGIC CŨ

---

### B. **XUNG ĐỘT TRONG VIEW ĐIỂM (Student Grades)**

#### File bị ảnh hưởng:
1. **Schema_StudentGrades.sql** (01_Schema/)
   - Định nghĩa SP: `sp_Student_GetGrades` 
   - Đọc từ các JOIN: DangKyHocPhan → LopHocPhan → HocPhan → Diem
   
2. **CreateStoredProcedures.sql** (03_StoredProcedures/)
   - Định nghĩa SP: `sp_XemBangDiemSinhVien` (Dòng ~710)
   - **LOGIC GẦN NHƯ GIỐNG NHAU** nhưng cách join hơi khác
   - Cùng output: Lấy điểm của sinh viên

**🚨 VẤN ĐỀ:**
- 2 Stored Procedure làm **CÙNG MỘC ĐÍCH** nhưng tên khác
- Frontend có thể gọi sai SP hoặc gọi cả 2 → Logic không nhất quán

---

### C. **XUNG ĐỘT TRONG TẠO TÀI KHOẢN (User Creation)**

#### File bị ảnh hưởng:
1. **CreateStoredProcedures.sql** (03_StoredProcedures/)
   - SP: `sp_TaoTaiKhoanSinhVien` (Dòng ~11)
   - SP: `sp_TaoTaiKhoanGiangVien` (Dòng ~30)
   - Logic: Tạo TaiKhoan đơn giản, chỉ với mật khẩu mặc định '123456'

2. **sp_CreateUserFull.sql** (03_StoredProcedures/)
   - SP: `sp_CreateUserAccount`
   - Logic: Tạo **SINH VIÊN + GIẢNG VIÊN + TAIKHOAN** cùng lúc
   - Sinh ra ID tự động (MaSV, MaGV)
   - **TOÀN DIỆN HƠN** 

**🚨 VẤN ĐỀ:**
- 3 cách tạo user khác nhau
- `sp_CreateUserFull` là **PHIÊN BẢN MỚI** và **HOÀN CHỈNH HƠN**
- `sp_TaoTaiKhoanSinhVien` và `sp_TaoTaiKhoanGiangVien` là **PHIÊN BẢN CŨ**
- Nếu chạy cả 2, có thể insert trùng lặp

---

### D. **XUNG ĐỘT TRONG ENCODING (Encoding Fixes)**

#### File bị ảnh hưởng:
1. **Fix_CTDT_Encoding.sql** (02_Fixes_Migrations/)
   - Fix lỗi mã hóa trong bảng **CTDT** (Chương trình đào tạo)
   - Cập nhật các tên bị mojibake

2. **Fix_Vietnamese_Encoding_DangKyHocPhan.sql** (02_Fixes_Migrations/)
   - Fix lỗi mã hóa trong bảng **Classes** (nhưng tham chiếu đến StudentManagementSystem DB)
   - **CHẠY VÀO SAI DATABASE!**

**🚨 VẤN ĐỀ:**
- File thứ 2 chạy vào database **sai** (StudentManagementSystem thay vì EduProDb)
- Cột tham chiếu là Status chứ không phải TrangThai
- **FILE NÀY CÓ NGUY CÓ GẶP LỖI!**

---

## 2. 📋 BẢNG SO SÁNH CHI TIẾT

| Thành phần | File 1 | File 2 | Vấn đề | Khuyến cáo |
|-----------|--------|--------|---------|-----------|
| **sp_Lecturer_UpdateGrade** | Schema_GradeManagement.sql | Fix_Grade_Logic.sql | Định nghĩa 2 lần | ⚠️ XÓA cái cũ |
| **sp_Student_GetGrades** | Schema_StudentGrades.sql | CreateStoredProcedures (sp_XemBangDiemSinhVien) | Logic trùng, tên khác | ⚠️ GIỮ 1, XÓA 1 |
| **TaoTaiKhoanSinhVien** | CreateStoredProcedures.sql | sp_CreateUserFull.sql | Có đè lên không (khác tên) | ✅ Giữ cả 2 (khác logic) |
| **TaoTaiKhoanGiangVien** | CreateStoredProcedures.sql | sp_CreateUserFull.sql | Có đè lên không (khác tên) | ✅ Giữ cả 2 (khác logic) |
| **Fix_CTDT_Encoding** | Fix_CTDT_Encoding.sql | - | Tự lập, đúng DB | ✅ Giữ lại |
| **Fix_Vietnamese_Encoding** | Fix_Vietnamese_Encoding_DangKyHocPhan.sql | - | **NHẦM DATABASE!** | ❌ XÓA hoặc sửa |

---

## 3. 🛠️ GIẢI PHÁP ĐỀ XUẤT

### BƯỚC 1: Xóa các file lỗi/trùng
```
❌ Xóa hoặc chuyển sang 05_Archive:
   - Fix_Vietnamese_Encoding_DangKyHocPhan.sql (SAI DATABASE!)
```

### BƯỚC 2: Sửa file định nghĩa lại
**Schema_GradeManagement.sql** - Xóa định nghĩa SP `sp_Lecturer_UpdateGrade` vì nó sẽ được định nghĩa lại trong Fix_Grade_Logic.sql

### BƯỚC 3: Quyết định thế nào với các SP trùng
**Lựa chọn A (Giữ cả 2 - KHÔNG khuyến cáo):**
- Giữ cả `sp_Student_GetGrades` và `sp_XemBangDiemSinhVien`
- Nhưng tài liệu phải rõ ràng nên dùng cái nào

**Lựa chọn B (Khuyến cáo):**
- ✅ Giữ `sp_XemBangDiemSinhVien` từ CreateStoredProcedures.sql (TÊN TIẾNG VIỆT HƠN)
- ❌ Xóa `sp_Student_GetGrades` từ Schema_StudentGrades.sql

---

## 4. 📝 DANH SÁCH FILE CẦN HÀNH ĐỘNG

| File | Hành động | Lý do |
|------|----------|-------|
| Schema_StudentGrades.sql | **SỬA** - Xóa SP `sp_Student_GetGrades` | Trùng với sp_XemBangDiemSinhVien |
| Schema_GradeManagement.sql | **SỬA** - Xóa SP `sp_Lecturer_UpdateGrade` | Sẽ được định nghĩa lại trong Fix file |
| Fix_Vietnamese_Encoding_DangKyHocPhan.sql | **XÓA → 05_Archive** | Chạy vào database sai! |
| CreateStoredProcedures.sql | ✅ **GIỮ NGUYÊN** | Tất cả các SP này là chuẩn |
| sp_CreateUserFull.sql | ✅ **GIỮ NGUYÊN** | Phiên bản mới và hoàn chỉnh hơn |

---

## 5. ⚠️ LƯU Ý KHI CHẠY SCRIPT

**⚡ NGUY HIỂM:**
1. Nếu chạy `Schema_GradeManagement.sql` **TRƯỚC** `Fix_Grade_Logic.sql`
   → SP `sp_Lecturer_UpdateGrade` sẽ bị ghi đè lại (LOGIC CŨ)

2. Nếu chạy cả hai `sp_Student_GetGrades` + `sp_XemBangDiemSinhVien`
   → Frontend không biết nên dùng cái nào

3. **Fix_Vietnamese_Encoding_DangKyHocPhan.sql** sẽ báo lỗi vì:
   - Database không phải EduProDb
   - Bảng Classes không tồn tại

---

## 6. 🎯 KHUYẾN CÁO CUỐI CÙNG

**Tuân theo thứ tự này để tránh xung đột:**

```
1️⃣ 01_Schema/Schema_GradeManagement.sql
   → MỤC ĐÍ: Tạo cấu trúc, ADD columns

2️⃣ 01_Schema/Schema_StudentGrades.sql
   → MỤC ĐÍ: Tạo view/SP để lấy điểm (nhưng XÓA SP trùng)

3️⃣ 02_Fixes_Migrations/Fix_*.sql (theo thứ tự)
   → MỤC ĐÍ: Fix lỗi và định nghĩa lại SP chính xác

4️⃣ 03_StoredProcedures/*.sql (NGOẠI TRỪ sp_CreateUserFull.sql)
   → MỤC ĐÍ: Tạo tất cả SP chính thức

5️⃣ 03_StoredProcedures/sp_CreateUserFull.sql (CUỐI CÙNG)
   → MỤC ĐÍ: Ghi đè các cách tạo user cũ (nếu cần)

6️⃣ 04_SampleData/*.sql
   → MỤC ĐÍ: Tạo dữ liệu mẫu
```

---

## 📌 TÓMLẠI - CẤP ĐỘ NGUY HIỂM

| Cấp độ | Số lượng | File |
|--------|---------|------|
| 🔴 **NGUY HIỂM CAO** | 1 | Fix_Vietnamese_Encoding_DangKyHocPhan.sql |
| 🟠 **NGUY HIỂM TRUNG BÌNH** | 2 | Schema_GradeManagement.sql, Schema_StudentGrades.sql |
| 🟡 **CẢNH BÁO** | 2 | sp_Student_GetGrades vs sp_XemBangDiemSinhVien |
| 🟢 **AN TOÀN** | Còn lại | Không vấn đề |

---

**Cập nhật: 14/12/2025**
**Trạng thái: ⚠️ CẦN ĐƯỢC XỬ LÝ NGAY**
