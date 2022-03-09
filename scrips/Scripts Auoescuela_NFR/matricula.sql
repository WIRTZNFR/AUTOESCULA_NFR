USE [Autoescuela_NFR]
GO

INSERT INTO [dbo].[Matricula]
           ([Id_matricula]
           ,[Material]
           ,[Curso]
           ,[Fecha_alta]
           ,[Alumno_DNI_Alumno]
           ,[Tasas_Trafico])
     VALUES
          	('1001','Libros','Teorico','01/01/2022','11111111A','50'),
			('1002','Test','Teorico','02/02/2022','11111122B','150'),
			('1003','Libros','Practico','04/01/2022','11111133C','20'),
			('1004','Test','Practico','06/01/2022','11111144D','40'),
			('1005','Libros y Test','Teorico','05/01/2022','11111155E','80'),
			('1006','Libros y Tesr','Practico','06/02/2022','11111166F','150')

GO