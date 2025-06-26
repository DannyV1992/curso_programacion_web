document.addEventListener('DOMContentLoaded', function() {
    // Elementos principales
    const loginSection = document.getElementById('loginSection');
    const mainSection = document.getElementById('mainSection');
    const btnLogin = document.getElementById('btnLogin');
    const emailInput = document.getElementById('email');
    const tablaTareas = document.getElementById('tablaTareas').getElementsByTagName('tbody')[0];
    const btnAgregarFila = document.getElementById('btnAgregarFila');
    const mensajeDiv = document.getElementById('mensaje');

    // Mapeo de tareas y subtareas (ejemplo)
    const tareasSubtareas = {
        "Mantenimiento": ["Lubricación", "Cambio de filtro", "Ajuste de componentes"],
        "Reparación": ["Diagnóstico", "Reemplazo de pieza", "Prueba funcional"],
        "Calibración": ["Ajuste de parámetros", "Verificación de precisión"],
        "Inspección": ["Visual", "Medición", "Prueba no destructiva"]
    };

    // Variables globales
    let tecnicoEmail = "";

    // Login de técnico
    btnLogin.addEventListener('click', function() {
        const email = emailInput.value.trim();
        if (!validarEmail(email)) {
            mostrarMensaje("Por favor, ingresa un correo válido", "red");
            return;
        }
        tecnicoEmail = email;
        loginSection.style.display = "none";
        mainSection.style.display = "block";
        agregarFilaInicial();
    });

    function validarEmail(email) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    }
    
    // Event delegation para eliminar filas
    tablaTareas.addEventListener('click', function(e) {
        if (e.target.classList.contains('btnEliminar')) {
            if (confirm("¿Eliminar esta tarea?")) {
                e.target.closest('tr').remove();
                mostrarMensaje("Tarea eliminada");
            }
        }
    });

    // Agregar nueva fila
    btnAgregarFila.addEventListener('click', agregarNuevaFila);

    // Funciones auxiliares
    function mostrarMensaje(texto, color = "green") {
        mensajeDiv.textContent = texto;
        mensajeDiv.style.color = color;
        setTimeout(() => mensajeDiv.textContent = "", 5000);
    }

    function obtenerTimestamp() {
        return new Date().toISOString();
    }

    function crearSelect(opciones = [], placeholder = "Seleccionar") {
        const select = document.createElement('select');
        select.innerHTML = `<option value="">${placeholder}</option>`;
        opciones.forEach(opcion => {
            select.innerHTML += `<option value="${opcion}">${opcion}</option>`;
        });
        return select;
    }

    function crearTextarea(placeholder) {
        const textarea = document.createElement('textarea');
        textarea.placeholder = placeholder;
        return textarea;
    }

    function crearBoton(texto, clase) {
        const boton = document.createElement('button');
        boton.textContent = texto;
        boton.classList.add(clase);
        return boton;
    }

    async function guardarTarea(tareaData) {
        try {
            const respuesta = await fetch("http://localhost:8000/tarea", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(tareaData)
            });
            const resultado = await respuesta.json();
            mostrarMensaje(resultado.mensaje || "Tarea guardada en sistema");
            setTimeout(() => agregarNuevaFila(), 500);
        } catch (error) {
            mostrarMensaje("Error al guardar tarea: " + error.message, "red");
        }
    }

    function agregarFilaInicial() {
        const fila = tablaTareas.insertRow();
        configurarFila(fila);
    }

    function agregarNuevaFila() {
        const fila = tablaTareas.insertRow();
        configurarFila(fila);
        mostrarMensaje("Nueva fila agregada");
    }

    function configurarFila(fila) {
        // Celdas
        const celdaTask = fila.insertCell(0);
        const celdaSubtask = fila.insertCell(1);
        const celdaCompleted = fila.insertCell(2);
        const celdaInicio = fila.insertCell(3);
        const celdaFin = fila.insertCell(4);
        const celdaAcciones = fila.insertCell(5);
        const celdaComentario = fila.insertCell(6);

        // Task select
        const selectTask = crearSelect(Object.keys(tareasSubtareas), "Seleccionar Task");
        celdaTask.appendChild(selectTask);

        // Subtask select
        const selectSubtask = crearSelect([], "Seleccionar Subtask");
        selectSubtask.disabled = true;
        celdaSubtask.appendChild(selectSubtask);

        // Comentario
        const textareaComentario = crearTextarea("Agregar comentario...");
        celdaComentario.appendChild(textareaComentario);

        // Timestamps
        celdaInicio.textContent = "--";
        celdaFin.textContent = "--";

        // Checkbox
        const checkboxCompleted = document.createElement('input');
        checkboxCompleted.type = "checkbox";
        celdaCompleted.appendChild(checkboxCompleted);

        // Botón Eliminar
        const btnEliminar = crearBoton("Eliminar", "btnEliminar");
        celdaAcciones.appendChild(btnEliminar);

        // Eventos
        selectTask.addEventListener('change', function() {
            selectSubtask.disabled = false;
            selectSubtask.innerHTML = '<option value="">Seleccionar Subtask</option>';
            tareasSubtareas[selectTask.value].forEach(subtask => {
                selectSubtask.innerHTML += `<option value="${subtask}">${subtask}</option>`;
            });
            const ahora = obtenerTimestamp();
            celdaInicio.textContent = new Date(ahora).toLocaleString();
            fila.dataset.startedAt = ahora;
        });

        checkboxCompleted.addEventListener('change', async function() {
            if (checkboxCompleted.checked) {
                const ahora = obtenerTimestamp();
                celdaFin.textContent = new Date(ahora).toLocaleString();
                fila.dataset.endAt = ahora;
                selectTask.disabled = true;
                selectSubtask.disabled = true;
                textareaComentario.disabled = true;
                checkboxCompleted.disabled = true;
                const tareaData = {
                    email: tecnicoEmail,
                    task: selectTask.value,
                    subtask: selectSubtask.value,
                    completed: true,
                    started_at: fila.dataset.startedAt,
                    end_at: fila.dataset.endAt,
                    comentario: textareaComentario.value
                };
                await guardarTarea(tareaData);
            }
        });
    }
});
