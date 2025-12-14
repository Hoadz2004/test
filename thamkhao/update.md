1. Mô tả đề tài & điểm “nâng cấp” so với Quản lý sinh viên

Không chỉ quản lý thông tin sinh viên, hệ thống bao trùm gần như toàn bộ quy trình đào tạo:

Cấu hình năm học – học kỳ – khoa – ngành – chương trình đào tạo

Mở lớp học phần, xếp thời khóa biểu

Sinh viên đăng ký học phần theo tín chỉ, ràng buộc tiên quyết

Giảng viên quản lý lớp, điểm danh, nhập điểm

Hệ thống tính điểm tổng kết, GPA, cảnh báo học vụ

Phòng đào tạo xét tốt nghiệp

2. Tác nhân chính

Admin hệ thống

Phòng đào tạo

Giảng viên

Sinh viên

(Tuỳ chọn) Ban giám hiệu / Khoa – xem báo cáo tổng hợp

3. Các module chính & cách liên kết
3.1. Module Quản trị hệ thống

Quản lý User, Role, Permission

Phân quyền:

Role Admin, PhòngĐT, GiảngViên, SinhVien

Log hoạt động (ai đăng nhập, nhập điểm, sửa điểm,…)

Bảng DB gợi ý:

Users, Roles, UserRoles, Permissions, RolePermissions, AuditLogs

Liên kết: Mọi module đều sử dụng Users để xác định quyền truy cập.

3.2. Module Danh mục – Cấu hình đào tạo

Năm học, học kỳ

Khoa, ngành, chuyên ngành

Môn học (Course)

Số tín chỉ

LT/TH

Môn tiên quyết (prerequisite)

Phòng học, ca học (tiết, thứ, slot)

Bảng DB:

AcademicYear, Semester

Faculty, Major, Class (lớp hành chính)

Course, CoursePrerequisite

Room, TimeSlot

Liên kết:

Major → dùng cho chương trình đào tạo

Course → dùng cho chương trình và lớp học phần

TimeSlot, Room → dùng cho xếp TKB

3.3. Module Hồ sơ sinh viên – giảng viên

Quản lý thông tin cá nhân:

Sinh viên: MSSV, khóa, lớp, ngành, trạng thái (đang học, bảo lưu, thôi học)

Giảng viên: khoa, học vị, chuyên môn

Liên kết đến account đăng nhập (Users)

Bảng DB:

Student (FK → Users)

Lecturer (FK → Users)

Liên kết: Student gắn với Major, Class. Lecturer gắn với Faculty.

3.4. Module Chương trình đào tạo (CTĐT) & Kế hoạch học tập

Định nghĩa CTĐT cho từng ngành/khóa:

Danh sách môn học, số tín chỉ

Môn bắt buộc / tự chọn

Kỳ gợi ý học (HK1, HK2, …)

Sinh kế hoạch học tập cá nhân cho sinh viên dựa trên CTĐT + tiến độ thực tế.

Bảng DB:

Curriculum (chương trình cho 1 ngành + khóa)

CurriculumCourse (liệt kê môn trong CTĐT, số kỳ gợi ý, bắt buộc/tự chọn)

Liên kết:

Curriculum → Major

Student → tham chiếu đến Curriculum để sinh kế hoạch học tập.

3.5. Module Mở lớp học phần & Xếp thời khóa biểu

Phòng đào tạo:

Chọn học kỳ, danh sách môn sẽ mở

Tạo Lớp học phần (LHP): mã LHP, môn, giảng viên, sĩ số tối đa

Gán phòng học + khung giờ (TimeSlot) cho từng LHP

Tránh trùng TKB (cùng lớp, cùng sinh viên, cùng giảng viên,…)

Bảng DB:

ClassSection (Lớp học phần)

FK → Course, Semester, Lecturer

ClassSectionSchedule

FK → ClassSection, Room, TimeSlot

Liên kết:

Course + Semester → mở ClassSection

Lecturer dạy ClassSection

TKB sinh từ ClassSectionSchedule

3.6. Module Đăng ký học phần

Đây là phần “nâng cấp” rõ nhất so với chỉ quản lý sinh viên.

Sinh viên xem:

CTĐT cá nhân

Danh sách môn được mở trong kỳ, lớp học phần còn chỗ

Đăng ký / hủy đăng ký môn trong thời gian cho phép

Hệ thống tự kiểm tra:

Đã học / đang học / đã đậu môn tiên quyết?

Vượt quá tín chỉ tối đa/tối thiểu trong kỳ?

Lịch học trùng nhau?

Lớp đã đầy?

Ghi lại lịch sử đăng ký

Bảng DB:

Registration (đăng ký lớp học phần)

FK → Student, ClassSection

Trạng thái: ĐãĐK, Hủy, RútSauThờiHạn,…

Liên kết:

Student ↔ ClassSection qua Registration

Dữ liệu này dùng cho:

Điểm danh

Nhập điểm

Tính GPA, tiến độ

3.7. Module Giảng dạy – Điểm danh – Điểm số

Giảng viên:

Xem danh sách sinh viên của lớp học phần mình dạy

Điểm danh theo buổi

Khai báo cấu trúc điểm:

Ví dụ: Chuyên cần 10%, Giữa kỳ 30%, Cuối kỳ 60%

Nhập điểm:

Thủ công hoặc import từ file Excel

Ký duyệt điểm cuối kỳ

Bảng DB:

Attendance (FK → ClassSection, Student, Date, Status)

ScoreColumn (các cột điểm: CC, GK, CK, Bài tập,…)

FK → ClassSection

ScoreDetail (Giá trị điểm cụ thể cho từng cột)

FK → ScoreColumn, Student

FinalGrade (tổng kết môn)

FK → ClassSection, Student

Điểm số, điểm chữ, đạt/không

Liên kết:

Registration → xác định danh sách SV của ClassSection

ScoreDetail + ScoreColumn → tính FinalGrade

FinalGrade → dùng cho tiến độ, xét tốt nghiệp

3.8. Module Theo dõi tiến độ học tập & Cảnh báo học vụ

Tính GPA từng kỳ, GPA tích lũy cho sinh viên

Theo dõi:

Tín chỉ đã tích lũy

Môn nợ, môn trượt, môn phải học lại

Cảnh báo:

Học lực yếu, cảnh báo ngừng học, thôi học

Gửi thông báo trên hệ thống

Bảng DB:

Có thể dùng FinalGrade + các view / stored procedure để:

Tính StudentTermResult (kết quả từng học kỳ)

StudentProgress (tiến độ toàn khóa)

3.9. Module Xét tốt nghiệp

Cấu hình điều kiện tốt nghiệp:

Số tín chỉ tối thiểu

Đã hoàn thành tất cả môn bắt buộc

GPA tối thiểu

Chứng chỉ ngoại ngữ, tin học (nếu có)

Chạy chức năng xét:

Lấy danh sách sinh viên khóa X

Kiểm tra điều kiện

Xuất danh sách đề nghị tốt nghiệp

Bảng DB:

GraduationCondition

GraduationReview (kết quả xét từng sinh viên)

GraduationDecision (quyết định, ngày, đợt)

3.10. Module Báo cáo – Thống kê

Số lượng sinh viên theo khoa, ngành, khóa

Sĩ số từng lớp học phần

Tỷ lệ đậu/trượt từng môn, từng giảng viên, từng học kỳ

Thống kê cảnh báo học vụ

Thống kê tốt nghiệp

Có thể dùng Stored Procedures + View để tạo các báo cáo phức tạp.

4. Luồng nghiệp vụ tổng quát (Workflow)
Workflow 1: Chuẩn bị học kỳ

Phòng ĐT tạo Năm học – Học kỳ.

Cập nhật CTĐT nếu có thay đổi.

Chọn những môn sẽ mở lớp → tạo ClassSection.

Gán giảng viên, phòng, TimeSlot → xếp TKB.

Công bố danh sách lớp mở cho sinh viên.

Workflow 2: Sinh viên đăng ký học phần

Sinh viên đăng nhập (role SinhVien).

Chọn Học kỳ hiện tại.

Hệ thống:

Lấy CTĐT + lịch sử học → các môn còn thiếu.

Lấy danh sách lớp học phần đã mở.

Sinh viên chọn lớp cần đăng ký → nhấn “Đăng ký”.

Back-end:

Gọi Stored Procedure kiểm tra:

Điều kiện tiên quyết (dựa CoursePrerequisite + FinalGrade).

Không trùng lịch (ClassSectionSchedule).

Không vượt số tín chỉ tối đa.

Lớp chưa đầy sĩ số.

Nếu OK → chèn vào Registration.

Cập nhật sĩ số lớp, hiển thị TKB cá nhân.

Workflow 3: Giảng viên giảng dạy & nhập điểm

Giảng viên đăng nhập (role GiangVien).

Xem danh sách lớp học phần mình phụ trách.

Mỗi buổi dạy:

Mở lớp → nhập điểm danh (Attendance).

Cuối kỳ:

Tạo cấu trúc điểm (ScoreColumn).

Nhập điểm chi tiết (ScoreDetail) hoặc import file.

Hệ thống tính FinalGrade bằng Stored Procedure.

Phòng ĐT duyệt điểm, “khóa” lớp không cho chỉnh sửa.

Workflow 4: Tính tiến độ & Xét tốt nghiệp

Sau mỗi kỳ:

Chạy SP tính GPA kỳ, GPA tích lũy, cập nhật StudentTermResult.

Sinh viên xem tiến độ, các môn nợ.

Cuối khóa:

Phòng ĐT chọn khóa + ngành → bấm “Xét tốt nghiệp”.

SP kiểm tra điều kiện tốt nghiệp theo GraduationCondition.

Sinh ra danh sách đề nghị tốt nghiệp, lưu GraduationReview.

5. Gợi ý kiến trúc kỹ thuật
5.1. Back-end C# + SQL Server 2012

Framework:

ASP.NET Core Web API (hoặc ASP.NET MVC + Web API nếu trường yêu cầu .NET Framework)

Kiến trúc gợi ý:

API Layer: Controllers

Business Layer (Services): xử lý logic, gọi Stored Procedure

Data Access Layer (Repository):

ADO.NET / Dapper để gọi Stored Procedure

Authentication:

JWT Token (login → trả token → Angular lưu token)

Ví dụ cách tổ chức:

Namespace TrainingManagement.Api

Controllers: StudentController, CourseController, RegistrationController, GradeController,…

Services: StudentService, RegistrationService,…

Repositories: StudentRepository, …

5.2. Database & Stored Procedure

Dùng SQL Server 2012

Các SP tiêu biểu:

sp_StudentRegisterSection – Đăng ký lớp HP + check điều kiện

sp_CalculateFinalGrade – Tính điểm tổng kết cho 1 lớp

sp_GetStudentProgress – Lấy tiến độ học tập

sp_GraduationReview – Xét tốt nghiệp cho 1 khóa/ngành

Có thể viết View cho báo cáo:

vw_StudentGPA, vw_ClassSectionStatistic,…

5.3. Front-end Angular + Angular Material

Cấu trúc module:

core (auth, interceptor, guard)

shared (component, pipe, directive dùng chung)

features:

auth (login)

student (đăng ký môn, xem TKB, điểm)

lecturer (quản lý lớp, nhập điểm)

admin (danh mục, user, phân quyền)

training (phòng ĐT: CTĐT, mở lớp, xét tốt nghiệp)

Angular Material components:

MatTable, MatPaginator, MatSort cho danh sách

MatDialog cho popup thêm/sửa/xoá

MatStepper cho các bước đăng ký học phần

MatSnackBar cho thông báo