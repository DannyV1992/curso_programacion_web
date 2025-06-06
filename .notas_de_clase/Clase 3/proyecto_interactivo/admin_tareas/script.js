const form = document.getElementById("formTarea");
const tabla = document.getElementById("tablaTareas").querySelector("tbody");

form.addEventListener("submit", function (e) {
  e.preventDefault();

  const titulo = document.getElementById("titulo").value.trim();
  const descripcion = document.getElementById("descripcion").value.trim();
  const fecha = document.getElementById("fecha").value;
  const estado = document.getElementById("estado").value;

  if (titulo === "" || descripcion === "" || fecha === "") {
    alert("Por favor, complete todos los campos.");
    return;
  }

  agregarTarea(titulo, descripcion, fecha, estado);
  form.reset();
});

function agregarTarea(titulo, descripcion, fecha, estado) {
  const fila = document.createElement("tr");

  fila.innerHTML = `
    <td>${titulo}</td>
    <td>${descripcion}</td>
    <td>${fecha}</td>
    <td class="estado-${estado.replace(' ', '-')}">${estado}</td>
    <td><button class="btn-eliminar">Eliminar</button></td>
  `;

  // Botón eliminar
  fila.querySelector("button").addEventListener("click", function () {
    fila.remove();
  });

  tabla.appendChild(fila);
}
