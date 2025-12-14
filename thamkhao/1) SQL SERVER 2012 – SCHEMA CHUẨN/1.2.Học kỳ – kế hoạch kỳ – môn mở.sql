CREATE TABLE dbo.Semesters (
    SemesterId INT IDENTITY PRIMARY KEY,
    YearNo SMALLINT NOT NULL,
    TermNo TINYINT NOT NULL, --1,2,3
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    RegOpenAt DATETIME NOT NULL,
    RegCloseAt DATETIME NOT NULL,
    Status TINYINT NOT NULL DEFAULT 0, --0=Draft,1=OpenReg,2=ClosedReg,3=Running,4=Closed
    UNIQUE (YearNo, TermNo)
);
GO

CREATE TABLE dbo.SemesterPlans (
    PlanId INT IDENTITY PRIMARY KEY,
    SemesterId INT NOT NULL,
    DepartmentId INT NULL,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE (),
    Status TINYINT NOT NULL DEFAULT 0, --0=Draft,1=Approved
    CONSTRAINT FK_Plan_Sem FOREIGN KEY (SemesterId) REFERENCES dbo.Semesters (SemesterId)
);
GO

CREATE TABLE dbo.PlannedCourses (
    PlanCourseId INT IDENTITY PRIMARY KEY,
    PlanId INT NOT NULL,
    CourseId INT NOT NULL,
    ExpectedSections INT NOT NULL DEFAULT 1,
    MinCapacity INT NOT NULL DEFAULT 10,
    MaxCapacity INT NOT NULL DEFAULT 60,
    DeliveryMode TINYINT NOT NULL DEFAULT 1, --1=Offline,2=Online,3=Blended
    ProposedFacultyId INT NULL,
    CONSTRAINT FK_Planned_Plan FOREIGN KEY (PlanId) REFERENCES dbo.SemesterPlans (PlanId),
    CONSTRAINT FK_Planned_Course FOREIGN KEY (CourseId) REFERENCES dbo.Courses (CourseId)
);
GO