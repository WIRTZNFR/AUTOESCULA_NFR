use Autoescuela_NFR_Pruebas
go

alter database current
	set memory_optimized_elevate_to_snapshot = on
go

--Commands completed successfully.


--creamos el filegroup
alter database Autoescuela_NFR_Pruebas
	add filegroup Autoescuela_mod
	contains memory_optimized_data
go

--Commands completed successfully.

--agregamos el contenedor MEMORY_OPTIMIZED_DATA filegroup
alter database Autoescuela_NFR_Pruebas
	add file (name='Autoescuela_mod1',
	filename='c:\data\Autoescuela_mod1')
	to filegroup Autoescuela_mod
go
--Commands completed successfully.



--creamos una tabla

DROP TABLE IF EXISTS venta_coche
go
CREATE TABLE venta_coche  
(  
    Id_coche integer not null  IDENTITY PRIMARY KEY NONCLUSTERED,  
    precio_venta     money        not null,  
    km_coche      integer       not null  
)  
    WITH  
        (MEMORY_OPTIMIZED = ON,  
        DURABILITY = SCHEMA_AND_DATA);
GO

--Commands completed successfully.