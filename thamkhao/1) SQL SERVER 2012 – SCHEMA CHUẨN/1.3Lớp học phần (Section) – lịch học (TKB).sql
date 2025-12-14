/* 1.3. Section (Lớp học phần, TKB, Phòng học) */
SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.SectionSchedules', 'U') IS NOT NULL
DROP TABLE dbo.SectionSchedules;

IF OBJECT_ID ('dbo.Sections', 'U') IS NOT NULL
DROP TABLE dbo.Sections;

IF OBJECT_ID ('dbo.Rooms', 'U') IS NOT NULL DROP TABLE dbo.Rooms;
GO

CREATE TABLE dbo.Rooms (
    RoomId INT IDENTITY PRIMARY KEY,
    RoomCode NVARCHAR (20) NOT NULL UNIQUE,
    Capacity INT NOT NULL,
    RoomType TINYINT NOT NULL DEFAULT 1 --1=Classroom,2=Lab,3=Hall
);
GO

CREATE TABLE dbo.Sections (
    SectionId INT IDENTITY PRIMARY KEY,
    SemesterId INT NOT NULL,
    CourseId INT NOT NULL,
    SectionCode NVARCHAR (30) NOT NULL,
    Status TINYINT NOT NULL DEFAULT 0,
    --0=DRAFT,1=OPEN,2=RUNNING,3=CANCELED,4=MERGED,5=FULL
    MinCapacity INT NOT NULL,
    MaxCapacity INT NOT NULL,
    FacultyId INT NULL,
    DeliveryMode TINYINT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE (),
    UpdatedAt DATETIME NULL,
    CONSTRAINT FK_Section_Sem FOREIGN KEY (SemesterId) REFERENCES dbo.Semesters (SemesterId),
    CONSTRAINT FK_Section_Course FOREIGN KEY (CourseId) REFERENCES dbo.Courses (CourseId),
    UNIQUE (SemesterId, SectionCode)
);
GO

CREATE TABLE dbo.SectionSchedules (
    ScheduleId INT IDENTITY PRIMARY KEY,
    SectionId INT NOT NULL,
    WeekDay TINYINT NOT NULL, --2=Mon..8=Sun
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    RoomId INT NULL,
    IsOfficial BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Schedule_Section FOREIGN KEY (SectionId) REFERENCES dbo.Sections (SectionId),
    CONSTRAINT FK_Schedule_Room FOREIGN KEY (RoomId) REFERENCES dbo.Rooms (RoomId)
);
GO

CREATE INDEX IX_Schedule_Official ON dbo.SectionSchedules (SectionId, IsOfficial);
GO