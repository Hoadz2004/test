/* 1.1. Catalog (Môn học, Tiên quyết, Tương đương) */
SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID ('dbo.CourseEquivalents', 'U') IS NOT NULL
DROP TABLE dbo.CourseEquivalents;

IF OBJECT_ID (
    'dbo.CoursePrerequisites',
    'U'
) IS NOT NULL
DROP TABLE dbo.CoursePrerequisites;

IF OBJECT_ID ('dbo.Courses', 'U') IS NOT NULL DROP TABLE dbo.Courses;
GO

CREATE TABLE dbo.Courses (
    CourseId INT IDENTITY (1, 1) PRIMARY KEY,
    CourseCode NVARCHAR (20) NOT NULL UNIQUE,
    CourseName NVARCHAR (200) NOT NULL,
    Credits TINYINT NOT NULL CHECK (Credits > 0),
    LectureHours SMALLINT NOT NULL DEFAULT 0,
    LabHours SMALLINT NOT NULL DEFAULT 0,
    CourseType TINYINT NOT NULL, -- 1=Required,2=Elective,3=General,...
    DepartmentId INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE (),
    UpdatedAt DATETIME NULL
);
GO

CREATE TABLE dbo.CoursePrerequisites (
    CourseId INT NOT NULL,
    PrereqCourseId INT NOT NULL,
    PrereqType TINYINT NOT NULL DEFAULT 1, --1=MustPass,2=Concurrent
    PRIMARY KEY (CourseId, PrereqCourseId),
    CONSTRAINT FK_Prereq_Course FOREIGN KEY (CourseId) REFERENCES dbo.Courses (CourseId),
    CONSTRAINT FK_Prereq_Req FOREIGN KEY (PrereqCourseId) REFERENCES dbo.Courses (CourseId)
);
GO

CREATE TABLE dbo.CourseEquivalents (
    CourseId INT NOT NULL,
    EquivalentId INT NOT NULL,
    PRIMARY KEY (CourseId, EquivalentId),
    CONSTRAINT FK_Equiv_Course FOREIGN KEY (CourseId) REFERENCES dbo.Courses (CourseId),
    CONSTRAINT FK_Equiv_Req FOREIGN KEY (EquivalentId) REFERENCES dbo.Courses (CourseId)
);
GO