USE [Autoescuela_NFR]
GO

INSERT INTO [dbo].[Vehiculo]
           ([Id_vehiculo]
           ,[Matricula]
           ,[Modelo]
           ,[Marca]
           ,[Combustible]
           ,[Kilometros]
           ,[Local_Id_local])
     VALUES
			('1','1234ABC','ibiza','seat','Gasolina','52000','1'),
			('2','6789ABC','focus','ford','Gasolina','24250','2'), 
			('3','1234DEF','a4','audi','Diesel','13125','1'), 
			('4','1892FCD','ibiza','seat','Diesel','4500','3'), 
			('5','6589FJC','fabia','skoda','Diesel','41200','4'), 
			('6','9999CDJ','auris','toyota','Hibrido','2800','4') 
GO