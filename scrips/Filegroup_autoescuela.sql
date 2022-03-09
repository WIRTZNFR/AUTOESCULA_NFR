
EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO
-- FileTable

DROP DATABASE IF EXISTS  Autoescuela_NFR_Pruebas
GO

--creamos manualmente la carpeta C:\AutoescuelaNFR_Filetable

Completion time: 2022-03-06T12:46:00.7690586+01:00

CREATE DATABASE  Autoescuela_NFR_Pruebas
ON PRIMARY
(
    NAME = Autoescuela_NFR_FileTable_data,
    FILENAME = 'C:\AutoescuelaNFR_Filetable\Autoescuela_NFR_FileTable_data.mdf'
),
FILEGROUP FileStreamFG CONTAINS FILESTREAM
(
    NAME = Autoescuela_NFR_Pruebas,
    FILENAME = 'C:\AutoescuelaNFR_Filetable\Autoescuela_NFR_Container' 
)
LOG ON
(
    NAME = Autoescuela_NFR_FileTable_Log,
    FILENAME = 'C:\AutoescuelaNFR_Filetable\Autoescuela_NFR_Log.ldf'
)
WITH FILESTREAM
(
    NON_TRANSACTED_ACCESS = FULL,
    DIRECTORY_NAME = 'Autoescuela_NFR_Container'
);
GO

--Commands completed successfully.

--Completion time: 2022-03-06T12:46:00.7690586+01:00



-- METADATA

-- Primera opcion, nos muestra todas las BBDD y su estado
SELECT DB_NAME(database_id),
non_transacted_access,
non_transacted_access_desc
FROM sys.database_filestream_options;
GO

--Segunda opción, nos muestra solo la FULL

SELECT DB_NAME(database_id) as DatabaseName, non_transacted_access, non_transacted_access_desc 
FROM sys.database_filestream_options
where DB_NAME(database_id)='SQLFileTable';
GO



--creamos una Filetable

USE Autoescuela_NFR_Pruebas
GO
DROP TABLE IF EXISTS Autoescuela_NFR_Docs 
GO
CREATE TABLE Autoescuela_NFR_Docs 
AS FILETABLE
WITH 
(
    FileTable_Directory = 'Autoescuela_NFR_Container',
    FileTable_Collate_Filename = database_default
);
GO
--Commands completed successfully.

--introducimos datos en la carpeta contenedora y los editamos

SELECT *
FROM Autoescuela_NFR_Docs 
GO