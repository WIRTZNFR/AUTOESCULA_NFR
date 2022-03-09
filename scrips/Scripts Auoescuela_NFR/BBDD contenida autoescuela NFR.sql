USE master
GO

-- A UNO SE ACTIVAN OPCIONES AVANZADAS , provoca que haga el cambio
EXEC SP_CONFIGURE 'show advanced options', 1
GO
-- Actualizamos el valor
RECONFIGURE
GO

--ACTIVAMOS LA CARACTERISTICA
EXEC SP_CONFIGURE 'contained database authentication', 1
GO
-- Actualizamos de nuevo
RECONFIGURE
GO

--creamos la bbdd para que sea contenida
DROP DATABASE IF EXISTS Contenida_Autoescuela_NFR
GO
CREATE DATABASE Contenida_Autoescuela_NFR
CONTAINMENT=PARTIAL
GO

--Una vez creada la activamos
USE Contenida_Autoescuela_NFR
GO

-- Creo usuario nuriaauto, asocio esquema dbo
--compruebo su existencia y lo borro si existe
DROP USER IF EXISTS nuriaauto
GO
-- lo creo
CREATE USER nuriaauto 
	WITH PASSWORD='Abcd1234.',
	DEFAULT_SCHEMA=[dbo]
GO
-- Añadimos el usuario nuriaauto el rol dbo_owner
-- Deprecated -- está en desuso
EXEC sp_addrolemember 'db_owner', 'nuriaauto'
GO
-- Esta seria la nueva
ALTER ROLE db_owner
ADD MEMBER nuriaauto
GO

-- Damos permiso grant para que nuriaauto se pueda conectar
GRANT CONNECT TO nuriaauto
GO
--Sigue dando error
--TITLE: Connect to Server
----------------------------

--Cannot connect to ..

----------------------------
--ADDITIONAL INFORMATION:

--Login failed for user 'nuriaauto'. (Microsoft SQL Server, Error: 18456)

--For help, click: https://docs.microsoft.com/sql/relational-databases/errors-events/mssqlserver-18456-database-engine-error

----------------------------
--BUTTONS:

--OK
----------------------------

CREATE TABLE [dbo].[TablaContenida_autoescuela_NFR](
	[Codigo] [nchar](10) NULL,
	[Nombre] [nchar](10) NULL
) ON [PRIMARY]
GO
