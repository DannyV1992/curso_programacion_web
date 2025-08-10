-- --------------------------------------------------------
-- Base de datos: `refugio_mascotas`
<<<<<<< HEAD
-- Proyecto Final - Gestión de Adopción de Mascotasdonantes
-- Autoras: Kendra Gutiérrez, Daniel Vasquez & Susana Herrera
=======
-- Proyecto Final - Gestión de Adopción de Mascotas
-- Autoras: Kendra Gutiérrez,Daniel Vasquez & Susana Herrera
>>>>>>> f5dbd61761312e25bf8949df3ab01344be1cfdb7
-- --------------------------------------------------------

DROP DATABASE IF EXISTS refugio_mascotas_api;
CREATE DATABASE refugio_mascotas_api;
USE refugio_mascotas_api;

-- Tabla SUCURSALES
CREATE TABLE SUCURSALES (
    id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    capacidad INT NOT NULL,
    contacto VARCHAR(50) NOT NULL
);

-- Tabla VETERINARIOS
CREATE TABLE VETERINARIOS (
    id_veterinario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    especialidad VARCHAR(50) NOT NULL,
    contacto VARCHAR(50) NOT NULL
);

-- Nueva tabla de perfil de mascota
CREATE TABLE PERFIL_ADOPCION (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    compatible_niños BOOLEAN DEFAULT FALSE,
    compatible_mascotas BOOLEAN DEFAULT FALSE,
    estado_adopcion ENUM('Disponible', 'Reservado', 'No disponible') NOT NULL DEFAULT 'Disponible'
);

CREATE TABLE ESPECIES (
    id_especie INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE RAZAS (
    id_razas INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    id_especie INT NOT NULL,
    FOREIGN KEY (id_especie) REFERENCES ESPECIES(id_especie)
);

-- Tabla MASCOTA Modificada
CREATE TABLE MASCOTA (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    id_razas INT NOT NULL,
    genero CHAR(1) CHECK (genero IN ('M', 'H')),
    fecha_nacimiento DATE NOT NULL,
    fecha_ingreso DATE NOT NULL,
    estado_salud ENUM('Excelente', 'Bueno', 'Regular', 'Crítico') NOT NULL DEFAULT 'Bueno',
    id_sucursal INT NOT NULL,
    id_perfil INT UNIQUE,
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSALES(id_sucursal),
    FOREIGN KEY (id_perfil) REFERENCES PERFIL_ADOPCION(id_perfil),
    FOREIGN KEY (id_razas) REFERENCES RAZAS(id_razas)
);

-- Tabla HISTORIAL_MEDICO 
CREATE TABLE HISTORIAL_MEDICO (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    diagnostico TEXT NOT NULL,
    fecha_consulta DATETIME NOT NULL,
    tratamiento TEXT NOT NULL,
    id_mascota INT NOT NULL,                      -- Nueva columna para la relación
    id_veterinario INT,
    FOREIGN KEY (id_veterinario) REFERENCES VETERINARIOS(id_veterinario),
    FOREIGN KEY (id_mascota) REFERENCES MASCOTA(id_mascota)  -- Nueva FK
);

-- Tabla ADOPTANTES
CREATE TABLE ADOPTANTES (
    id_adoptante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    fecha_registro DATE NOT NULL,
    experiencia_mascotas ENUM('Ninguna', 'Poca', 'Moderada', 'Alta') NOT NULL DEFAULT 'Ninguna',
    tiene_patio BOOLEAN DEFAULT FALSE,
    telefono VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL
);

-- Nueva tabla de SOLICITUDES por la relación muchos a muchos
CREATE TABLE SOLICITUDES (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_adoptante INT NOT NULL,
    id_mascota INT NOT NULL,
    fecha_solicitud DATE NOT NULL,
    estado ENUM('Pendiente', 'Aprobada', 'Rechazada') DEFAULT 'Pendiente',
    FOREIGN KEY (id_adoptante) REFERENCES ADOPTANTES(id_adoptante),
    FOREIGN KEY (id_mascota) REFERENCES MASCOTA(id_mascota)
);

-- Tabla ADOPCIONES corregida
CREATE TABLE ADOPCIONES (
    id_adopcion INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    estado ENUM('Pendiente', 'Aprobado', 'Rechazado', 'Completado') NOT NULL,
    id_adoptante INT NOT NULL,
    FOREIGN KEY (id_adoptante) REFERENCES ADOPTANTES(id_adoptante)
);

-- Tabla intermedia para relación N:M entre adopciones y mascotas
CREATE TABLE DETALLE_ADOPCION (
    id_adopcion INT NOT NULL,
    id_mascota INT NOT NULL,
    PRIMARY KEY (id_adopcion, id_mascota),
    FOREIGN KEY (id_adopcion) REFERENCES ADOPCIONES(id_adopcion),
    FOREIGN KEY (id_mascota) REFERENCES MASCOTA(id_mascota)
);

-- Nueva Tabla donantes
-- Tabla DONANTES (Donors)
CREATE TABLE DONANTES (
    id_donante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('Persona', 'Empresa') NOT NULL,
    contacto VARCHAR(100),
    fecha_registro DATE,
    direccion VARCHAR(200),
    email VARCHAR(100),
    telefono VARCHAR(20)
);

-- Tabla DONACIONES (Donations)
CREATE TABLE DONACIONES (
    id_donacion INT AUTO_INCREMENT PRIMARY KEY,
    id_donante INT NOT NULL,
    tipo ENUM('Efectivo', 'Alimentos', 'Medicinas', 'Otros', 'Equipamiento', 'Materiales de construcción', 'Vehiculo de transporte') NOT NULL,
    monto DECIMAL(10,2) DEFAULT 0.00,
    descripcion VARCHAR(255),
    fecha DATE NOT NULL,
    id_sucursal INT NOT NULL,
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSALES(id_sucursal),
    FOREIGN KEY (id_donante) REFERENCES DONANTES(id_donante)
);

-- Tabla PERSONAL Modificada
CREATE TABLE PERSONAL (
    id_personal INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL
);

-- Nueva tabla para asignación de personal a las sucursales
CREATE TABLE ASIGNACIONES_PERSONAL (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_personal INT NOT NULL,
    id_sucursal INT NOT NULL,
    fecha_asignacion DATE NOT NULL,
    FOREIGN KEY (id_personal) REFERENCES PERSONAL(id_personal),
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSALES(id_sucursal)
);

-- Tabla INVENTARIO 
CREATE TABLE INVENTARIO (
    id_inventario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    categoria ENUM('Alimentos', 'Medicinas', 'Limpieza', 'Otros', 'Accesorios', 'Higiene', 'Equipamiento', 'Herramientas', 'Juguetes', 'Muebles') NOT NULL,
    cantidad INT NOT NULL,
    cantidad_minima INT NOT NULL,
    proveedor VARCHAR(50),
    id_sucursal INT NOT NULL,
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSALES(id_sucursal)
);

-- Tabla VOLUNTARIOS  Modificada
CREATE TABLE VOLUNTARIOS (
    id_voluntario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    horas_trabajo INT DEFAULT 0
);

-- Nueva tabla para asignacion de voluntarios a sucursales
CREATE TABLE ASIGNACIONES_VOLUNTARIO (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_sucursal INT NOT NULL,
    id_voluntario INT NOT NULL,
    fecha_asignacion DATE NOT NULL,
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSALES(id_sucursal),
    FOREIGN KEY (id_voluntario) REFERENCES VOLUNTARIOS(id_voluntario)
);

-- Nueva tabla para seguimiento de turnos en personal y voluntarios
CREATE TABLE TURNOS (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    id_voluntario INT,
    id_personal INT,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    actividad TEXT,
    FOREIGN KEY (id_voluntario) REFERENCES VOLUNTARIOS(id_voluntario),
    FOREIGN KEY (id_personal) REFERENCES PERSONAL(id_personal)
);

-- Nueva tabla para seguimientos de adopciones
CREATE TABLE SEGUIMIENTOS (
    id_seguimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_adopcion INT NOT NULL,
    fecha DATE NOT NULL,
    observaciones TEXT,
    estado ENUM('Pendiente', 'Conforme', 'Problema detectado'),
    FOREIGN KEY (id_adopcion) REFERENCES ADOPCIONES(id_adopcion)
);



 -- 1. SUCURSALES
 
INSERT INTO SUCURSALES (nombre, direccion, capacidad, contacto) VALUES
('Sucursal Central', 'Av. Principal 123, San José', 100, 'central@refugio.com'),
('Sucursal Norte', 'Calle 45, Heredia', 50, 'norte@refugio.com'),
('Sucursal Sur', 'Barrio Sur 78, Cartago', 60, 'sur@refugio.com'),
('Sucursal Este', 'Residencial Este 22, Alajuela', 40, 'este@refugio.com'),
('Sucursal Oeste', 'Pueblo Oeste 33, Puntarenas', 30, 'oeste@refugio.com'),
('Sucursal Pacifico', 'Costanera 200, Puntarenas', 45, 'pacifico@refugio.com'),
('Sucursal Caribe', 'Calle Limón 150, Limón', 55, 'caribe@refugio.com'),
('Sucursal Montaña', 'Cerro Alto 300, Cartago', 35, 'montana@refugio.com'),
('Sucursal Valle', 'Valle Central 88, Alajuela', 65, 'valle@refugio.com'),
('Sucursal Río', 'Ribera 120, Heredia', 40, 'rio@refugio.com'),
('Sucursal Bosque', 'Calle Arboleda 77, San José', 25, 'bosque@refugio.com'),
('Sucursal Sol', 'Avenida Solar 90, Guanacaste', 50, 'sol@refugio.com'),
('Sucursal Luna', 'Calle Nocturna 33, Alajuela', 30, 'luna@refugio.com'),
('Sucursal Esperanza', 'Barrio Esperanza 45, Heredia', 60, 'esperanza@refugio.com'),
('Sucursal Paraíso', 'Calle Florida 12, Cartago', 40, 'paraiso@refugio.com'),
('Sucursal Libertad', 'Avenida Libre 67, San José', 55, 'libertad@refugio.com'),
('Sucursal Paz', 'Calle Tranquila 89, Alajuela', 35, 'paz@refugio.com'),
('Sucursal Amistad', 'Barrio Unión 22, Heredia', 45, 'amistad@refugio.com'),
('Sucursal Alegría', 'Avenida Feliz 156, San José', 50, 'alegria@refugio.com'),
('Sucursal Arcoíris', 'Calle Color 78, Cartago', 30, 'arcoiris@refugio.com'),
('Sucursal Volcán', 'Faldas del Volcán 200, Alajuela', 40, 'volcan@refugio.com'),
('Sucursal Playa', 'Boulevard Marítimo 45, Puntarenas', 60, 'playa@refugio.com'),
('Sucursal Palmeras', 'Avenida Coco 89, Limón', 35, 'palmeras@refugio.com'),
('Sucursal Brisas', 'Calle Ventosa 123, Guanacaste', 25, 'brisas@refugio.com'),
('Sucursal Cascada', 'Ruta Verde 67, Heredia', 45, 'cascada@refugio.com'),
('Sucursal Jardín', 'Barrio Flores 34, San José', 50, 'jardin@refugio.com'),
('Sucursal Mirador', 'Cerro Vista 100, Cartago', 30, 'mirador@refugio.com'),
('Sucursal Aurora', 'Amanecer 55, Alajuela', 40, 'aurora@refugio.com'),
('Sucursal Atardecer', 'Ocaso 78, Puntarenas', 35, 'atardecer@refugio.com'),
('Sucursal Colina', 'Loma Alta 90, Heredia', 45, 'colina@refugio.com'),
('Sucursal Fuente', 'Plaza Agua 23, San José', 50, 'fuente@refugio.com'),
('Sucursal Puente', 'Cruce Río 45, Limón', 30, 'puente@refugio.com'),
('Sucursal Horizonte', 'Vista Lejana 89, Guanacaste', 40, 'horizonte@refugio.com'),
('Sucursal Estrella', 'Calle Cielo 12, Alajuela', 35, 'estrella@refugio.com'),
('Sucursal Nube', 'Avenida Celeste 67, Cartago', 25, 'nube@refugio.com'),
('Sucursal Río Celeste', 'Parque Nacional 100, Alajuela', 50, 'rioceleste@refugio.com'),
('Sucursal Arenal', 'Lago Arenal 200, Guanacaste', 45, 'arenal@refugio.com'),
('Sucursal Monteverde', 'Bosque Nuboso 150, Puntarenas', 40, 'monteverde@refugio.com'),
('Sucursal Tortuguero', 'Canal Principal 90, Limón', 35, 'tortuguero@refugio.com'),
('Sucursal Manuel Antonio', 'Parque Nacional 45, Puntarenas', 55, 'manuelantonio@refugio.com'),
('Sucursal Corcovado', 'Peninsula Osa 300, Puntarenas', 30, 'corcovado@refugio.com');


-- 2. VETERINARIOS 
INSERT INTO VETERINARIOS (nombre, especialidad, contacto) VALUES
('Dr. Carlos Méndez', 'Cirugía', 'carlos@vet.com'),
('Dra. Ana López', 'Dermatología', 'ana@vet.com'),
('Dr. Luis Rojas', 'Cardiología', 'luis@vet.com'),
('Dra. Sofía Ramírez', 'Oftalmología', 'sofia@vet.com'),
('Dr. Pablo Castro', 'Oncología', 'pablo@vet.com'),
('Dra. María Fernández', 'Neurología', 'maria@vet.com'),
('Dr. Jorge Navarro', 'Odontología', 'jorge@vet.com'),
('Dra. Laura Díaz', 'Fisioterapia', 'laura@vet.com'),
('Dr. Ricardo Mora', 'Radiología', 'ricardo@vet.com'),
('Dra. Patricia Solís', 'Nutrición', 'patricia@vet.com'),
('Dr. Andrés Guzmán', 'Traumatología', 'andres@vet.com'),
('Dra. Valeria Chaves', 'Endocrinología', 'valeria@vet.com'),
('Dr. Diego Herrera', 'Urología', 'diego@vet.com'),
('Dra. Carolina Vega', 'Hematología', 'carolina@vet.com'),
('Dr. Eduardo Cordero', 'Neumología', 'eduardo@vet.com'),
('Dra. Gabriela Ríos', 'Gastroenterología', 'gabriela@vet.com'),
('Dr. Sergio Peña', 'Ortopedia', 'sergio@vet.com'),
('Dra. Daniela Jiménez', 'Oncología Felina', 'daniela@vet.com'),
('Dr. Roberto Murillo', 'Cirugía Plástica Veterinaria', 'roberto@vet.com'),
('Dra. Ximena Valverde', 'Medicina de Emergencia', 'ximena@vet.com'),
('Dr. Fernando Ruiz', 'Nefrología', 'fernando@vet.com'),
('Dra. Adriana Méndez', 'Dermatología Felina', 'adriana@vet.com'),
('Dr. Arturo Campos', 'Cardiología Felina', 'arturo@vet.com'),
('Dra. Silvia Castro', 'Medicina Avícola', 'silvia@vet.com'),
('Dr. Rafael Ortega', 'Medicina de Reptiles', 'rafael@vet.com'),
('Dra. Lucía Barrantes', 'Etología Veterinaria', 'lucia@vet.com'),
('Dr. Óscar Vargas', 'Anestesiología', 'oscar@vet.com'),
('Dra. Natalia Soto', 'Medicina Acuática', 'natalia@vet.com'),
('Dr. Guillermo Pérez', 'Cirugía de Pequeños Animales', 'guillermo@vet.com'),
('Dra. Marcela Rojas', 'Geriatría Veterinaria', 'marcela@vet.com'),
('Dr. José Rodríguez', 'Medicina Equina', 'jose@vet.com'),
('Dra. Verónica Quesada', 'Nutrición Canina', 'veronica@vet.com'),
('Dr. Leonardo Sancho', 'Infectología', 'leonardo@vet.com'),
('Dra. Paula Umaña', 'Medicina de Animales Exóticos', 'paula@vet.com'),
('Dr. Mauricio Loria', 'Cirugía Oncológica', 'mauricio@vet.com'),
('Dra. Jimena Alvarado', 'Rehabilitación Canina', 'jimena@vet.com'),
('Dr. Esteban Chacón', 'Oftalmología Equina', 'esteban@vet.com'),
('Dra. Fabiola Brenes', 'Genética Veterinaria', 'fabiola@vet.com'),
('Dr. Alejandro Madrigal', 'Medicina de Fauna Silvestre', 'alejandro@vet.com'),
('Dra. Irene Cordero', 'Terapia Intensiva Veterinaria', 'irene@vet.com');

-- 3. ESPECIES
INSERT INTO ESPECIES (nombre) VALUES 
('Perro'), ('Gato'), ('Conejo'), ('Hámster'), ('Pájaro');

-- 4.DONANTES
INSERT INTO DONANTES (nombre, tipo, contacto, fecha_registro, direccion, email, telefono) VALUES
('Ana María Fernández', 'Persona', 'Contacto principal', '2023-01-01', 'San José', 'anamaria@email.com', '8888-1111'),
('Carlos Eduardo Rojas', 'Persona', 'Contacto principal', '2023-01-02', 'Alajuela', 'carlosr@email.com', '8888-2222'),
('María José Vargas', 'Persona', 'Contacto principal', '2023-01-03', 'Heredia', 'mariajv@email.com', '8888-3333'),
('Jorge Luis Solís', 'Persona', 'Contacto principal', '2023-01-04', 'Cartago', 'jorgels@email.com', '8888-4444'),
('Laura Patricia Méndez', 'Persona', 'Contacto principal', '2023-01-05', 'San José', 'laurapm@email.com', '8888-5555'),
('Diego Armando Navarro', 'Persona', 'Contacto principal', '2023-01-06', 'Puntarenas', 'diegoan@email.com', '8888-6666'),
('Sofía Elena Cordero', 'Persona', 'Contacto principal', '2023-01-07', 'Limón', 'sofiaec@email.com', '8888-7777'),
('Pablo Andrés Brenes', 'Persona', 'Contacto principal', '2023-01-08', 'San José', 'pabloab@email.com', '8888-8888'),
('Valeria Cristina Chaves', 'Persona', 'Contacto principal', '2023-01-09', 'Alajuela', 'valeriacc@email.com', '8888-9999'),
('Ricardo Antonio Mora', 'Persona', 'Contacto principal', '2023-01-10', 'Heredia', 'ricardoam@email.com', '8888-0000'),
('Supermercados Unidos', 'Empresa', 'Departamento de RSE', '2023-01-11', 'San José', 'contacto@superunidos.com', '2200-1234'),
('Farmacias La Salud', 'Empresa', 'Gerencia', '2023-01-12', 'Alajuela', 'rrhh@farmaciasalud.com', '2200-2345'),
('Veterinaria Animal Feliz', 'Empresa', 'Administración', '2023-01-13', 'Heredia', 'info@animalfeliz.com', '2200-3456'),
('Distribuidora de Alimentos S.A.', 'Empresa', 'Ventas', '2023-01-14', 'Cartago', 'ventas@distrialimentos.com', '2200-4567'),
('Constructora Habitat', 'Empresa', 'Proyectos', '2023-01-15', 'San José', 'proyectos@constructorahabitat.com', '2200-5678'),
('Tienda de Mascotas Peludos', 'Empresa', 'Administración', '2023-01-16', 'Puntarenas', 'admin@tiendapeludos.com', '2200-6789'),
('Laboratorios VetPharma', 'Empresa', 'Contacto', '2023-01-17', 'Limón', 'contacto@vetpharma.com', '2200-7890'),
('Transportes Rápidos', 'Empresa', 'Logística', '2023-01-18', 'San José', 'logistica@transportesrapidos.com', '2200-8901'),
('Clínica Veterinaria San Francisco', 'Empresa', 'Citas', '2023-01-19', 'Alajuela', 'citas@clinicasanfrancisco.com', '2200-9012'),
('Alimentos Balanceados NutriPet', 'Empresa', 'Ventas', '2023-01-20', 'Heredia', 'ventas@nutripet.com', '2200-0123'),
('Banco Nacional', 'Empresa', 'RSE', '2023-01-21', 'San José', 'responsabilidad.social@bncr.com', '800-BANCO-NAC'),
('Grupo ICE', 'Empresa', 'Comunicación', '2023-01-22', 'San José', 'comunicacion@ice.go.cr', '800-ICE-CR'),
('Florida Bebidas', 'Empresa', 'Información', '2023-01-23', 'Heredia', 'info@floridabebidas.com', '800-555-5555'),
('Automercado', 'Empresa', 'Atención al cliente', '2023-01-24', 'San José', 'atencioncliente@automercado.com', '800-123-4567'),
('Hospital Veterinario San Rafael', 'Empresa', 'Administración', '2023-01-25', 'Cartago', 'admin@hvsr.com', '2280-8080'),
('PetLove Foundation', 'Empresa', 'Donaciones', '2023-01-26', 'Internacional', 'donations@petlove.org', '+1-800-PET-LOVE'),
('World Animal Protection', 'Empresa', 'Información', '2023-01-27', 'Internacional', 'info@worldanimalprotection.org', '+44-20-7239-0500'),
('Purina Pro Plan', 'Empresa', 'Contacto', '2023-01-28', 'Internacional', 'contact@purina.com', '+1-800-778-7462'),
('Donador Anónimo 001', 'Persona', 'N/A', '2023-01-29', 'N/A', 'N/A', 'N/A'),
('Donador Anónimo 002', 'Persona', 'N/A', '2023-01-30', 'N/A', 'N/A', 'N/A'),
('Donador Corporativo Anónimo', 'Empresa', 'N/A', '2023-01-31', 'N/A', 'contacto@empresaanonima.com', 'N/A');

-- 5.PERSONAL
INSERT INTO PERSONAL (nombre, tipo, telefono, email) VALUES
-- Personal administrativo
('María Fernanda Jiménez', 'Administrativo', '2222-1111', 'maria.jimenez@refugio.com'),
('Carlos Alberto López', 'Administrativo', '2222-1112', 'carlos.lopez@refugio.com'),
('Ana Patricia Rodríguez', 'Administrativo', '2222-1113', 'ana.rodriguez@refugio.com'),

-- Coordinadores de adopciones
('Laura Sofía Vargas', 'Coordinador Adopciones', '2222-2111', 'laura.vargas@refugio.com'),
('Diego Armando Méndez', 'Coordinador Adopciones', '2222-2112', 'diego.mendez@refugio.com'),
('Valeria Cristina Solís', 'Coordinador Adopciones', '2222-2113', 'valeria.solis@refugio.com'),

-- Cuidadores de animales
('Juan Carlos Rojas', 'Cuidador Animales', '2222-3111', 'juan.rojas@refugio.com'),
('María José Brenes', 'Cuidador Animales', '2222-3112', 'maria.brenes@refugio.com'),
('Pedro Pablo Cordero', 'Cuidador Animales', '2222-3113', 'pedro.cordero@refugio.com'),
('Sofía Elena Chaves', 'Cuidador Animales', '2222-3114', 'sofia.chaves@refugio.com'),

-- Veterinarios de planta (no confundir con los de la tabla VETERINARIOS)
('Dra. Gabriela Mora', 'Veterinario', '2222-4111', 'gabriela.mora@refugio.com'),
('Dr. Roberto Navarro', 'Veterinario', '2222-4112', 'roberto.navarro@refugio.com'),

-- Personal de limpieza y mantenimiento
('José Luis Herrera', 'Mantenimiento', '2222-5111', 'jose.herrera@refugio.com'),
('Carmen Elena Castro', 'Limpieza', '2222-5112', 'carmen.castro@refugio.com'),
('Mario Antonio Díaz', 'Mantenimiento', '2222-5113', 'mario.diaz@refugio.com'),

-- Recepcionistas
('Luisa Fernanda Morales', 'Recepcionista', '2222-6111', 'luisa.morales@refugio.com'),
('Andrés Felipe González', 'Recepcionista', '2222-6112', 'andres.gonzalez@refugio.com'),

-- Educadores caninos
('Elena Beatriz Ramírez', 'Educador Canino', '2222-7111', 'elena.ramirez@refugio.com'),
('Ricardo Alfonso Soto', 'Educador Canino', '2222-7112', 'ricardo.soto@refugio.com'),

-- Personal de transporte
('Fernando José Cruz', 'Transportista', '2222-8111', 'fernando.cruz@refugio.com'),
('Daniela Patricia Umaña', 'Transportista', '2222-8112', 'daniela.umana@refugio.com'),

-- Personal de marketing y comunicación
('Ximena Valentina Valverde', 'Marketing', '2222-9111', 'ximena.valverde@refugio.com'),
('Alejandro Arturo Campos', 'Comunicación', '2222-9112', 'alejandro.campos@refugio.com'),

-- Responsables de voluntariado
('Silvia Patricia Fernández', 'Coordinador Voluntarios', '2222-0111', 'silvia.fernandez@refugio.com'),
('Leonardo Andrés Sancho', 'Coordinador Voluntarios', '2222-0112', 'leonardo.sancho@refugio.com'),

-- Personal de recaudación de fondos
('Patricia María Solís', 'Recaudación Fondos', '2222-1211', 'patricia.solis@refugio.com'),
('Mauricio Antonio Loria', 'Recaudación Fondos', '2222-1212', 'mauricio.loria@refugio.com'),

-- Fotógrafos de mascotas
('Fabiola Eugenia Brenes', 'Fotógrafo', '2222-1311', 'fabiola.brenes@refugio.com'),
('Natalia Alejandra Soto', 'Fotógrafo', '2222-1312', 'natalia.soto@refugio.com'),

-- Personal de eventos
('Guillermo José Pérez', 'Coordinador Eventos', '2222-1411', 'guillermo.perez@refugio.com'),
('Marcela Adriana Rojas', 'Coordinador Eventos', '2222-1412', 'marcela.rojas@refugio.com'),

-- Personal de almacén
('Rafael Ángel Ortega', 'Almacén', '2222-1511', 'rafael.ortega@refugio.com'),
('Lucía María Barrantes', 'Almacén', '2222-1512', 'lucia.barrantes@refugio.com'),

-- Personal de recursos humanos
('José Manuel Rodríguez', 'Recursos Humanos', '2222-1611', 'jose.rodriguez@refugio.com'),
('Jimena Carolina Alvarado', 'Recursos Humanos', '2222-1612', 'jimena.alvarado@refugio.com'),

-- Personal de tecnología
('Esteban Alonso Chacón', 'Soporte Técnico', '2222-1711', 'esteban.chacon@refugio.com'),
('Irene Marcela Cordero', 'Sistemas', '2222-1712', 'irene.cordero@refugio.com');

-- 6.VOLUNTARIOS
INSERT INTO VOLUNTARIOS (nombre, email, telefono, horas_trabajo) VALUES
-- Voluntarios regulares (horas variables)
('María Fernanda González', 'maria.gonzalez@email.com', '8888-1001', 12),
('Carlos Andrés Martínez', 'carlos.martinez@email.com', '8888-1002', 8),
('Ana Lucía Ramírez', 'ana.ramirez@email.com', '8888-1003', 15),
('Jorge Luis Herrera', 'jorge.herrera@email.com', '8888-1004', 10),
('Laura Patricia Sánchez', 'laura.sanchez@email.com', '8888-1005', 20),
('Diego Armando Rojas', 'diego.rojas@email.com', '8888-1006', 5),
('Sofía Elena Vargas', 'sofia.vargas@email.com', '8888-1007', 18),
('Pablo Enrique Brenes', 'pablo.brenes@email.com', '8888-1008', 7),
('Valeria Cristina Mora', 'valeria.mora@email.com', '8888-1009', 14),
('Ricardo Antonio Chaves', 'ricardo.chaves@email.com', '8888-1010', 9),

-- Voluntarios con muchas horas (comprometidos)
('Gabriela María Soto', 'gabriela.soto@email.com', '8888-2011', 30),
('Fernando José Cruz', 'fernando.cruz@email.com', '8888-2012', 25),
('Adriana Patricia Umaña', 'adriana.umana@email.com', '8888-2013', 35),
('Óscar Alonso Cordero', 'oscar.cordero@email.com', '8888-2014', 28),
('Lucía Fernanda Barrantes', 'lucia.barrantes@email.com', '8888-2015', 32),

-- Voluntarios ocasionales (pocas horas)
('Raúl Antonio Jiménez', 'raul.jimenez@email.com', '8888-3016', 3),
('Daniela Sofía Guzmán', 'daniela.guzman@email.com', '8888-3017', 4),
('Andrés Felipe Vega', 'andres.vega@email.com', '8888-3018', 2),
('Carolina Eugenia Castro', 'carolina.castro@email.com', '8888-3019', 3),
('Roberto Carlos Navarro', 'roberto.navarro@email.com', '8888-3020', 5),

-- Voluntarios especializados
('Ximena Valentina Valverde', 'ximena.valverde@email.com', '8888-4021', 15), -- Veterinaria en formación
('Arturo José Campos', 'arturo.campos@email.com', '8888-4022', 12), -- Adiestrador canino
('Silvia Patricia Fernández', 'silvia.fernandez@email.com', '8888-4023', 10), -- Experta en gatos
('Leonardo Andrés Sancho', 'leonardo.sancho@email.com', '8888-4024', 18), -- Fotógrafo de mascotas
('Patricia María Solís', 'patricia.solis@email.com', '8888-4025', 20), -- Organizadora de eventos

-- Voluntarios jóvenes (estudiantes)
('Mauricio Antonio Loria', 'mauricio.loria@email.com', '8888-5026', 8),
('Fabiola Eugenia Brenes', 'fabiola.brenes@email.com', '8888-5027', 6),
('Alejandro José Madrigal', 'alejandro.madrigal@email.com', '8888-5028', 7),
('Irene Marcela Cordero', 'irene.cordero@email.com', '8888-5029', 5),
('Esteban Alonso Chacón', 'esteban.chacon@email.com', '8888-5030', 9),

-- Voluntarios mayores (jubilados)
('José Manuel Rodríguez', 'jose.rodriguez@email.com', '8888-6031', 15),
('Jimena Carolina Alvarado', 'jimena.alvarado@email.com', '8888-6032', 12),
('Guillermo Antonio Pérez', 'guillermo.perez@email.com', '8888-6033', 10),
('Marcela Adriana Rojas', 'marcela.rojas@email.com', '8888-6034', 8),
('Rafael Ángel Ortega', 'rafael.ortega@email.com', '8888-6035', 12),

-- Voluntarios corporativos (programa de RSE)
('Natalia Alejandra Soto', 'natalia.soto@empresa.com', '8888-7036', 4),
('Lucía María Barrantes', 'lucia.barrantes@empresa.com', '8888-7037', 4),
('José Miguel Rodríguez', 'jose.rodriguez@empresa.com', '8888-7038', 4),
('María Elena Quesada', 'maria.quesada@empresa.com', '8888-7039', 4),
('Alberto Francisco Mora', 'alberto.mora@empresa.com', '8888-7040', 4);

-- 7. RAZAS
INSERT INTO RAZAS (nombre, id_especie) VALUES
('Persa', 2), ('Bulldog', 1), ('Bengalí', 2), ('Pastor Alemán', 1), 
('Angora', 2), ('Beagle', 1), ('Maine Coon', 2), ('Chihuahua', 1),
('Ragdoll', 2), ('Poodle', 1), ('Boxer', 1), ('Esfinge', 2),
('Dálmata', 1), ('Siberiano', 2), ('Rottweiler', 1), ('Scottish Fold', 2),
('Husky', 1), ('British Shorthair', 2), ('Gran Danés', 1), ('Abisinio', 2),
('San Bernardo', 1), ('Burmés', 2), ('Pug', 1), ('Cornish Rex', 2),
('Doberman', 1), ('Sphynx', 2), ('Bull Terrier', 1), ('Cocker Spaniel', 1),
('Birmano', 2), ('Schnauzer', 1), ('Manx', 2), ('Pastor Belga', 1),
('Tonkinés', 2), ('Shar Pei', 1), ('Oriental', 2), ('Akita', 1),
('Labrador Retriever', 1), ('Golden Retriever', 1), ('Bulldog Francés', 1),
('Pastor Australiano', 1), ('Border Collie', 1), ('Pomerania', 1),
('Bichón Frisé', 1), ('Shih Tzu', 1), ('Maltés', 1), ('Galgo', 1),
('Pitbull', 1), ('Mestizo', 1), ('Sabueso', 1), ('Terrier', 1),
('Caniche', 1), ('Dogo Argentino', 1), ('Carlino', 1), ('Bóxer', 1),
('Siamés', 2), ('Azul Ruso', 2), ('Bombay', 2), ('Chartreux', 2),
('Devon Rex', 2), ('Exótico', 2), ('Himalayo', 2), ('Korat', 2),
('Munchkin', 2), ('Nebelung', 2), ('Ocicat', 2), ('Peterbald', 2),
('Ragamuffin', 2), ('Selkirk Rex', 2), ('Van Turco', 2), ('Mestizo', 2),
('Holandés Enano', 3), ('Cabeza de León', 3), ('Rex', 3), ('Angora', 3),
('Belier', 3), ('Californiano', 3), ('Gigante de Flandes', 3), ('Mini Lop', 3),
('Mini Rex', 3), ('Tan', 3), ('Mestizo', 3),
('Sirio', 4), ('Ruso', 4), ('Roborovski', 4), ('Chino', 4),
('Campbell', 4), ('Mestizo', 4),
('Canario', 5), ('Periquito', 5), ('Cacatúa', 5), ('Loro', 5),
('Agapornis', 5), ('Diamante Mandarín', 5), ('Jilguero', 5), ('Ninfa', 5),
('Cotorra', 5), ('Mestizo', 5);

-- 8.PERFIL ADOPCION
INSERT INTO PERFIL_ADOPCION (compatible_niños, compatible_mascotas, estado_adopcion) VALUES
(TRUE, TRUE, 'Disponible'),   -- Perro familiar (1)
(TRUE, FALSE, 'Disponible'),  -- Perro que no lleva bien otras mascotas (2)
(FALSE, TRUE, 'Disponible'),  -- Perro para adultos sin niños (3)
(FALSE, FALSE, 'Disponible'), -- Perro que necesita hogar sin niños ni otras mascotas (4)
(TRUE, TRUE, 'Reservado'),    -- Perro familiar reservado (5)
(TRUE, FALSE, 'No disponible'), -- Perro en tratamiento médico (6)
(TRUE, TRUE, 'Disponible'),   -- Gato sociable (7)
(TRUE, FALSE, 'Disponible'),  -- Gato que no lleva bien otras mascotas (8)
(FALSE, TRUE, 'Disponible'),  -- Gato para adultos sin niños (9)
(FALSE, FALSE, 'Disponible'), -- Gato que necesita hogar sin niños ni otras mascotas (10)
(TRUE, TRUE, 'Reservado'),    -- Gato reservado (11)
(FALSE, TRUE, 'No disponible'), -- Gato en rehabilitación (12)
(TRUE, TRUE, 'Disponible'),   -- Conejo familiar (13)
(FALSE, TRUE, 'Disponible'),  -- Conejo para adultos (14)
(TRUE, FALSE, 'Disponible'),  -- Conejo que no lleva bien otras mascotas (15)
(FALSE, FALSE, 'Disponible'), -- Hámster para adultos (16)
(TRUE, FALSE, 'Disponible'),  -- Hámster para niños (17)
(TRUE, TRUE, 'Disponible'),   -- Pájaro sociable (18)
(FALSE, TRUE, 'Disponible'),  -- Pájaro para adultos (19)
(TRUE, FALSE, 'Reservado'),   -- Pájaro reservado (20)
(TRUE, TRUE, 'No disponible'), -- Animal en cuarentena (21)
(FALSE, FALSE, 'No disponible'), -- Animal con necesidades especiales (22)
(TRUE, TRUE, 'Disponible'),   -- Animal rehabilitado (23)
(FALSE, TRUE, 'Disponible'),  -- Animal senior (24)
(TRUE, FALSE, 'Disponible'),   -- Animal con discapacidad (25)
(TRUE, TRUE, 'Disponible'),   -- Perfil 26
(TRUE, FALSE, 'Disponible');  -- Perfil 27;

-- 9.ADOPTANTES
INSERT INTO ADOPTANTES (nombre, direccion, fecha_registro, experiencia_mascotas, tiene_patio, telefono, email) VALUES
('Juan Pérez Mora', 'Calle 1, San José, Costa Rica', '2024-01-05', 'Moderada', TRUE, '+506 8888-8888', 'juan.perez@email.com'),
('María Rodríguez Solís', 'Avenida 2, Heredia, Costa Rica', '2024-01-10', 'Alta', TRUE, '+506 8888-7777', 'maria.rodriguez@email.com'),
('Carlos Sánchez Vargas', 'Barrio 3, Cartago, Costa Rica', '2024-02-15', 'Poca', FALSE, '+506 8888-6666', 'carlos.sanchez@email.com'),
('Laura Gómez Fernández', 'Residencial 4, Alajuela, Costa Rica', '2024-02-20', 'Ninguna', TRUE, '+506 8888-5555', 'laura.gomez@email.com'),
('Pedro Díaz Castro', 'Pueblo 5, Puntarenas, Costa Rica', '2024-03-01', 'Moderada', TRUE, '+506 8888-4444', 'pedro.diaz@email.com'),
('Ana Martínez Jiménez', 'Calle 6, Limón, Costa Rica', '2024-03-10', 'Alta', FALSE, '+506 8888-3333', 'ana.martinez@email.com'),
('Luis González Herrera', 'Avenida 7, Guanacaste, Costa Rica', '2024-04-05', 'Poca', TRUE, '+506 8888-2222', 'luis.gonzalez@email.com'),
('Sofía Ramírez Chaves', 'Barrio 8, San José, Costa Rica', '2024-04-15', 'Ninguna', FALSE, '+506 8888-1111', 'sofia.ramirez@email.com'),
('Jorge Herrera Rojas', 'Residencial 9, Heredia, Costa Rica', '2024-05-01', 'Moderada', TRUE, '+506 8888-0000', 'jorge.herrera@email.com'),
('Carmen Vargas Méndez', 'Pueblo 10, Cartago, Costa Rica', '2024-05-10', 'Alta', TRUE, '+506 8777-7777', 'carmen.vargas@email.com'),
('Diego Rojas Cordero', 'Callejón 654, Heredia, Costa Rica', '2024-05-15', 'Moderada', TRUE, '+506 8888-9999', 'diego.rojas@email.com'),
('Valeria Méndez Brenes', 'Avenida 987, Cartago, Costa Rica', '2024-05-20', 'Alta', FALSE, '+506 8888-0001', 'valeria.mendez@email.com'),
('Ricardo Castro Umaña', 'Barrio Oeste, Alajuela, Costa Rica', '2024-06-01', 'Poca', TRUE, '+506 8777-1111', 'ricardo.castro@email.com'),
('Gabriela Solís Guzmán', 'Residencial Este, Puntarenas, Costa Rica', '2024-06-10', 'Ninguna', TRUE, '+506 8777-2222', 'gabriela.solis@email.com'),
('Fernando Navarro Vega', 'Pueblo Norte, Limón, Costa Rica', '2024-06-15', 'Moderada', FALSE, '+506 8777-3333', 'fernando.navarro@email.com'),
('Adriana Cordero Soto', 'Colonia 135, Guanacaste, Costa Rica', '2024-07-01', 'Alta', TRUE, '+506 8777-4444', 'adriana.cordero@email.com'),
('Óscar Brenes López', 'Boulevard 246, San José, Costa Rica', '2024-07-10', 'Poca', TRUE, '+506 8777-5555', 'oscar.brenes@email.com'),
('Lucía Vargas Quesada', 'Urbanización 357, Heredia, Costa Rica', '2024-07-15', 'Ninguna', FALSE, '+506 8777-6666', 'lucia.vargas@email.com'),
('Raúl Mora Salas', 'Calle 468, Cartago, Costa Rica', '2024-08-01', 'Moderada', TRUE, '+506 8777-7778', 'raul.mora@email.com'),
('Daniela Soto Alvarado', 'Avenida 579, Alajuela, Costa Rica', '2024-08-10', 'Alta', TRUE, '+506 8777-8888', 'daniela.soto@email.com'),
('Helena Ramírez Céspedes', 'Calle 11, Heredia, Costa Rica', '2024-08-15', 'Alta', TRUE, '+506 8666-6666', 'helena.ramirez@email.com'),
('Mario Vargas Sandí', 'Barrio Nuevo 33, Cartago, Costa Rica', '2024-08-20', 'Moderada', FALSE, '+506 8666-7777', 'mario.vargas@email.com'),
('Esteban Quesada Ríos', 'Avenida Central, San José, Costa Rica', '2024-09-01', 'Poca', TRUE, '+506 8666-8888', 'esteban.quesada@email.com'),
('Julieta Fernández Madrigal', 'Urbanización Norte, Alajuela, Costa Rica', '2024-09-05', 'Alta', TRUE, '+506 8666-9999', 'julieta.fernandez@email.com'),
('Iván Céspedes Loria', 'Colonia Verde, Puntarenas, Costa Rica', '2024-09-10', 'Ninguna', FALSE, '+506 8555-0000', 'ivan.cespedes@email.com'),
('Camila Salas Brenes', 'Barrio del Sol, Limón, Costa Rica', '2024-09-12', 'Moderada', TRUE, '+506 8555-1111', 'camila.salas@email.com'),
('Andrés Mora Chacón', 'Calle 15, Guanacaste, Costa Rica', '2024-09-20', 'Alta', TRUE, '+506 8555-2222', 'andres.mora@email.com'),
('Isabel Rojas Barrantes', 'Residencial Sur, Cartago, Costa Rica', '2024-10-01', 'Poca', FALSE, '+506 8555-3333', 'isabel.rojas@email.com'),
('Tomás Herrera Valverde', 'Centro, Alajuela, Costa Rica', '2024-10-08', 'Alta', TRUE, '+506 8555-4444', 'tomas.herrera@email.com'),
('Nicole Jiménez Ortega', 'Calle 22, Heredia, Costa Rica', '2024-10-12', 'Ninguna', FALSE, '+506 8555-5555', 'nicole.jimenez@email.com'),
('Felipe Soto Pérez', 'Barrio Naranjo, San José, Costa Rica', '2024-10-20', 'Poca', TRUE, '+506 8444-6666', 'felipe.soto@email.com'),
('Daniela Araya Campos', 'Avenida Norte, Puntarenas, Costa Rica', '2024-10-22', 'Alta', TRUE, '+506 8444-7777', 'daniela.araya@email.com'),
('Julián Chaves Fuentes', 'Calle Bosque, Limón, Costa Rica', '2024-10-30', 'Moderada', FALSE, '+506 8444-8888', 'julian.chaves@email.com'),
('Karla Sandí Cordero', 'Urbanización Este, Heredia, Costa Rica', '2024-11-05', 'Alta', TRUE, '+506 8444-9999', 'karla.sandi@email.com'),
('Pablo Rivera Méndez', 'Colinas del Este, Cartago, Costa Rica', '2024-11-10', 'Moderada', TRUE, '+506 8333-0000', 'pablo.rivera@email.com'),
('Melina Gómez Rojas', 'Pueblo Norte, San José, Costa Rica', '2024-11-15', 'Poca', TRUE, '+506 8333-1111', 'melina.gomez@email.com'),
('Rodrigo Méndez Navarro', 'Calle Sur 123, Heredia, Costa Rica', '2024-11-20', 'Ninguna', FALSE, '+506 8333-2222', 'rodrigo.mendez@email.com'),
('Ángela Díaz Soto', 'Barrio Primavera, Cartago, Costa Rica', '2024-12-01', 'Alta', TRUE, '+506 8333-3333', 'angela.diaz@email.com'),
('Santiago Ramírez Vargas', 'Colonia Vista, Alajuela, Costa Rica', '2024-12-05', 'Moderada', TRUE, '+506 8333-4444', 'santiago.ramirez@email.com'),
('Jimena Vargas Alvarado', 'Calle Amanecer, Guanacaste, Costa Rica', '2024-12-10', 'Alta', TRUE, '+506 8333-5555', 'jimena.vargas@email.com');


-- 10.MASCOTA CON CORRECCIONES
-- 10.MASCOTA CON CORRECCIONES
INSERT INTO MASCOTA (nombre, id_razas, genero, fecha_nacimiento, fecha_ingreso, estado_salud, id_sucursal, id_perfil) VALUES
('Max', 1, 'M', '2020-05-15', '2023-01-10', 'Bueno', 1, 1),        -- Labrador Retriever
('Luna', 2, 'H', '2019-08-20', '2023-02-15', 'Excelente', 2, 2),    -- Golden Retriever
('Rocky', 3, 'M', '2021-03-10', '2023-03-20', 'Regular', 3, 3),     -- Bulldog Francés
('Thor', 4, 'M', '2019-04-01', '2023-04-01', 'Regular', 4, 4),      -- Pastor Alemán 
('Toby', 6, 'M', '2021-05-05', '2023-05-05', 'Bueno', 5, 5),        -- Beagle
('Bella', 10, 'H', '2020-06-20', '2023-06-20', 'Bueno', 6, 6),      -- Poodle 
('Zeus', 11, 'M', '2019-07-05', '2023-07-05', 'Regular', 7, 7),     -- Boxer
('Bruno', 13, 'M', '2020-08-01', '2023-08-01', 'Bueno', 8, 8),      -- Dálmata
('Rex', 15, 'M', '2018-09-03', '2023-09-03', 'Regular', 9, 9),      -- Rottweiler
('Jack', 17, 'M', '2021-10-05', '2023-10-05', 'Excelente', 10, 10), -- Husky
('Milo', 24, 'M', '2021-07-12', '2023-06-18', 'Bueno', 1, 11),      -- Persa
('Luna', 25, 'H', '2020-09-05', '2023-07-22', 'Excelente', 2, 12),  -- Bengalí
('Simba', 26, 'M', '2022-02-14', '2023-08-30', 'Regular', 3, 13),   -- Maine Coon
('Nala', 27, 'H', '2021-12-03', '2023-09-10', 'Bueno', 4, 14),      -- Ragdoll
('Oliver', 28, 'M', '2020-04-18', '2023-10-15', 'Excelente', 5, 15),-- Esfinge
('Molly', 16, 'H', '2022-09-18', '2023-11-18', 'Bueno', 6, 16),     -- Scottish Fold
('Chloe', 18, 'H', '2021-10-20', '2023-12-20', 'Bueno', 7, 17),     -- British Shorthair
('Misty', 20, 'H', '2022-11-25', '2024-01-25', 'Excelente', 8, 18), -- Abisinio
('Pearl', 22, 'H', '2021-12-15', '2024-02-15', 'Excelente', 9, 19), -- Burmés
('Daisy', 24, 'H', '2022-01-25', '2024-03-25', 'Bueno', 10, 20),    -- Cornish Rex
('Algodón', 61, 'M', '2022-06-20', '2023-11-20', 'Bueno', 1, 21),   -- Conejo Holandés Enano (ID corregido)
('Bugs', 62, 'M', '2021-10-15', '2023-12-05', 'Excelente', 2, 22),  -- Conejo Cabeza de León (ID corregido)
('Lola', 63, 'H', '2022-03-08', '2024-01-10', 'Regular', 3, 23),    -- Conejo Rex (ID corregido)
('Peluso', 68, 'M', '2023-01-25', '2024-02-15', 'Bueno', 4, 24),    -- Hámster Sirio (ID corregido)
('Gizmo', 69, 'M', '2023-03-12', '2024-03-01', 'Excelente', 5, 25), -- Hámster Ruso (ID corregido)
('Piolín', 74, 'M', '2021-05-30', '2024-04-05', 'Bueno', 6, 26),    -- Canario (ID corregido)
('Loro', 77, 'M', '2019-11-22', '2024-05-12', 'Regular', 7, 27);    -- Loro (ID corregido)

-- 11. INVENTARIO

INSERT INTO INVENTARIO (nombre, categoria, cantidad, cantidad_minima, proveedor, id_sucursal) VALUES
-- Sucursal 1 (Central)
('Croquetas para perro adulto', 'Alimentos', 50, 10, 'Purina', 1),
('Correas ajustables', 'Accesorios', 60, 8, 'Ruffwear', 1),
('Juguetes interactivos', 'Juguetes', 50, 12, 'KONG', 1),
('Analgésico canino', 'Medicinas', 18, 5, 'Rimadyl', 1),
('Loción limpieza oídos', 'Higiene', 40, 9, 'Virbac', 1),
('Alimento hipoalergénico', 'Alimentos', 22, 8, 'Pro Plan', 1),

-- Sucursal 2 (Norte)
('Croquetas para gato adulto', 'Alimentos', 45, 12, 'Whiskas', 2),
('Antiparasitarios', 'Medicinas', 30, 5, 'Bayer', 2),
('Champú antipulgas', 'Limpieza', 20, 7, 'Adams', 2),
('Rascador para gatos', 'Muebles', 35, 10, 'GoPetClub', 2),
('Cama térmica', 'Equipamiento', 12, 5, 'K&H', 2),
('Guante deslanador', 'Limpieza', 30, 8, 'ShedMonster', 2),

<<<<<<< HEAD
-- Sucursal 3 (Sur)
('Shampoo para mascotas', 'Limpieza', 20, 3, 'Hartz', 3),
('Cepillo para mascotas', 'Limpieza', 25, 4, 'Safari', 3),
('Collar reflectante', 'Accesorios', 40, 6, 'Blue-9', 3),
('Pañales para perros', 'Higiene', 40, 12, 'Simple Solution', 3),
('Suplemento articular', 'Medicinas', 30, 10, 'Cosequin', 3),
('Jaula para transporte', 'Equipamiento', 8, 3, 'MidWest', 3),

-- Sucursal 4 (Este)
('Juguetes para gato', 'Juguetes', 40, 8, 'PetSmart', 4),
('Arena sanitaria', 'Higiene', 30, 6, 'Fresh Step', 4),
('Alimento para cachorros', 'Alimentos', 30, 10, 'Royal Canin', 4),
('Kit primeros auxilios', 'Medicinas', 10, 5, 'RC Pet', 4),
('Pelotas de goma', 'Juguetes', 60, 15, 'Chuckit!', 4),
('Transportadora pequeña', 'Equipamiento', 10, 5, 'AmazonBasics', 4),

-- Sucursal 5 (Oeste)
('Camas para perro', 'Muebles', 15, 5, 'Petco', 5),
('Snacks para perro', 'Alimentos', 35, 10, 'Pedigree', 5),
('Cortauñas profesional', 'Herramientas', 15, 5, 'Safari', 5),
('Chaleco salvavidas', 'Accesorios', 15, 5, 'Outward Hound', 5),
('Platos antideslizantes', 'Accesorios', 45, 10, 'Neater Feeder', 5),
('Alimento senior', 'Alimentos', 28, 8, 'Hill\'s', 5),

-- Sucursal 6 (Pacífico)
('Comedero automático', 'Accesorios', 15, 5, 'PetSafe', 6),
('Fórmula para gatitos', 'Alimentos', 25, 8, 'KMR', 6),
('Vitaminas caninas', 'Medicinas', 40, 10, 'Nutri-Vet', 6),
('Pasta dental', 'Higiene', 35, 10, 'Petsmile', 6),
('Bebedero automático', 'Accesorios', 12, 5, 'Petsafe', 6),

-- Sucursal 7 (Caribe)
('Aspirador de pelo', 'Limpieza', 8, 2, 'Bissell', 7),
('Desinfectante ambiental', 'Limpieza', 25, 5, 'Nature\'s Miracle', 7),
('Difusor calmante', 'Medicinas', 20, 5, 'Feliway', 7),
('Arnés de paseo', 'Accesorios', 25, 8, 'Kurgo', 7),

-- Sucursal 8 (Montaña)
('Bozal ajustable', 'Accesorios', 30, 8, 'Baskerville', 8),
('Transportadora mediana', 'Equipamiento', 7, 3, 'AmazonBasics', 8),
('Cama ortopédica', 'Muebles', 10, 3, 'K&H', 8),
('Juguetes para perro', 'Juguetes', 55, 15, 'KONG', 8);

-- 12. ASIGNACIONES PERSONAL
INSERT INTO ASIGNACIONES_PERSONAL (id_personal, id_sucursal, fecha_asignacion) VALUES
-- Sucursal Central (1)
(1, 1, '2023-01-10'),  -- María Jiménez (Administrativo)
(2, 1, '2023-01-10'),  -- Carlos López (Coordinador)
(3, 1, '2023-01-15'),  -- Ana Rodríguez (Cuidador)
(19, 1, '2023-02-01'), -- Ximena Valverde (Marketing)

-- Sucursal Norte (2)
(4, 2, '2023-01-12'),  -- Laura Vargas (Coordinador)
(5, 2, '2023-01-12'),  -- Diego Méndez (Administrativo)
(20, 2, '2023-02-05'), -- Alejandro Campos (Comunicación)

-- Sucursal Sur (3)
(6, 3, '2023-01-18'),  -- Juan Rojas (Cuidador)
(7, 3, '2023-01-18'),  -- María Brenes (Cuidador)
(21, 3, '2023-02-10'), -- Silvia Fernández (Voluntarios)

-- Sucursal Este (4)
(8, 4, '2023-01-20'),  -- Pedro Cordero (Cuidador)
(9, 4, '2023-01-20'),  -- Sofía Chaves (Cuidador)
(22, 4, '2023-02-15'), -- Leonardo Sancho (Educador)

-- Sucursal Oeste (5)
(10, 5, '2023-01-25'), -- Gabriela Soto (Educador)
(11, 5, '2023-01-25'), -- Fernando Cruz (Transportista)
(23, 5, '2023-03-01'), -- Patricia Solís (Fondos)

-- Sucursal Pacífico (6)
(12, 6, '2023-02-05'), -- Ricardo Mora (Voluntarios)
(13, 6, '2023-02-05'), -- Valeria Chaves (Eventos)
(24, 6, '2023-03-05'), -- Mauricio Loria (Fondos)

-- Sucursal Caribe (7)
(14, 7, '2023-02-10'), -- Oscar Herrera (Cuidador)
(15, 7, '2023-02-10'), -- Lucía Barrantes (Cuidador)
(25, 7, '2023-03-10'), -- Fabiola Brenes (Fotógrafo)

-- Sucursal Montaña (8)
(16, 8, '2023-02-15'), -- Raúl Cordero (Entrenador)
(17, 8, '2023-02-15'), -- Daniela Jiménez (Recepcionista)
(26, 8, '2023-03-15'); -- Natalia Soto (Fotógrafo)

-- 13. ASIGNACIONES VOLUNTARIOS
INSERT INTO ASIGNACIONES_VOLUNTARIO (id_sucursal, id_voluntario, fecha_asignacion) VALUES
-- Sucursal Central (1) - 4 voluntarios
(1, 1, '2023-01-15'),  -- María Fernández
(1, 2, '2023-01-15'),  -- Carlos Rojas
(1, 17, '2023-02-20'), -- Daniela Jiménez
(1, 30, '2023-03-01'), -- Esteban Chacón

-- Sucursal Norte (2) - 3 voluntarios
(2, 3, '2023-01-18'),  -- Ana Vargas
(2, 4, '2023-01-18'),  -- Jorge Solís
(2, 18, '2023-02-22'), -- Andrés Guzmán

-- Sucursal Sur (3) - 3 voluntarios
(3, 5, '2023-01-20'),  -- Laura Méndez
(3, 6, '2023-01-20'),  -- Diego Navarro
(3, 19, '2023-02-25'), -- Carolina Vega

-- Sucursal Este (4) - 3 voluntarios
(4, 7, '2023-01-22'),  -- Sofía Cordero
(4, 8, '2023-01-22'),  -- Pablo Brenes
(4, 20, '2023-03-01'), -- Roberto Castro

-- Sucursal Oeste (5) - 3 voluntarios
(5, 9, '2023-01-25'),  -- Valeria Chaves
(5, 10, '2023-01-25'), -- Ricardo Mora
(5, 21, '2023-03-05'), -- Ximena Valverde

-- Sucursal Pacífico (6) - 2 voluntarios
(6, 11, '2023-02-01'), -- Gabriela Soto
(6, 12, '2023-02-01'), -- Fernando Cruz

-- Sucursal Caribe (7) - 2 voluntarios
(7, 13, '2023-02-05'), -- Adriana Umaña
(7, 14, '2023-02-05'), -- Óscar Herrera

-- Sucursal Montaña (8) - 2 voluntarios
(8, 15, '2023-02-10'), -- Lucía Barrantes
(8, 16, '2023-02-10'); -- Raúl Cordero

-- 14.HISTORIAL MEDICO
INSERT INTO HISTORIAL_MEDICO (diagnostico, fecha_consulta, tratamiento, id_veterinario, id_mascota) VALUES
('Examen físico normal', '2024-01-12 10:00:00', 'Vacuna antirrábica anual', 1, 1),
('Dermatitis alérgica', '2024-01-17 11:30:00', 'Cremas tópicas cada 12 horas', 2, 2),
('Chequeo preventivo', '2024-02-07 09:15:00', 'Ningún tratamiento requerido', 3, 3),  
('Conjuntivitis bacteriana', '2024-02-10 14:00:00', 'Gotas oftálmicas cada 8 horas', 4, 4),  
('Recuperación post-quirúrgica', '2024-02-15 16:30:00', 'Analgésicos cada 12 horas', 5, 5), 
('Control de vacunación', '2024-01-20 09:00:00', 'Vacuna polivalente', 3, 5),
('Dolor articular leve', '2024-02-05 14:30:00', 'Antiinflamatorios por 3 días', 7, 8),
('Control de peso', '2024-02-18 11:00:00', 'Plan nutricional personalizado', 10, 12),
('Limpieza dental profesional', '2024-03-10 10:15:00', 'Profilaxis dental completa', 15, 15),
('Dermatitis por contacto', '2024-03-22 16:45:00', 'Baños medicados 2 veces por semana', 18, 18),
('Otitis externa', '2024-03-18 15:20:00', 'Limpieza y gotas óticas diarias', 9, 9),  
('Sobrepeso moderado', '2024-04-02 09:30:00', 'Dieta controlada y ejercicio', 10, 10),  
('Vacunación anual', '2024-04-10 13:00:00', 'Vacuna antirrábica y polivalente', 11, 11),  
('Gastritis leve', '2024-04-15 10:15:00', 'Protectores gástricos por 5 días', 12, 12),  
('Herida superficial por trauma', '2024-04-22 17:00:00', 'Curación cada 24 horas', 13, 13),  
('Esterilización electiva', '2024-05-03 07:45:00', 'Reposo y cuidado de herida', 14, 14),
('Conjuntivitis viral', '2024-05-09 14:30:00', 'Pomada antiviral 3 veces al día', 15, 15),
('Chequeo geriátrico completo', '2024-05-20 11:00:00', 'Suplementos articulares', 16, 16),
('Osteoartritis incipiente', '2024-06-01 16:15:00', 'Antiinflamatorios y condroprotectores', 17, 17),
('Vacunación múltiple', '2024-06-08 09:45:00', 'Vacunas según protocolo', 18, 18),
('Control postoperatorio', '2024-06-20 10:30:00', 'Retiro de suturas', 19, 19),
('Alergia ambiental', '2024-07-05 15:00:00', 'Antihistamínicos por 10 días', 20, 20),
('Control de crecimiento', '2024-07-18 11:45:00', 'Ninguna intervención necesaria', 21, 21),
('Dermatitis seborreica', '2024-07-25 09:15:00', 'Shampoo medicado semanal', 22, 22),
('Tartrectomía completa', '2024-08-05 08:30:00', 'Control en 6 meses', 23, 23);

-- 15. ADOPCIONES con correcciones
INSERT INTO ADOPCIONES (fecha, estado, id_adoptante) VALUES 
-- Adopciones completadas (20 registros)
('2024-03-10', 'Completado', 1),
('2024-03-15', 'Completado', 2),
('2024-05-01', 'Completado', 5),
('2024-05-10', 'Completado', 6),
('2024-06-25', 'Completado', 10),
('2024-08-03', 'Completado', 14),
('2024-09-15', 'Completado', 18),
('2024-10-20', 'Completado', 22),
('2024-11-10', 'Completado', 25),
('2024-12-10', 'Completado', 29),
('2025-01-05', 'Completado', 32),
('2025-02-12', 'Completado', 37),

-- Adopciones aprobadas (12 registros)
('2024-05-18', 'Aprobado', 7),
('2024-07-05', 'Aprobado', 11),
('2024-08-10', 'Aprobado', 15),
('2024-09-28', 'Aprobado', 19),
('2024-10-15', 'Aprobado', 21),
('2024-12-20', 'Aprobado', 31),
('2025-01-28', 'Aprobado', 35),
('2025-02-20', 'Aprobado', 38),

-- Adopciones pendientes (12 registros)
('2024-04-05', 'Pendiente', 3),
('2024-06-02', 'Pendiente', 8),
('2024-07-12', 'Pendiente', 12),
('2024-08-22', 'Pendiente', 16),
('2024-10-10', 'Pendiente', 20),
('2024-10-28', 'Pendiente', 23),
('2024-11-25', 'Pendiente', 27),
('2024-12-15', 'Pendiente', 30),
('2025-01-12', 'Pendiente', 33),
('2025-02-05', 'Pendiente', 36),
('2025-02-28', 'Pendiente', 39),

-- Adopciones rechazadas (8 registros)
('2024-04-20', 'Rechazado', 4),
('2024-06-15', 'Rechazado', 9),
('2024-07-20', 'Rechazado', 13),
('2024-09-05', 'Rechazado', 17),
('2024-11-03', 'Rechazado', 24),
('2024-12-01', 'Rechazado', 28),
('2025-01-20', 'Rechazado', 34),
('2025-03-05', 'Rechazado', 40);

-- 16. DONACIONES
INSERT INTO DONACIONES (tipo, monto, descripcion, fecha, id_sucursal, id_donante) VALUES
('Efectivo', 50000.00, 'Donación monetaria para alimentación', '2024-01-15', 1, 1),
('Efectivo', 25000.00, 'Donación general', '2024-04-20', 4, 2),
('Efectivo', 150000.00, 'Donación para construcción', '2024-06-12', 1, 3),
('Efectivo', 75000.00, 'Donación para medicinas', '2024-09-22', 4, 4),
('Efectivo', 200000.00, 'Donación para equipamiento', '2024-11-08', 6, 5),
('Efectivo', 100000.00, 'Donación general', '2025-01-25', 8, 6),
('Efectivo', 300000.00, 'Donación para vehículo', '2025-03-10', 2, 7),
('Efectivo', 35000.00, 'Donación monetaria', '2025-04-01', 2, 8),
('Efectivo', 45000.00, 'Donación para alimentos', '2025-05-05', 2, 9),
('Efectivo', 50000.00, 'Donación general', '2025-05-20', 5, 10),
('Efectivo', 60000.00, 'Donación para construcción', '2025-06-05', 8, 11),
('Efectivo', 70000.00, 'Donación monetaria', '2025-06-25', 4, 12),
('Efectivo', 80000.00, 'Donación para medicinas', '2025-07-05', 6, 13),
('Efectivo', 90000.00, 'Donación general', '2025-07-20', 1, 14),
('Efectivo', 95000.00, 'Donación para equipamiento', '2025-07-30', 3, 15),
('Alimentos', 0.00, '500 kg de alimento para perros', '2024-02-10', 2, 16),
('Medicinas', 0.00, 'Lote de medicamentos veterinarios', '2024-03-05', 3, 17),
('Equipamiento', 0.00, 'Equipo quirúrgico para clínica', '2024-10-15', 5, 18),
('Materiales de construcción', 0.00, 'Materiales para ampliación de refugio', '2024-12-03', 7, 19),
('Vehiculo de transporte', 0.00, 'Camioneta para transporte de animales', '2025-02-14', 1, 20),
('Medicinas', 0.00, 'Vacunas y antibióticos', '2025-04-05', 3, 21),
('Alimentos', 0.00, '300 kg de alimento balanceado', '2025-04-10', 4, 22),
('Equipamiento', 0.00, 'Jaulas y transportadoras', '2025-04-20', 6, 23),
('Materiales de construcción', 0.00, 'Materiales para área de cuarentena', '2025-04-25', 7, 24),
('Vehiculo de transporte', 0.00, 'Ambulancia veterinaria', '2025-05-01', 1, 25),
('Alimentos', 0.00, '400 kg de alimento para gatos', '2025-05-10', 3, 26),
('Medicinas', 0.00, 'Medicamentos para tratamientos', '2025-05-15', 4, 27),
('Equipamiento', 0.00, 'Mobiliario para clínica', '2025-06-01', 7, 28),
('Alimentos', 0.00, '600 kg de alimento premium', '2025-06-15', 2, 29),
('Medicinas', 0.00, 'Insumos médicos varios', '2025-06-20', 3, 30),
('Materiales de construcción', 0.00, 'Materiales para área de recreación', '2025-07-01', 5, 31);


-- 17.SOLICITUDES
INSERT INTO SOLICITUDES (id_adoptante, id_mascota, fecha_solicitud, estado) VALUES 
-- Solicitudes aprobadas (usando solo mascotas 1-27)
(1, 1, '2024-02-28', 'Aprobada'),
(2, 3, '2024-03-05', 'Aprobada'),
(5, 5, '2024-04-20', 'Aprobada'),
(6, 7, '2024-04-25', 'Aprobada'),
(7, 9, '2024-05-10', 'Aprobada'),
(10, 11, '2024-06-15', 'Aprobada'),
(11, 13, '2024-06-20', 'Aprobada'),
(14, 15, '2024-07-25', 'Aprobada'),
(15, 17, '2024-07-30', 'Aprobada'),
(18, 19, '2024-09-05', 'Aprobada'),
(19, 21, '2024-09-10', 'Aprobada'),
(21, 23, '2024-10-05', 'Aprobada'),
(22, 25, '2024-10-10', 'Aprobada'),
(25, 27, '2024-11-05', 'Aprobada'),
-- Solicitudes pendientes (usando solo mascotas 1-27)
(3, 2, '2024-03-30', 'Pendiente'),
(8, 8, '2024-05-28', 'Pendiente'),
(12, 12, '2024-07-10', 'Pendiente'),
(16, 16, '2024-08-15', 'Pendiente'),
(20, 20, '2024-09-30', 'Pendiente'),
(23, 24, '2024-10-25', 'Pendiente'),
(27, 26, '2024-11-20', 'Pendiente'), -- Cambiado de 28 a 26
(30, 27, '2024-12-12', 'Pendiente'); -- Cambiado de 30 a 27


-- 18. DETALLES DE ADOPCIONES
INSERT INTO DETALLE_ADOPCION (id_adopcion, id_mascota) VALUES
-- Adopciones completadas (solo mascotas existentes 1-27)
(1, 1), (2, 3), (5, 5), (6, 7), (10, 11), 
(14, 15), (18, 19), (22, 25), (25, 27),

-- Adopciones aprobadas (solo mascotas existentes 1-27)
(3, 2), (3, 4), (7, 9), (11, 13), 
(15, 17), (15, 21), (19, 23);

-- 19. TURNOS
INSERT INTO TURNOS (id_personal, id_voluntario, fecha, hora_inicio, hora_fin, actividad) VALUES
-- Turnos del personal (sin voluntario)
(1, NULL, '2024-03-01', '08:00:00', '16:00:00', 'Atención administrativa'),
(3, NULL, '2024-03-01', '07:00:00', '15:00:00', 'Cuidado matutino de animales'),
(5, NULL, '2024-03-01', '09:00:00', '17:00:00', 'Gestión de adopciones'),
(7, NULL, '2024-03-02', '08:00:00', '16:00:00', 'Limpieza de instalaciones'),
(10, NULL, '2024-03-02', '10:00:00', '18:00:00', 'Entrenamiento canino'),
-- Turnos de voluntarios (sin personal)
(NULL, 2, '2024-03-01', '09:00:00', '13:00:00', 'Paseo de perros'),
(NULL, 5, '2024-03-01', '14:00:00', '18:00:00', 'Socialización de gatos'),
(NULL, 8, '2024-03-02', '08:30:00', '12:30:00', 'Apoyo en limpieza'),
(NULL, 11, '2024-03-02', '13:00:00', '17:00:00', 'Asistencia en consultas veterinarias'),
-- MIXTO
(2, 3, '2024-03-03', '09:00:00', '14:00:00', 'Jornada de adopciones'),
(4, 7, '2024-03-03', '10:00:00', '15:00:00', 'Taller de cuidado animal'),
(6, 9, '2024-03-04', '08:00:00', '13:00:00', 'Revisión médica preventiva'),
(8, 12, '2024-03-04', '11:00:00', '16:00:00', 'Actividad con niños');

-- 20. SEGUIMIENTOS
INSERT INTO SEGUIMIENTOS (id_adopcion, fecha, observaciones, estado) VALUES
-- Seguimientos positivos
(1, '2024-04-10', 'La mascota se ha adaptado perfectamente al hogar. Excelente relación con la familia.', 'Conforme'),
(2, '2024-04-15', 'El animal muestra buen estado de salud y comportamiento. Ambiente adecuado.', 'Conforme'),
(5, '2024-05-20', 'Cumplimiento de todas las pautas de cuidado. Mascota en óptimas condiciones.', 'Conforme'),
(6, '2024-05-25', 'Entrevista telefónica satisfactoria. Dueños comprometidos con el bienestar animal.', 'Conforme'),
-- Seguimientos con problemas
(3, '2024-04-18', 'Se detectó sobrepeso en la mascota. Se recomendó ajustar dieta y aumentar ejercicio.', 'Problema detectado'),
(7, '2024-06-05', 'El animal muestra signos de ansiedad por separación. Se derivó a especialista.', 'Problema detectado'),
-- Seguimientos pendientes
(4, '2024-04-22', 'Primer contacto establecido. Programar visita domiciliaria para evaluación completa.', 'Pendiente'),
(8, '2024-06-10', 'No se pudo contactar al adoptante. Se realizará nuevo intento en 3 días.', 'Pendiente'),
-- Seguimientos adicionales
(9, '2024-06-15', 'La mascota ha mejorado su comportamiento gracias a las recomendaciones aplicadas.', 'Conforme'),
(10, '2024-06-20', 'Problemas iniciales de adaptación resueltos satisfactoriamente.', 'Conforme'),
(11, '2024-07-01', 'Visita domiciliaria realizada. Condiciones del hogar mejorables pero dentro de parámetros aceptables.', 'Conforme'),
(12, '2024-07-05', 'Se reportó problema de alergias. Se coordinó consulta con veterinario del refugio.', 'Problema detectado');
=======
-- DONACIONES 
INSERT INTO DONACIONES (tipo, monto, fecha, id_sucursal) VALUES
('Efectivo', 50000.00, '2024-01-15', 1),
('Alimentos', 0.00, '2024-02-10', 2),
('Medicinas', 0.00, '2024-03-05', 3),
('Efectivo', 25000.00, '2024-04-20', 4),
('Otros', 10000.00, '2024-05-01', 5),
('Efectivo', 150000.00, '2024-06-12', 1),
('Alimentos', 0.00, '2024-07-18', 2),
('Medicinas', 0.00, '2024-08-05', 3),
('Efectivo', 75000.00, '2024-09-22', 4),
('Equipamiento', 0.00, '2024-10-15', 5),
('Efectivo', 200000.00, '2024-11-08', 6),
('Materiales de construcción', 0.00, '2024-12-03', 7),
('Efectivo', 100000.00, '2025-01-25', 8),
('Vehiculo de transporte', 0.00, '2025-02-14', 1),
('Efectivo', 300000.00, '2025-03-10', 2),
('Efectivo', 35000.00, '2025-04-01', 2),
('Medicinas', 0.00, '2025-04-05', 3),
('Alimentos', 0.00, '2025-04-10', 4),
('Otros', 5000.00, '2025-04-15', 5),
('Equipamiento', 0.00, '2025-04-20', 6),
('Materiales de construcción', 0.00, '2025-04-25', 7),
('Vehiculo de transporte', 0.00, '2025-05-01', 1),
('Efectivo', 45000.00, '2025-05-05', 2),
('Alimentos', 0.00, '2025-05-10', 3),
('Medicinas', 0.00, '2025-05-15', 4),
('Efectivo', 50000.00, '2025-05-20', 5),
('Otros', 7500.00, '2025-05-25', 6),
('Equipamiento', 0.00, '2025-06-01', 7),
('Efectivo', 60000.00, '2025-06-05', 8),
('Vehiculo de transporte', 0.00, '2025-06-10', 1),
('Alimentos', 0.00, '2025-06-15', 2),
('Medicinas', 0.00, '2025-06-20', 3),
('Efectivo', 70000.00, '2025-06-25', 4),
('Materiales de construcción', 0.00, '2025-07-01', 5),
('Efectivo', 80000.00, '2025-07-05', 6),
('Equipamiento', 0.00, '2025-07-10', 7),
('Otros', 9000.00, '2025-07-15', 8),
('Efectivo', 90000.00, '2025-07-20', 1),
('Medicinas', 0.00, '2025-07-25', 2),
('Efectivo', 95000.00, '2025-07-30', 3);
>>>>>>> f5dbd61761312e25bf8949df3ab01344be1cfdb7
