--Activamos filestream
EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO

--Configuration option 'filestream access level' changed from 0 to 2. Run the RECONFIGURE statement to install.



-- ENABLE FILESTREAM

-- RESTART MSSQLSERVER SERVICE

EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO


USE [master]
GO
DROP DATABASE IF EXISTS Autoescuela_NFR_Pruebas 
GO
CREATE DATABASE Autoescuela_NFR_Pruebas 
go
USE Autoescuela_NFR_Pruebas 
go
ALTER DATABASE Autoescuela_NFR_Pruebas 
	ADD FILEGROUP [AutoescuelaNFR_FILESTREAM] 
	CONTAINS FILESTREAM 
GO
ALTER DATABASE Autoescuela_NFR_Pruebas 
       ADD FILE (
             NAME = 'MyDatabaseAutoesculaNFR_filestream',
             FILENAME = 'C:\AutoescuelaNFR_FILESTREAM'
       )
       TO FILEGROUP [AutoescuelaNFR_FILESTREAM]
GO



USE Autoescuela_NFR_Pruebas
GO
DROP TABLE IF EXISTS IMAGES_AutoescuelaNFR
GO
CREATE TABLE IMAGES_AutoescuelaNFR(
       id UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
       imageFile VARBINARY(MAX) FILESTREAM
);
GO


-- Tenenemos las fotos guardadas en C:\  y las insertamos


INSERT INTO IMAGES_AutoescuelaNFR(id, imageFile)
	SELECT NEWID(), BulkColumn
	FROM OPENROWSET(BULK 'c:\logo_autoescuela.png', SINGLE_BLOB) as f;
GO
INSERT INTO IMAGES_AutoescuelaNFR(id, imageFile)
	SELECT NEWID(), BulkColumn
	FROM OPENROWSET(BULK 'c:\foto_carnet.png', SINGLE_BLOB) as f;
GO

--vemos con un select que estan creadas 
SELECT *
FROM IMAGES_AutoescuelaNFR;
GO


--Hacemos una consulta con un join 
-- Filestream columns
SELECT SCHEMA_NAME(t.schema_id) AS [schema], 
    t.[name] AS [table],
    c.[name] AS [column],
    TYPE_NAME(c.user_type_id) AS [column_type]
FROM sys.columns c
JOIN sys.tables t ON c.object_id = t.object_id
WHERE t.filestream_data_space_id IS NOT NULL
    AND c.is_filestream = 1
ORDER BY 1, 2;
-- Filestream files and filegroups
SELECT f.[name] AS [file_name],
    f.physical_name AS [file_path],
    fg.[name] AS [filegroup_name]
FROM sys.database_files f 
JOIN sys.filegroups fg ON f.data_space_id = fg.data_space_id
WHERE f.[type] = 2
ORDER BY 1;
GO


--Borrar la Base de datos 

ALTER TABLE [dbo].[images_AutoescuelaNFR] DROP COLUMN [imageFile]
GO

--Commands completed successfully.

ALTER TABLE [images_AutoescuelaNFR] SET (FILESTREAM_ON="NULL")
GO

--Commands completed successfully.

ALTER DATABASE [Autoescuela_NFR_Pruebas] REMOVE FILE MyDatabaseAutoesculaNFR_filestream;
GO

--Msg 5042, Level 16, State 13, Line 104
--The file 'MyDatabaseAutoesculaNFR_filestream' cannot be removed because it is not empty.


USE master
GO

ALTER DATABASE [Autoescuela_NFR_Pruebas] REMOVE FILE MyDatabaseAutoesculaNFR_filestream;
GO

--The file 'MyDatabaseAutoesculaNFR_filestream' has been removed.

DROP DATABASE [Autoescuela_NFR_Pruebas]
GO