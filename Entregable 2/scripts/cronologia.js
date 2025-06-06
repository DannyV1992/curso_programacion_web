document.addEventListener("DOMContentLoaded", function () {
    const eventos = [
        {
            anio: 1687,
            titulo: "Leyes del movimiento",
            descripcion: "Isaac Newton publica los Principia, estableciendo las leyes fundamentales del movimiento y la gravitación universal."
        },
        {
            anio: 1869,
            titulo: "Tabla periódica",
            descripcion: "Dmitri Mendeléyev presenta la primera versión de la tabla periódica de los elementos, organizando los elementos conocidos según sus propiedades."
        },
        {
            anio: 1928,
            titulo: "Descubrimiento de la penicilina",
            descripcion: "Alexander Fleming descubre la penicilina, el primer antibiótico, revolucionando la medicina moderna."
        },
        {
            anio: 1953,
            titulo: "Estructura del ADN",
            descripcion: "James Watson y Francis Crick describen la estructura de doble hélice del ADN, base de la genética moderna."
        },
        {
            anio: 1969,
            titulo: "Llegada a la Luna",
            descripcion: "La misión Apolo 11 logra el primer alunizaje tripulado. Neil Armstrong y Buzz Aldrin caminan sobre la superficie lunar."
        }
    ];

    const botones = document.querySelectorAll(".evento");
    const detalle = document.getElementById("detalleEvento");

    botones.forEach(function (btn) {
        btn.addEventListener("click", function () {
            // Remueve la clase 'active' de todos los botones
            botones.forEach(function (b) {
                b.classList.remove("active");
            });
            // Agrega la clase 'active' al botón actual
            btn.classList.add("active");

            const idx = parseInt(btn.getAttribute("data-idx"));
            const evento = eventos[idx];
            detalle.innerHTML = `
                <h3>${evento.anio}: ${evento.titulo}</h3>
                <p>${evento.descripcion}</p>
            `;
        });
    });
});

