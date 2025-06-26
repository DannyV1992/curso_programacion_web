from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
import mysql.connector

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class TareaTecnico(BaseModel):
    email: str
    task: str
    subtask: str
    started_at: str
    end_at: Optional[str]
    completed: bool
    comentario: Optional[str]

def conectar_db():
    return mysql.connector.connect(
        host="localhost",
        port=3306,
        user="root",
        password="root",
        database="manufacturing_logs"
    )

@app.post("/tarea")
def crear_tarea(tarea: TareaTecnico):
    db = conectar_db()
    cursor = db.cursor()
    sql = """
    INSERT INTO tech_logs 
    (email, task, subtask, completed, started_at, end_at, comentario)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    valores = (
        tarea.email, tarea.task, tarea.subtask, tarea.completed,
        tarea.started_at, tarea.end_at, tarea.comentario
    )
    cursor.execute(sql, valores)
    db.commit()
    cursor.close()
    db.close()

