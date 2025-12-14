# Quy trình quản lý đào tạo (nâng cấp từ QLSV)

## Chuỗi nghiệp vụ tổng thể
1. Lập kế hoạch học kỳ.
2. Mở lớp/Section (DRAFT).
3. Xếp thời khóa biểu → Section OPEN.
4. SV đăng ký học phần.
5. Tính học phí.
6. Thanh toán.
7. Chốt lớp (RUNNING/CANCELED/MERGED) + roster final.

## Các bước chi tiết

### 1. Lập kế hoạch học kỳ
- Vai trò: Phòng Đào tạo (chủ trì) + Khoa.
- Input: CTĐT (version), thống kê SV theo CT (môn phải học kỳ này), danh sách rớt/học lại kỳ trước, teaching load GV, phòng/thiết bị.
- Xử lý: Hệ thống gợi ý nhu cầu theo môn (SV tiến độ + học lại). Phòng Đào tạo chốt danh sách môn mở (PlannedCourse), số lớp dự kiến mỗi môn (PlannedSections), sĩ số min/max, hình thức; Khoa đề xuất GV.
- Output/Data: SemesterPlan, PlannedCourseList, PlannedSectionCount, ProposedFaculty.
- Liên kết & lưu ý: Đây là đầu vào duy nhất để mở lớp; thiếu kế hoạch → mở lớp tùy tiện, khó kiểm soát min-open và tải phòng/GV.

### 2. Mở lớp học phần (Section/Course Offering)
- Vai trò: Phòng Đào tạo.
- Input: PlannedCourseList + PlannedSectionCount.
- Xử lý: Tạo Section (mã lớp, mã môn, min/max, hình thức, thời lượng), gán GV dự kiến; trạng thái Section = DRAFT.
- Output/Data: Section (DRAFT), CapacityMin/Max.
- Liên kết: Section là hub nối TKB + đăng ký + học phí + điểm; chưa có Section thì không xếp TKB/đăng ký.

### 3. Xếp thời khóa biểu (Timetable Scheduling)
- Vai trò: Phòng Đào tạo + Khoa.
- Input: Section DRAFT, lịch rảnh GV, tài nguyên phòng/thiết bị.
- Xử lý: Auto-schedule theo rule (không trùng GV, không trùng phòng, ưu tiên môn core), chỉnh tay; gán phòng-ca-ngày và GV chính thức; khi chốt TKB → publish SectionStatus = OPEN.
- Output/Data: TimetableDraft & TimetableOfficial, RoomAllocation, FacultyAssignment, SectionStatus=OPEN, TimetableChangeLog.
- Liên kết: Chỉ Section OPEN + TKB official mới xuất hiện trên portal đăng ký; nếu đổi TKB sau đăng ký phải đi flow reconcile/auto-swap và log thay đổi.

### 4. Sinh viên đăng ký học phần (Enrollment)
- Vai trò: SV + Hệ thống.
- Input: SectionStatus=OPEN, điều kiện tiên quyết (Catalog), rào chắn tài chính/học vụ, rule tín chỉ min/max.
- Xử lý realtime: SV chọn lớp; hệ thống kiểm tra Prerequisite, ScheduleConflict, CreditMinMax, FinancialHold, AcademicHold; pass → ghi danh tạm (TEMP_ENROLL), SV xác nhận → ENROLLED; full → WAITLIST; log thất bại kèm reason tags.
- Output/Data: EnrollmentTemp, EnrollmentOfficial, Waitlist, FailEnrollmentLog.
- Liên kết: EnrollmentOfficial là đầu vào duy nhất để tính học phí; Waitlist dùng mở thêm/điều chuyển khi có slot.

### 5. Tính học phí (Billing)
- Vai trò: Hệ thống + Tài chính.
- Input: EnrollmentOfficial.
- Xử lý: Tính phí theo tín chỉ/loại môn/chương trình; áp học bổng/miễn giảm; sinh Invoice kèm due-date; đẩy portal + thông báo.
- Output/Data: Invoice/StudentBill, DiscountScholarshipApplied, PaymentDueDate.
- Liên kết: Chỉ ENROLLED mới sinh phí; invoice quá hạn tạo rào chắn (hold) nếu cần.

### 6. Thanh toán (Payment)
- Vai trò: SV + Kế toán + Hệ thống.
- Input: Invoice.
- Xử lý: SV thanh toán online/offline; kế toán đối soát; hệ thống cập nhật PaymentStatus = PAID | PARTIAL | OVERDUE. Nếu OVERDUE → tự kích hoạt FinancialHold (có thể chặn đăng ký, thi, xét TN).
- Output/Data: PaymentReceipt, PaymentStatus, FinancialHoldLog.
- Liên kết: Payment status quay ngược về quyết định giữ/hủy ghi danh và quyền thi.

### 7. Chốt lớp sau đăng ký (Class Finalization)
- Vai trò: Phòng Đào tạo.
- Input: EnrollmentOfficial, PaymentStatus, CapacityMin/Max.
- Xử lý: Kiểm tra sĩ số; nếu < min-open → hủy/ghép lớp; nếu đạt → xác nhận lớp chạy. Khi hủy: hoàn phí/chuyển lớp, xử lý waitlist. Khóa danh sách lớp chính thức (FinalClassRoster) để điểm danh/sync LMS/thi.
- Output/Data: SectionStatus=RUNNING hoặc CANCELED/MERGED, FinalClassRoster, Refund/TransferRecord, SyncToLMS.
- Liên kết: Không có roster final sẽ làm sai điểm danh/thi/nhập điểm.

## Điểm kiểm soát bắt buộc
- Catalog môn là master; không tạo môn ad-hoc ngoài kế hoạch.
- Section là hub; mọi TKB/ĐK/học phí/điểm gắn vào Section.
- Chỉ OPEN + TKB official mới cho đăng ký (tránh SV chọn lớp chưa có lịch).
- Chỉ EnrollmentOfficial mới sinh học phí; TEMP_ENROLL không sinh phí.
- FinancialHold chạy xuyên suốt: chặn đăng ký + thi + xét TN theo policy.
- Min-open/Cancel rule phải áp ở bước chốt lớp; tránh mở lớp dư, thu phí sai.

## Ngoại lệ cần workflow riêng
- Đổi TKB sau khi SV đã đăng ký: Đào tạo đổi TKB → hệ thống tạm đặt SV vào trạng thái “mất lịch” → cho SV chọn lớp khác hoặc auto-swap theo ưu tiên → log thay đổi. Output: ScheduleChangeImpactList, AutoSwapLog.
- SV không đóng phí đúng hạn: Đến hạn → OVERDUE → chuyển ENROLLED → PENDING_CANCEL, hết grace → CANCELED_BY_FINANCE. SV muốn học tiếp phải đóng phí + xin mở lại. Output: PendingCancelList, FinanceCancelLog, ReinstateRequest.
- Hủy lớp do < min-open: Hủy lớp → hoàn phí (nếu đã thu) → chuyển SV sang lớp khác → notify. Output: CanceledSectionRoster, RefundRecord, TransferredEnrollment.

## Ghi nhớ kiến trúc & trạng thái
- Entity lõi: Program, CurriculumVersion, Course, Prerequisite, SemesterPlan, Section, TimetableSlot, FacultyAssignment, Enrollment, Waitlist, Invoice, Payment, Hold, FinalRoster.
- Trạng thái: Section (DRAFT/OPEN/RUNNING/CANCELED/MERGED), Enrollment (TEMP/ENROLLED/WAITLIST/PENDING_CANCEL), Invoice (UNPAID/PARTIAL/PAID/OVERDUE).
- Event/Log: timetable_changed, enrollment_failed, waitlist_promoted, invoice_due, payment_overdue, section_canceled; dùng cho thông báo đa kênh và audit.
