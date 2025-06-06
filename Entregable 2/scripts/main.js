document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("formPregunta");
    const listaPreguntas = document.getElementById("listaPreguntas");
    const seccionPreguntas = document.getElementById("preguntasRecibidas");
    const mensajeError = document.getElementById("mensajeError");

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        // Obtener valores
        const nombre = document.getElementById("nombre").value.trim();
        const email = document.getElementById("email").value.trim();
        const pregunta = document.getElementById("preguntaTxt").value.trim();

        // Validación básica
        if (nombre === "" || email === "" || pregunta === "") {
        mensajeError.textContent = "Por favor, completa todos los campos.";
        return;
        }

        // Validación de formato de email (simple)
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        mensajeError.textContent = "Introduce un correo electrónico válido.";
        return;
        }

        mensajeError.textContent = "";

        // Crear elemento de pregunta
        const li = document.createElement("li");
        li.innerHTML = `<strong>${nombre}</strong> pregunta: <em>${pregunta}</em>`;

        listaPreguntas.appendChild(li);

        // Mostrar la sección si está oculta
        seccionPreguntas.style.display = "block";

        // Limpiar el formulario
        form.reset();
    });
});
