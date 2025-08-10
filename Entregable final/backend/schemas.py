from pydantic import BaseModel
from typing import Optional
from datetime import date

# -------------------------------
# Esquema para Mascota
# -------------------------------
class MascotaSchema(BaseModel):
    id: int
    nombre: str
    raza: str
    edad: int
    imagen: str

    class Config:
        orm_mode = True

# -------------------------------
# Esquema para Voluntario
# -------------------------------
class VoluntarioSchema(BaseModel):
    id: int
    nombre: str
    correo: str
    telefono: str
    disponibilidad: Optional[str]

    class Config:
        orm_mode = True

# -------------------------------
# Esquema para Donación
# -------------------------------
class DonacionSchema(BaseModel):
    id: int
    donante: str
    monto: float
    fecha: date
    comentario: Optional[str]

    class Config:
        orm_mode = True

# -------------------------------
# Esquema para Inventario
# -------------------------------
class InventarioSchema(BaseModel):
    id: int
    nombre: str
    categoria: str
    cantidad: int
    descripcion: Optional[str]

    class Config:
        orm_mode = True

# -------------------------------
# Esquema para Adoptante
# -------------------------------
class AdoptanteSchema(BaseModel):
    id: int
    nombre: str
    correo: str
    telefono: str
    direccion: Optional[str]

    class Config:
        orm_mode = True
