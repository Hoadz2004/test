# Database Scripts – Safe Run Order

## Mục tiêu
Giảm rủi ro trùng/xung đột dữ liệu khi chạy script trên DB đã lớn. Dưới đây là bộ file “chuẩn” và thứ tự khuyến nghị. Các script khác chỉ chạy khi cần, có ghi chú rõ.

## Thứ tự chạy chuẩn
1. **Schema (bảng/constraint)**
   - `Schema_GradeManagement.sql`
   - `Schema_StudentGrades.sql`
   - (Các file schema khác trong `Schema bảng` nếu có)

2. **Indexes**
   - Thư mục `Indexes/` (ví dụ: `IX_AuditLog_FilterPaging.sql`, `IX_TuitionPaging.sql`, …)

3. **Stored Procedures (bản chuẩn)**
   - `CreateStoredProcedures.sql` (hoặc chạy từng file trong `StoredProcedures/` và `StoreProduce/` tùy nhu cầu, nhưng chỉ **một** phiên bản cho mỗi SP).
   - Sử dụng **sp_CreateUserFull.sql** là bản chuẩn cho `sp_CreateUserAccount` (tránh trùng với bản trong `sp_Admin.sql`).

4. **Seed tối thiểu (dữ liệu thật)**
   - Seed ngành/khoa/học phí thực tế trước khi mở đăng ký: thêm dòng vào `HocPhiCatalog` cho từng `MaNganh` + `MaHK`.
   - Seed tài khoản quản trị (nếu cần) qua `CreateAdminAccounts.sql`.
   - Sample data chỉ chạy ở môi trường test.

## Script KHÔNG chạy mặc định / chỉ dùng khi cần
- `sp_SeedHocPhiDefaults.sql`: chỉ dùng để seed nhanh học phí mặc định khi môi trường trống. **Không dùng cho dữ liệu thật.**
- Các script fix/patch riêng: `Fix_Vietnamese_Encoding_DangKyHocPhan.sql`, `Fix_CTDT_Encoding.sql`, `FixSinhVienConstraint.sql`, `Fix_Grade_Logic.sql`… chỉ chạy khi đúng vấn đề.
- Sample/Import test: `CreateSampleData_Enrollment.sql`, `SampleData_LecturerGrades.sql`, `OpenMoreClasses.sql`, `OptimizeEnrollment.sql`, `EnrollmentSPs.sql`, `GradeSPs.sql`… chỉ dùng ở môi trường thử nghiệm.

## Lưu ý vận hành
- Mỗi chức năng chỉ giữ **một** SP chuẩn (ví dụ `sp_CreateUserAccount` dùng bản trong `sp_CreateUserFull.sql`, không song song với `sp_Admin.sql`).
- Trước khi chạy patch trên dữ liệu lớn: backup hoặc chạy staging.
- Khi mở kỳ mới: bắt buộc kiểm tra `HocPhiCatalog` đã đủ cho từng ngành/kỳ. Nếu thiếu, công nợ sẽ tính 0 (fail-soft) nhưng không phản ánh đúng nghiệp vụ.

## Gợi ý dọn dẹp
- Đưa các script legacy/test vào thư mục riêng hoặc đánh dấu “DO NOT RUN” để tránh nhầm.
- Đọc README trước khi chạy `RunAllSqlScripts.bat`: bảo đảm chỉ chứa file chuẩn ở thứ tự trên.

## Phân loại file hiện có (snapshot)

### Gốc `/database`
- **Schema**: `Schema_GradeManagement.sql`, `Schema_StudentGrades.sql`.
- **SP chuẩn (gộp)**: `CreateStoredProcedures.sql` (gồm nhiều SP chuẩn).
- **SP riêng**: `sp_CreateUserFull.sql` (bản chuẩn `sp_CreateUserAccount`), `sp_LoginFirstLogin.sql`, `sp_Profile.sql`.
- **Indexes**: thư mục `Indexes/` (không liệt kê chi tiết ở đây).
- **Seed/Test**: `CreateSampleData_Enrollment.sql`, `SampleData_LecturerGrades.sql`, `OpenMoreClasses.sql`, `OptimizeEnrollment.sql`, `RunSampleData.bat`, `RunAllSqlScripts.bat` (cần rà lại nội dung trước khi dùng).
- **Patch/Fix**: `Fix_CTDT_Encoding.sql`, `Fix_Grade_Logic.sql`, `Fix_Vietnamese_Encoding_DangKyHocPhan.sql`, `FixSinhVienConstraint.sql`.
- **Khác**: `EnrollmentSPs.sql`, `GradeSPs.sql` (gói SP thử nghiệm/test), `CreateAdminAccounts.sql`, `doc*.md`.

### `/database/StoredProcedures`
- `sp_CheckTrungLich.sql`, `sp_GetAuditLogs.sql`, `sp_LayDanhSachLopHocPhan_Admin.sql`, `sp_SuaLopHocPhan.sql`, `sp_ThemLopHocPhan.sql` (5 SP riêng lẻ).

### `/database/StoreProduce`
- **SP nghiệp vụ chính**: `sp_Admin.sql`, `sp_Admissions*.sql`, `sp_ClassManagement.sql`, `sp_Enrollment_Update.sql`, `sp_GetEnrollmentStatus.sql`, `sp_RegisterCourse.sql`, `sp_Payment_*`, `sp_UpdateClassStatus.sql`, `sp_CheckTienQuyet.sql`, `sp_Check_Conflict.sql`, `sp_GetStudentInfo.sql`, `sp_GetLecturerClasses.sql`, `sp_MasterData_*`, `sp_TrainingProgram.sql`, `sp_LayThongTinSinhVien.sql`, `sp_Lecturer_Filter.sql`.
- **Fix/Encoding**: nhiều file `Fix_*Encoding*.sql`, `Fix_Registration_And_Encoding.sql`, `Fix_Remaining_Issues.sql`, `Fix_All_*`.
- **Seed/Test**: `Seed_HocPhiCatalog_Default.sql`, `sp_SeedHocPhiDefaults.sql`, `Clean_Reinit_*`, `RunAllStoredProcedures_CORRECTED.sql`, `Clean_Reinit_SampleData.sql`.
- **Inventory**: `00_STORED_PROCEDURES_INVENTORY*.sql` (danh sách SP).

**Lưu ý:** chỉ chọn một phiên bản SP chuẩn cho mỗi chức năng (ví dụ sp_CreateUserAccount dùng bản trong `sp_CreateUserFull.sql`; tránh dùng thêm bản trong `sp_Admin.sql` nếu không cần). Các file seed/fix/test chỉ chạy khi đã đọc nội dung và xác nhận phù hợp môi trường. 
