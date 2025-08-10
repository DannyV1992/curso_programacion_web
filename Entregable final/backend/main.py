#Punto de entrada de FastAPI


from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware

import models, schemas
from database import SessionLocal, engine

# Crear las tablas automáticamente si no existen
models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# Permitir solicitudes desde cualquier origen (para frontend local)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Función para obtener sesión de BD
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ---------------------------
# ENDPOINTS API
# ---------------------------

@app.get("/mascotas", response_model=list[schemas.MascotaSchema])
def get_mascotas(db: Session = Depends(get_db)):
    return db.query(models.Mascota).all()

@app.get("/voluntarios", response_model=list[schemas.VoluntarioSchema])
def get_voluntarios(db: Session = Depends(get_db)):
    return db.query(models.Voluntario).all()

@app.get("/donaciones", response_model=list[schemas.DonacionSchema])
def get_donaciones(db: Session = Depends(get_db)):
    return db.query(models.Donacion).all()

@app.get("/inventario", response_model=list[schemas.InventarioSchema])
def get_inventario(db: Session = Depends(get_db)):
    return db.query(models.Inventario).all()

@app.get("/adoptantes", response_model=list[schemas.AdoptanteSchema])
def get_adoptantes(db: Session = Depends(get_db)):
    return db.query(models.Adoptante).all()
