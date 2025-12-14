USE EduProDb1;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_HocPhan_MaHP' AND object_id = OBJECT_ID('HocPhan'))
BEGIN
    CREATE INDEX IX_HocPhan_MaHP ON HocPhan (MaHP);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_HocPhiCatalog_Filter' AND object_id = OBJECT_ID('HocPhiCatalog'))
BEGIN
    CREATE INDEX IX_HocPhiCatalog_Filter ON HocPhiCatalog (MaHK, MaNganh, HieuLucTu DESC, Id);
END
GO
