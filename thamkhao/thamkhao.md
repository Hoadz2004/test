Dưới đây là checklist chuẩn “đầy đủ 100%” cho một hệ thống quản lý đào tạo SIS+ (nâng cấp từ quản lý sinh viên).
Mình viết theo 3 lớp: (A) Module & workflow, (B) Output dữ liệu bắt buộc, (C) Liên kết & kiểm soát hệ thống.
Bạn có thể dùng làm checklist nghiệm thu.

A. CHECKLIST MODULE + WORKFLOW (End-to-End)
A1. Tuyển sinh (Admission)

 Tạo đợt tuyển sinh (năm/khoá/ngành/cơ sở/phương thức)

 Nhận hồ sơ thí sinh (online/offline)

 Import dữ liệu điểm/thông tin thí sinh

 Rule tính điểm xét tuyển theo từng phương thức

 Xếp hạng → lọc quota → DS đề xuất trúng tuyển

 Hội đồng duyệt trúng tuyển

 Công bố DS trúng tuyển/không trúng tuyển

 Lưu version rule xét tuyển + audit log

A2. Nhập học (Enrollment / Matriculation)

 Check hồ sơ nhập học đủ/thiếu/không hợp lệ

 Xác nhận phí nhập học

 Sinh mã SV + email + tài khoản portal/LMS

 Gán lớp hành chính/khoá/ngành/CTĐT áp dụng

 Kích hoạt trạng thái SV “đang học”

 Lưu audit log thay đổi hồ sơ

A3. Cấu trúc học thuật & CTĐT (Academic Structure / Curriculum)

 Danh mục ngành–chuyên ngành–khoá–lớp

 Danh mục môn/học phần: TC, LT/TH, loại môn, bộ môn

 Tiên quyết / học trước / song hành

 Rule môn tương đương (equivalence)

 CTĐT khung theo kỳ (bắt buộc/tự chọn)

 Mapping môn ↔ CLO/PLO (OBE)

 Versioning CTĐT (phát hành vX.Y)

 CT chuyển tiếp cho SV cũ khi đổi version

A4. Kế hoạch đào tạo học kỳ/năm (Academic Planning)

 Ước lượng nhu cầu mở lớp (SV mới + SV học lại)

 Chọn môn mở kỳ này theo CTĐT

 Dự kiến số lớp/sĩ số min-max

 Dự kiến tải giảng dạy (teaching load)

 Chốt kế hoạch học kỳ + mốc học vụ

A5. Mở lớp học phần & Thời khoá biểu (Course Offering / Scheduling)

 Tạo lớp học phần (môn, sĩ số, hình thức, số buổi)

 Gán GV/bộ môn

 Phân bổ phòng-thiết bị-ca học

 Auto-schedule + manual adjust

 Publish TKB chính thức

 Trạng thái lớp: draft/open/full/canceled/merged

 Log thay đổi TKB/lớp

A6. Đăng ký học phần (Registration)

 Mở cổng đăng ký (theo khoá/ngành/đối tượng)

 SV xem gợi ý môn theo CTĐT

 Kiểm tra realtime:

 tiên quyết

 trùng lịch

 min/max TC

 nợ học phí/rào chặn

 cảnh báo học vụ/cấm đăng ký

 Ghi danh tạm (temporary) → xác nhận chính thức

 Waitlist + rule ưu tiên

 Mở thêm lớp khi waitlist vượt ngưỡng

 Luồng rút môn/đổi lớp trong hạn

 Khóa đăng ký

A7. Học phí – Công nợ – Rào chặn (Tuition / Finance)

 Tính học phí theo TC/loại môn

 Áp miễn-giảm/học bổng/chính sách

 Phát hành công nợ kỳ

 Đối soát thanh toán

 Rào chặn học vụ khi quá hạn (không đăng ký/không thi/không TN)

 Báo cáo đối soát học vụ-tài chính

A8. Tổ chức dạy học (Delivery / LMS)

 GV publish syllabus/học liệu

 Sync lớp SIS ↔ LMS (nếu có)

 Dạy offline/online/blended theo TKB

 Bài tập/quiz/thảo luận

 Ghi log học tập & activity LMS

 Theo dõi tiến độ học phần

A9. Chuyên cần – Cảnh báo học vụ (Attendance / Early Warning)

 Điểm danh theo buổi (QR/manual/LMS)

 Tính % chuyên cần theo rule

 Quy trình xin phép/giải trình vắng

 Auto cấm thi khi vắng vượt ngưỡng

 Rule cảnh báo học vụ (vắng nhiều/điểm thấp/GPA thấp)

 Gửi cảnh báo SV + CVHT + Khoa

A10. Thi – Điểm – Phúc khảo (Exams / Grades)

 Tạo đợt thi cuối kỳ/giữa kỳ

 Xếp lịch thi + phòng thi + SBD

 Phân công giám thị/hội đồng

 DS dự thi (lọc theo cấm thi/nợ phí)

 Nhập điểm thành phần QT/TH/CK

 Tính điểm tổng + điểm chữ

 Điểm draft → duyệt bộ môn → khóa điểm học phần

 Khóa điểm toàn kỳ

 Luồng phúc khảo (nộp đơn → chấm lại → update version điểm)

 Audit log sửa điểm + lý do

 Log kỷ luật thi

A11. Tổng kết học kỳ (Semester Closing)

 Tính GPA kỳ & CPA tích luỹ

 Xếp loại học lực

 Cập nhật trạng thái học vụ:

 học tiếp

 cảnh báo

 buộc thôi học

 bảo lưu/chuyển ngành

 DS học lại/học cải thiện kỳ sau

 Log quyết định học vụ

A12. Thực tập – Đồ án – Luận văn (Internship / Thesis)

 Auto check điều kiện tham gia (TC/GPA/môn tiên quyết)

 Mở đợt + danh sách đề tài/đơn vị

 SV đăng ký nguyện vọng

 Phân công GVHD/DN thực tập

 Theo dõi tiến độ + nhật ký + feedback

 Chấm điểm theo rubric

 Hội đồng bảo vệ + biên bản + điểm

A13. Xét tốt nghiệp – Cấp bằng (Graduation)

 Mở đợt xét TN theo khoá/ngành

 Rule check tự động:

 đủ TC bắt buộc/tự chọn

 CPA/GPA đạt chuẩn

 đạt chuẩn đầu ra NN/TH/kỹ năng

 không nợ học phí

 không bị kỷ luật chưa xoá

 DS đủ điều kiện / thiếu điều kiện (chi tiết thiếu gì)

 Hội đồng TN duyệt

 Khóa DS TN

 Cấp số bằng/serial/QR

 In VBCC + bảng điểm + phụ lục

 Tra cứu văn bằng online

 Lưu version rule xét TN + audit log

A14. Báo cáo – Kiểm định – BI (Reporting / QA)

 Dashboard vận hành realtime (đăng ký, lớp, điểm, chuyên cần, học phí, TN)

 Báo cáo chuẩn Bộ/kiểm định (AUN-QA/ABET/MOET…)

 Báo cáo CLO/PLO attainment (nếu OBE)

 Export Excel/PDF/API BI

 Data warehouse/ETL chuẩn

A15. Quản trị hệ thống (Admin / Security)

 Quản lý tổ chức (khoa/ngành/lớp/cơ sở)

 Quản lý user (SV/GV/nhân sự) + import

 Phân quyền RBAC/ABAC theo vai trò & đơn vị

 Nhật ký hoạt động (audit log)

 Sao lưu/khôi phục dữ liệu

 SSO/LDAP/AzureAD (nếu cần)

 Cấu hình thông báo đa kênh (email/app/Zalo/Teams)

B. CHECKLIST OUTPUT DỮ LIỆU BẮT BUỘC (per module)

Tuyển sinh

 DS trúng tuyển

 DS không trúng tuyển + lý do

 Trạng thái hồ sơ thí sinh

 Log xét tuyển + version rule

Nhập học

 Mã SV

 Lớp hành chính/khoá/ngành/cơ sở

 Tài khoản portal/LMS

 Trạng thái phí nhập học + biên lai

 Audit log hồ sơ SV

CTĐT

 Catalog môn/học phần

 Prerequisite / equivalence

 Version CTĐT

 CT chuyển tiếp

 Mapping CLO/PLO + chuẩn đầu ra ngoài môn

Kế hoạch kỳ

 DS môn mở

 Dự kiến số lớp & sĩ số min-max

 Teaching load dự kiến

 Mốc học vụ kỳ

Mở lớp/TKB

 DS lớp học phần

 Phòng-thiết bị-ca học đã phân bổ

 TKB draft → official

 Trạng thái lớp + log thay đổi

Đăng ký

 DS đăng ký chính thức

 DS đăng ký tạm

 Waitlist + thứ tự ưu tiên

 DS fail đăng ký + lý do fail

 DS rút môn/đổi lớp

 Học phí theo TC

Dạy học

 Syllabus publish

 Học liệu

 Log học tập

 Activity LMS + tiến độ

Chuyên cần

 Log điểm danh

 % attendance theo buổi/môn

 DS xin phép/giải trình

 DS cấm thi

 DS cảnh báo học vụ

Thi/điểm

 Lịch thi + phòng thi + SBD

 DS dự thi

 Biên bản thi/kỷ luật thi

 Bảng điểm draft

 Bảng điểm locked

 Phúc khảo log + version điểm

Tổng kết kỳ

 GPA kỳ

 CPA tích luỹ

 Xếp loại học lực

 Trạng thái học vụ

 DS học lại/cải thiện

Thực tập/luận văn

 DS đủ điều kiện tham gia

 DS phân công GVHD/DN

 Nhật ký tiến độ + feedback

 Rubric điểm + biên bản bảo vệ

Tốt nghiệp

 DS đủ điều kiện + thiếu điều kiện (chi tiết)

 DS TN chính thức

 Văn bằng + QR/serial

 Rule xét TN version + audit

Báo cáo

 Dashboard vận hành

 Báo cáo kiểm định

 Dataset BI/ETL chuẩn

 Báo cáo đối soát học vụ-tài chính

 Báo cáo CLO/PLO attainment (nếu áp dụng)

C. CHECKLIST LIÊN KẾT & KIỂM SOÁT (đảm bảo chạy “đúng 100%”)
C1. Liên kết dữ liệu bắt buộc giữa module

 Tuyển sinh → Nhập học (đúng ngành/khoá/cơ sở)

 Nhập học → CTĐT áp dụng đúng version

 CTĐT → Kế hoạch kỳ (môn mở theo CT + điều kiện)

 Kế hoạch kỳ → Mở lớp/TKB (đúng số lớp & teaching load)

 Mở lớp/TKB → Đăng ký (chỉ lớp open mới cho đăng ký)

 Đăng ký → Học phí (tính phí từ ghi danh chính thức)

 Học phí → Đăng ký/Thi/TN (rào chặn xuyên suốt)

 Đăng ký → Dạy học/LMS (sync DS lớp chuẩn)

 Dạy học/Attendance → Cấm thi/ cảnh báo

 Cấm thi → DS dự thi

 Điểm locked → Tổng kết kỳ

 Tổng kết kỳ → Kế hoạch kỳ sau (nhu cầu học lại)

 Tổng kết kỳ + Thực tập + Học phí → Xét TN

 Tất cả → BI/Report

C2. Kiểm soát hệ thống (governance)

 Single Source of Truth: mỗi dữ liệu lõi có 1 nơi master

 Versioning: CTĐT, Rule xét tuyển, Rule xét TN, GradeVersion

 Audit log mọi thay đổi high-stake (điểm, CT, học vụ, TN)

 RBAC/ABAC đúng vai trò, đúng đơn vị

 Transaction integrity: ghi danh ↔ học phí ↔ cấm thi không mâu thuẫn

 Data quality checks: trùng mã SV/lớp/môn, lệch TC, lệch GPA

 Backup/restore + DR

 Notification engine theo sự kiện học vụ

C3. Bộ test E2E tối thiểu

 Kịch bản SV bình thường đi hết vòng đời

 Kịch bản SV rớt môn/học lại/đổi CT version

 Kịch bản SV nợ phí bị rào chặn đăng ký-thi-TN

 Kịch bản phúc khảo đổi điểm có audit log

 Kịch bản cấm thi do chuyên cần

 Kịch bản xét TN thiếu chuẩn NN/TH