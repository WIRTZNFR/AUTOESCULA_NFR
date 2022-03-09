USE [Autoescuela_NFR]
GO

INSERT INTO [dbo].[Clase]
           ([Id_clase]
           ,[Fecha_clase]
           ,[Precio]
           ,[Num_clases]
           ,[Tipo_clase]
           ,[Vehiculo_Id_vehiculo]
           ,[Profesor_DNI_Profesor]
           ,[Alumno_DNI_Alumno])
     VALUES
             
		   ('1','01/01/2022','10','10','T','1','53111222A','11111111A'),
		   ('2','03/01/2022','20','5','P','2','51265554F','11111133C'),
		   ('3','06/01/2022','20','10','P','3','53258999B','11111155E'),
		   ('4','12/01/2022','10','15','T','4','56224488H','11111166F'),
		   ('5','11/01/2022','10','15','T','5','56224494L','11111122B')
		   
GO