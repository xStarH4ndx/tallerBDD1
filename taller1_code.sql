/*
------TALLER 1 BDD-----
Integrantes:
	- Nicolas
	- Bruno Toro
*/


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
	tarifas text not null
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
	fecha_contrato text not null,
	precio integer not null
);


-- Insertar datos en la tabla cliente
INSERT INTO cliente (rut_cliente, nombre_cliente, direccion, correo, telefono)VALUES
('12345678-9', 'Juan Pérez', 'Calle 123', 'juan@example.com', '+56912345678'),
('98765432-1', 'María Gómez', 'Avenida Principal', 'maria@example.com', '+56987654321'),
('55555555-5', 'Pedro Rodríguez', 'Avenida Central', 'pedro@example.com', '+56955555555'),
('11111111-1', 'Ana Martínez', 'Calle Secundaria', 'ana@example.com', '+56911111111'),
('99999999-9', 'Laura López', 'Calle Principal', 'laura@example.com', '+56999999999');

-- Insertar datos en la tabla espacio
INSERT INTO espacio (tipo_espacio, capacidad_max, ubicacion, servicios_disponibles, tarifas)VALUES
('Salón de conferencias', 100, 'Piso 1', 'Proyector, equipo de sonido, catering', '1000'),
('Área al aire libre', 200, 'Jardín', 'Catering, mobiliario', '1500'),
('Sala de reuniones', 20, 'Piso 2', 'Proyector, pizarra, coffee break', '500'),
('Salón de eventos', 150, 'Piso 3', 'Proyector, equipo de sonido, catering', '2000'),
('Sala de exposiciones', 50, 'Piso 4', 'Mobiliario, iluminación', '800');

-- Insertar datos en la tabla reserva
INSERT INTO reserva (id_reserva, tipo_espacio, servicios_adicionales, cantidad_asistentes, hora, fecha_reserva)VALUES
(1, 'Salón de conferencias', 'Proyector, equipo de sonido', 80, '09:00', '2024-04-20'),
(2, 'Área al aire libre', 'Catering', 150, '14:00', '2024-05-15'),
(3, 'Sala de reuniones', 'Proyector, coffee break', 15, '11:00', '2024-06-10'),
(4, 'Salón de eventos', 'Equipo de sonido, catering', 120, '10:30', '2024-07-05'),
(5, 'Sala de exposiciones', 'Mobiliario', 30, '15:30', '2024-08-20');

-- Insertar datos en la tabla contrato
INSERT INTO contrato (id_reserva, rut_cliente, fecha_contrato, precio)VALUES
(1, '12345678-9', '2024-04-19', 1200),
(2, '98765432-1', '2024-04-20', 1800),
(3, '55555555-5', '2024-04-21', 700),
(4, '11111111-1', '2024-04-22', 2500),
(5, '99999999-9', '2024-04-23', 1000);



