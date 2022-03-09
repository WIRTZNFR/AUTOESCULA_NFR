/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id_direccion]
      ,[Direccion]
      ,[CP]
      ,[Localidad]
      ,[Provincia]
  FROM [Autoescuela_NFR].[dbo].[Datos_Residencia]