
-- Eliminar las tablas si existen para evitar conflictos de datos previos
DROP TABLE IF EXISTS Estado_Ticket CASCADE;
DROP TABLE IF EXISTS Estado CASCADE;
DROP TABLE IF EXISTS Ticket CASCADE;
DROP TABLE IF EXISTS Tipo_Incidencia CASCADE;
DROP TABLE IF EXISTS Usuario CASCADE;
DROP TABLE IF EXISTS Tipo_Usuario CASCADE;
DROP TABLE IF EXISTS Tecnico CASCADE;
DROP TABLE IF EXISTS Mantenimiento CASCADE;
DROP TABLE IF EXISTS Equipo CASCADE;
DROP TABLE IF EXISTS Empleado CASCADE;
DROP TABLE IF EXISTS Departamento CASCADE;

-- Tabla Departamento
CREATE TABLE IF NOT EXISTS Departamento (
    id_departamento SERIAL PRIMARY KEY, -- Identificador autoincremental
    nombre_departamento VARCHAR(100) NOT NULL, -- Nombre del departamento
    descripcion TEXT -- Descripción opcional del departamento
);

-- Tabla Empleado
CREATE TABLE IF NOT EXISTS Empleado (
    id_empleado SERIAL PRIMARY KEY, -- Identificador autoincremental
    nombre VARCHAR(50) NOT NULL, -- Nombre del empleado
    apellido_p VARCHAR(50) NOT NULL, -- Primer apellido
    apellido_m VARCHAR(50), -- Segundo apellido
    id_departamento INT, -- Relación con la tabla Departamento
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento) -- Clave foránea
);

-- Tabla Tipo_Usuario
CREATE TABLE IF NOT EXISTS Tipo_Usuario (
    id_tipo_usuario SERIAL PRIMARY KEY, -- Identificador autoincremental
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE -- Tipo de usuario único
);

-- Tabla Usuario
CREATE TABLE IF NOT EXISTS Usuario (
    id_usuario SERIAL PRIMARY KEY, -- Identificador autoincremental
    id_empleado INT NOT NULL, -- Relación con Empleado
    id_tipo_usuario INT NOT NULL, -- Relación con Tipo_Usuario
    nickname VARCHAR(50) UNIQUE NOT NULL, -- Nombre de usuario único
    password VARCHAR(100) NOT NULL, -- Contraseña
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado), -- Clave foránea
    FOREIGN KEY (id_tipo_usuario) REFERENCES Tipo_Usuario(id_tipo_usuario) -- Clave foránea
);

-- Tabla Equipo
CREATE TABLE IF NOT EXISTS Equipo (
    id_equipo SERIAL PRIMARY KEY, -- Identificador autoincremental
    caracteristica TEXT NOT NULL, -- Características del equipo
    fecha_ult_mantenimiento DATE, -- Última fecha de mantenimiento
    id_departamento INT, -- Relación con Departamento
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento) -- Clave foránea
);

-- Tabla Tipo_Incidencia
CREATE TABLE IF NOT EXISTS Tipo_Incidencia (
    id_tipo_incidencia SERIAL PRIMARY KEY, -- Identificador autoincremental
    nombre_tipo VARCHAR(50) NOT NULL, -- Nombre del tipo de incidencia
    descripcion TEXT -- Descripción opcional
);

-- Tabla Ticket
CREATE TABLE IF NOT EXISTS Ticket (
    id_ticket SERIAL PRIMARY KEY, -- Identificador autoincremental
    id_usuario INT NOT NULL, -- Relación con Usuario
    id_equipo INT NOT NULL, -- Relación con Equipo
    id_tipo_incidencia INT NOT NULL, -- Relación con Tipo_Incidencia
    fecha_creacion DATE DEFAULT CURRENT_DATE, -- Fecha de creación automática
    descripcion TEXT NOT NULL, -- Descripción de la incidencia
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario), -- Clave foránea
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo), -- Clave foránea
    FOREIGN KEY (id_tipo_incidencia) REFERENCES Tipo_Incidencia(id_tipo_incidencia) -- Clave foránea
);

-- Tabla Estado
CREATE TABLE IF NOT EXISTS Estado (
    id_estado SERIAL PRIMARY KEY, -- Identificador autoincremental
    nombre_estado VARCHAR(50) NOT NULL, -- Nombre del estado
    descripcion TEXT -- Descripción opcional
);

-- Tabla Estado_Ticket
CREATE TABLE IF NOT EXISTS Estado_Ticket (
    id_estado_ticket SERIAL PRIMARY KEY, -- Identificador autoincremental
    id_ticket INT NOT NULL, -- Relación con Ticket
    id_estado INT NOT NULL, -- Relación con Estado
    fecha_cambio DATE DEFAULT CURRENT_DATE, -- Fecha del cambio automática
    comentario TEXT, -- Comentario opcional
    FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket), -- Clave foránea
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado) -- Clave foránea
);

-- Tabla Técnico
CREATE TABLE IF NOT EXISTS Tecnico (
    id_tecnico SERIAL PRIMARY KEY, -- Identificador autoincremental
    id_empleado INT NOT NULL, -- Relación con Empleado
    especialidad VARCHAR(50), -- Especialidad del técnico
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado) -- Clave foránea
);

-- Tabla Mantenimiento
CREATE TABLE IF NOT EXISTS Mantenimiento (
    id_mantenimiento SERIAL PRIMARY KEY, -- Identificador autoincremental
    id_equipo INT NOT NULL, -- Relación con Equipo
    id_tecnico INT NOT NULL, -- Relación con Técnico
    fecha_mantenimiento DATE DEFAULT CURRENT_DATE, -- Fecha del mantenimiento automática
    descripcion TEXT, -- Descripción del mantenimiento
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo), -- Clave foránea
    FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_tecnico) -- Clave foránea
);

-- Procedimiento para registrar un empleado con su departamento
CREATE OR REPLACE FUNCTION registrar_empleado(
    p_nombre VARCHAR,
    p_apellido_p VARCHAR,
    p_apellido_m VARCHAR,
    p_nombre_departamento VARCHAR
) RETURNS VOID AS $$
DECLARE
    v_id_departamento INT;
BEGIN
    -- Crear o buscar el departamento
    INSERT INTO Departamento (nombre_departamento)
    VALUES (p_nombre_departamento)
    ON CONFLICT (nombre_departamento) DO NOTHING;
    SELECT id_departamento INTO v_id_departamento
    FROM Departamento
    WHERE nombre_departamento = p_nombre_departamento;

    -- Crear el empleado
    INSERT INTO Empleado (nombre, apellido_p, apellido_m, id_departamento)
    VALUES (p_nombre, p_apellido_p, p_apellido_m, v_id_departamento);
END;
$$ LANGUAGE plpgsql;

-- Datos de prueba
INSERT INTO Departamento (nombre_departamento, descripcion) VALUES ('Recursos Humanos', 'Gestión de personal');
INSERT INTO Tipo_Usuario (nombre_tipo) VALUES ('Administrador'), ('Usuario');
INSERT INTO Empleado (nombre, apellido_p, apellido_m, id_departamento) VALUES ('Juan', 'Pérez', 'López', 1);
INSERT INTO Usuario (id_empleado, id_tipo_usuario, nickname, password) VALUES (1, 1, 'admin', '12345');
INSERT INTO Usuario (id_empleado, id_tipo_usuario, nickname, password) VALUES (null, 1, 'root', ' ');
INSERT INTO Equipo (caracteristica, fecha_ult_mantenimiento, id_departamento) VALUES ('Computadora', '2024-11-01', 1);
INSERT INTO Tipo_Incidencia (nombre_tipo, descripcion) VALUES ('Falla Técnica', 'Problemas técnicos en el equipo');
INSERT INTO Ticket (id_usuario, id_equipo, id_tipo_incidencia, descripcion) VALUES (1, 1, 1, 'No enciende la computadora');
INSERT INTO Estado (nombre_estado, descripcion) VALUES ('Abierto', 'Ticket en progreso');
INSERT INTO Estado_Ticket (id_ticket, id_estado, comentario) VALUES (1, 1, 'Revisar hardware');
INSERT INTO Tecnico (id_empleado, especialidad) VALUES (1, 'Soporte Técnico');
INSERT INTO Mantenimiento (id_equipo, id_tecnico, descripcion) VALUES (1, 1, 'Revisión de componentes internos');

-- Eliminar las tablas si existen para evitar conflictos de datos previos
DROP TABLE IF EXISTS Estado_Ticket CASCADE;
DROP TABLE IF EXISTS Estado CASCADE;
DROP TABLE IF EXISTS Ticket CASCADE;
DROP TABLE IF EXISTS Tipo_Incidencia CASCADE;
DROP TABLE IF EXISTS Usuario CASCADE;
DROP TABLE IF EXISTS Tipo_Usuario CASCADE;
DROP TABLE IF EXISTS Tecnico CASCADE;
DROP TABLE IF EXISTS Mantenimiento CASCADE;
DROP TABLE IF EXISTS Equipo CASCADE;
DROP TABLE IF EXISTS Empleado CASCADE;
DROP TABLE IF EXISTS Departamento CASCADE;

-- Tabla Departamento
CREATE TABLE IF NOT EXISTS Departamento (
    id_departamento SERIAL PRIMARY KEY, -- Identificador autoincremental
    nombre_departamento VARCHAR(100) NOT NULL, -- Nombre del departamento
    descripcion TEXT -- Descripción opcional del departamento
);


-- Tabla Empleado
CREATE TABLE IF NOT EXISTS Empleado (
    id_empleado SERIAL PRIMARY KEY, -- Identificador autoincremental
    nombre VARCHAR(50) NOT NULL, -- Nombre del empleado
    apellido_p VARCHAR(50) NOT NULL, -- Primer apellido
    apellido_m VARCHAR(50), -- Segundo apellido
    email VARCHAR(50) NOT NULL, -- CHECK (email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'), -- email con validación
    id_departamento INT, -- Relación con la tabla Departamento
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento) -- Clave foránea
);

-- Tabla Tipo_Usuario
CREATE TABLE IF NOT EXISTS Tipo_Usuario (
    id_tipo_usuario SERIAL PRIMARY KEY, -- Identificador autoincremental
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE -- Tipo de usuario único
);

-- Tabla Usuario
CREATE TABLE IF NOT EXISTS Usuario (
    id_usuario SERIAL PRIMARY KEY, -- Identificador autoincremental
    id_empleado INT NOT NULL, -- Relación con Empleado
    id_tipo_usuario INT NOT NULL, -- Relación con Tipo_Usuario
    nickname VARCHAR(50) UNIQUE NOT NULL, -- Nombre de usuario único
    password VARCHAR(100) NOT NULL, -- Contraseña
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado), -- Clave foránea
    FOREIGN KEY (id_tipo_usuario) REFERENCES Tipo_Usuario(id_tipo_usuario) -- Clave foránea
);

-- Tabla Equipo
CREATE TABLE IF NOT EXISTS Equipo (
    id_equipo SERIAL PRIMARY KEY, -- Identificador autoincremental
    caracteristica TEXT NOT NULL, -- Características del equipo
    fecha_ult_mantenimiento DATE, -- Última fecha de mantenimiento
    id_departamento INT, -- Relación con Departamento
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento) -- Clave foránea
);

-- Tabla Tipo_Incidencia
CREATE TABLE IF NOT EXISTS Tipo_Incidencia (
    id_tipo_incidencia SERIAL PRIMARY KEY, -- Identificador autoincremental
    nombre_tipo VARCHAR(50) NOT NULL, -- Nombre del tipo de incidencia
    descripcion TEXT -- Descripción opcional
);

-- Tabla Ticket
CREATE TABLE IF NOT EXISTS Ticket (
    id_ticket SERIAL PRIMARY KEY, -- Identificador autoincremental
    id_usuario INT NOT NULL, -- Relación con Usuario
    id_equipo INT NOT NULL, -- Relación con Equipo
    id_tipo_incidencia INT NOT NULL, -- Relación con Tipo_Incidencia
    fecha_creacion DATE DEFAULT CURRENT_DATE, -- Fecha de creación automática
    descripcion TEXT NOT NULL, -- Descripción de la incidencia
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario), -- Clave foránea
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo), -- Clave foránea
    FOREIGN KEY (id_tipo_incidencia) REFERENCES Tipo_Incidencia(id_tipo_incidencia) -- Clave foránea
);

-- Tabla Estado
CREATE TABLE IF NOT EXISTS Estado (
    id_estado SERIAL PRIMARY KEY, -- Identificador autoincremental
    nombre_estado VARCHAR(50) NOT NULL, -- Nombre del estado
    descripcion TEXT -- Descripción opcional
);

-- Tabla Estado_Ticket
CREATE TABLE IF NOT EXISTS Estado_Ticket (
    id_estado_ticket SERIAL PRIMARY KEY, -- Identificador autoincremental
    id_ticket INT NOT NULL, -- Relación con Ticket
    id_estado INT NOT NULL, -- Relación con Estado
    fecha_cambio DATE DEFAULT CURRENT_DATE, -- Fecha del cambio automática
    comentario TEXT, -- Comentario opcional
    FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket), -- Clave foránea
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado) -- Clave foránea
);

-- Tabla Técnico
CREATE TABLE IF NOT EXISTS Tecnico (
    id_tecnico SERIAL PRIMARY KEY, -- Identificador autoincremental
    id_empleado INT NOT NULL, -- Relación con Empleado
    especialidad VARCHAR(50), -- Especialidad del técnico
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado) -- Clave foránea
);

-- Tabla Mantenimiento
CREATE TABLE IF NOT EXISTS Mantenimiento (
    id_mantenimiento SERIAL PRIMARY KEY, -- Identificador autoincremental
    id_equipo INT NOT NULL, -- Relación con Equipo
    id_tecnico INT NOT NULL, -- Relación con Técnico
    fecha_mantenimiento DATE DEFAULT CURRENT_DATE, -- Fecha del mantenimiento automática
    descripcion TEXT, -- Descripción del mantenimiento
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo), -- Clave foránea
    FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_tecnico) -- Clave foránea
);

-- Procedimiento para registrar un empleado con su departamento
CREATE OR REPLACE FUNCTION registrar_empleado(
    p_nombre VARCHAR,
    p_apellido_p VARCHAR,
    p_apellido_m VARCHAR,
    p_nombre_departamento VARCHAR
) RETURNS VOID AS $$
DECLARE
    v_id_departamento INT;
BEGIN
    -- Crear o buscar el departamento
    INSERT INTO Departamento (nombre_departamento)
    VALUES (p_nombre_departamento)
    ON CONFLICT (nombre_departamento) DO NOTHING;
    SELECT id_departamento INTO v_id_departamento
    FROM Departamento
    WHERE nombre_departamento = p_nombre_departamento;

    -- Crear el empleado
    INSERT INTO Empleado (nombre, apellido_p, apellido_m, id_departamento)
    VALUES (p_nombre, p_apellido_p, p_apellido_m, v_id_departamento);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE registrar_empleado_usuario(
    p_nombre VARCHAR,
    p_apellido_p VARCHAR,
    p_apellido_m VARCHAR,
    p_email VARCHAR,
    p_id_departamento INT,
    p_id_tipo_usuario INT,
    p_nickname VARCHAR,
    p_password VARCHAR
) AS $$
DECLARE
    v_id_empleado INT;
BEGIN
    -- Insertar en la tabla Empleado
    INSERT INTO Empleado (nombre, apellido_p, apellido_m, email, id_departamento)
    VALUES (p_nombre, p_apellido_p, p_apellido_m, p_email, p_id_departamento)
    RETURNING id_empleado INTO v_id_empleado;

    -- Insertar en la tabla Usuario
    INSERT INTO Usuario (id_empleado, id_tipo_usuario, nickname, password)
    VALUES (v_id_empleado, p_id_tipo_usuario, p_nickname, p_password);
    
    RAISE NOTICE 'Empleado y Usuario registrados correctamente. ID del empleado: %', v_id_empleado;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Error: el email % ya está en uso.', p_email;
    WHEN others THEN
        RAISE EXCEPTION 'Error al registrar: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Datos de prueba
----------------------------------------------------------
-- Insertar datos en Departamento
INSERT INTO Departamento (nombre_departamento, descripcion) VALUES 
('Recursos Humanos', 'Gestión de personal'),
('Tecnología', 'Gestión de sistemas y redes'),
('Finanzas', 'Gestión financiera y contable'),
('Ventas', 'Atención y venta al cliente'),
('Logística', 'Gestión de transporte y almacenes'),
('Producción', 'Control de fabricación'),
('Marketing', 'Publicidad y promoción'),
('Legal', 'Asesoría jurídica'),
('Calidad', 'Aseguramiento de calidad'),
('Soporte', 'Atención al cliente'),
('Compras', 'Adquisición de bienes'),
('I+D', 'Investigación y desarrollo'),
('Diseño', 'Creación de contenido visual'),
('Operaciones', 'Gestión operativa'),
('Administración', 'Administración general'),
('Mantenimiento', 'Gestión de infraestructura'),
('Recursos TI', 'Control de hardware y software'),
('Ventas internacionales', 'Gestión de ventas globales'),
('Innovación', 'Estrategias innovadoras'),
('Dirección General', 'Gestión estratégica empresarial');

-- Insertar datos en Tipo_Usuario
INSERT INTO Tipo_Usuario (nombre_tipo) VALUES 
('Administrador'),
('Usuario'),
('Superusuario'),
('Invitado'),
('Gerente'),
('Analista'),
('Operador'),
('Desarrollador'),
('Auditor'),
('Líder de proyecto'),
('Consultor'),
('Técnico'),
('Vendedor'),
('Especialista'),
('Coordinador'),
('Asistente'),
('Director'),
('Supervisor'),
('Empleado'),
('Trainee');

-- Insertar datos en Empleado
INSERT INTO Empleado (nombre, apellido_p, apellido_m, email, id_departamento) VALUES 
('Juan', 'Pérez', 'López', 'juan.perez@example.com', 1),
('Ana', 'García', 'Hernández', 'ana.garcia@example.com', 2),
('Luis', 'Martínez', 'Gómez', 'luis.martinez@example.com', 3),
('Carmen', 'Sánchez', 'Morales', 'carmen.sanchez@example.com', 4),
('Miguel', 'Torres', 'Ruiz', 'miguel.torres@example.com', 5),
('Sofía', 'Ramírez', 'Díaz', 'sofia.ramirez@example.com', 6),
('Carlos', 'Vázquez', 'Ortega', 'carlos.vazquez@example.com', 7),
('Laura', 'Hernández', 'Cruz', 'laura.hernandez@example.com', 8),
('Diego', 'Flores', 'Fernández', 'diego.flores@example.com', 9),
('Paula', 'Jiménez', 'Mendoza', 'paula.jimenez@example.com', 10),
('Jorge', 'Romero', 'Santos', 'jorge.romero@example.com', 11),
('Valeria', 'Domínguez', 'Castro', 'valeria.dominguez@example.com', 12),
('Fernando', 'Moreno', 'Ortega', 'fernando.moreno@example.com', 13),
('María', 'Gómez', 'Silva', 'maria.gomez@example.com', 14),
('Alejandro', 'Gutiérrez', 'Ibarra', 'alejandro.gutierrez@example.com', 15),
('Isabel', 'Salas', 'Hernández', 'isabel.salas@example.com', 16),
('Roberto', 'Alonso', 'López', 'roberto.alonso@example.com', 17),
('Camila', 'Castillo', 'García', 'camila.castillo@example.com', 18),
('Pablo', 'Ríos', 'Espinosa', 'pablo.rios@example.com', 19),
('Lucía', 'Santos', 'Valdés', 'lucia.santos@example.com', 20);


-- Insertar datos en Usuario
INSERT INTO Usuario (id_empleado, id_tipo_usuario, nickname, password) VALUES 
(1, 1, 'admin1', 'pass123'),
(2, 2, 'ana_user', 'pass456'),
(3, 3, 'luis_super', 'pass789'),
(4, 4, 'carmen_inv', 'pass101'),
(5, 5, 'miguel_ger', 'pass102'),
(6, 6, 'sofia_ana', 'pass103'),
(7, 7, 'carlos_op', 'pass104'),
(8, 8, 'laura_dev', 'pass105'),
(9, 9, 'diego_aud', 'pass106'),
(10, 10, 'paula_lider', 'pass107'),
(11, 11, 'jorge_cons', 'pass108'),
(12, 12, 'valeria_tec', 'pass109'),
(13, 13, 'fernando_ven', 'pass110'),
(14, 14, 'maria_esp', 'pass111'),
(15, 15, 'alejandro_coor', 'pass112'),
(16, 16, 'isabel_asist', 'pass113'),
(17, 17, 'roberto_dir', 'pass114'),
(18, 18, 'camila_sup', 'pass115'),
(19, 19, 'pablo_emp', 'pass116'),
(20, 20, 'lucia_trai', 'pass117');

-- Insertar datos en Equipo
INSERT INTO Equipo (caracteristica, fecha_ult_mantenimiento, id_departamento) VALUES 
('Computadora A', '2024-10-01', 1),
('Computadora B', '2024-10-02', 2),
('Impresora X', '2024-10-03', 3),
('Servidor Central', '2024-10-04', 4),
('Switch de Red', '2024-10-05', 5),
('Router', '2024-10-06', 6),
('Monitor', '2024-10-07', 7),
('Teclado', '2024-10-08', 8),
('Mouse', '2024-10-09', 9),
('Tablet', '2024-10-10', 10),
('Laptop A', '2024-10-11', 11),
('Laptop B', '2024-10-12', 12),
('Escáner', '2024-10-13', 13),
('Plotter', '2024-10-14', 14),
('Cámara', '2024-10-15', 15),
('Disco Duro', '2024-10-16', 16),
('SSD', '2024-10-17', 17),
('Panel Solar', '2024-10-18', 18),
('UPS', '2024-10-19', 19),
('Proyector', '2024-10-20', 20);

-- Insertar datos en Tipo_Incidencia
INSERT INTO Tipo_Incidencia (nombre_tipo, descripcion) VALUES 
('Falla Técnica', 'Problemas técnicos en equipos'),
('Conexión', 'Problemas de red o internet'),
('Software', 'Error en programas instalados'),
('Hardware', 'Fallos en componentes físicos'),
('Mantenimiento', 'Solicitud de revisión preventiva'),
('Capacitación', 'Requerimiento de formación'),
('Soporte General', 'Ayuda general de TI'),
('Backup', 'Problemas con copias de seguridad'),
('Acceso', 'Problemas de credenciales'),
('Seguridad', 'Incidentes de seguridad');

-- Insertar datos en Ticket
INSERT INTO Ticket (id_usuario, id_equipo, id_tipo_incidencia, descripcion) VALUES 
(1, 1, 1, 'El equipo no enciende.'),
(2, 2, 2, 'Problemas de conexión a internet.'),
(3, 3, 3, 'Error al abrir software de contabilidad.'),
(4, 4, 4, 'Ruido en el disco duro.'),
(5, 5, 5, 'Solicitar mantenimiento periódico.'),
(6, 6, 6, 'Capacitación sobre uso de herramientas.'),
(7, 7, 7, 'El monitor muestra una pantalla azul.'),
(8, 8, 8, 'Fallo en las copias de seguridad diarias.'),
(9, 9, 9, 'El usuario olvidó su contraseña.'),
(10, 10, 10, 'Posible brecha de seguridad en el sistema.'),
(11, 11, 1, 'El teclado no responde.'),
(12, 12, 2, 'El switch de red está inactivo.'),
(13, 13, 3, 'No se pueden instalar actualizaciones.'),
(14, 14, 4, 'Problemas en el ventilador del servidor.'),
(15, 15, 5, 'Revisión del cableado eléctrico.'),
(16, 16, 6, 'Capacitación sobre seguridad de datos.'),
(17, 17, 7, 'Pantalla negra al iniciar la computadora.'),
(18, 18, 8, 'Error al restaurar un respaldo.'),
(19, 19, 9, 'Usuario bloqueado por intentos fallidos.'),
(20, 20, 10, 'Virus detectado en el sistema.');

-- Insertar datos en Estado
INSERT INTO Estado (nombre_estado, descripcion) VALUES 
('Abierto', 'El ticket está en progreso.'),
('Cerrado', 'El ticket ha sido resuelto.'),
('Pendiente', 'El ticket está esperando atención.'),
('En Proceso', 'El ticket está siendo atendido.'),
('Cancelado', 'El ticket ha sido cancelado.');

-- Insertar datos en Estado_Ticket
INSERT INTO Estado_Ticket (id_ticket, id_estado, comentario) VALUES 
(1, 1, 'El problema ha sido registrado y está en análisis.'),
(2, 3, 'Esperando respuesta del proveedor.'),
(3, 4, 'Se está diagnosticando el problema.'),
(4, 2, 'Problema resuelto, ticket cerrado.'),
(5, 5, 'El mantenimiento ha sido cancelado.'),
(6, 1, 'La capacitación está siendo agendada.'),
(7, 1, 'Revisando hardware del monitor.'),
(8, 3, 'Solicitando nuevos medios de almacenamiento.'),
(9, 4, 'Usuario informado sobre el proceso.'),
(10, 2, 'Incidente de seguridad resuelto.'),
(11, 1, 'Teclado revisado, esperando piezas.'),
(12, 3, 'Esperando al técnico para reparación.'),
(13, 4, 'Actualización realizada con éxito.'),
(14, 2, 'Servidor funcionando correctamente.'),
(15, 5, 'El cableado no requiere revisión.'),
(16, 1, 'Capacitación en curso.'),
(17, 1, 'Pantalla negra diagnosticada como fallo de GPU.'),
(18, 3, 'Esperando nuevos respaldos.'),
(19, 4, 'Usuario desbloqueado.'),
(20, 2, 'Virus eliminado, ticket cerrado.');

-- Insertar datos en Tecnico
INSERT INTO Tecnico (id_empleado, especialidad) VALUES 
(1, 'Soporte Técnico'),
(2, 'Redes y Telecomunicaciones'),
(3, 'Desarrollo de Software'),
(4, 'Mantenimiento de Hardware'),
(5, 'Seguridad Informática'),
(6, 'Capacitación Técnica'),
(7, 'Análisis de Sistemas'),
(8, 'Bases de Datos'),
(9, 'Infraestructura TI'),
(10, 'Auditoría de TI'),
(11, 'Administración de Servidores'),
(12, 'Virtualización'),
(13, 'Optimización de Rendimiento'),
(14, 'Soporte a Usuarios'),
(15, 'Automatización de Procesos'),
(16, 'Configuración de Equipos'),
(17, 'Gestión de Proyectos TI'),
(18, 'Despliegue de Aplicaciones'),
(19, 'Recuperación de Datos'),
(20, 'Pruebas de Seguridad');

-- Insertar datos en Mantenimiento
INSERT INTO Mantenimiento (id_equipo, id_tecnico, descripcion) VALUES 
(1, 1, 'Revisión de componentes internos.'),
(2, 2, 'Configuración de red en el equipo.'),
(3, 3, 'Actualización del software instalado.'),
(4, 4, 'Reparación de disco duro.'),
(5, 5, 'Escaneo de seguridad completo.'),
(6, 6, 'Mantenimiento preventivo del servidor.'),
(7, 7, 'Optimización del sistema operativo.'),
(8, 8, 'Limpieza y ajustes del monitor.'),
(9, 9, 'Configuración de UPS.'),
(10, 10, 'Revisión de conexiones de red.'),
(11, 11, 'Instalación de nuevos controladores.'),
(12, 12, 'Diagnóstico de problemas de alimentación.'),
(13, 13, 'Actualización de firmware del router.'),
(14, 14, 'Inspección de cables de red.'),
(15, 15, 'Revisión de ventilación del gabinete.'),
(16, 16, 'Pruebas de carga en servidores.'),
(17, 17, 'Recuperación de sistema tras un fallo.'),
(18, 18, 'Revisión de almacenamiento externo.'),
(19, 19, 'Recuperación de datos en disco dañado.'),
(20, 20, 'Pruebas de estabilidad de sistema.');


