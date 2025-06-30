# Registro Diario de Tareas — Curso de Programación Web

Este proyecto es una **aplicación web** para registrar y consultar tareas diarias, diseñada como práctica para un curso de programación web. Incluye un frontend en HTML, CSS y JavaScript, y un backend en Python con FastAPI, utilizando MySQL como base de datos.

---

## Estructura de archivos

| Archivo           | Descripción                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `index.html`      | Interfaz principal para registrar y consultar tareas.                        |
| `styles.css`      | Estilos visuales para la aplicación web.                                     |
| `script.js`       | Lógica de interacción en el frontend (añadir, eliminar, guardar, consultar). |
| `main.py`         | Backend API con FastAPI para guardar y consultar tareas.                     |
| `data_base.sql`   | Script para crear la base de datos y la tabla de tareas en MySQL.            |
| `db_tester.py`    | Script de prueba para verificar la conexión y operaciones en la base de datos.|

---

## Instalación y puesta en marcha

### 1. Requisitos

- Python 3.8+
- MySQL Server
- Navegador web moderno

### 2. Configuración de la base de datos

1. Inicia tu servidor MySQL.
2. Ejecuta el script `data_base.sql` en tu cliente MySQL favorito para crear la base de datos y la tabla necesaria:

    ```
    CREATE DATABASE IF NOT EXISTS manufacturing_logs;
    USE manufacturing_logs;
    CREATE TABLE IF NOT EXISTS tech_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        email VARCHAR(100) NOT NULL,
        task VARCHAR(100) NOT NULL,
        subtask VARCHAR(100) NOT NULL,
        started_at TIMESTAMP NOT NULL,
        end_at TIMESTAMP NOT NULL,
        comentario TEXT
    );
    ```

### 3. Backend (API con FastAPI)

1. Instala dependencias en tu entorno Python:

    ```
    pip install fastapi uvicorn pydantic mysql-connector-python
    ```

2. Asegúrate de que los parámetros de conexión en `main.py` coincidan con tu configuración de MySQL (usuario, contraseña, host, puerto).

3. Inicia el backend:

    ```
    uvicorn main:app --reload --port 8000
    ```

4. (Opcional) Usa `db_tester.py` para probar la conexión a la base de datos.

### 4. Frontend

1. Abre el archivo `index.html` en tu navegador web.
2. Asegúrate de que el backend esté corriendo en `http://localhost:8000`.

---

## Uso de la aplicación

### Registrar Tareas

- Ingresa tu email.
- Añade filas para nuevas tareas y subtareas.
- Elige la tarea y subtarea, agrega comentarios si es necesario.
- Marca como completado cuando termines una tarea (se registra la hora final).
- Haz clic en **Guardar todas las tareas** para enviar los datos al backend.

### Consultar tareas

- Ingresa un email en la sección de consulta.
- Haz clic en **Buscar** para ver el historial de tareas asociadas a ese email.

---

## Detalle de archivos

### index.html

- Formulario para ingresar tareas, subtareas, horas, comentarios y estado de completado.
- Sección para consultar tareas previas por email.

### script.js

- Maneja la lógica de añadir/eliminar filas, registrar horas de inicio/finalización, validar datos y enviar/consultar tareas al backend mediante fetch API.

### styles.css

- Proporciona estilos modernos y responsivos para la interfaz, botones, tablas y mensajes de usuario.

### main.py

- API REST con FastAPI:
    - `POST /guardar-tareas`: Guarda una lista de tareas en la base de datos.
    - `GET /consultar-tareas?email=...`: Devuelve las tareas asociadas a un email.
- Conexión a MySQL y manejo de errores básicos.

### data_base.sql

- Script SQL para crear la base de datos y la tabla principal de registros de tareas.

### db_tester.py

- Script de prueba para verificar la conexión y realizar inserciones de ejemplo en la base de datos.

---

## Notas

- **Seguridad:** esta aplicación es solo para fines educativos y no implementa autenticación ni validación avanzada.
- **Personalización:** puedes modificar las tareas y subtareas disponibles editando el arreglo `tareas` en `script.js`.
- **Problemas comunes:** verifica que los datos de conexión a MySQL sean correctos y que el backend esté en ejecución antes de usar el frontend.

---

## Autor
Daniel Vásquez González
Susana Herrera Fonseca
Kendra Gutiérrez Vega

