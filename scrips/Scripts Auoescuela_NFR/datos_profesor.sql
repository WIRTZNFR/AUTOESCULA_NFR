USE [Autoescuela_NFR]
GO

INSERT INTO [dbo].[Profesor]
           ([DNI_Profesor]
           ,[Nombre]
           ,[Apellido1]
           ,[Apellido2]
           ,[Telefono]
           ,[Email]
           ,[Local_Id_local]
           ,[Datos_Residencia_Id_direccion])
     VALUES
            ('53111222A','Cesar','Perez','Fernandez','777111999','cesar@autoescuela.com','1','5'),
			('53258999B','Roi', 'Lopez','insua','777111888','roi@autoescuela.com','1','3'),
			('51265554F','Gerardo', 'Santos','iglesias','777111666','gerardo@autoescuela.com','2','2'),
			('56224488H','Elena', 'Mala','Ventura','777111555','elena@autoescuela.com','3','1'),
			('56224494L','Maria', 'Benitez','Campos','777111444','maria@autoescuela.com','4','4')
GO