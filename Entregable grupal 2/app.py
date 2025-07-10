import streamlit as st
from datetime import datetime
from sqlalchemy import create_engine, Column, Integer, String, Text, DateTime, Boolean
from sqlalchemy.orm import declarative_base, sessionmaker

# Configuración de la base de datos
engine = create_engine("mysql+pymysql://root:root@localhost/tareas_db")
Base = declarative_base()
Session = sessionmaker(bind=engine)
session = Session()

# Modelo de la tabla
class Tarea(Base):
    __tablename__ = 'tareas'
    id = Column(Integer, primary_key=True)
    email = Column(String(100), nullable=False)
    tarea = Column(Text)
    subtarea = Column(Text)
    hora_inicio = Column(DateTime)
    hora_final = Column(DateTime)
    comentarios = Column(Text)
    completado = Column(Boolean)

Base.metadata.create_all(engine)

# Diccionario de tareas y subtareas
tareas_dict = {
    "Mantenimiento": ["Lubricación", "Inspección", "Ajuste"],
    "Producción": ["Montaje", "Verificación"],
}

st.title("Gestor de tareas de mantenimiento")

# Estado inicial
if "tarea" not in st.session_state:
    st.session_state.tarea = ""
if "subtarea" not in st.session_state:
    st.session_state.subtarea = ""
if "hora_inicio" not in st.session_state:
    st.session_state.hora_inicio = None
if "completado" not in st.session_state:
    st.session_state.completado = False
if "hora_final" not in st.session_state:
    st.session_state.hora_final = None

def on_tarea_change():
    if st.session_state.tarea and st.session_state.tarea in tareas_dict:
        st.session_state.subtarea = tareas_dict[st.session_state.tarea][0]
        if not st.session_state.hora_inicio:
            st.session_state.hora_inicio = datetime.now()
    else:
        st.session_state.subtarea = ""
        st.session_state.hora_inicio = None

def on_completado_change():
    if st.session_state.completado:
        st.session_state.hora_final = datetime.now()
    else:
        st.session_state.hora_final = None

email = st.text_input("Email")

# Selectbox de tarea con opción vacía
tarea_opciones = [""] + list(tareas_dict.keys())
tarea = st.selectbox(
    "Tarea",
    tarea_opciones,
    index=0,
    key="tarea",
    on_change=on_tarea_change
)

# Selectbox de subtarea solo si la tarea es válida
if st.session_state.tarea and st.session_state.tarea in tareas_dict:
    subtarea = st.selectbox(
        "Subtarea",
        tareas_dict[st.session_state.tarea],
        key="subtarea"
    )
else:
    subtarea = None
    st.info("Selecciona una tarea para ver las subtareas disponibles.")

# Checkbox fuera del formulario para actualización en tiempo real
completado = st.checkbox("Completado", key="completado", on_change=on_completado_change)

with st.form("form_tarea"):
    # Hora de inicio
    hora_inicio_str = ""
    if not st.session_state.hora_inicio:
        st.info("La hora de inicio se asignará al seleccionar la tarea.")
    else:
        hora_inicio_str = st.session_state.hora_inicio.strftime('%Y-%m-%d %H:%M:%S')
    st.text_input("Hora de inicio", value=hora_inicio_str, disabled=True)

    # Hora final
    hora_final_str = ""
    if completado and st.session_state.hora_final:
        hora_final_str = st.session_state.hora_final.strftime('%Y-%m-%d %H:%M:%S')
    st.text_input(
        "Hora final",
        value=hora_final_str if completado else "(se asignará al completar la tarea)",
        disabled=True
    )

    comentarios = st.text_area("Comentarios")
    submitted = st.form_submit_button("Guardar")

    if submitted:
        if not email:
            st.error("Por favor, ingresa un email.")
        elif not tarea or tarea not in tareas_dict:
            st.error("Por favor, selecciona una tarea antes de guardar.")
        elif not subtarea:
            st.error("Por favor, selecciona una subtarea antes de guardar.")
        else:
            # Asignar hora de inicio si no existe
            if not st.session_state.hora_inicio:
                st.session_state.hora_inicio = datetime.now()
            # Asignar hora final si está completado
            hora_final_db = st.session_state.hora_final if completado else None
            nueva_tarea = Tarea(
                email=email,
                tarea=st.session_state.tarea,
                subtarea=st.session_state.subtarea,
                hora_inicio=st.session_state.hora_inicio,
                hora_final=hora_final_db,
                comentarios=comentarios,
                completado=completado
            )
            session.add(nueva_tarea)
            session.commit()
            st.success("Tarea guardada exitosamente")
            # Recargar la app para limpiar los campos y evitar el error de session_state
            st.rerun()

# --- Filtros para visualizar tareas ---
st.header("Tareas registradas")

filtro_email = st.text_input("Filtrar por email")
filtro_completado = st.selectbox("Filtrar por estado", ["Todos", "Completado", "No completado"])

query = session.query(Tarea)
if filtro_email:
    query = query.filter(Tarea.email == filtro_email)
if filtro_completado != "Todos":
    query = query.filter(Tarea.completado == (filtro_completado == "Completado"))

tareas = query.all()

# --- Mostrar las tareas en tabla ---
if tareas:
    st.write("Total de tareas:", len(tareas))
    for t in tareas:
        cols = st.columns([2, 2, 2, 2, 2, 2, 1, 1])
        cols[0].write(t.email)
        cols[1].write(t.tarea)
        cols[2].write(t.subtarea)
        cols[3].write(t.hora_inicio.strftime("%Y-%m-%d %H:%M") if t.hora_inicio else "")
        cols[4].write(t.hora_final.strftime("%Y-%m-%d %H:%M") if t.hora_final else "")
        cols[5].write(t.comentarios)
        cols[6].write("✔️" if t.completado else "❌")
        # Botón para marcar como completada
        if not t.completado:
            if cols[7].button("Completar", key=f"comp_{t.id}"):
                t.completado = True
                t.hora_final = datetime.now()
                session.commit()
                st.rerun()
        # Botón para eliminar tarea
        if cols[7].button("Eliminar", key=f"elim_{t.id}"):
            session.delete(t)
            session.commit()
            st.rerun()
else:
    st.info("No hay tareas para mostrar con los filtros seleccionados.")

