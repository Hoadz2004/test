-- =============================================
-- STORED PROCEDURES INVENTORY - DANH SÁCH TOÀN BỘ SP
-- =============================================
-- Ngày: 2025-12-11
-- Tổng số: 34 files
-- Status: Audit toàn bộ liên kết bảng dữ liệu

-- ========== STORED PROCEDURES CHÍNH (CÓ SỬ DỤNG) ==========

1. sp_GetEnrollmentStatus.sql
   ├─ Chức năng: Lấy kết quả đăng ký học phần của sinh viên
   ├─ Parameters: @MaSV (NVARCHAR(20))
   ├─ Bảng liên kết:
   │  ├─ DangKyHocPhan dk (Primary)
   │  ├─ LopHocPhan lhp (INNER JOIN on dk.MaLHP = lhp.MaLHP)
   │  ├─ HocPhan hp (INNER JOIN on lhp.MaHP = hp.MaHP)
   │  └─ GiangVien gv (INNER JOIN on lhp.MaGV = gv.MaGV)
   ├─ Status: ✅ CÓ SỬ DỤNG
   └─ Column Names: ✅ CHUẨN (MaLHP, TenHP, SoTinChi, ThuTrongTuan, Id)

2. sp_GetClassManagement.sql
   ├─ Chức năng: Lấy danh sách lớp học phần cho quản lý
   ├─ Parameters: @MaHK (NVARCHAR(20)), @MaNam (NVARCHAR(20))
   ├─ Bảng liên kết:
   │  ├─ LopHocPhan lhp (Primary)
   │  ├─ HocPhan hp (INNER JOIN on lhp.MaHP = hp.MaHP)
   │  ├─ GiangVien gv (INNER JOIN on lhp.MaGV = gv.MaGV)
   │  └─ DangKyHocPhan dk (LEFT JOIN on lhp.MaLHP = dk.MaLHP)
   ├─ Status: ✅ CÓ SỬ DỤNG
   └─ Column Names: ✅ CHUẨN

3. sp_UpdateClassStatus.sql (CŨNG CẦN FIX)
   ├─ Chức năng: Cập nhật trạng thái lớp học phần
   ├─ Parameters: @MaLopHP (NVARCHAR(20)), @TrangThaiLop, @NgayBatDau, @NgayKetThuc
   ├─ Bảng sử dụng:
   │  └─ LopHocPhan (UPDATE)
   ├─ Status: ⚠️ CẦN FIX - Dùng @MaLopHP thay vì @MaLHP
   └─ Column Names: ❌ SAI - LopHocPhan.MaLopHP (nên là MaLHP)

4. sp_UpdateClassStatus_NEW.sql
   ├─ Chức năng: Cập nhật trạng thái lớp học phần (Version mới)
   ├─ Parameters: @MaLHP (NVARCHAR(20)), @TrangThaiLop, @NgayBatDau, @NgayKetThuc
   ├─ Bảng sử dụng:
   │  └─ LopHocPhan (UPDATE)
   ├─ Status: ✅ CÓ SỬ DỤNG
   └─ Column Names: ✅ CHUẨN (MaLHP)

5. sp_GetLecturerClasses_NEW.sql
   ├─ Chức năng: Lấy danh sách lớp học phần của giảng viên
   ├─ Parameters: @MaGV (NVARCHAR(20))
   ├─ Bảng liên kết:
   │  ├─ LopHocPhan lhp (Primary)
   │  ├─ HocPhan hp (INNER JOIN on lhp.MaHP = hp.MaHP)
   │  └─ DangKyHocPhan dk (LEFT JOIN on lhp.MaLHP = dk.MaLHP)
   ├─ Status: ✅ CÓ SỬ DỤNG
   └─ Column Names: ✅ CHUẨN

6. sp_RegisterCourse_NEW.sql
   ├─ Chức năng: Đăng ký học phần
   ├─ Parameters: @MaSV (NVARCHAR(20)), @MaLHP (NVARCHAR(20))
   ├─ Bảng sử dụng:
   │  ├─ SinhVien (SELECT - Check exists)
   │  ├─ LopHocPhan (SELECT - Check exists)
   │  └─ DangKyHocPhan (INSERT + SELECT - Check exists)
   ├─ Status: ✅ CÓ SỬ DỤNG
   └─ Column Names: ✅ CHUẨN

7. sp_GetStudentInfo.sql
   ├─ Chức năng: Lấy thông tin chi tiết sinh viên
   ├─ Parameters: @MaSV (NVARCHAR(20))
   ├─ Bảng liên kết:
   │  ├─ SinhVien sv (Primary)
   │  ├─ Nganh n (LEFT JOIN on sv.MaNganh = n.MaNganh)
   │  └─ KhoaTuyenSinh kts (LEFT JOIN on sv.MaKhoaTS = kts.MaKhoaTS)
   ├─ Status: ✅ CÓ SỬ DỤNG
   └─ Column Names: ✅ CHUẨN

-- ========== STORED PROCEDURES CŨNG CẦN CHECK/FIX ==========

8. sp_GetLecturerClasses.sql (CŨNG)
   ├─ Status: ⚠️ Có file _NEW.sql rồi, file này có thể xóa
   └─ Ghi chú: Duplicate với sp_GetLecturerClasses_NEW.sql

9. sp_Enrollment_Update.sql
   ├─ Status: ⚠️ Cần check xem có dùng hay không
   └─ Ghi chú: Tên giống với chức năng RegisterCourse

10. sp_ClassManagement.sql (CŨNG)
    ├─ Status: ⚠️ Có file sp_GetClassManagement.sql rồi
    └─ Ghi chú: Duplicate

11. sp_Check_Conflict.sql
    ├─ Status: ⚠️ Cần check xem có dùng hay không
    └─ Ghi chú: Tên không rõ chức năng

12. sp_LayThongTinSinhVien.sql
    ├─ Status: ⚠️ Tương tự sp_GetStudentInfo.sql
    └─ Ghi chú: Duplicate với language khác (tiếng Việt vs English)

13. sp_Lecturer_Filter.sql
    ├─ Status: ⚠️ Cần check xem có dùng hay không
    └─ Ghi chú: Có thể là filter giảng viên

14. sp_MasterData_Lecturer.sql
    ├─ Status: ⚠️ Cần check xem có dùng hay không
    └─ Ghi chú: Master data cho giảng viên

15. sp_MasterData_Remaining.sql
    ├─ Status: ⚠️ Cần check xem có dùng hay không
    └─ Ghi chú: Master data còn lại

-- ========== FIX ENCODING SCRIPTS (KHÔNG CẦN) ==========

16. Fix_All_Encoding_Direct.sql
17. Fix_Encoding_All.sql
18. Fix_Encoding_Reinit.sql
19. Fix_Encoding_SchemaTable1.sql
20. Fix_Encoding_SchemaTable2.sql
21. Fix_Encoding_SchemaTable3.sql
22. Fix_Encoding_SchemaTable4.sql
23. Fix_Encoding_SchemaTable5.sql
24. Fix_Encoding_SchemaTable6.sql
25. Fix_Encoding_Update.sql
26. Fix_Enrollment_Mapping.sql
27. Fix_GiangVien_Encoding.sql
28. Fix_HocPhan_Encoding.sql
29. Fix_Registration_And_Encoding.sql
30. Fix_Remaining_Issues.sql
    ├─ Status: ⚠️ LỖI THỜI - Đã fix encoding bằng SampleData_03_Users_Fixed.sql
    └─ Ghi chú: Có thể XÓA - Không còn dùng

-- ========== CLEAN UP SCRIPTS ==========

31. Clean_Reinit_HocPhan.sql
    ├─ Status: ⚠️ Cần check
    └─ Ghi chú: Clean/Init dữ liệu HocPhan

32. Clean_Reinit_SampleData.sql
    ├─ Status: ⚠️ Cần check
    └─ Ghi chú: Clean/Init sample data

33. RunAllStoredProcedures.sql
    ├─ Status: ⚠️ Dùng :r directive (không work với sqlcmd)
    └─ Ghi chú: Cần sửa hoặc tạo batch script

-- ========== CHƯA PHÂN LOẠI ==========

34. sp_RegisterCourse.sql
    ├─ Status: ⚠️ Có file _NEW.sql rồi
    └─ Ghi chú: Duplicate với sp_RegisterCourse_NEW.sql

-- =============================================
-- KẾT LUẬN
-- =============================================

✅ SPs CÓ SỬ DỤNG:
  1. sp_GetEnrollmentStatus.sql
  2. sp_GetClassManagement.sql
  3. sp_UpdateClassStatus_NEW.sql
  4. sp_GetLecturerClasses_NEW.sql
  5. sp_RegisterCourse_NEW.sql
  6. sp_GetStudentInfo.sql

⚠️ CẦN CLEAN UP:
  - Xóa file cũ: sp_GetLecturerClasses.sql, sp_RegisterCourse.sql, sp_ClassManagement.sql
  - Xóa file Fix Encoding (đã không dùng)
  - Sửa RunAllStoredProcedures.sql (hoặc tạo batch mới)

❌ CẦN FIX:
  - sp_UpdateClassStatus.sql (dùng @MaLopHP sai, nên dùng @MaLHP)
  - Check & verify sp_Enrollment_Update.sql, sp_Check_Conflict.sql, etc.

-- =============================================
-- LIÊN KẾT BẢNG - SUMMARY
-- =============================================

Bảng chính được sử dụng:
├─ SinhVien (6 SPs)
├─ GiangVien (3 SPs)
├─ HocPhan (3 SPs)
├─ LopHocPhan (5 SPs - Bảng quan trọng nhất)
├─ DangKyHocPhan (4 SPs)
├─ Nganh (1 SP)
└─ KhoaTuyenSinh (1 SP)

Column names đã được chuẩn hóa:
✅ LopHocPhan: MaLHP (không phải MaLopHP)
✅ HocPhan: TenHP, SoTinChi (không phải TenHocPhan, SoTC)
✅ DangKyHocPhan: Id (không phải MaDangKy), MaLHP (FK)
✅ LopHocPhan: ThuTrongTuan (không phải Tuan)

GO
