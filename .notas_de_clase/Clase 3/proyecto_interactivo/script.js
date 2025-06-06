function saludarUsario(){
    const input = document.getElementById("nombreUsuario");
    const nombre = input.value.trim();
    const mensaje = document.getElementById("mensaje");

    if (nombre == ""){
        mensaje.textContent = "Por favor, ingrese un nombre válido.";
        mensaje.style.color = "red";
    } else {
        mensaje.textContent = `Hola, ${nombre}! Que bueno verte aquí.`;
        mensaje.style.color = "green";
    }
}