-- Tabla Departamento
CREATE TABLE Departamento (
    id_departamento INT PRIMARY KEY,
    nombre_departamento VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Tabla Empleado
CREATE TABLE Empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido_p VARCHAR(50) NOT NULL,
    apellido_m VARCHAR(50),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

-- Tabla Tipo_Usuario
CREATE TABLE Tipo_Usuario (
    id_tipo_usuario INT PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_tipo_usuario INT NOT NULL,
    nickname VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
    FOREIGN KEY (id_tipo_usuario) REFERENCES Tipo_Usuario(id_tipo_usuario)
);




-- Tabla Equipo
CREATE TABLE Equipo (
    id_equipo INT PRIMARY KEY,
    caracteristica TEXT NOT NULL,
    fecha_ult_mantenimiento DATE,
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

-- Tabla Tipo_Incidencia
CREATE TABLE Tipo_Incidencia (
    id_tipo_incidencia INT PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla Ticket
CREATE TABLE Ticket (
    id_ticket INT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_equipo INT NOT NULL,
    id_tipo_incidencia INT NOT NULL,
    fecha_creacion DATE DEFAULT CURRENT_DATE,
    descripcion TEXT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo),
    FOREIGN KEY (id_tipo_incidencia) REFERENCES Tipo_Incidencia(id_tipo_incidencia)
);

-- Tabla Estado
CREATE TABLE Estado (
    id_estado INT PRIMARY KEY,
    nombre_estado VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla Estado_Ticket
CREATE TABLE Estado_Ticket (
    id_estado_ticket INT PRIMARY KEY,
    id_ticket INT NOT NULL,
    id_estado INT NOT NULL,
    fecha_cambio DATE DEFAULT CURRENT_DATE,
    comentario TEXT,
    FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket),
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado)
);

-- Tabla Técnico
CREATE TABLE Tecnico (
    id_tecnico INT PRIMARY KEY,
    id_empleado INT NOT NULL,
    especialidad VARCHAR(50),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- Tabla Mantenimiento
CREATE TABLE Mantenimiento (
    id_mantenimiento INT PRIMARY KEY,
    id_equipo INT NOT NULL,
    id_tecnico INT NOT NULL,
    fecha_mantenimiento DATE DEFAULT CURRENT_DATE,
    descripcion TEXT,
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo),
    FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_tecnico)
);
