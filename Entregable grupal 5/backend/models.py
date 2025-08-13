from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from enum import Enum

class EspecieEnum(str, Enum):
    perro = "perro"
    gato = "gato"
    otro = "otro"

class EstadoEnum(str, Enum):
    disponible = "disponible"
    adoptado = "adoptado"

class MascotaBase(BaseModel):
    nombre: str = Field(..., min_length=1, max_length=100, description="Nombre de la mascota")
    especie: EspecieEnum = Field(..., description="Especie de la mascota")
    edad: Optional[int] = Field(None, ge=0, le=30, description="Edad en años")
    descripcion: Optional[str] = Field("", max_length=500, description="Descripción de la mascota")
    estado: EstadoEnum = Field(EstadoEnum.disponible, description="Estado de adopción")

class MascotaCreate(MascotaBase):
    pass

class MascotaUpdate(MascotaBase):
    pass

class MascotaResponse(MascotaBase):
    id: int
    created_at: datetime
    
    class Config:
        from_attributes = True

class MascotaCleanedResponse(BaseModel):
    id: int
    mascota_id: int
    data_quality_score: float
    processed_at: datetime

class ExternalDataResponse(BaseModel):
    dog_breeds: list[str]
    cat_fact: str

class PipelineStatusResponse(BaseModel):
    status: str
    last_run: Optional[str]
    next_run: Optional[str]
    processed_records: int
