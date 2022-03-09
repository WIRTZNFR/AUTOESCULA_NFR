DROP DATABASE IF EXISTS Autoescuela_NFR_Pruebas
GO

CREATE DATABASE Autoescuela_NFR_Pruebas
GO

USE Autoescuela_NFR_Pruebas
GO

--Lo habilitamos

EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO

-- Paramos y arrancamos el servicio

EXEC sp_configure filestream_access_level, 2
RECONFIGURE
GO



ALTER DATABASE Autoescuela_NFR_Pruebas 
	ADD FILEGROUP Autoescuela_NFR_Pruebas_File01
	CONTAINS FILESTREAM 
GO
ALTER DATABASE Autoescuela_NFR_Pruebas
       ADD FILE (
             NAME = 'Autoescuela_NFR_Pruebas_filestream',
             FILENAME = 'C:\Autoescuela_NFR_Pruebas_filestream'
       )
       TO FILEGROUP Autoescuela_NFR_Pruebas_File01
GO


DROP DATABASE IF EXISTS LocalautoescuelaNFR_Prueba
CREATE TABLE [dbo].[LocalautoescuelaNFR_Prueba](
	[Id_local] [int] NOT NULL,
	[Nombre] [varchar](30) NULL,
	[Telefono] [int] NULL,
	[Email] [varchar](35) NULL,
	[Datos_Residencia_Id_direccion] [int] NOT NULL,
	[Logo] [varbinary](max) FILESTREAM
	);
GO

--CREAR UNA TABLA CON EL LOGO

USE [Autoescuela_NFR_Pruebas]
GO
Drop table if exists Local_AutoescuelaNFR_Pruebas
 --Creamos tabla
CREATE TABLE [dbo].[Local_AutoescuelaNFR_Pruebas](
	Id uniqueidentifier rowguidcol not null unique,
	[Id_local] [int] NOT NULL ,
	[Nombre] [varchar](30) NULL,
	[Telefono] [int] NULL,
	[Email] [varchar](35) NULL,
	[Logo] [varbinary](max) FILESTREAM,
	);
GO
--insertamos valores
INSERT INTO [dbo].[Local_AutoescuelaNFR_Pruebas]
           ([Id]
		   ,[Id_local]
           ,[Nombre]
           ,[Telefono]
           ,[Email]
           ,[Logo])
     SELECT
		   
		  NEWID(),'1','Autoescuela_Coru','981909090','autoescuela_coru@autoescuela.com', bulkcolumn
		   from openrowset (BULK 'c:\logo_autoescuela.png', SINGLE_BLOB) as ImageFile
GO


--creamos otra tabla llamada Regalo_NFR

Drop table if exists regaloNFR_Pruebas

CREATE TABLE [dbo].[regaloNFR_Pruebas](
	Id uniqueidentifier rowguidcol not null unique,
	[Nombre] [varchar](30) NULL,
	[carnet] [varbinary](max) FILESTREAM,
	);
GO


--insertamos valores
INSERT INTO [dbo].[regaloNFR_Pruebas]
           ([Id]
           ,[Nombre]
           ,[carnet])
     SELECT
		   
		  NEWID(),'Nuria', bulkcolumn
		   from openrowset (BULK 'c:\foto_carnet.png', SINGLE_BLOB) as ImageFile
GO



--Para borrar 
USE master
GO

ALTER DATABASE Autoescuela_NFR_Pruebas  REMOVE FILE Autoescuela_NFR_Pruebas_filestream;
GO

--Msg 5042, Level 16, State 10, Line 107
--The file 'Autoescuela_NFR_Pruebas_filestream' cannot be removed because it is not empty.


ALTER DATABASE Autoescuela_NFR_Pruebas  REMOVE FILE Autoescuela_NFR_Pruebas_filestream;
GO
