--PARTICIONES

USE master 
GO
-- CREAMOS EN C: UNA CARPETA LLAMADA Data y 
DROP DATABASE IF EXISTS Autoescuela_NFR_Pruebas 
GO
CREATE DATABASE [Autoescuela_NFR_Pruebas] 
	ON PRIMARY ( NAME = 'Autoescuela_NFR_Pruebas', 
		FILENAME = 'C:\Data\Autoescuela_NFR_Pruebas_Fijo.mdf' , 
		SIZE = 15360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 0) 
	LOG ON ( NAME = 'Autoescuela_NFR_Pruebas_log', 
		FILENAME = 'C:\Data\Autoescuela_NFR_Pruebas_log.ldf' , 
		SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%) 
GO

--creamos los filegroups


USE Autoescuela_NFR_Pruebas 
GO 

ALTER DATABASE [Autoescuela_NFR_Pruebas] ADD FILEGROUP [Autoescuela_NFR_Archivo] 
GO 
ALTER DATABASE [Autoescuela_NFR_Pruebas] ADD FILEGROUP [Autoescuela_NFR_FG_2020] 
GO 
ALTER DATABASE [Autoescuela_NFR_Pruebas] ADD FILEGROUP [Autoescuela_NFR_FG_2021] 
GO 
ALTER DATABASE [Autoescuela_NFR_Pruebas] ADD FILEGROUP [Autoescuela_NFR_FG_2022]
GO



select * from sys.filegroups
GO

--creamos las filas

-- -- CREATE FILES

ALTER DATABASE [Autoescuela_NFR_Pruebas] ADD FILE ( NAME = 'Matriculas_Archivo', FILENAME = 'c:\Data\Matriculas_Archivo.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [Autoescuela_NFR_Archivo] 
GO
ALTER DATABASE [Autoescuela_NFR_Pruebas] ADD FILE ( NAME = 'Matriculas_2020', FILENAME = 'c:\DATA\Matriculas_2020.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [Autoescuela_NFR_FG_2020] 
GO
ALTER DATABASE [Autoescuela_NFR_Pruebas] ADD FILE ( NAME = 'Matriculas_2021', FILENAME = 'c:\DATA\Matriculas_2021.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [Autoescuela_NFR_FG_2021] 
GO
ALTER DATABASE [Autoescuela_NFR_Pruebas] ADD FILE ( NAME = 'Matriculas_2022', FILENAME = 'c:\DATA\Matriculas_2022.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [Autoescuela_NFR_FG_2022] 
GO


select * from sys.filegroups
GO

select * from sys.database_files
GO


-- PARTICIONES CON LIMITES



CREATE PARTITION FUNCTION FN_fecha_matricula (datetime) 
AS RANGE RIGHT 
	FOR VALUES ('2020-01-01','2021-01-01')
GO


--Creamos el esquema de particionado de los rangos que tenemos

CREATE PARTITION SCHEME matricula_fecha 
AS PARTITION FN_fecha_matricula 
	TO (Autoescuela_NFR_Archivo,Autoescuela_NFR_FG_2020,Autoescuela_NFR_FG_2021,Autoescuela_NFR_FG_2022) 
GO

--Partition scheme 'matricula_fecha' has been created successfully. 'Autoescuela_NFR_FG_2022' is marked as the next used filegroup in partition scheme 'matricula_fecha'.



--creamos la tabla , haremos el esquema y marcamos el campo para marcar las particiones

DROP TABLE IF EXISTS dbo.matricula
GO
CREATE TABLE dbo.matricula
	( id_alta int identity (1,1), 
	nombre varchar(20), 
	apellido varchar (20), 
	fecha_alta datetime,
	fecha_aprobado datetime ) 
	ON matricula_fecha -- Esquema de la particion 
	(fecha_alta) -- Columna que aplica la funcion
GO
--Commands completed successfully.


--Introducimos los datos

USE [Autoescuela_NFR_Pruebas]
GO

INSERT INTO [dbo].[matricula]
           ([nombre]
           ,[apellido]
           ,[fecha_alta]
           ,[fecha_aprobado])
     VALUES
           ('Nuria','Ferreiro','2019-01-01', '2019-05-01'),
		   ('Carlos','Lopez','2019-02-08', '2019-06-12'),
           ('Julia','Perez','2019-04-01', '2019-07-07'),
           ('Jesus','Iglesias','2019-06-12', '2019-09-01'),
           ('Maria','Castro','2019-07-01', '2019-09-01'),
		   ('Marta','Rodriguez','2020-01-01', '2020-05-01'),
		   ('Armando','Casas','2020-02-08', '2020-06-12'),
           ('Fernando','Otero','2020-04-01', '2020-07-07'),
           ('Mariano','Iglesias','2020-06-12', '2020-09-01'),
           ('Pedro','Suarez','2021-07-01', '2021-09-01'),
		   ('Carmela','Varela','2021-01-01', '2021-05-01'),
		   ('Roberto','Santos','2021-02-08', '2021-06-12'),
           ('Antonio','Miguez','2021-04-01', '2021-07-07'),
           ('Rosa','Montes','2022-06-12', '2022-09-01'),
           ('Francisco','Delicado','2022-07-01', '2022-09-01'),
		   ('Javier','Negreira','2022-06-01', '2022-10-01')

GO


--Consultamos

SELECT * from dbo.matricula
GO


--Consultamos los metadatos, 

SELECT *,$Partition.FN_fecha_matricula(fecha_alta) AS Partition
FROM dbo.matricula
GO


---Particion funtion

select name, create_date, value from sys.partition_functions f 
inner join sys.partition_range_values rv 
on f.function_id=rv.function_id 
where f.name = 'FN_fecha_matricula'
go

--numero de registgros particion

select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'matricula' 
GO


--
DECLARE @TableName NVARCHAR(200) = N'matricula' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO


---SPLIT

ALTER PARTITION FUNCTION FN_fecha_matricula() 
	SPLIT RANGE ('2022-01-01'); 
GO

SELECT *,$Partition.FN_fecha_matricula(fecha_alta) as PARTITION
FROM dbo.matricula
GO

--para ver la nueva particion y resto de datos

DECLARE @TableName NVARCHAR(200) = N'matricula' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO


----MERGE

ALTER PARTITION FUNCTION FN_fecha_matricula() 
	MERGE RANGE ('2020-01-01'); 
GO

SELECT *,$Partition.FN_altas_fecha(fecha_alta) 
FROM Alta_Coleg
GO

DECLARE @TableName NVARCHAR(200) = N'matricula' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO


--SWITCH


USE Autoescuela_NFR_Pruebas
go

--comprobamos los datos

DECLARE @TableName NVARCHAR(200) = N'Matricula' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--creamos una tabla nueva 

DROP TABLE IF EXISTS Archivo_Matricula
GO

CREATE TABLE Archivo_Matricula
	( id_alta int identity (1,1), 
	nombre varchar(20), 
	apellido varchar (20), 
	fecha_alta datetime,
	fecha_aprobado datetime ) 
	ON Autoescuela_NFR_Archivo
GO


--Commands completed successfully.



--
ALTER TABLE matricula 
	SWITCH Partition 1 to Archivo_Matricula
GO

select * from matricula
go

select * from Archivo_Matricula
go


DECLARE @TableName NVARCHAR(200) = N'matricula' SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows
, au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--TRUNCATE

TRUNCATE TABLE matricula 
	WITH (PARTITIONS (3));
go

select * from matricula
GO

DECLARE @TableName NVARCHAR(200) = N'matricula' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO