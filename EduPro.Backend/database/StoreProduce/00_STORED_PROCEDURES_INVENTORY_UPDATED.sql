-- =============================================
-- STORED PROCEDURES INVENTORY - PHÂN LOẠI HOÀN CHỈNH
-- =============================================
-- Ngày: 2025-12-11
-- Tổng số: 34 files
-- ✅ UPDATED: Đã gộp duplicates, giữ lại Fix Encoding

-- ========== STORED PROCEDURES CHÍNH - CÓ SỬ DỤNG ==========

 1. sp_GetEnrollmentStatus.sql
    ├─ Chức năng: Lấy kết quả đăng ký học phần của sinh viên
    ├─ Bảng: DangKyHocPhan → LopHocPhan → HocPhan → GiangVien
    ├─ Status: ✅ SỬ DỤNG
    └─ Column Names: ✅ CHUẨN

 2. sp_GetClassManagement.sql
    ├─ Chức năng: Lấy danh sách lớp học phần cho quản lý
    ├─ Bảng: LopHocPhan → HocPhan → GiangVien → DangKyHocPhan
    ├─ Status: ✅ SỬ DỤNG
    └─ Column Names: ✅ CHUẨN

 3. sp_UpdateClassStatus.sql (✅ ĐÃ GỘP _NEW)
    ├─ Chức năng: Cập nhật trạng thái lớp học phần
    ├─ Bảng: LopHocPhan (UPDATE)
    ├─ Status: ✅ SỬ DỤNG - Đã fix @MaLHP
    └─ Column Names: ✅ CHUẨN

 4. sp_GetLecturerClasses.sql (✅ ĐÃ GỘP _NEW)
    ├─ Chức năng: Lấy danh sách lớp học phần của giảng viên
    ├─ Bảng: LopHocPhan → HocPhan → DangKyHocPhan
    ├─ Status: ✅ SỬ DỤNG
    └─ Column Names: ✅ CHUẨN

 5. sp_RegisterCourse.sql (✅ ĐÃ GỘP _NEW)
    ├─ Chức năng: Đăng ký học phần
    ├─ Bảng: SinhVien → LopHocPhan → DangKyHocPhan
    ├─ Status: ✅ SỬ DỤNG
    └─ Column Names: ✅ CHUẨN

 6. sp_GetStudentInfo.sql
    ├─ Chức năng: Lấy thông tin chi tiết sinh viên
    ├─ Bảng: SinhVien → Nganh → KhoaTuyenSinh
    ├─ Status: ✅ SỬ DỤNG
    └─ Column Names: ✅ CHUẨN

-- ========== STORED PROCEDURES CẦN VERIFY/UPDATE ==========

 7. sp_Enrollment_Update.sql
    ├─ Chức năng: Update enrollment (cần verify)
    ├─ Status: ⚠️ CẦN CHECK
    └─ Ghi chú: Có thể là version cũ của RegisterCourse

 8. sp_Check_Conflict.sql
    ├─ Chức năng: Check conflict (cần verify)
    ├─ Status: ⚠️ CẦN CHECK
    └─ Ghi chú: Tên không rõ chức năng

 9. sp_ClassManagement.sql (CŨNG)
    ├─ Status: ⚠️ CẦN XÓA - Duplicate của sp_GetClassManagement.sql
    └─ Ghi chú: File cũ, không dùng

10. sp_LayThongTinSinhVien.sql
    ├─ Chức năng: Lấy thông tin sinh viên (tiếng Việt)
    ├─ Status: ⚠️ CẦN XÓA - Duplicate của sp_GetStudentInfo.sql
    └─ Ghi chú: Giống chức năng, tên khác

11. sp_Lecturer_Filter.sql
    ├─ Chức năng: Filter giảng viên (cần verify)
    ├─ Status: ⚠️ CẦN CHECK
    └─ Ghi chú: Có thể là version lọc giảng viên

12. sp_MasterData_Lecturer.sql
    ├─ Chức năng: Master data giảng viên
    ├─ Status: ⚠️ CẦN CHECK
    └─ Ghi chú: Có thể dùng cho initial data

13. sp_MasterData_Remaining.sql
    ├─ Chức năng: Master data còn lại
    ├─ Status: ⚠️ CẦN CHECK
    └─ Ghi chú: Có thể dùng cho initial data

-- ========== STORED PROCEDURES XÓA (CŨNG CÓ CÁC FILE _NEW) ==========

14. sp_GetLecturerClasses_NEW.sql
    ├─ Status: ✅ ĐÃ GỘP vào sp_GetLecturerClasses.sql → CÓ THỂ XÓA

15. sp_RegisterCourse_NEW.sql
    ├─ Status: ✅ ĐÃ GỘP vào sp_RegisterCourse.sql → CÓ THỂ XÓA

16. sp_UpdateClassStatus_NEW.sql
    ├─ Status: ✅ ĐÃ GỘP vào sp_UpdateClassStatus.sql → CÓ THỂ XÓA

-- ========== FIX ENCODING SCRIPTS (GIỮ LẠI!) ==========
-- ⚠️ QUAN TRỌNG: Những file này sửa lỗi encoding trong database
-- Không được xóa! Chỉ chạy khi cần fix dữ liệu

17. Fix_All_Encoding_Direct.sql
    ├─ Chức năng: Fix encoding toàn bộ trực tiếp
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu
    └─ Chạy khi: Có lỗi encoding trong database

18. Fix_Encoding_All.sql
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu

19. Fix_Encoding_Reinit.sql
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu

20. Fix_Encoding_SchemaTable1.sql
21. Fix_Encoding_SchemaTable2.sql
22. Fix_Encoding_SchemaTable3.sql
23. Fix_Encoding_SchemaTable4.sql
24. Fix_Encoding_SchemaTable5.sql
25. Fix_Encoding_SchemaTable6.sql
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu
    └─ Chúc năng: Fix encoding từng bảng cụ thể

26. Fix_Encoding_Update.sql
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu
    └─ Chức năng: Update dữ liệu với encoding đúng

27. Fix_Enrollment_Mapping.sql
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu
    └─ Chức năng: Fix mapping enrollment

28. Fix_GiangVien_Encoding.sql
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu
    └─ Chức năng: Fix encoding bảng GiangVien

29. Fix_HocPhan_Encoding.sql
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu
    └─ Chức năng: Fix encoding bảng HocPhan

30. Fix_Registration_And_Encoding.sql
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu
    └─ Chức năng: Fix registration và encoding

31. Fix_Remaining_Issues.sql
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu
    └─ Chức năng: Fix các vấn đề còn lại

-- ========== CLEAN UP SCRIPTS ==========

32. Clean_Reinit_HocPhan.sql
    ├─ Chức năng: Clean/Init dữ liệu HocPhan
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu
    └─ Chạy khi: Cần reset dữ liệu HocPhan

33. Clean_Reinit_SampleData.sql
    ├─ Chức năng: Clean/Init sample data
    ├─ Status: ✅ GIỮ LẠI - Bảo trì dữ liệu
    └─ Chạy khi: Cần reset dữ liệu mẫu

-- ========== MASTER SCRIPTS ==========

34. RunAllStoredProcedures_CORRECTED.sql
    ├─ Chức năng: Chạy tất cả SPs chính
    ├─ Status: ✅ DÙNG CÁI NÀY
    └─ Chạy: sqlcmd -f 65001 -i RunAllStoredProcedures_CORRECTED.sql

-- =============================================
-- KẾT LUẬN & HƯỚNG DẪN
-- =============================================

✅ 6 SPs CHÍNH (SẢN XUẤT):
  1. sp_GetEnrollmentStatus.sql - Enrollment results
  2. sp_GetClassManagement.sql - Class management
  3. sp_UpdateClassStatus.sql - Update class status
  4. sp_GetLecturerClasses.sql - Lecturer classes
  5. sp_RegisterCourse.sql - Course registration
  6. sp_GetStudentInfo.sql - Student information

📋 CÓ THỂ XÓA:
  - sp_GetLecturerClasses_NEW.sql (đã gộp)
  - sp_RegisterCourse_NEW.sql (đã gộp)
  - sp_UpdateClassStatus_NEW.sql (đã gộp)
  - sp_ClassManagement.sql (duplicate)
  - sp_LayThongTinSinhVien.sql (duplicate)

⚠️ CẦN VERIFY:
  - sp_Enrollment_Update.sql
  - sp_Check_Conflict.sql
  - sp_Lecturer_Filter.sql
  - sp_MasterData_Lecturer.sql
  - sp_MasterData_Remaining.sql

✅ GIỮ LẠI (KHÔNG XÓA!):
  - Tất cả file Fix_*.sql (Bảo trì dữ liệu)
  - Clean_Reinit_*.sql (Reset dữ liệu khi cần)

-- =============================================
-- CÁCH CHẠY
-- =============================================

1. Chạy tất cả SPs chính:
   sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 -i RunAllStoredProcedures_CORRECTED.sql

2. Fix encoding nếu cần:
   sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 -i Fix_All_Encoding_Direct.sql

3. Reset dữ liệu mẫu nếu cần:
   sqlcmd -S 202.55.135.42 -U sa -P "Aa@0967941364" -d EduProDb -f 65001 -i Clean_Reinit_SampleData.sql

-- =============================================
GO
