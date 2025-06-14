const form = document.getElementById("formLead");
const tabla = document.getElementById("bodyVentas");
const leads = []; // Almacena leads temporalmente en memoria

function mostrarFormulario() {
    document.getElementById("formularioLead").style.display = "block";
    document.getElementById("tablaVentas").style.display = "none";
}

function mostrarTabla() {
    document.getElementById("formularioLead").style.display = "none";
    document.getElementById("tablaVentas").style.display = "block";
    renderizarTabla();
}

form.addEventListener("submit", function (e) {
    e.preventDefault();

    // Obtener valores del formulario
    const lead = {
        contacto: form.nombre.value + " " + form.apellido.value,
        empresa: form.empresa.value,
        telefono: form.telefono.value,
        correo: form.correo.value,
        oportunidad: form.oportunidad.value,
        estado: "Propuesta"
    };

    // Guardar en memoria
    leads.push(lead);

    // Limpiar formulario
    form.reset();

    // Mostrar tabla actualizada
    mostrarTabla();
});

function renderizarTabla() {
    tabla.innerHTML = "";
    leads.forEach((lead, index) => {
        const fila = document.createElement("tr");
        fila.innerHTML = `
            <td>${lead.contacto}</td>
            <td>${lead.empresa}</td>
            <td>${lead.telefono}</td>
            <td>${lead.correo}</td>
            <td>${lead.oportunidad}</td>
            <td>
                <select onchange="cambiarEstado(${index}, this.value)">
                    <option value="Propuesta" ${lead.estado === "Propuesta" ? "selected" : ""}>Propuesta</option>
                    <option value="Negociación" ${lead.estado === "Negociación" ? "selected" : ""}>Negociación</option>
                    <option value="Venta cerrada" ${lead.estado === "Venta cerrada" ? "selected" : ""}>Venta cerrada</option>
                </select>
            </td>
        `;
        tabla.appendChild(fila);
    });
}

function cambiarEstado(index, nuevoEstado) {
    leads[index].estado = nuevoEstado;
}

function exportarCSV() {
    let csv = "Nombre completo,Empresa,Teléfono,Correo,Oportunidad,Estado\n";
    leads.forEach(lead => {
        const fila = `${lead.contacto},${lead.empresa},${lead.telefono},${lead.correo},"${lead.oportunidad}",${lead.estado}`;
        csv += fila + "\n";
    });

    // Crear y descargar archivo CSV
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "leads.csv";
    a.click();
    URL.revokeObjectURL(url);
}

