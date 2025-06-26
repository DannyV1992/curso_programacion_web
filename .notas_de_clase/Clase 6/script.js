const form = document.getElementById("formLead");
const mensaje = document.getElementById("mensaje");

form.addEventListener("submit", async function(e) {
    e.preventDefault();
    const datos = Object.fromEntries(new FormData(form));

    const respuesta = await fetch("http://localhost:8000/guardar-lead", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(datos)
    });

    const resultado = await respuesta.json();
    mensaje.textContent = resultado.mensaje;
    mensaje.style.color = "green";
    form.reset();
});
