# 📊 PHÂN TÍCH TOÀN BỘ FOLDER "Schema bảng" - EduPro Database

---

## 📋 TÓMLẠI 19 FILE SQL

### **NHÓM 1: SCHEMA CỐT LÕI (8 file)**

| # | File | Mục đích | Trạng thái |
|---|------|---------|-----------|
| 1 | **1. Bảng danh mục & người dùng.sql** | Khoa, Ngành, KhoaTuyenSinh, NamHoc, HocKy, PhongHoc, CaHoc, HocPhan, GiangVien, SinhVien | ✅ Chuẩn |
| 2 | **2. Tài khoản & phân quyền.sql** | VaiTro, Quyen, VaiTro_Quyen, TaiKhoan, TokenBlacklist, LoginAttempt | ✅ Chuẩn |
| 3 | **3. Chương trình đào tạo & tiên quyết.sql** | CTDT, CTDT_ChiTiet, TienQuyet | ✅ Chuẩn |
| 4 | **4. Kế hoạch đào tạo – Lớp học phần – Đăng ký.sql** | LopHocPhan, DangKyHocPhan | ✅ Chuẩn |
| 5 | **5. AuditLog.sql** | AuditLog (với indexes) | ✅ Chuẩn |
| 6 | **5. Điểm, phúc khảo, tốt nghiệp.sql** | Diem, PhucKhao, DieuKienTotNghiep, XetTotNghiep | ✅ Chuẩn |
| 7 | **6. Thông báo & log.sql** | ThongBao, ThongBao_NguoiNhan, LogHeThong | ✅ Chuẩn |
| 8 | **5. AuditLog.sql** | AuditLog + Indexes | ✅ Duplicate (nội dung) |

---

### **NHÓM 2: CONSTRAINTS & INDEXES (3 file)**

| # | File | Mục đích | Trạng thái |
|---|------|---------|-----------|
| 7 | **7. CRITICAL - Thiếu Index...** | 26 Indexes cho performance | ✅ Chuẩn |
| 8 | **8. IMPORTANT - Thiếu UNIQUE constraints.sql** | 8 UNIQUE constraints/indexes | ✅ Chuẩn |
| 9 | **9. IMPORTANT - Thiếu CHECK constraints.sql** | 18 CHECK constraints validate data | ✅ Chuẩn |

---

### **NHÓM 3: BỔ SUNG DỮ LIỆU (3 file)**

| # | File | Mục đích | Trạng thái |
|---|------|---------|-----------|
| 10 | **10. MEDIUM - Bổ sung trường cần thiết.sql** | ⚠️ TRỐNG (cấu trúc đã ở các file khác) | ✅ Có thể xóa |
| 11 | **11. MEDIUM - Bổ sung bảng...** | CongNo, YeuCauDacBiet (học phí, request đặc biệt) | ✅ Chuẩn |
| 12 | **12. LOW - Vấn đề nhỏ về data type.sql** | Fix DECIMAL(3,2) → (4,2) cho DiemTB | ✅ Chuẩn |

---

### **NHÓM 4: TÍNH NĂNG MỞ RỘNG (3 file)**

| # | File | Mục đích | Trạng thái |
|---|------|---------|-----------|
| 13 | **13. Payment - HocPhi - ThanhToan.sql** | HocPhiCatalog, PaymentTransaction, PaymentLedger | ✅ Chuẩn |
| 14 | **14. Admissions.sql** | Admissions, AdmissionDocuments, AdmissionTransactions | ✅ Chuẩn |
| 15 | **15. Admissions_Requirements_Scores.sql** | AdmissionRequirements, AdmissionScores, AdmissionStatusHistory | ✅ Chuẩn |

---

### **NHÓM 5: MIGRATIONS & STORED PROCEDURES (2 file + 2 overlap)**

| # | File | Mục đích | Trạng thái |
|---|------|---------|-----------|
| 001 | **001_Improve_LopHocPhan_Schema.sql** | ADD 5 cột: NgayBatDau, NgayKetThuc, SoBuoiHoc, SoBuoiTrongTuan, TrangThaiLop | ✅ Chuẩn |
| 002 | **002_Add_MaKhoa_MaNganh_LopHocPhan.sql** | ADD 2 cột: MaKhoa, MaNganh (nullable) | ✅ Chuẩn |
| GradeMgmt | **Schema_GradeManagement.sql** | ADD TrongSoCC/GK/CK + 4 SPs | ⚠️ TRÙNG |
| StudentGrades | **Schema_StudentGrades.sql** | SP: sp_Student_GetGrades | ⚠️ TRÙNG |

---

## 🔴 PHÁT HIỆN VẤN ĐỀ

### **1. ⚠️ FILE TRỐNG (Không cần chạy)**
```
❌ 10. MEDIUM - Bổ sung trường cần thiết.sql
   → Chỉ chứa: "-- File này đã được tích hợp vào các file tạo bảng chính"
   → Hành động: CÓ THỂ XÓA hoặc GIỮ ĐỂ THÔNG TIN
```

### **2. 🔴 STORED PROCEDURES TRÙNG (NGUY HIỂM)**

#### A. `sp_Student_GetGrades` (Lấy điểm sinh viên)
- **File 1:** `Schema_StudentGrades.sql` - Định nghĩa SP
- **File 2:** `CreateStoredProcedures.sql` (03_StoredProcedures/) - Định nghĩa `sp_XemBangDiemSinhVien` (logic 95% giống)
- **Vấn đề:** Hai SP làm việc y hệt nhưng tên khác → Frontend confused

#### B. `sp_Lecturer_UpdateGrade` (Cập nhật điểm)
- **File 1:** `Schema_GradeManagement.sql` - Định nghĩa version **CŨ**
- **File 2:** `02_Fixes_Migrations/Fix_Grade_Logic.sql` - Định nghĩa lại version **MỚI** (có thêm rule: CK < 4.0 → FAIL)
- **Vấn đề:** Nếu chạy sai thứ tự → Logic điểm bị sai!

#### C. Các SP khác trong `Schema_GradeManagement.sql`
```
- sp_Lecturer_GetClasses       (Lấy danh sách lớp của giảng viên)
- sp_Lecturer_GetClassGrades   (Lấy danh sách sinh viên + điểm trong lớp)
- sp_Lecturer_UpdateGrade      (Cập nhật điểm)
```

### **3. ⚠️ CẤU TRÚC LOP_HOC_PHAN BỊ PHÂN TÁCH (NHƯNG ĐỦ)**

**Cột được ADD theo thứ tự:**
1. File #4: Cột cơ bản (MaHP, MaHK, MaGV, MaPhong, MaCa, ThuTrongTuan, SiSoToiDa)
2. File `Schema_GradeManagement.sql`: TrongSoCC, TrongSoGK, TrongSoCK
3. File `001_Improve_LopHocPhan_Schema.sql`: NgayBatDau, NgayKetThuc, SoBuoiHoc, SoBuoiTrongTuan, TrangThaiLop
4. File `002_Add_MaKhoa_MaNganh_LopHocPhan.sql`: MaKhoa, MaNganh

**Tổng: 18 cột + 5 constraints** ✅ Hợp lý

---

## 📊 THỐNG KÊ BẢNG

### **BẢNG ĐƯỢC TẠO (25 bảng chính + 3 archive)**

**Người dùng & Quyền (5):**
- Khoa, Nganh, GiangVien, SinhVien, SinhVien_TrangThai
- VaiTro, Quyen, VaiTro_Quyen, TaiKhoan, TokenBlacklist, LoginAttempt

**Học tập (6):**
- HocPhan, CTDT, CTDT_ChiTiet, TienQuyet
- LopHocPhan, DangKyHocPhan

**Quản lý Học kỳ (4):**
- NamHoc, HocKy, PhongHoc, CaHoc

**Điểm & Kết quả (4):**
- Diem, PhucKhao, DieuKienTotNghiep, XetTotNghiep

**Notification & Audit (3):**
- ThongBao, ThongBao_NguoiNhan, LogHeThong
- AuditLog

**Học phí (3):**
- CongNo, YeuCauDacBiet
- HocPhiCatalog, PaymentTransaction, PaymentLedger

**Tuyển sinh (6):**
- Admissions, AdmissionDocuments, AdmissionTransactions
- AdmissionRequirements, AdmissionScores, AdmissionStatusHistory

**TỔNG: 35 bảng** ✅

---

## 🎯 KHUYẾN CÁO THỰC HIỆN

### **STEP 1: SẮP XẾP CÁC FILE VÀO 01_Schema**

**Hiện tại file trong `Schema bảng/` nên di chuyển vào `01_Schema/`:**

```bash
# Thứ tự chạy trong 01_Schema:
1. 1. Bảng danh mục & người dùng.sql
2. 2. Tài khoản & phân quyền.sql
3. 3. Chương trình đào tạo & tiên quyết.sql
4. 4. Kế hoạch đào tạo – Lớp học phần – Đăng ký.sql
5. 5. AuditLog.sql
6. 5. Điểm, phúc khảo, tốt nghiệp.sql
7. 6. Thông báo & log.sql

# Tính năng mở rộng (chạy sau):
8. 7. CRITICAL - Thiếu Index...
9. 8. IMPORTANT - Thiếu UNIQUE constraints.sql
10. 9. IMPORTANT - Thiếu CHECK constraints.sql

# Bổ sung dữ liệu:
11. 11. MEDIUM - Bổ sung bảng...
12. 12. LOW - Vấn đề nhỏ về data type.sql

# Tính năng mới:
13. 13. Payment - HocPhi - ThanhToan.sql
14. 14. Admissions.sql
15. 15. Admissions_Requirements_Scores.sql

# Migrations:
16. 001_Improve_LopHocPhan_Schema.sql
17. 002_Add_MaKhoa_MaNganh_LopHocPhan.sql

# CÓ TRÙNG - CẦN XỬ LÝ:
❌ Schema_GradeManagement.sql → DI CHUYỂN vào 02_Fixes_Migrations hoặc 03_StoredProcedures
❌ Schema_StudentGrades.sql → XÓAB hoặc MERGE vào CreateStoredProcedures.sql
❌ 10. MEDIUM - Bổ sung trường cần thiết.sql → XÓA (trống)
```

---

## 📌 TÓMLẠI

| Tính năng | Trạng thái | Ghi chú |
|-----------|-----------|--------|
| **Schema cơ bản** | ✅ Đầy đủ | 7 file chính |
| **Indexes & Constraints** | ✅ Đầy đủ | 3 file riêng biệt (tốt!) |
| **Stored Procedures** | ⚠️ CÓ TRÙNG | Cần xóa/merge |
| **Tính năng mở rộng** | ✅ Đầy đủ | Payment, Admissions, Learning |
| **Migrations** | ✅ Đủ | 2 file cải thiện schema |

---

**Bạn muốn tôi:**
1. ✅ Di chuyển các file vào đúng folder (01_Schema, 02_Fixes)?
2. ✅ Xóa/Merge các SP trùng?
3. ✅ Tạo script mới để chạy tất cả theo đúng thứ tự?

---
*Cập nhật: 14/12/2025*
