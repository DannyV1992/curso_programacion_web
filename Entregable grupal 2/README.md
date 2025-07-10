# Gestor de tareas de mantenimiento

Este proyecto es una aplicación web desarrollada en **Python** usando **Streamlit** y **SQLAlchemy** para la gestión de tareas y subtareas dependientes, con almacenamiento en **MySQL**.

## Características

- Registro de tareas con los campos: email, tarea, subtarea, hora de inicio, hora final, comentarios y estado de completado.
- Menús desplegables dependientes: las subtareas se actualizan según la tarea seleccionada.
- Hora de inicio y hora final automáticas.
- Filtros para visualizar tareas por email y estado.
- Botones para completar y eliminar tareas.
- Interfaz web simple y moderna.

## Requisitos

- Python 3.8 o superior
- MySQL Server
- Paquetes Python:
  - streamlit
  - sqlalchemy
  - pymysql

## Instalación

1. **Clona el repositorio o descarga los archivos.**

2. **Instala las dependencias:**
```
pip install streamlit sqlalchemy pymysql
```

3. **Configura la base de datos MySQL:**

- Crea la base de datos y la tabla ejecutando en tu cliente MySQL:
  ```
  CREATE DATABASE IF NOT EXISTS tareas_db;
  USE tareas_db;
  CREATE TABLE IF NOT EXISTS tareas (
      id INT AUTO_INCREMENT PRIMARY KEY,
      email VARCHAR(100) NOT NULL,
      tarea TEXT,
      subtarea TEXT,
      hora_inicio DATETIME,
      hora_final DATETIME,
      comentarios TEXT,
      completado BOOLEAN
  );
  ```

- Asegúrate de que la cadena de conexión en `app.py` coincida con tu usuario, contraseña y host de MySQL.
  ```
  engine = create_engine("mysql+pymysql://usuario:contraseña@localhost/tareas_db")
  ```

4. **Ejecuta la aplicación:**
```
streamlit run app.py
```

5. **Abre tu navegador** en la dirección que Streamlit te indique (por defecto [http://localhost:8501](http://localhost:8501)).

## Uso

1. Ingresa tu email.
2. Selecciona una tarea y luego una subtarea (el menú de subtareas depende de la tarea).
3. Marca "Completado" si corresponde.
4. Agrega comentarios si lo deseas.
5. Haz clic en "Guardar".
6. Visualiza, filtra, completa o elimina tareas desde la tabla inferior.

## Notas

- Puedes modificar las tareas y subtareas editando el diccionario `tareas_dict` en `app.py`.
- Si se elimina una tarea desde la interfaz, esta se eliminará de la base de datos tambien.

## Autor
- Daniel Vásquez González
- Susana Herrera Fonseca
- Kendra Gutiérrez Vega

