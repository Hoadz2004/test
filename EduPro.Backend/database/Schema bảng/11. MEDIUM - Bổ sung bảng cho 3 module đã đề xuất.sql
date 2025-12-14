-- Bảng CongNo (học phí cơ bản)
CREATE TABLE CongNo (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaSV NVARCHAR(10) NOT NULL,
    MaHK NVARCHAR(10) NOT NULL,
    SoTienNo DECIMAL(18, 2) NOT NULL DEFAULT 0,
    NgayCapNhat DATETIME NOT NULL DEFAULT GETDATE (),
    CONSTRAINT FK_CongNo_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV),
    CONSTRAINT FK_CongNo_HK FOREIGN KEY (MaHK) REFERENCES HocKy (MaHK)
);

-- Bảng YeuCauDacBiet (workflow duyệt)
CREATE TABLE YeuCauDacBiet (
    Id INT IDENTITY (1, 1) PRIMARY KEY,
    MaSV NVARCHAR(10) NOT NULL,
    LoaiYeuCau NVARCHAR (50) NOT NULL, -- 'Học vượt', 'Rút môn', 'Học lại'
    MaLHP NVARCHAR(20) NULL,
    LyDo NVARCHAR (500) NULL,
    TrangThai NVARCHAR (50) NOT NULL DEFAULT N'Chờ duyệt',
    NgayGui DATETIME NOT NULL DEFAULT GETDATE (),
    NgayXuLy DATETIME NULL,
    NguoiXuLy NVARCHAR(50) NULL,
    KetQuaXuLy NVARCHAR (500) NULL,
    CONSTRAINT FK_YCDB_SV FOREIGN KEY (MaSV) REFERENCES SinhVien (MaSV),
    CONSTRAINT FK_YCDB_LHP FOREIGN KEY (MaLHP) REFERENCES LopHocPhan (MaLHP)
);

-- Index cho CongNo
CREATE INDEX IX_CongNo_MaSV ON CongNo (MaSV);

CREATE INDEX IX_CongNo_MaHK ON CongNo (MaHK);

-- Index cho YeuCauDacBiet
CREATE INDEX IX_YeuCauDacBiet_MaSV ON YeuCauDacBiet (MaSV);

CREATE INDEX IX_YeuCauDacBiet_TrangThai ON YeuCauDacBiet (TrangThai);

-- Unique constraint cho CongNo
ALTER TABLE CongNo
ADD CONSTRAINT UQ_CongNo_SV_HK UNIQUE (MaSV, MaHK);

-- Check constraint cho YeuCauDacBiet
ALTER TABLE YeuCauDacBiet
ADD CONSTRAINT CK_YeuCau_LoaiYeuCau CHECK (
    LoaiYeuCau IN (
        N'Học vượt',
        N'Rút môn',
        N'Học lại',
        N'Miễn giảm học phí'
    )
);

ALTER TABLE YeuCauDacBiet
ADD CONSTRAINT CK_YeuCau_TrangThai CHECK (
    TrangThai IN (
        N'Chờ duyệt',
        N'Đã duyệt',
        N'Từ chối'
    )
);