from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import mysql.connector

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Lead(BaseModel):
    nombre: str
    apellido: str
    empresa: str
    telefono: str
    correo: str
    oportunidad: str

def conectar_db():
    return mysql.connector.connect(
        host="localhost",
        port=3306,
        user="root",
        password="root",
        database="crm_leads"
    )

@app.post("/guardar-lead")
def guardar_lead(lead: Lead):
    try:
        db = conectar_db()
        cursor = db.cursor()
        sql = """
        INSERT INTO leads (nombre, apellido, empresa, telefono, correo, oportunidad)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        valores = (lead.nombre, lead.apellido, lead.empresa, lead.telefono, lead.correo, lead.oportunidad)
        cursor.execute(sql, valores)
        db.commit()
        cursor.close()
        db.close()
        return {"mensaje": "Lead guardado con éxito"}
    except Exception as e:
        return {"mensaje": f"Error: {str(e)}"}
