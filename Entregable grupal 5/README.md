# Refugio de Mascotas (FastAPI + MySQL + Frontend con Tailwind)

Proyecto full‑stack para gestionar mascotas en un refugio: API con FastAPI y MySQL, frontend en HTML+JS estilizado con Tailwind, y un pipeline de limpieza y respaldo de datos en Python. El entregable cumple el requerimiento de integrar un framework CSS (Tailwind) y documentar la comparación con otro framework (Bootstrap, en documento separado).

## Estructura del proyecto

```
Entregable grupal 5/
├── frontend/
│   ├── index.html
│   └── app.js
├── backend/
│   ├── .env
│   ├── main.py (FastAPI app)
│   ├── database.py
│   ├── models.py
│   └── requirements.txt
├── pipeline/
│   ├── flows.py
│   ├── logs/
│   └── backups/
├── sql/
│   └── init.sql
└── README.md
```

## Requisitos
- Python 3.10+
- MySQL 8.x
- Node no requerido (frontend es HTML/JS plano)
- Dependencias Python en backend/requirements.txt

## Configuración de base de datos
1) Crear la base con el script:
- Ejecutar MySQL y correr sql/init.sql para crear la base refugio_mascotas, tablas, datos de ejemplo e índices.

2) Variables de entorno (.env en backend/):
Dentro de backend/ se encuentra el archivo .env.example. Este archivo contiene las variables usadas para acceder a la base de datos, sin embargo los archivos llamados `.env` son ignorados por GitHub por lo cual, debes modificar el nombre del archivo cuando hayas clonado el repositorio.
Simplemente renombra el archivo y edita las credenciales por las que tienes en tu base de datos local.

```
DB_HOST=localhost
DB_NAME=refugio_mascotas
DB_USER=root
DB_PASSWORD=root
```

## Backend (FastAPI)
- Entrypoint: backend/main.py
- Endpoints principales:
  - GET /mascotas — lista mascotas
  - POST /mascotas — crea mascota
  - PUT /mascotas/{id} — actualiza mascota
  - DELETE /mascotas/{id} — elimina mascota
  - GET /api/external-pet-data — integra Dog CEO y Cat Facts
  - GET /api/pipeline/status — estado simulado del pipeline

Instalación y ejecución:

```
Crear entorno virtual
python -m venv venv

Activar entorno virtual
En Windows:
venv\Scripts\activate

En Linux/macOS:
source venv/bin/activate

Instalar dependencias
pip install -r requirements.txt

Ejecutar servidor
uvicorn main:app --host 0.0.0.0 --port 8001 --reload
```

Notas:
- CORS abierto para permitir consumo desde frontend.
- Manejo de errores con HTTPException.
- Conectores MySQL nativos de mysql-connector-python.

## Frontend (Tailwind)
- index.html y app.js consumen la API (API_BASE=http://localhost:8001).
- Migración a Tailwind: se aplicaron utilidades de Tailwind para layout, tipografía, formularios, grid y estados visuales (por ejemplo, clases para espaciado, color, sombras, transiciones), siguiendo el enfoque utility‑first del framework.
- Beneficios:
  - Composición rápida de estilos con clases utilitarias (p.ej., bg-blue-500, text-center, rounded).
  - Diseño responsivo y consistente directamente en el markup.
  - Personalización mediante theme y utilidades sin escribir CSS tradicional para la mayoría de casos.

Ejecución:
- Abrir frontend/index.html en navegador (o servir con un servidor estático).
- Ver registros cargados desde la API, CRUD completo y datos externos (razas de perros y dato de gatos).

## Pipeline de datos
- Script: pipeline/flows.py
- Funciones:
  - Conecta a MySQL y extrae mascotas.
  - Limpia datos (nombre no vacío; edades inválidas a NULL).
  - Guarda backup CSV en pipeline/backups/.
  - Actualiza tabla mascotas_cleaned con un score simple de calidad.
  - Registra métricas en pipeline/logs/simple_log.json.

Ejecución manual:

```
Desde el directorio del proyecto
cd pipeline/
python flows.py
```

El pipeline genera:
- Backups en formato CSV con timestamp
- Logs de métricas en formato JSON
- Tabla mascotas_cleaned con scores de calidad de datos

## Estructura de la base de datos

### Tabla mascotas
- id (INT, AUTO_INCREMENT, PRIMARY KEY)
- nombre (VARCHAR(100), NOT NULL)
- especie (ENUM: 'perro', 'gato', 'otro')
- edad (INT, DEFAULT NULL)
- descripcion (TEXT)
- estado (ENUM: 'disponible', 'adoptado')
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)

### Tabla mascotas_cleaned
- id (INT, AUTO_INCREMENT, PRIMARY KEY)
- mascota_id (INT, FOREIGN KEY)
- data_quality_score (DECIMAL(3,2))
- processed_at (TIMESTAMP)

## APIs externas integradas
- **Dog CEO API**: Obtiene lista de razas de perros
- **Cat Facts API**: Obtiene datos curiosos sobre gatos

## Créditos y frameworks
- **Tailwind CSS**: utility‑first CSS framework utilizado en el frontend
- **FastAPI**: Framework web moderno para Python
- **MySQL**: Sistema de gestión de base de datos
- **Bootstrap**: se compara en el documento de investigación adjunto, como framework alternativo popular con componentes pre‑diseñados y grid responsivo.
