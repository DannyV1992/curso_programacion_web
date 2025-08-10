# Conexion con MySQL

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# Datos de conexión (ajustá según tus credenciales)
DATABASE_URL = "mysql+pymysql://root:123Queso.@localhost/refugio_mascotas"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
