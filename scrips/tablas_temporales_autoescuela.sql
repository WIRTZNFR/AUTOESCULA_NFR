USE Autoescuela_NFR_Pruebas
GO

use master
go

--creamos una tabla de reserva coche

drop table if exists reservas_coche
go

create table reservas_coche(
		id_reserva int Primary Key Clustered, 
		num_reserva  integer,
		modelo varchar(50),
		SysStartTime datetime2 generated always as row start not null,  
		SysEndTime datetime2 generated always as row end not null,  
		period for System_time (SysStartTime,SysEndTime) 
		) 
	with (System_Versioning = ON (History_Table = dbo.reservas_coche_historico)
	) 
go

insert into reservas_coche (id_reserva,num_reserva,modelo)
values 
		('1','101','seat'),
		('2','102','honda'),
		('3','103','DS'),
		('4','104','citroen'),
		('5','105','opel'),
		('6','106','toyota'),
		('7','107','dacia'),
		('8','108','skoda')
GO

select * from reservas_coche
GO


select * from reservas_coche_historico
GO

--vamos a modificar la reserva 8 como la 

update reservas_coche set
num_reserva = 888
Where id_reserva ='8'

select * from reservas_coche
GO

select * from reservas_coche_historico
GO

update reservas_coche set
num_reserva = 222
Where id_reserva ='2'

select * from reservas_coche
GO

--id_reserva	num_reserva	modelo	SysStartTime	SysEndTime
--1	101	seat	2022-03-06 23:12:42.1861146	9999-12-31 23:59:59.9999999
--2	222	honda	2022-03-06 23:40:34.5148269	9999-12-31 23:59:59.9999999
--3	103	DS	2022-03-06 23:12:42.1861146	9999-12-31 23:59:59.9999999
--4	104	citroen	2022-03-06 23:12:42.1861146	9999-12-31 23:59:59.9999999
--5	105	opel	2022-03-06 23:12:42.1861146	9999-12-31 23:59:59.9999999
--6	106	toyota	2022-03-06 23:12:42.1861146	9999-12-31 23:59:59.9999999
--7	107	dacia	2022-03-06 23:12:42.1861146	9999-12-31 23:59:59.9999999
--8	888	skoda	2022-03-06 23:35:50.0173345	9999-12-31 23:59:59.9999999

select * from reservas_coche_historico
GO

--id_reserva	num_reserva	modelo	SysStartTime	SysEndTime
--8	108	skoda	2022-03-06 23:12:42.1861146	2022-03-06 23:35:50.0173345
--2	102	honda	2022-03-06 23:12:42.1861146	2022-03-06 23:40:34.5148269
--


--Ahroa haremos un delete
delete from reservas_coche
where id_reserva ='7'

--(1 row affected)

select * from reservas_coche
GO


select * from reservas_coche_historico
GO




--	id_reserva	num_reserva	modelo	SysStartTime	SysEndTime
--1	8	108	skoda	2022-03-06 23:12:42.1861146	2022-03-06 23:35:50.0173345
--2	2	102	honda	2022-03-06 23:12:42.1861146	2022-03-06 23:40:34.5148269
--3	7	107	dacia	2022-03-06 23:12:42.1861146	2022-03-08 11:29:33.6969948



--insertamos un valor
insert into reservas_coche (id_reserva,num_reserva,modelo)
values 
		('9','109','renault')
GO

select * from reservas_coche
GO


select * from reservas_coche_historico
GO







--Ahora realizaremos las consultas 

--for system_time all  vemos todas las operaciones realizas en la tabla

select * 
from reservas_coche
for system_time all 
go



--for system_time as of  vemos el estado de la tabla en un punto exacto de tiempo
select * 
from reservas_coche
for system_time as of '2022-03-06 23:59:42.1861146'
go


--for system_time from  vemos los cambios que ha sufrido la tabla entre dos fechas determinadas

select * 
from reservas_coche
for system_time from '2022-03-06 23:20:42.1861146' to '2022-03-06 23:55:42.1861146'
go

--con between vemos los cambios que ha sufrido la tabla entre dos fechas determinadas, pero tomando de referencia SysStartTime

select * 
from reservas_coche
for system_time between '2022-03-06 23:20:42.1861146' and '2022-03-06 23:55:42.1861146'
go




insert into reservas_coche (id_reserva,num_reserva,modelo)
values 
		('10','110','mitsubishi')
GO
--con contained in  vemos los registros que hemos dado de alta entre dos intervalso de tiempo

select * 
from reservas_coche
for system_time contained in ('2022-03-08 19:19:29.9777417','9999-12-31 23:59:59.9999999')
go