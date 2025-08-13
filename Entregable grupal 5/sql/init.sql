-- Crear base de datos
CREATE DATABASE IF NOT EXISTS refugio_mascotas;
USE refugio_mascotas;

-- Tabla principal de mascotas
CREATE TABLE IF NOT EXISTS mascotas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especie ENUM('perro', 'gato', 'otro') NOT NULL,
    edad INT DEFAULT NULL,
    descripcion TEXT,
    estado ENUM('disponible', 'adoptado') DEFAULT 'disponible',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de datos limpios del pipeline
CREATE TABLE IF NOT EXISTS mascotas_cleaned (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mascota_id INT NOT NULL,
    data_quality_score DECIMAL(3,2) DEFAULT 1.00,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mascota_id) REFERENCES mascotas(id) ON DELETE CASCADE
);

-- Insertar datos de ejemplo
INSERT INTO mascotas (nombre, especie, edad, descripcion, estado) VALUES
('Max', 'perro', 3, 'Perro muy amigable y juguetón. Le encanta correr en el parque.', 'disponible'),
('Luna', 'gato', 2, 'Gata tranquila y cariñosa. Perfecta para apartamentos.', 'disponible'),
('Rocky', 'perro', 5, 'Perro guardián, muy leal. Necesita espacio para correr.', 'disponible'),
('Mia', 'gato', 1, 'Gatita muy activa y curiosa. Le gusta jugar con pelotas.', 'adoptado'),
('Buddy', 'perro', 7, 'Perro mayor, muy tranquilo y obediente.', 'disponible');

-- Crear índices para mejorar rendimiento
CREATE INDEX idx_mascotas_especie ON mascotas(especie);
CREATE INDEX idx_mascotas_estado ON mascotas(estado);
CREATE INDEX idx_mascotas_created_at ON mascotas(created_at);
