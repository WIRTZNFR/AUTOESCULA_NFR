-- Generado por Oracle SQL Developer Data Modeler 21.2.0.183.1957
--   en:        2022-03-02 19:37:40 CET
--   sitio:      SQL Server 2012
--   tipo:      SQL Server 2012

USE master
GO


DROP DATABASE IF EXISTS Autoescuela_NFR
GO
CREATE DATABASE Autoescuela_NFR
GO
USE Autoescuela_NFR
GO





CREATE TABLE Alumno 
    (
     DNI_Alumno VARCHAR (30) NOT NULL , 
     Nombre VARCHAR (20) , 
     Apellido1 VARCHAR (20) , 
     Apellido2 VARCHAR (20) , 
     Telefono VARCHAR (15) , 
     Email VARCHAR (30) , 
     Fecha_nacimiento DATE , 
     Datos_Residencia_Id_direccion INTEGER NOT NULL , 
     Local_Id_local INTEGER NOT NULL 
    )
GO

ALTER TABLE Alumno ADD CONSTRAINT Alumno_PK PRIMARY KEY CLUSTERED (DNI_Alumno)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Clase 
    (
     Id_clase INTEGER NOT NULL , 
     Fecha_clase DATE NOT NULL , 
     Precio MONEY NOT NULL , 
     Num_clases INTEGER NOT NULL , 
     Tipo_clase VARCHAR (10) NOT NULL , 
     Vehiculo_Id_vehiculo INTEGER NOT NULL , 
     Profesor_DNI_Profesor VARCHAR (15) NOT NULL , 
     Alumno_DNI_Alumno VARCHAR (30) NOT NULL 
    )
GO

ALTER TABLE Clase ADD CONSTRAINT Clase_PK PRIMARY KEY CLUSTERED (Id_clase)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Datos_Residencia 
    (
     Id_direccion INTEGER NOT NULL , 
     Direccion VARCHAR (25) NOT NULL , 
     CP VARCHAR (15) NOT NULL , 
     Localidad VARCHAR (20) NOT NULL , 
     Provincia VARCHAR (20) NOT NULL 
    )
GO

ALTER TABLE Datos_Residencia ADD CONSTRAINT Datos_Residencia_PK PRIMARY KEY CLUSTERED (Id_direccion)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Factura 
    (
     Id_Factura INTEGER NOT NULL , 
     Num_factura VARCHAR (25) , 
     Fecha_fra DATE , 
     Importe MONEY , 
     Impuestos MONEY , 
     Forma_pago VARCHAR (20) , 
     Descuento VARCHAR (20) , 
     Forma_pago_Id_pago INTEGER NOT NULL , 
     Matricula_Id_matricula INTEGER NOT NULL 
    )
GO

ALTER TABLE Factura ADD CONSTRAINT Factura_PK PRIMARY KEY CLUSTERED (Id_Factura)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Forma_pago 
    (
     Id_pago INTEGER NOT NULL , 
     tipo_pago VARCHAR (30) NOT NULL , 
     Id_Factura INTEGER NOT NULL , 
     Tarjeta_credito_numero_tarjeta INTEGER NOT NULL , 
     Transferencia_Num_cuenta INTEGER NOT NULL 
    )
GO

ALTER TABLE Forma_pago ADD CONSTRAINT Forma_pago_PK PRIMARY KEY CLUSTERED (Id_pago)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Local 
    (
     Id_local INTEGER NOT NULL , 
     Nombre VARCHAR (30) , 
     Telefono INTEGER , 
     Email VARCHAR (35) , 
     Datos_Residencia_Id_direccion INTEGER NOT NULL , 
     Logo VARBINARY 
    )
GO

ALTER TABLE Local ADD CONSTRAINT Local_PK PRIMARY KEY CLUSTERED (Id_local)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Matricula 
    (
     Id_matricula INTEGER NOT NULL , 
     Material VARCHAR (20) NOT NULL , 
     Curso VARCHAR (20) NOT NULL , 
     Fecha_alta DATE NOT NULL , 
     Alumno_DNI_Alumno VARCHAR (30) NOT NULL , 
     Tasas_Trafico MONEY 
    )
GO

ALTER TABLE Matricula ADD CONSTRAINT Matricula_PK PRIMARY KEY CLUSTERED (Id_matricula)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Profesor 
    (
     DNI_Profesor VARCHAR (15) NOT NULL , 
     Nombre VARCHAR (20) NOT NULL , 
     Apellido1 VARCHAR (20) NOT NULL , 
     Apellido2 VARCHAR (20) NOT NULL , 
     Telefono VARCHAR (20) NOT NULL , 
     Email VARCHAR NOT NULL , 
     Local_Id_local INTEGER NOT NULL , 
     Datos_Residencia_Id_direccion INTEGER NOT NULL 
    )
GO

ALTER TABLE Profesor ADD CONSTRAINT Profesor_PK PRIMARY KEY CLUSTERED (DNI_Profesor)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Tarjeta_credito 
    (
     numero_tarjeta INTEGER NOT NULL , 
     Nombre_titular VARCHAR (40) NOT NULL , 
     CVV INTEGER NOT NULL , 
     Fecha_caducidad DATE NOT NULL 
    )
GO

ALTER TABLE Tarjeta_credito ADD CONSTRAINT Tarjeta_credito_PK PRIMARY KEY CLUSTERED (numero_tarjeta)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Transferencia 
    (
     Num_cuenta INTEGER NOT NULL , 
     Entidad_bancaria VARCHAR (30) NOT NULL 
    )
GO

ALTER TABLE Transferencia ADD CONSTRAINT Transferencia_PK PRIMARY KEY CLUSTERED (Num_cuenta)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE Vehiculo 
    (
     Id_vehiculo INTEGER NOT NULL , 
     Matricula VARCHAR (10) , 
     Modelo VARCHAR (20) , 
     Marca VARCHAR (20) , 
     Combustible VARCHAR (10) , 
     Kilometros INTEGER , 
     Local_Id_local INTEGER NOT NULL 
    )
GO

ALTER TABLE Vehiculo ADD CONSTRAINT Vehiculo_PK PRIMARY KEY CLUSTERED (Id_vehiculo)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

ALTER TABLE Alumno 
    ADD CONSTRAINT Alumno_Datos_Residencia_FK FOREIGN KEY 
    ( 
     Datos_Residencia_Id_direccion
    ) 
    REFERENCES Datos_Residencia 
    ( 
     Id_direccion 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Alumno 
    ADD CONSTRAINT Alumno_Local_FK FOREIGN KEY 
    ( 
     Local_Id_local
    ) 
    REFERENCES Local 
    ( 
     Id_local 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Clase 
    ADD CONSTRAINT Clase_Alumno_FK FOREIGN KEY 
    ( 
     Alumno_DNI_Alumno
    ) 
    REFERENCES Alumno 
    ( 
     DNI_Alumno 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Clase 
    ADD CONSTRAINT Clase_Profesor_FK FOREIGN KEY 
    ( 
     Profesor_DNI_Profesor
    ) 
    REFERENCES Profesor 
    ( 
     DNI_Profesor 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Clase 
    ADD CONSTRAINT Clase_Vehiculo_FK FOREIGN KEY 
    ( 
     Vehiculo_Id_vehiculo
    ) 
    REFERENCES Vehiculo 
    ( 
     Id_vehiculo 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Factura 
    ADD CONSTRAINT Factura_Forma_pago_FK FOREIGN KEY 
    ( 
     Forma_pago_Id_pago
    ) 
    REFERENCES Forma_pago 
    ( 
     Id_pago 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Factura 
    ADD CONSTRAINT Factura_Matricula_FK FOREIGN KEY 
    ( 
     Matricula_Id_matricula
    ) 
    REFERENCES Matricula 
    ( 
     Id_matricula 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Forma_pago 
    ADD CONSTRAINT Forma_pago_Tarjeta_credito_FK FOREIGN KEY 
    ( 
     Tarjeta_credito_numero_tarjeta
    ) 
    REFERENCES Tarjeta_credito 
    ( 
     numero_tarjeta 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Forma_pago 
    ADD CONSTRAINT Forma_pago_Transferencia_FK FOREIGN KEY 
    ( 
     Transferencia_Num_cuenta
    ) 
    REFERENCES Transferencia 
    ( 
     Num_cuenta 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Local 
    ADD CONSTRAINT Local_Datos_Residencia_FK FOREIGN KEY 
    ( 
     Datos_Residencia_Id_direccion
    ) 
    REFERENCES Datos_Residencia 
    ( 
     Id_direccion 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Matricula 
    ADD CONSTRAINT Matricula_Alumno_FK FOREIGN KEY 
    ( 
     Alumno_DNI_Alumno
    ) 
    REFERENCES Alumno 
    ( 
     DNI_Alumno 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Profesor 
    ADD CONSTRAINT Profesor_Datos_Residencia_FK FOREIGN KEY 
    ( 
     Datos_Residencia_Id_direccion
    ) 
    REFERENCES Datos_Residencia 
    ( 
     Id_direccion 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Profesor 
    ADD CONSTRAINT Profesor_Local_FK FOREIGN KEY 
    ( 
     Local_Id_local
    ) 
    REFERENCES Local 
    ( 
     Id_local 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE Vehiculo 
    ADD CONSTRAINT Vehiculo_Local_FK FOREIGN KEY 
    ( 
     Local_Id_local
    ) 
    REFERENCES Local 
    ( 
     Id_local 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             0
-- ALTER TABLE                             25
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE DATABASE                          0
-- CREATE DEFAULT                           0
-- CREATE INDEX ON VIEW                     0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE ROLE                              0
-- CREATE RULE                              0
-- CREATE SCHEMA                            0
-- CREATE SEQUENCE                          0
-- CREATE PARTITION FUNCTION                0
-- CREATE PARTITION SCHEME                  0
-- 
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

