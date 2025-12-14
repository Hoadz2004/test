/* DROP ALL OBJECTS SCRIPT - SQL 2012 SAFE */
DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

/* 1. Drop all Foreign Key Constraints */
SELECT @sql = @sql + N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
    + N' DROP CONSTRAINT ' + QUOTENAME(name) + N';' + CHAR(13)
FROM sys.foreign_keys;

/* 2. Drop all Routines (Procedures, Functions, Triggers, Views) */
SELECT @sql = @sql + N'DROP ' + 
    CASE type 
        WHEN 'P' THEN 'PROCEDURE' 
        WHEN 'FN' THEN 'FUNCTION' 
        WHEN 'TF' THEN 'FUNCTION' 
        WHEN 'IF' THEN 'FUNCTION' 
        WHEN 'V' THEN 'VIEW'
        WHEN 'TR' THEN 'TRIGGER'
    END

+ N' ' + QUOTENAME (SCHEMA_NAME (schema_id)) + '.' + QUOTENAME (name) + N';' + CHAR(13)
FROM sys.objects
WHERE
    type IN (
        'P',
        'FN',
        'TF',
        'IF',
        'V',
        'TR'
    )
    AND is_ms_shipped = 0;

/* 3. Drop all Tables */
SELECT
    @sql = @sql + N'DROP TABLE ' + QUOTENAME (SCHEMA_NAME (schema_id)) + '.' + QUOTENAME (name) + N';' + CHAR(13)
FROM sys.tables;

/* 4. Drop Custom Types */
SELECT
    @sql = @sql + N'DROP TYPE ' + QUOTENAME (SCHEMA_NAME (schema_id)) + '.' + QUOTENAME (name) + N';' + CHAR(13)
FROM sys.types
WHERE
    is_user_defined = 1;

PRINT @sql;

EXEC sp_executesql @sql;
GO