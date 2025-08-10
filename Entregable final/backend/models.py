from sqlalchemy import Column, Integer, String, Float, Date
from database import Base

# ---------------------
# Modelo: MASCOTA
# ---------------------
class Mascota(Base):
    __tablename__ = "MASCOTA"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100))
    raza = Column(String(100))
    edad = Column(Integer)
    imagen = Column(String(255))  # Ruta o nombre del archivo

# ---------------------
# Modelo: VOLUNTARIOS
# ---------------------
class Voluntario(Base):
    __tablename__ = "VOLUNTARIOS"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100))
    correo = Column(String(100))
    telefono = Column(String(20))
    disponibilidad = Column(String(100))

# ---------------------
# Modelo: DONACIONES
# ---------------------
class Donacion(Base):
    __tablename__ = "DONACIONES"

    id = Column(Integer, primary_key=True, index=True)
    donante = Column(String(100))
    monto = Column(Float)
    fecha = Column(Date)
    comentario = Column(String(255))

# ---------------------
# Modelo: INVENTARIO
# ---------------------
class Inventario(Base):
    __tablename__ = "INVENTARIO"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100))
    categoria = Column(String(100))
    cantidad = Column(Integer)
    descripcion = Column(String(255))

# ---------------------
# Modelo: ADOPTANTES
# ---------------------
class Adoptante(Base):
    __tablename__ = "ADOPTANTES"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100))
    correo = Column(String(100))
    telefono = Column(String(20))
    direccion = Column(String(255))
