/*
------TALLER 1 BDD-----
Integrantes:
1) Nicolas
2) Bruno Toro Elgueta - 20864066-6 - ICCI

DROP TABLE IF EXISTS contrato;
DROP TABLE IF EXISTS reserva;
DROP TABLE IF EXISTS espacio;
DROP TABLE IF EXISTS cliente;
*/


/*---------POBLAR BASE DE DATOS--------*/
create table cliente(
	rut_cliente text primary key,
	nombre_cliente text not null,
	direccion text not null,
	correo text not null,
	telefono text not null
);

create table espacio(
	tipo_espacio text primary key,
	capacidad_max integer not null,
	ubicacion text not null,
	servicios_disponibles text not null,
	tarifas text not null,
	calificacion integer not null
);

create table reserva(
	id_reserva integer primary key,
	tipo_espacio text not null references espacio(tipo_espacio),
	servicios_adicionales text not null,
	cantidad_asistentes integer not null,
	hora text not null,
	fecha_reserva text not null
);

create table contrato(
	id_reserva integer not null references reserva(id_reserva),
	rut_cliente text not null references cliente(rut_cliente),
	precio integer not null
);


-- Insertar datos en la tabla cliente
insert into cliente (rut_cliente, nombre_cliente, direccion, correo, telefono)VALUES
('12345678-9', 'Juan Pérez', 'Calle 123', 'juan@ucn.com', '+56912345678'),
('98765432-1', 'María Gómez', 'Avenida Principal', 'maria@ucn.com', '+56987654321'),
('55555555-5', 'Pedro Rodríguez', 'Avenida Central', 'pedro@ucn.com', '+56955555555'),
('11111111-1', 'Ana Martínez', 'Calle Secundaria', 'ana@ucn.com', '+56911111111'),
('99999999-9', 'Laura López', 'Calle Principal', 'laura@ucn.com', '+56999999999');

-- Insertar datos en la tabla espacio
insert into espacio (tipo_espacio, capacidad_max, ubicacion, servicios_disponibles, tarifas, calificacion)VALUES
('Salón de conferencias', 100, 'Piso 1', 'Proyector, equipo de sonido, catering', '1000',5),
('Área al aire libre', 200, 'Jardín', 'Catering, mobiliario', '1500',3),
('Sala de reuniones', 20, 'Piso 2', 'Proyector, pizarra, coffee break', '500',4),
('Salón de eventos', 150, 'Piso 3', 'Proyector, equipo de sonido, catering', '2000',2.5),
('Sala de exposiciones', 50, 'Piso 4', 'Mobiliario, iluminación', '800',4);

-- Insertar datos en la tabla reserva
insert into reserva (id_reserva, tipo_espacio, servicios_adicionales, cantidad_asistentes, hora, fecha_reserva)VALUES
(1, 'Salón de conferencias', 'Proyector, equipo de sonido', 80, '09:00', '2024-04-20'),
(2, 'Área al aire libre', 'Catering', 150, '14:00', '2024-04-15'),
(3, 'Sala de reuniones', 'Proyector, coffee break', 15, '11:00', '2024-05-01'),
(4, 'Sala de reuniones', 'coffee break', 25, '10:30', '2024-05-05'),
(5, 'Salón de eventos', 'Equipo de sonido, catering', 120, '10:30', '2024-06-05'),
(6, 'Sala de exposiciones', 'Mobiliario', 30, '15:30', '2024-07-20');

-- Insertar datos en la tabla contrato
insert into contrato (id_reserva, rut_cliente, precio)VALUES
(1, '12345678-9', 1200),
(2, '98765432-1', 1800),
(3, '55555555-5', 700),
(4, '11111111-1', 2500),
(5, '12345678-9', 3200),
(6, '99999999-9', 1000);


/*---------------CONSULTAS---------------*/
--1
select e.tipo_espacio, e.capacidad_max, e.ubicacion, e.servicios_disponibles, e.tarifas
from espacio as e
inner join reserva as r on e.tipo_espacio = r.tipo_espacio
where r.fecha_reserva != '2024-06-10'
order by e.capacidad_max asc

--2
select r.tipo_espacio, r.hora, r.fecha_reserva
from reserva as r
where r.tipo_espacio = 'Área al aire libre' --tipo de espacio
and (r.fecha_reserva >='2024-05-10' or r.fecha_reserva <='2024-07-15')--rango de fechas

--3
select *
from espacio as e
where e.servicios_disponibles like '%atering%'
or e.servicios_disponibles like '%quipo de sonido%'

--4
select sum(c.precio) as total_ingreso, TO_CHAR(TO_DATE(r.fecha_reserva,'YYYY-MM-DD'), 'Month') as Mes
from contrato as c
inner join reserva as r on c.id_reserva = r.id_reserva
where extract(Month from TO_DATE(r.fecha_reserva, 'YYYY-MM-DD'))= 4 --SELECCIONAR MES
and extract(Year from TO_DATE(r.fecha_reserva, 'YYYY-MM-DD'))= 2024 --SELECCIONAR AÑO
group by TO_CHAR(TO_DATE(r.fecha_reserva, 'YYYY-MM-DD'), 'Month')


--5
select c.rut_cliente,client.nombre_cliente, r.tipo_espacio ,r.fecha_reserva
from contrato as c
inner join reserva as r on c.id_reserva= r.id_reserva
inner join cliente as client on c.rut_cliente=client.rut_cliente
where c.rut_cliente like '12345678-9' --RUT ESPECIFICO DEL CLIENTE DESEADO

--6
select *
from reserva as r
where r.fecha_reserva >= '2024-04-29'
and r.fecha_reserva <= '2024-05-05'

--7
select tipo_espacio, count(*) as num_reservas --COUNT actua como un contador
from reserva
where fecha_reserva > '2023-12-31'
group by tipo_espacio
order by num_reservas desc

--8
select e.tipo_espacio,
case
	when r.id_reserva is not null --si el valor NO es NULL
	then 'No disponible' --significa que NO esta disponible
	else 'Disponible'    --si es null, significa que esta disponible
end as disponibilidad
from espacio as e
left join reserva as r on e.tipo_espacio= r.tipo_espacio
and r.fecha_reserva= '2024-05-05' --fecha especifica

--9
select e.tipo_espacio, e.ubicacion, e.calificacion
from espacio as e
order by 3 desc

--10
select lower(servicio) as servicio, count(*) as total
from(--los servicios estan escritos en una cadena de texto
	select unnest(string_to_array(servicios_adicionales,', ')) as servicio --separamos la cadena por la ,
	from reserva 
) as servicios
group by lower(servicio)--agrupamos teniendo en cuenta que todo lo dejamos en minusculas
order by total desc



