/* =========================================================
   EduFlowPro - Schema, Stored Procedures, Seed Data (UTF-8)
   Mục tiêu: bám sát mô tả hệ thống đào tạo tín chỉ, tiếng Việt có dấu.
   SQL Server 2012 compatible.
========================================================= */

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF DB_ID(N'EduFlowPro') IS NULL
    CREATE DATABASE EduFlowPro;
GO

USE EduFlowPro;
GO

/* =========================================================
   Cleanup (drop SPs trước, rồi bảng từ con tới cha)
========================================================= */
IF OBJECT_ID(N'dbo.sp_DangKyHocPhan', N'P') IS NOT NULL DROP PROCEDURE dbo.sp_DangKyHocPhan;
IF OBJECT_ID(N'dbo.sp_TinhDiemTongKet', N'P') IS NOT NULL DROP PROCEDURE dbo.sp_TinhDiemTongKet;
IF OBJECT_ID(N'dbo.sp_TinhTienDoHocTap', N'P') IS NOT NULL DROP PROCEDURE dbo.sp_TinhTienDoHocTap;
IF OBJECT_ID(N'dbo.sp_XetTotNghiep', N'P') IS NOT NULL DROP PROCEDURE dbo.sp_XetTotNghiep;
GO

IF OBJECT_ID(N'dbo.GraduationReview', N'U') IS NOT NULL DROP TABLE dbo.GraduationReview;
IF OBJECT_ID(N'dbo.GraduationCondition', N'U') IS NOT NULL DROP TABLE dbo.GraduationCondition;
IF OBJECT_ID(N'dbo.StudentTermResult', N'U') IS NOT NULL DROP TABLE dbo.StudentTermResult;
IF OBJECT_ID(N'dbo.FinalGrade', N'U') IS NOT NULL DROP TABLE dbo.FinalGrade;
IF OBJECT_ID(N'dbo.ScoreDetail', N'U') IS NOT NULL DROP TABLE dbo.ScoreDetail;
IF OBJECT_ID(N'dbo.ScoreColumn', N'U') IS NOT NULL DROP TABLE dbo.ScoreColumn;
IF OBJECT_ID(N'dbo.Attendance', N'U') IS NOT NULL DROP TABLE dbo.Attendance;
IF OBJECT_ID(N'dbo.Registration', N'U') IS NOT NULL DROP TABLE dbo.Registration;
IF OBJECT_ID(N'dbo.ClassSectionSchedule', N'U') IS NOT NULL DROP TABLE dbo.ClassSectionSchedule;
IF OBJECT_ID(N'dbo.ClassSection', N'U') IS NOT NULL DROP TABLE dbo.ClassSection;
IF OBJECT_ID(N'dbo.CurriculumCourse', N'U') IS NOT NULL DROP TABLE dbo.CurriculumCourse;
IF OBJECT_ID(N'dbo.Curriculum', N'U') IS NOT NULL DROP TABLE dbo.Curriculum;
IF OBJECT_ID(N'dbo.CoursePrerequisite', N'U') IS NOT NULL DROP TABLE dbo.CoursePrerequisite;
IF OBJECT_ID(N'dbo.Course', N'U') IS NOT NULL DROP TABLE dbo.Course;
IF OBJECT_ID(N'dbo.TimeSlot', N'U') IS NOT NULL DROP TABLE dbo.TimeSlot;
IF OBJECT_ID(N'dbo.Room', N'U') IS NOT NULL DROP TABLE dbo.Room;
IF OBJECT_ID(N'dbo.Class', N'U') IS NOT NULL DROP TABLE dbo.Class;
IF OBJECT_ID(N'dbo.Lecturer', N'U') IS NOT NULL DROP TABLE dbo.Lecturer;
IF OBJECT_ID(N'dbo.Notification', N'U') IS NOT NULL DROP TABLE dbo.Notification;
IF OBJECT_ID(N'dbo.Student', N'U') IS NOT NULL DROP TABLE dbo.Student;
IF OBJECT_ID(N'dbo.Major', N'U') IS NOT NULL DROP TABLE dbo.Major;
IF OBJECT_ID(N'dbo.Faculty', N'U') IS NOT NULL DROP TABLE dbo.Faculty;
IF OBJECT_ID(N'dbo.Semester', N'U') IS NOT NULL DROP TABLE dbo.Semester;
IF OBJECT_ID(N'dbo.AcademicYear', N'U') IS NOT NULL DROP TABLE dbo.AcademicYear;
IF OBJECT_ID(N'dbo.UserRoles', N'U') IS NOT NULL DROP TABLE dbo.UserRoles;
IF OBJECT_ID(N'dbo.RolePermissions', N'U') IS NOT NULL DROP TABLE dbo.RolePermissions;
IF OBJECT_ID(N'dbo.Permissions', N'U') IS NOT NULL DROP TABLE dbo.Permissions;
IF OBJECT_ID(N'dbo.Roles', N'U') IS NOT NULL DROP TABLE dbo.Roles;
IF OBJECT_ID(N'dbo.[User]', N'U') IS NOT NULL DROP TABLE dbo.[User];
IF OBJECT_ID(N'dbo.AuditLog', N'U') IS NOT NULL DROP TABLE dbo.AuditLog;
GO

/* =========================================================
   Bảng nền: người dùng, phân quyền, log
========================================================= */
CREATE TABLE dbo.[User] (
    UserId INT IDENTITY PRIMARY KEY,
    UserName NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(200) NOT NULL,
    HoTen NVARCHAR(150) NOT NULL,
    Email NVARCHAR(120) NULL,
    DienThoai NVARCHAR(30) NULL,
    TrangThai TINYINT NOT NULL DEFAULT 1, --1=Hoạt động,2=Khoá
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.Roles (
    RoleId INT IDENTITY PRIMARY KEY,
    RoleCode NVARCHAR(30) NOT NULL UNIQUE,
    RoleName NVARCHAR(80) NOT NULL
);
GO

CREATE TABLE dbo.Permissions (
    PermissionId INT IDENTITY PRIMARY KEY,
    PermissionCode NVARCHAR(50) NOT NULL UNIQUE,
    PermissionName NVARCHAR(120) NOT NULL,
    Module NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.RolePermissions (
    RoleId INT NOT NULL,
    PermissionId INT NOT NULL,
    PRIMARY KEY (RoleId, PermissionId),
    CONSTRAINT FK_RolePermission_Role FOREIGN KEY (RoleId) REFERENCES dbo.Roles(RoleId),
    CONSTRAINT FK_RolePermission_Perm FOREIGN KEY (PermissionId) REFERENCES dbo.Permissions(PermissionId)
);
GO

CREATE TABLE dbo.UserRoles (
    UserId INT NOT NULL,
    RoleId INT NOT NULL,
    PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_UserRole_User FOREIGN KEY (UserId) REFERENCES dbo.[User](UserId),
    CONSTRAINT FK_UserRole_Role FOREIGN KEY (RoleId) REFERENCES dbo.Roles(RoleId)
);
GO

CREATE TABLE dbo.AuditLog (
    AuditId INT IDENTITY PRIMARY KEY,
    EntityName NVARCHAR(80) NOT NULL,
    EntityId INT NOT NULL,
    Action NVARCHAR(20) NOT NULL,
    OldValue NVARCHAR(MAX) NULL,
    NewValue NVARCHAR(MAX) NULL,
    ActorId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/* =========================================================
   Danh mục đào tạo
========================================================= */
CREATE TABLE dbo.AcademicYear (
    AcademicYearId INT IDENTITY PRIMARY KEY,
    TenNam NVARCHAR(20) NOT NULL UNIQUE, --VD: 2025-2026
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE dbo.Semester (
    SemesterId INT IDENTITY PRIMARY KEY,
    AcademicYearId INT NOT NULL,
    TenHocKy NVARCHAR(20) NOT NULL,
    ThuTu TINYINT NOT NULL, --1,2,3
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    ThoiGianMoDangKy DATETIME NOT NULL,
    ThoiGianDongDangKy DATETIME NOT NULL,
    TrangThai TINYINT NOT NULL DEFAULT 0, --0=Nháp,1=Mở đăng ký,2=Đang học,3=Kết thúc
    CONSTRAINT FK_Sem_Year FOREIGN KEY (AcademicYearId) REFERENCES dbo.AcademicYear(AcademicYearId),
    UNIQUE (AcademicYearId, ThuTu)
);
GO

CREATE TABLE dbo.Faculty (
    FacultyId INT IDENTITY PRIMARY KEY,
    MaKhoa NVARCHAR(20) NOT NULL UNIQUE,
    TenKhoa NVARCHAR(150) NOT NULL
);
GO

CREATE TABLE dbo.Major (
    MajorId INT IDENTITY PRIMARY KEY,
    FacultyId INT NOT NULL,
    MaNganh NVARCHAR(20) NOT NULL UNIQUE,
    TenNganh NVARCHAR(150) NOT NULL,
    CONSTRAINT FK_Major_Faculty FOREIGN KEY (FacultyId) REFERENCES dbo.Faculty(FacultyId)
);
GO

CREATE TABLE dbo.Class (
    ClassId INT IDENTITY PRIMARY KEY,
    MajorId INT NOT NULL,
    MaLop NVARCHAR(30) NOT NULL UNIQUE,
    TenLop NVARCHAR(150) NOT NULL,
    KhoaTuyen SMALLINT NOT NULL,
    CoVanHocTap NVARCHAR(150) NULL,
    CONSTRAINT FK_Class_Major FOREIGN KEY (MajorId) REFERENCES dbo.Major(MajorId)
);
GO

CREATE TABLE dbo.Room (
    RoomId INT IDENTITY PRIMARY KEY,
    MaPhong NVARCHAR(20) NOT NULL UNIQUE,
    TenPhong NVARCHAR(100) NOT NULL,
    SucChua SMALLINT NOT NULL,
    LoaiPhong TINYINT NOT NULL DEFAULT 1 --1=Lý thuyết,2=Thực hành,3=Hội trường
);
GO

CREATE TABLE dbo.TimeSlot (
    TimeSlotId INT IDENTITY PRIMARY KEY,
    ThuTrongTuan TINYINT NOT NULL, --2=Thứ 2 ... 8=Chủ nhật
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    TenCa NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.Course (
    CourseId INT IDENTITY PRIMARY KEY,
    MaHocPhan NVARCHAR(30) NOT NULL UNIQUE,
    TenHocPhan NVARCHAR(200) NOT NULL,
    SoTinChi TINYINT NOT NULL CHECK (SoTinChi > 0),
    SoTietLyThuyet SMALLINT NOT NULL DEFAULT 0,
    SoTietThucHanh SMALLINT NOT NULL DEFAULT 0,
    LoaiHocPhan TINYINT NOT NULL, --1=Bắt buộc,2=Tự chọn
    IsActive BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE dbo.CoursePrerequisite (
    CourseId INT NOT NULL,
    PrereqCourseId INT NOT NULL,
    PrereqType TINYINT NOT NULL DEFAULT 1, --1=Đã qua,2=Học song song
    PRIMARY KEY (CourseId, PrereqCourseId),
    CONSTRAINT FK_Prereq_Course FOREIGN KEY (CourseId) REFERENCES dbo.Course(CourseId),
    CONSTRAINT FK_Prereq_Req FOREIGN KEY (PrereqCourseId) REFERENCES dbo.Course(CourseId)
);
GO

CREATE TABLE dbo.Curriculum (
    CurriculumId INT IDENTITY PRIMARY KEY,
    MajorId INT NOT NULL,
    KhoaTuyen SMALLINT NOT NULL, --Khóa áp dụng (vd: 2022)
    TongTinChiYeuCau SMALLINT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Curriculum_Major FOREIGN KEY (MajorId) REFERENCES dbo.Major(MajorId),
    UNIQUE (MajorId, KhoaTuyen)
);
GO

CREATE TABLE dbo.CurriculumCourse (
    CurriculumId INT NOT NULL,
    CourseId INT NOT NULL,
    HocKyGoiY TINYINT NULL,
    BatBuoc BIT NOT NULL DEFAULT 1,
    PRIMARY KEY (CurriculumId, CourseId),
    CONSTRAINT FK_CurCourse_Cur FOREIGN KEY (CurriculumId) REFERENCES dbo.Curriculum(CurriculumId),
    CONSTRAINT FK_CurCourse_Course FOREIGN KEY (CourseId) REFERENCES dbo.Course(CourseId)
);
GO

/* =========================================================
   Hồ sơ sinh viên / giảng viên
========================================================= */
CREATE TABLE dbo.Student (
    StudentId INT IDENTITY PRIMARY KEY,
    UserId INT NOT NULL,
    StudentCode NVARCHAR(20) NOT NULL UNIQUE,
    HoTen NVARCHAR(150) NOT NULL,
    GioiTinh NVARCHAR(10) NULL,
    NgaySinh DATE NULL,
    Email NVARCHAR(120) NULL,
    DienThoai NVARCHAR(30) NULL,
    MajorId INT NOT NULL,
    ClassId INT NOT NULL,
    CurriculumId INT NOT NULL,
    TrangThai TINYINT NOT NULL DEFAULT 1, --1=Đang học,2=Bảo lưu,3=Thôi học,4=Tốt nghiệp
    CONSTRAINT FK_Student_User FOREIGN KEY (UserId) REFERENCES dbo.[User](UserId),
    CONSTRAINT FK_Student_Major FOREIGN KEY (MajorId) REFERENCES dbo.Major(MajorId),
    CONSTRAINT FK_Student_Class FOREIGN KEY (ClassId) REFERENCES dbo.Class(ClassId),
    CONSTRAINT FK_Student_Curr FOREIGN KEY (CurriculumId) REFERENCES dbo.Curriculum(CurriculumId)
);
GO

CREATE TABLE dbo.Lecturer (
    LecturerId INT IDENTITY PRIMARY KEY,
    UserId INT NOT NULL,
    LecturerCode NVARCHAR(20) NOT NULL UNIQUE,
    HoTen NVARCHAR(150) NOT NULL,
    HocVi NVARCHAR(50) NULL,
    FacultyId INT NOT NULL,
    TrangThai TINYINT NOT NULL DEFAULT 1, --1=Đang công tác,2=Tạm nghỉ
    CONSTRAINT FK_Lecturer_User FOREIGN KEY (UserId) REFERENCES dbo.[User](UserId),
    CONSTRAINT FK_Lecturer_Fac FOREIGN KEY (FacultyId) REFERENCES dbo.Faculty(FacultyId)
);
GO

/* =========================================================
   Mở lớp, TKB, đăng ký
========================================================= */
CREATE TABLE dbo.ClassSection (
    ClassSectionId INT IDENTITY PRIMARY KEY,
    SemesterId INT NOT NULL,
    CourseId INT NOT NULL,
    SectionCode NVARCHAR(40) NOT NULL,
    GiangVienId INT NULL,
    TrangThai TINYINT NOT NULL DEFAULT 0, --0=Nháp,1=Mở đăng ký,2=Đang học,3=Đóng,4=Hủy
    SiSoToiThieu SMALLINT NOT NULL DEFAULT 10,
    SiSoToiDa SMALLINT NOT NULL DEFAULT 60,
    PhuongThucGiangDay TINYINT NOT NULL DEFAULT 1, --1=Trực tiếp,2=Online,3=Blended
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    CONSTRAINT FK_ClassSection_Sem FOREIGN KEY (SemesterId) REFERENCES dbo.Semester(SemesterId),
    CONSTRAINT FK_ClassSection_Course FOREIGN KEY (CourseId) REFERENCES dbo.Course(CourseId),
    CONSTRAINT FK_ClassSection_Lect FOREIGN KEY (GiangVienId) REFERENCES dbo.Lecturer(LecturerId),
    UNIQUE (SemesterId, SectionCode)
);
GO

CREATE TABLE dbo.ClassSectionSchedule (
    ScheduleId INT IDENTITY PRIMARY KEY,
    ClassSectionId INT NOT NULL,
    TimeSlotId INT NOT NULL,
    RoomId INT NULL,
    TuanHocTu SMALLINT NULL,
    TuanHocDen SMALLINT NULL,
    CONSTRAINT FK_Schedule_Section FOREIGN KEY (ClassSectionId) REFERENCES dbo.ClassSection(ClassSectionId),
    CONSTRAINT FK_Schedule_TimeSlot FOREIGN KEY (TimeSlotId) REFERENCES dbo.TimeSlot(TimeSlotId),
    CONSTRAINT FK_Schedule_Room FOREIGN KEY (RoomId) REFERENCES dbo.Room(RoomId)
);
GO

CREATE TABLE dbo.Registration (
    RegistrationId INT IDENTITY PRIMARY KEY,
    StudentId INT NOT NULL,
    ClassSectionId INT NOT NULL,
    TrangThai TINYINT NOT NULL DEFAULT 1, --1=Đã đăng ký,2=Hủy,3=Rút sau hạn
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Reg_Student FOREIGN KEY (StudentId) REFERENCES dbo.Student(StudentId),
    CONSTRAINT FK_Reg_Section FOREIGN KEY (ClassSectionId) REFERENCES dbo.ClassSection(ClassSectionId),
    UNIQUE (StudentId, ClassSectionId)
);
GO

/* =========================================================
   Điểm danh & điểm số
========================================================= */
CREATE TABLE dbo.Attendance (
    AttendanceId INT IDENTITY PRIMARY KEY,
    ClassSectionId INT NOT NULL,
    StudentId INT NOT NULL,
    NgayHoc DATE NOT NULL,
    TrangThai TINYINT NOT NULL, --1=Có mặt,2=Vắng,3=Phép
    GhiChu NVARCHAR(200) NULL,
    CONSTRAINT FK_Att_Section FOREIGN KEY (ClassSectionId) REFERENCES dbo.ClassSection(ClassSectionId),
    CONSTRAINT FK_Att_Student FOREIGN KEY (StudentId) REFERENCES dbo.Student(StudentId),
    UNIQUE (ClassSectionId, StudentId, NgayHoc)
);
GO

CREATE TABLE dbo.ScoreColumn (
    ScoreColumnId INT IDENTITY PRIMARY KEY,
    ClassSectionId INT NOT NULL,
    TenCot NVARCHAR(100) NOT NULL,
    TyTrong DECIMAL(5, 2) NOT NULL, --Phần trăm
    ThuTu TINYINT NOT NULL,
    CONSTRAINT FK_ScoreCol_Section FOREIGN KEY (ClassSectionId) REFERENCES dbo.ClassSection(ClassSectionId)
);
GO

CREATE TABLE dbo.ScoreDetail (
    ScoreDetailId INT IDENTITY PRIMARY KEY,
    ScoreColumnId INT NOT NULL,
    StudentId INT NOT NULL,
    Diem DECIMAL(5, 2) NOT NULL,
    CONSTRAINT FK_ScoreDetail_Col FOREIGN KEY (ScoreColumnId) REFERENCES dbo.ScoreColumn(ScoreColumnId),
    CONSTRAINT FK_ScoreDetail_Stu FOREIGN KEY (StudentId) REFERENCES dbo.Student(StudentId),
    UNIQUE (ScoreColumnId, StudentId)
);
GO

CREATE TABLE dbo.FinalGrade (
    FinalGradeId INT IDENTITY PRIMARY KEY,
    ClassSectionId INT NOT NULL,
    CourseId INT NOT NULL,
    StudentId INT NOT NULL,
    TongKet DECIMAL(5, 2) NOT NULL,
    DiemChu NVARCHAR(2) NOT NULL,
    Dat BIT NOT NULL,
    CalculatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Final_Section FOREIGN KEY (ClassSectionId) REFERENCES dbo.ClassSection(ClassSectionId),
    CONSTRAINT FK_Final_Course FOREIGN KEY (CourseId) REFERENCES dbo.Course(CourseId),
    CONSTRAINT FK_Final_Stu FOREIGN KEY (StudentId) REFERENCES dbo.Student(StudentId),
    UNIQUE (ClassSectionId, StudentId)
);
GO

CREATE TABLE dbo.StudentTermResult (
    TermResultId INT IDENTITY PRIMARY KEY,
    StudentId INT NOT NULL,
    SemesterId INT NOT NULL,
    SoTinChiDangKy SMALLINT NOT NULL,
    SoTinChiDat SMALLINT NOT NULL,
    GPA DECIMAL(4, 2) NOT NULL,
    XepLoaiHocVu NVARCHAR(50) NULL,
    CalculatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_TermResult_Stu FOREIGN KEY (StudentId) REFERENCES dbo.Student(StudentId),
    CONSTRAINT FK_TermResult_Sem FOREIGN KEY (SemesterId) REFERENCES dbo.Semester(SemesterId),
    UNIQUE (StudentId, SemesterId)
);
GO

/* =========================================================
   Điều kiện & xét tốt nghiệp
========================================================= */
CREATE TABLE dbo.GraduationCondition (
    ConditionId INT IDENTITY PRIMARY KEY,
    CurriculumId INT NOT NULL,
    MinTinChi SMALLINT NOT NULL,
    MinGPA DECIMAL(3, 2) NOT NULL,
    YeuCauMonBatBuoc BIT NOT NULL DEFAULT 1,
    YeuCauChungChiNgoaiNgu BIT NOT NULL DEFAULT 0,
    YeuCauTinHoc BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Cond_Cur FOREIGN KEY (CurriculumId) REFERENCES dbo.Curriculum(CurriculumId)
);
GO

CREATE TABLE dbo.GraduationReview (
    ReviewId INT IDENTITY PRIMARY KEY,
    StudentId INT NOT NULL,
    ConditionId INT NOT NULL,
    DuDieuKien BIT NOT NULL,
    GhiChu NVARCHAR(200) NULL,
    CheckedAt DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Review_Stu FOREIGN KEY (StudentId) REFERENCES dbo.Student(StudentId),
    CONSTRAINT FK_Review_Cond FOREIGN KEY (ConditionId) REFERENCES dbo.GraduationCondition(ConditionId)
);
GO

/* =========================================================
   Thông báo (dùng cho cảnh báo học vụ)
========================================================= */
CREATE TABLE dbo.Notification (
    NotificationId INT IDENTITY PRIMARY KEY,
    StudentId INT NULL,
    TieuDe NVARCHAR(200) NOT NULL,
    NoiDung NVARCHAR(MAX) NOT NULL,
    Kenh TINYINT NOT NULL, --1=Email,2=Ứng dụng,3=SMS
    TrangThai TINYINT NOT NULL DEFAULT 0, --0=Chờ gửi,1=Đã gửi,2=Lỗi
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    SentAt DATETIME NULL,
    CONSTRAINT FK_Notify_Stu FOREIGN KEY (StudentId) REFERENCES dbo.Student(StudentId)
);
GO

/* =========================================================
   Seed dữ liệu mẫu (tiếng Việt có dấu)
========================================================= */
SET NOCOUNT ON;

INSERT INTO dbo.Roles (RoleCode, RoleName)
VALUES (N'ADMIN', N'Quản trị hệ thống'),
       (N'PDT', N'Phòng Đào tạo'),
       (N'GIANGVIEN', N'Giảng viên'),
       (N'SINHVIEN', N'Sinh viên');

INSERT INTO dbo.Permissions (PermissionCode, PermissionName, Module)
VALUES (N'SYSTEM_MANAGE_USER', N'Quản lý người dùng', N'Hệ thống'),
       (N'DANHMUC_EDIT', N'Quản lý danh mục đào tạo', N'Danh mục'),
       (N'LOPHOCPHAN_OPEN', N'Mở lớp học phần', N'Đào tạo'),
       (N'DANGKY_XULY', N'Xử lý đăng ký học phần', N'Đăng ký'),
       (N'DIEM_NHAP', N'Nhập điểm', N'Đánh giá'),
       (N'BAOCAO_XEM', N'Xem báo cáo', N'Báo cáo');

INSERT INTO dbo.RolePermissions (RoleId, PermissionId)
SELECT r.RoleId, p.PermissionId
FROM dbo.Roles r
JOIN dbo.Permissions p ON
    (r.RoleCode = N'ADMIN')
    OR (r.RoleCode = N'PDT' AND p.PermissionCode IN (N'DANHMUC_EDIT', N'LOPHOCPHAN_OPEN', N'DANGKY_XULY', N'BAOCAO_XEM'))
    OR (r.RoleCode = N'GIANGVIEN' AND p.PermissionCode IN (N'DIEM_NHAP', N'BAOCAO_XEM'))
    OR (r.RoleCode = N'SINHVIEN' AND p.PermissionCode IN (N'DANGKY_XULY'));

INSERT INTO dbo.[User] (UserName, PasswordHash, HoTen, Email, DienThoai)
VALUES (N'admin', N'hashed-admin', N'Quản trị hệ thống', N'admin@eduflowpro.local', N'0900000000'),
       (N'pdt', N'hashed-pdt', N'Phòng Đào tạo', N'pdt@eduflowpro.local', N'0901111111'),
       (N'gv001', N'hashed-gv', N'Trần Thị Hương', N'huong.tt@eduflowpro.local', N'0902222222'),
       (N'sv001', N'hashed-sv1', N'Nguyễn Minh An', N'an.nm@eduflowpro.local', N'0903333333'),
       (N'sv002', N'hashed-sv2', N'Lê Thu Hà', N'ha.lt@eduflowpro.local', N'0904444444');

INSERT INTO dbo.UserRoles (UserId, RoleId)
SELECT u.UserId, r.RoleId
FROM dbo.[User] u
JOIN dbo.Roles r
    ON (u.UserName = N'admin' AND r.RoleCode = N'ADMIN')
    OR (u.UserName = N'pdt' AND r.RoleCode = N'PDT')
    OR (u.UserName = N'gv001' AND r.RoleCode = N'GIANGVIEN')
    OR (u.UserName IN (N'sv001', N'sv002') AND r.RoleCode = N'SINHVIEN');

INSERT INTO dbo.AcademicYear (TenNam, NgayBatDau, NgayKetThuc, IsActive)
VALUES (N'2025-2026', '2025-08-01', '2026-07-31', 1);

INSERT INTO dbo.Semester (AcademicYearId, TenHocKy, ThuTu, NgayBatDau, NgayKetThuc, ThoiGianMoDangKy, ThoiGianDongDangKy, TrangThai)
SELECT ay.AcademicYearId, N'Học kỳ 1', 1, '2025-08-15', '2025-12-31', '2025-07-20', '2025-08-20', 1
FROM dbo.AcademicYear ay
WHERE ay.TenNam = N'2025-2026';

INSERT INTO dbo.Faculty (MaKhoa, TenKhoa)
VALUES (N'CNTT', N'Công nghệ thông tin'),
       (N'KTE', N'Kinh tế');

INSERT INTO dbo.Major (FacultyId, MaNganh, TenNganh)
SELECT f.FacultyId, N'KHMT', N'Khoa học máy tính' FROM dbo.Faculty f WHERE f.MaKhoa = N'CNTT'
UNION ALL
SELECT f.FacultyId, N'HTTT', N'Hệ thống thông tin' FROM dbo.Faculty f WHERE f.MaKhoa = N'CNTT';

INSERT INTO dbo.Class (MajorId, MaLop, TenLop, KhoaTuyen, CoVanHocTap)
SELECT m.MajorId, N'DHKHMT2022A', N'Đại học KHMT 2022 - A', 2022, N'TS. Phạm Quang Long' FROM dbo.Major m WHERE m.MaNganh = N'KHMT'
UNION ALL
SELECT m.MajorId, N'DHHTTT2022B', N'Đại học HTTT 2022 - B', 2022, N'TS. Nguyễn Thuỳ Linh' FROM dbo.Major m WHERE m.MaNganh = N'HTTT';

INSERT INTO dbo.Room (MaPhong, TenPhong, SucChua, LoaiPhong)
VALUES (N'P101', N'Phòng 101 - Nhà A1', 60, 1),
       (N'LAB201', N'Phòng máy 201', 40, 2),
       (N'HALL', N'Hội trường lớn', 200, 3);

INSERT INTO dbo.TimeSlot (ThuTrongTuan, GioBatDau, GioKetThuc, TenCa)
VALUES (2, '07:00', '09:00', N'Thứ 2 (Tiết 1-3)'),
       (2, '09:10', '11:10', N'Thứ 2 (Tiết 4-6)'),
       (4, '07:00', '09:00', N'Thứ 4 (Tiết 1-3)'),
       (6, '07:00', '09:00', N'Thứ 6 (Tiết 1-3)');

INSERT INTO dbo.Course (MaHocPhan, TenHocPhan, SoTinChi, SoTietLyThuyet, SoTietThucHanh, LoaiHocPhan, IsActive)
VALUES (N'CSC101', N'Lập trình cơ bản', 3, 30, 15, 1, 1),
       (N'CSC201', N'Cấu trúc dữ liệu', 3, 30, 15, 1, 1),
       (N'CSC301', N'Cơ sở dữ liệu', 3, 30, 15, 1, 1),
       (N'MTH101', N'Toán cao cấp A1', 4, 45, 0, 1, 1),
       (N'ENG201', N'Tiếng Anh học thuật', 3, 30, 0, 2, 1);

INSERT INTO dbo.CoursePrerequisite (CourseId, PrereqCourseId, PrereqType)
SELECT c2.CourseId, c1.CourseId, 1
FROM dbo.Course c1
JOIN dbo.Course c2 ON c1.MaHocPhan = N'CSC101' AND c2.MaHocPhan = N'CSC201';

INSERT INTO dbo.Curriculum (MajorId, KhoaTuyen, TongTinChiYeuCau, IsActive)
SELECT m.MajorId, 2022, 130, 1 FROM dbo.Major m WHERE m.MaNganh = N'KHMT';

INSERT INTO dbo.CurriculumCourse (CurriculumId, CourseId, HocKyGoiY, BatBuoc)
SELECT cur.CurriculumId, c.CourseId, 1, 1
FROM dbo.Curriculum cur
JOIN dbo.Course c ON c.MaHocPhan IN (N'CSC101', N'MTH101')
UNION ALL
SELECT cur.CurriculumId, c.CourseId, 2, 1
FROM dbo.Curriculum cur
JOIN dbo.Course c ON c.MaHocPhan IN (N'CSC201', N'CSC301')
UNION ALL
SELECT cur.CurriculumId, c.CourseId, 3, 0
FROM dbo.Curriculum cur
JOIN dbo.Course c ON c.MaHocPhan = N'ENG201';

INSERT INTO dbo.Student (UserId, StudentCode, HoTen, GioiTinh, NgaySinh, Email, DienThoai, MajorId, ClassId, CurriculumId, TrangThai)
SELECT u.UserId, N'SV001', N'Nguyễn Minh An', N'Nam', '2004-03-12', u.Email, u.DienThoai, m.MajorId, cl.ClassId, cur.CurriculumId, 1
FROM dbo.[User] u
JOIN dbo.Major m ON m.MaNganh = N'KHMT'
JOIN dbo.Class cl ON cl.MaLop = N'DHKHMT2022A'
JOIN dbo.Curriculum cur ON cur.MajorId = m.MajorId AND cur.KhoaTuyen = 2022
WHERE u.UserName = N'sv001'
UNION ALL
SELECT u.UserId, N'SV002', N'Lê Thu Hà', N'Nữ', '2004-08-21', u.Email, u.DienThoai, m.MajorId, cl.ClassId, cur.CurriculumId, 1
FROM dbo.[User] u
JOIN dbo.Major m ON m.MaNganh = N'KHMT'
JOIN dbo.Class cl ON cl.MaLop = N'DHKHMT2022A'
JOIN dbo.Curriculum cur ON cur.MajorId = m.MajorId AND cur.KhoaTuyen = 2022
WHERE u.UserName = N'sv002';

INSERT INTO dbo.Lecturer (UserId, LecturerCode, HoTen, HocVi, FacultyId, TrangThai)
SELECT u.UserId, N'GV001', u.HoTen, N'ThS', f.FacultyId, 1
FROM dbo.[User] u
JOIN dbo.Faculty f ON f.MaKhoa = N'CNTT'
WHERE u.UserName = N'gv001';

INSERT INTO dbo.ClassSection (SemesterId, CourseId, SectionCode, GiangVienId, TrangThai, SiSoToiThieu, SiSoToiDa, PhuongThucGiangDay)
SELECT s.SemesterId, c.CourseId, N'CSC101-01', lec.LecturerId, 1, 10, 50, 1
FROM dbo.Semester s
JOIN dbo.Course c ON c.MaHocPhan = N'CSC101'
LEFT JOIN dbo.Lecturer lec ON lec.LecturerCode = N'GV001'
UNION ALL
SELECT s.SemesterId, c.CourseId, N'CSC201-01', lec.LecturerId, 1, 10, 50, 1
FROM dbo.Semester s
JOIN dbo.Course c ON c.MaHocPhan = N'CSC201'
LEFT JOIN dbo.Lecturer lec ON lec.LecturerCode = N'GV001';

INSERT INTO dbo.ClassSectionSchedule (ClassSectionId, TimeSlotId, RoomId, TuanHocTu, TuanHocDen)
SELECT cs.ClassSectionId, ts.TimeSlotId, r.RoomId, 1, 15
FROM dbo.ClassSection cs
JOIN dbo.TimeSlot ts ON ts.TenCa = N'Thứ 2 (Tiết 1-3)'
JOIN dbo.Room r ON r.MaPhong = N'P101'
WHERE cs.SectionCode = N'CSC101-01'
UNION ALL
SELECT cs.ClassSectionId, ts.TimeSlotId, r.RoomId, 1, 15
FROM dbo.ClassSection cs
JOIN dbo.TimeSlot ts ON ts.TenCa = N'Thứ 4 (Tiết 1-3)'
JOIN dbo.Room r ON r.MaPhong = N'P101'
WHERE cs.SectionCode = N'CSC201-01';

INSERT INTO dbo.Registration (StudentId, ClassSectionId, TrangThai)
SELECT st.StudentId, cs.ClassSectionId, 1
FROM dbo.Student st
CROSS JOIN dbo.ClassSection cs
WHERE st.StudentCode = N'SV001' AND cs.SectionCode = N'CSC101-01'
UNION ALL
SELECT st.StudentId, cs.ClassSectionId, 1
FROM dbo.Student st
CROSS JOIN dbo.ClassSection cs
WHERE st.StudentCode = N'SV002' AND cs.SectionCode = N'CSC101-01';

INSERT INTO dbo.ScoreColumn (ClassSectionId, TenCot, TyTrong, ThuTu)
SELECT cs.ClassSectionId, N'Chuyên cần', 10, 1 FROM dbo.ClassSection cs WHERE cs.SectionCode = N'CSC101-01'
UNION ALL
SELECT cs.ClassSectionId, N'Giữa kỳ', 30, 2 FROM dbo.ClassSection cs WHERE cs.SectionCode = N'CSC101-01'
UNION ALL
SELECT cs.ClassSectionId, N'Cuối kỳ', 60, 3 FROM dbo.ClassSection cs WHERE cs.SectionCode = N'CSC101-01';

INSERT INTO dbo.ScoreDetail (ScoreColumnId, StudentId, Diem)
SELECT sc.ScoreColumnId, st.StudentId, CASE sc.ThuTu WHEN 1 THEN 9.5 WHEN 2 THEN 8.0 ELSE 8.5 END
FROM dbo.ScoreColumn sc
JOIN dbo.ClassSection cs ON sc.ClassSectionId = cs.ClassSectionId
JOIN dbo.Student st ON st.StudentCode = N'SV001'
WHERE cs.SectionCode = N'CSC101-01'
UNION ALL
SELECT sc.ScoreColumnId, st.StudentId, CASE sc.ThuTu WHEN 1 THEN 9.0 WHEN 2 THEN 7.5 ELSE 8.0 END
FROM dbo.ScoreColumn sc
JOIN dbo.ClassSection cs ON sc.ClassSectionId = cs.ClassSectionId
JOIN dbo.Student st ON st.StudentCode = N'SV002'
WHERE cs.SectionCode = N'CSC101-01';

/* =========================================================
   Stored Procedures
========================================================= */
GO
CREATE PROCEDURE dbo.sp_DangKyHocPhan
    @StudentId INT,
    @ClassSectionId INT,
    @MaxTinChiTrongKy TINYINT = 25
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @CourseId INT, @SemesterId INT, @Credits TINYINT, @SectionStatus TINYINT;

    -- Kiểm tra sinh viên hợp lệ
    IF NOT EXISTS (SELECT 1 FROM dbo.Student WHERE StudentId = @StudentId AND TrangThai = 1)
    BEGIN
        RAISERROR (N'Sinh viên không hợp lệ hoặc không ở trạng thái đang học.', 16, 1);
        RETURN;
    END

    SELECT @CourseId = cs.CourseId,
           @SemesterId = cs.SemesterId,
           @SectionStatus = cs.TrangThai
    FROM dbo.ClassSection cs
    WHERE cs.ClassSectionId = @ClassSectionId;

    IF @CourseId IS NULL
    BEGIN
        RAISERROR (N'Lớp học phần không tồn tại.', 16, 1);
        RETURN;
    END

    IF @SectionStatus <> 1
    BEGIN
        RAISERROR (N'Lớp học phần chưa mở đăng ký.', 16, 1);
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.Registration r
        WHERE r.StudentId = @StudentId
          AND r.ClassSectionId = @ClassSectionId
          AND r.TrangThai = 1
    )
    BEGIN
        RAISERROR (N'Đã đăng ký lớp học phần này.', 16, 1);
        RETURN;
    END

    DECLARE @TinChiDaDK SMALLINT;
    SELECT @TinChiDaDK = ISNULL(SUM(c.SoTinChi), 0)
    FROM dbo.Registration r
    JOIN dbo.ClassSection cs ON r.ClassSectionId = cs.ClassSectionId
    JOIN dbo.Course c ON cs.CourseId = c.CourseId
    WHERE r.StudentId = @StudentId AND r.TrangThai = 1 AND cs.SemesterId = @SemesterId;

    SELECT @Credits = c.SoTinChi
    FROM dbo.Course c WHERE c.CourseId = @CourseId;

    -- Tiên quyết: phải đạt môn PrereqType=1
    IF EXISTS (
        SELECT 1
        FROM dbo.CoursePrerequisite cp
        WHERE cp.CourseId = @CourseId AND cp.PrereqType = 1
          AND NOT EXISTS (
                SELECT 1 FROM dbo.FinalGrade fg
                WHERE fg.StudentId = @StudentId
                  AND fg.CourseId = cp.PrereqCourseId
                  AND fg.Dat = 1
          )
    )
    BEGIN
        RAISERROR (N'Chưa đạt môn tiên quyết bắt buộc.', 16, 1);
        RETURN;
    END

    -- Song hành: cho phép nếu đã đạt hoặc đang đăng ký cùng kỳ
    IF EXISTS (
        SELECT 1
        FROM dbo.CoursePrerequisite cp
        WHERE cp.CourseId = @CourseId AND cp.PrereqType = 2
          AND NOT EXISTS (
                SELECT 1 FROM dbo.FinalGrade fg WHERE fg.StudentId = @StudentId AND fg.CourseId = cp.PrereqCourseId AND fg.Dat = 1
                UNION ALL
                SELECT 1 FROM dbo.Registration r
                JOIN dbo.ClassSection cs ON r.ClassSectionId = cs.ClassSectionId
                WHERE r.StudentId = @StudentId AND r.TrangThai = 1 AND cs.SemesterId = @SemesterId AND cs.CourseId = cp.PrereqCourseId
          )
    )
    BEGIN
        RAISERROR (N'Chưa đăng ký hoặc đạt môn yêu cầu song hành.', 16, 1);
        RETURN;
    END

    IF EXISTS (
        SELECT 1
        FROM dbo.Registration r
        JOIN dbo.ClassSection cs ON r.ClassSectionId = cs.ClassSectionId
        JOIN dbo.ClassSectionSchedule s1 ON s1.ClassSectionId = cs.ClassSectionId
        JOIN dbo.ClassSectionSchedule s2 ON s2.ClassSectionId = @ClassSectionId
        WHERE r.StudentId = @StudentId
          AND r.TrangThai = 1
          AND cs.SemesterId = @SemesterId
          AND s1.TimeSlotId = s2.TimeSlotId
    )
    BEGIN
        RAISERROR (N'Trùng lịch học với lớp khác.', 16, 1);
        RETURN;
    END

    DECLARE @SiSoHienTai INT, @SiSoToiDa INT;
    SELECT @SiSoHienTai = COUNT(1) FROM dbo.Registration WHERE ClassSectionId = @ClassSectionId AND TrangThai = 1;
    SELECT @SiSoToiDa = SiSoToiDa FROM dbo.ClassSection WHERE ClassSectionId = @ClassSectionId;

    IF @SiSoHienTai >= @SiSoToiDa
    BEGIN
        RAISERROR (N'Lớp đã đủ sĩ số.', 16, 1);
        RETURN;
    END

    IF (@TinChiDaDK + @Credits) > @MaxTinChiTrongKy
    BEGIN
        RAISERROR (N'Vượt quá số tín chỉ cho phép trong kỳ.', 16, 1);
        RETURN;
    END

    BEGIN TRAN;
        INSERT INTO dbo.Registration (StudentId, ClassSectionId, TrangThai)
        VALUES (@StudentId, @ClassSectionId, 1);
    COMMIT TRAN;
END
GO

CREATE PROCEDURE dbo.sp_TinhDiemTongKet
    @ClassSectionId INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @TongTyTrong DECIMAL(6, 2), @CourseId INT;
    SELECT @TongTyTrong = SUM(TyTrong) FROM dbo.ScoreColumn WHERE ClassSectionId = @ClassSectionId;
    SELECT @CourseId = CourseId FROM dbo.ClassSection WHERE ClassSectionId = @ClassSectionId;

    IF @TongTyTrong IS NULL OR @TongTyTrong <> 100
    BEGIN
        RAISERROR (N'Tổng tỷ trọng phải bằng 100%.', 16, 1);
        RETURN;
    END

    ;WITH DiemCTE AS (
        SELECT r.StudentId,
               SUM(sd.Diem * sc.TyTrong / 100.0) AS DiemTong
        FROM dbo.Registration r
        JOIN dbo.ScoreColumn sc ON sc.ClassSectionId = r.ClassSectionId
        JOIN dbo.ScoreDetail sd ON sd.ScoreColumnId = sc.ScoreColumnId AND sd.StudentId = r.StudentId
        WHERE r.ClassSectionId = @ClassSectionId AND r.TrangThai = 1
        GROUP BY r.StudentId
    )
    MERGE dbo.FinalGrade AS tgt
    USING (
        SELECT d.StudentId,
               @ClassSectionId AS ClassSectionId,
               @CourseId AS CourseId,
               CAST(d.DiemTong AS DECIMAL(5, 2)) AS TongKet,
               CASE
                    WHEN d.DiemTong >= 8.5 THEN N'A'
                    WHEN d.DiemTong >= 7.0 THEN N'B'
                    WHEN d.DiemTong >= 5.5 THEN N'C'
                    WHEN d.DiemTong >= 4.0 THEN N'D'
                    ELSE N'F'
               END AS DiemChu,
               CASE WHEN d.DiemTong >= 4.0 THEN 1 ELSE 0 END AS Dat
        FROM DiemCTE d
    ) AS src
    ON tgt.ClassSectionId = src.ClassSectionId AND tgt.StudentId = src.StudentId
    WHEN MATCHED THEN
        UPDATE SET TongKet = src.TongKet,
                   CourseId = src.CourseId,
                   DiemChu = src.DiemChu,
                   Dat = src.Dat,
                   CalculatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ClassSectionId, CourseId, StudentId, TongKet, DiemChu, Dat, CalculatedAt)
        VALUES (src.ClassSectionId, src.CourseId, src.StudentId, src.TongKet, src.DiemChu, src.Dat, GETDATE());
END
GO

CREATE PROCEDURE dbo.sp_TinhTienDoHocTap
    @StudentId INT,
    @SemesterId INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    ;WITH Diem AS (
        SELECT fg.StudentId,
               cs.SemesterId,
               c.SoTinChi,
               fg.TongKet,
               CASE
                    WHEN fg.TongKet >= 8.5 THEN 4.0
                    WHEN fg.TongKet >= 7.0 THEN 3.0
                    WHEN fg.TongKet >= 5.5 THEN 2.0
                    WHEN fg.TongKet >= 4.0 THEN 1.0
                    ELSE 0.0
               END AS DiemHe4,
               fg.Dat
        FROM dbo.FinalGrade fg
        JOIN dbo.ClassSection cs ON fg.ClassSectionId = cs.ClassSectionId
        JOIN dbo.Course c ON cs.CourseId = c.CourseId
        WHERE fg.StudentId = @StudentId AND cs.SemesterId = @SemesterId
    )
    SELECT *
    INTO #tmpDiem
    FROM Diem;

    DECLARE @SoTinChiDangKy SMALLINT = (SELECT ISNULL(SUM(SoTinChi), 0) FROM #tmpDiem);
    DECLARE @SoTinChiDat SMALLINT = (SELECT ISNULL(SUM(SoTinChi), 0) FROM #tmpDiem WHERE Dat = 1);
    DECLARE @TongDiemHe4 DECIMAL(10, 2) = (SELECT ISNULL(SUM(SoTinChi * DiemHe4), 0) FROM #tmpDiem);
    DECLARE @GPA DECIMAL(4, 2) = CASE WHEN @SoTinChiDangKy = 0 THEN 0 ELSE CAST(@TongDiemHe4 / @SoTinChiDangKy AS DECIMAL(4, 2)) END;

    MERGE dbo.StudentTermResult AS tgt
    USING (SELECT @StudentId AS StudentId, @SemesterId AS SemesterId) AS src
    ON tgt.StudentId = src.StudentId AND tgt.SemesterId = src.SemesterId
    WHEN MATCHED THEN
        UPDATE SET SoTinChiDangKy = @SoTinChiDangKy,
                   SoTinChiDat = @SoTinChiDat,
                   GPA = @GPA,
                   XepLoaiHocVu = CASE
                                      WHEN @GPA >= 3.6 THEN N'Xuất sắc'
                                      WHEN @GPA >= 3.2 THEN N'Giỏi'
                                      WHEN @GPA >= 2.5 THEN N'Khá'
                                      WHEN @GPA >= 2.0 THEN N'Trung bình'
                                      ELSE N'Yếu'
                                 END,
                   CalculatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (StudentId, SemesterId, SoTinChiDangKy, SoTinChiDat, GPA, XepLoaiHocVu, CalculatedAt)
        VALUES (@StudentId, @SemesterId, @SoTinChiDangKy, @SoTinChiDat, @GPA,
                CASE
                    WHEN @GPA >= 3.6 THEN N'Xuất sắc'
                    WHEN @GPA >= 3.2 THEN N'Giỏi'
                    WHEN @GPA >= 2.5 THEN N'Khá'
                    WHEN @GPA >= 2.0 THEN N'Trung bình'
                    ELSE N'Yếu'
                END,
                GETDATE());
END
GO

CREATE PROCEDURE dbo.sp_XetTotNghiep
    @StudentId INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @CurriculumId INT, @ConditionId INT, @MinTinChi SMALLINT, @MinGPA DECIMAL(3, 2), @YeuCauMonBatBuoc BIT;

    SELECT @CurriculumId = s.CurriculumId FROM dbo.Student s WHERE s.StudentId = @StudentId;

    IF @CurriculumId IS NULL
    BEGIN
        RAISERROR (N'Không tìm thấy sinh viên.', 16, 1);
        RETURN;
    END

    SELECT TOP 1 @ConditionId = c.ConditionId,
                 @MinTinChi = c.MinTinChi,
                 @MinGPA = c.MinGPA,
                 @YeuCauMonBatBuoc = c.YeuCauMonBatBuoc
    FROM dbo.GraduationCondition c
    WHERE c.CurriculumId = @CurriculumId;

    IF @ConditionId IS NULL
    BEGIN
        RAISERROR (N'Chưa cấu hình điều kiện tốt nghiệp cho chương trình học.', 16, 1);
        RETURN;
    END

    ;WITH DiemAll AS (
        SELECT fg.StudentId,
               c.SoTinChi,
               fg.Dat,
               CASE
                    WHEN fg.TongKet >= 8.5 THEN 4.0
                    WHEN fg.TongKet >= 7.0 THEN 3.0
                    WHEN fg.TongKet >= 5.5 THEN 2.0
                    WHEN fg.TongKet >= 4.0 THEN 1.0
                    ELSE 0.0
               END AS DiemHe4,
               fg.CourseId
        FROM dbo.FinalGrade fg
        JOIN dbo.Course c ON fg.CourseId = c.CourseId
        WHERE fg.StudentId = @StudentId
    )
    SELECT *
    INTO #tmpAll
    FROM DiemAll;

    DECLARE @TinChiDat INT = (SELECT ISNULL(SUM(SoTinChi), 0) FROM #tmpAll WHERE Dat = 1);
    DECLARE @TongTinChi INT = (SELECT ISNULL(SUM(SoTinChi), 0) FROM #tmpAll);
    DECLARE @TongDiemHe4 DECIMAL(10, 2) = (SELECT ISNULL(SUM(SoTinChi * DiemHe4), 0) FROM #tmpAll);
    DECLARE @GPA DECIMAL(4, 2) = CASE WHEN @TongTinChi = 0 THEN 0 ELSE CAST(@TongDiemHe4 / @TongTinChi AS DECIMAL(4, 2)) END;

    DECLARE @ThieuMonBatBuoc BIT = 0;
    IF @YeuCauMonBatBuoc = 1
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM dbo.CurriculumCourse cc
            WHERE cc.CurriculumId = @CurriculumId AND cc.BatBuoc = 1
              AND NOT EXISTS (
                    SELECT 1 FROM #tmpAll t WHERE t.CourseId = cc.CourseId AND t.Dat = 1
              )
        )
            SET @ThieuMonBatBuoc = 1;
    END

    DECLARE @DuDieuKien BIT = CASE WHEN @TinChiDat >= @MinTinChi AND @GPA >= @MinGPA AND @ThieuMonBatBuoc = 0 THEN 1 ELSE 0 END;

    MERGE dbo.GraduationReview AS tgt
    USING (SELECT @StudentId AS StudentId, @ConditionId AS ConditionId) AS src
    ON tgt.StudentId = src.StudentId AND tgt.ConditionId = src.ConditionId
    WHEN MATCHED THEN
        UPDATE SET DuDieuKien = @DuDieuKien,
                   GhiChu = CASE WHEN @DuDieuKien = 1 THEN N'Đủ điều kiện tốt nghiệp' ELSE N'Chưa đủ điều kiện' END,
                   CheckedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (StudentId, ConditionId, DuDieuKien, GhiChu, CheckedAt)
        VALUES (@StudentId, @ConditionId, @DuDieuKien,
                CASE WHEN @DuDieuKien = 1 THEN N'Đủ điều kiện tốt nghiệp' ELSE N'Chưa đủ điều kiện' END,
                GETDATE());
END
GO

/* =========================================================
   Gợi ý gọi nhanh cho dữ liệu mẫu
========================================================= */
-- Tính điểm tổng kết lớp mẫu
EXEC dbo.sp_TinhDiemTongKet @ClassSectionId = (SELECT ClassSectionId FROM dbo.ClassSection WHERE SectionCode = N'CSC101-01');

-- Cập nhật tiến độ SV001 kỳ 1
EXEC dbo.sp_TinhTienDoHocTap
    @StudentId = (SELECT StudentId FROM dbo.Student WHERE StudentCode = N'SV001'),
    @SemesterId = (SELECT SemesterId FROM dbo.Semester WHERE ThuTu = 1 AND AcademicYearId = (SELECT AcademicYearId FROM dbo.AcademicYear WHERE TenNam = N'2025-2026'));

-- Cấu hình điều kiện tốt nghiệp & xét nhanh
INSERT INTO dbo.GraduationCondition (CurriculumId, MinTinChi, MinGPA, YeuCauMonBatBuoc)
SELECT CurriculumId, 130, 2.0, 1 FROM dbo.Curriculum WHERE KhoaTuyen = 2022 AND MajorId = (SELECT MajorId FROM dbo.Major WHERE MaNganh = N'KHMT');

EXEC dbo.sp_XetTotNghiep @StudentId = (SELECT StudentId FROM dbo.Student WHERE StudentCode = N'SV001');

SET NOCOUNT OFF;
