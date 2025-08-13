from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
import mysql.connector
from mysql.connector import Error
import os
from datetime import datetime
import httpx
from database import db

app = FastAPI(title="Refugio de Mascotas API")

# CORS para permitir frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modelos Pydantic
class Mascota(BaseModel):
    nombre: str
    especie: str
    edad: Optional[int] = None
    descripcion: Optional[str] = ""
    estado: str = "disponible"

class MascotaResponse(Mascota):
    id: int
    created_at: datetime

# Configuración de BD
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'database': os.getenv('DB_NAME', 'refugio_mascotas'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', 'root')
}

def get_db_connection():
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        raise HTTPException(status_code=500, detail=f"Error de conexión: {e}")

# Rutas CRUD
@app.get("/mascotas", response_model=List[MascotaResponse])
async def listar_mascotas():
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    try:
        cursor.execute("SELECT * FROM mascotas ORDER BY created_at DESC")
        mascotas = cursor.fetchall()
        return mascotas
    except Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        connection.close()

@app.post("/mascotas", response_model=dict)
async def crear_mascota(mascota: Mascota):
    connection = get_db_connection()
    cursor = connection.cursor()
    
    try:
        query = """
        INSERT INTO mascotas (nombre, especie, edad, descripcion, estado)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(query, (mascota.nombre, mascota.especie, mascota.edad, 
                              mascota.descripcion, mascota.estado))
        connection.commit()
        
        return {"message": "Mascota creada exitosamente", "id": cursor.lastrowid}
    except Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        connection.close()

@app.put("/mascotas/{mascota_id}")
async def actualizar_mascota(mascota_id: int, mascota: Mascota):
    connection = get_db_connection()
    cursor = connection.cursor()
    
    try:
        query = """
        UPDATE mascotas SET nombre=%s, especie=%s, edad=%s, descripcion=%s, estado=%s
        WHERE id=%s
        """
        cursor.execute(query, (mascota.nombre, mascota.especie, mascota.edad,
                              mascota.descripcion, mascota.estado, mascota_id))
        connection.commit()
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Mascota no encontrada")
            
        return {"message": "Mascota actualizada exitosamente"}
    except Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        connection.close()

@app.delete("/mascotas/{mascota_id}")
async def eliminar_mascota(mascota_id: int):
    connection = get_db_connection()
    cursor = connection.cursor()
    
    try:
        cursor.execute("DELETE FROM mascotas WHERE id=%s", (mascota_id,))
        connection.commit()
        
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Mascota no encontrada")
            
        return {"message": "Mascota eliminada exitosamente"}
    except Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        cursor.close()
        connection.close()

# APIs Externas
@app.get("/api/external-pet-data")
async def obtener_datos_externos():
    async with httpx.AsyncClient() as client:
        try:
            # Dog breeds
            dog_response = await client.get("https://dog.ceo/api/breeds/list/all")
            dog_breeds = dog_response.json()
            
            # Cat fact
            cat_response = await client.get("https://catfact.ninja/fact")
            cat_fact = cat_response.json()
            
            return {
                "dog_breeds": list(dog_breeds["message"].keys())[:10],
                "cat_fact": cat_fact["fact"]
            }
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Error obteniendo datos externos: {e}")

@app.get("/api/pipeline/status")
async def estado_pipeline():
    return {
        "status": "running",
        "last_run": datetime.now().isoformat(),
        "next_run": "2024-01-01T00:00:00",
        "processed_records": 0
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)
