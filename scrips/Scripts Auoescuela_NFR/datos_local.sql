USE [Autoescuela_NFR]
GO

INSERT INTO [dbo].[Local]
           ([Id_local]
           ,[Nombre]
           ,[Telefono]
           ,[Email]
           ,[Datos_Residencia_Id_direccion])
           
     VALUES
       	   ('1','Autoescuela_Coru','981909090','autoescuela_coru@autoescuela.com','1'),
		   ('2','Autoescuela_Ourense','981909091','autoescuela_ourense@autoescuela.com','2'),
		   ('3','Autoescuela_Vigo','981909092','autoescuela_vigo@autoescuela.com','3'),
		   ('4','Autoescuela_Madrid','981909093','autoescuela_madrid@autoescuela.com','4')
GO