const API_BASE = 'http://localhost:8001';

let editingMascotaId = null;

// Elementos del DOM
const mascotaForm = document.getElementById('mascotaForm');
const mascotasList = document.getElementById('mascotasList');
const submitBtn = document.getElementById('submitBtn');
const submitText = document.getElementById('submitText');
const cancelBtn = document.getElementById('cancelBtn');
const formTitle = document.getElementById('formTitle');

// Inicializar aplicación
document.addEventListener('DOMContentLoaded', function() {
    cargarMascotas();
    cargarDatosExternos();
    
    mascotaForm.addEventListener('submit', manejarSubmit);
    cancelBtn.addEventListener('click', cancelarEdicion);
});

// Función para mostrar toast notifications
function showToast(message, type = 'success') {
    const toast = document.getElementById('toast');
    const toastIcon = document.getElementById('toastIcon');
    const toastMessage = document.getElementById('toastMessage');
    
    const icons = {
        success: '✅',
        error: '❌',
        info: 'ℹ️'
    };
    
    const colors = {
        success: 'border-green-500',
        error: 'border-red-500',
        info: 'border-blue-500'
    };
    
    toastIcon.textContent = icons[type];
    toastMessage.textContent = message;
    
    // Remover clases de color anteriores y agregar nueva
    toast.firstElementChild.className = `bg-white rounded-lg shadow-lg border-l-4 ${colors[type]} p-4 max-w-sm`;
    
    // Mostrar toast
    toast.classList.remove('translate-x-full');
    toast.classList.add('translate-x-0');
    
    // Ocultar después de 3 segundos
    setTimeout(() => {
        toast.classList.remove('translate-x-0');
        toast.classList.add('translate-x-full');
    }, 3000);
}

// Funciones CRUD
async function cargarMascotas() {
    try {
        const response = await fetch(`${API_BASE}/mascotas`);
        if (!response.ok) throw new Error('Error al cargar mascotas');
        
        const mascotas = await response.json();
        mostrarMascotas(mascotas);
    } catch (error) {
        console.error('Error:', error);
        mascotasList.innerHTML = `
            <div class="text-center py-8">
                <div class="text-red-500 text-6xl mb-4">😞</div>
                <p class="text-red-600 font-medium">Error al cargar las mascotas</p>
                <button onclick="cargarMascotas()" class="mt-4 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition">
                    Reintentar
                </button>
            </div>
        `;
    }
}

function mostrarMascotas(mascotas) {
    if (mascotas.length === 0) {
        mascotasList.innerHTML = `
            <div class="text-center py-12">
                <div class="text-gray-400 text-6xl mb-4">🐾</div>
                <p class="text-gray-600 text-lg font-medium">No hay mascotas registradas</p>
                <p class="text-gray-500 text-sm mt-2">¡Agrega la primera mascota usando el formulario!</p>
            </div>
        `;
        return;
    }

    const mascotasHTML = mascotas.map(mascota => {
        const especieEmoji = {
            'perro': '🐕',
            'gato': '🐱',
            'otro': '🐾'
        };

        const estadoStyles = {
            'disponible': 'bg-green-100 text-green-800 border-green-200',
            'adoptado': 'bg-red-100 text-red-800 border-red-200'
        };

        const estadoEmoji = {
            'disponible': '✅',
            'adoptado': '🏠'
        };

        return `
            <div class="bg-gradient-to-r from-white to-gray-50 rounded-lg border border-gray-200 p-6 hover:shadow-md transition-all duration-200 hover:scale-102">
                <div class="flex justify-between items-start mb-4">
                    <div class="flex items-center">
                        <span class="text-2xl mr-3">${especieEmoji[mascota.especie]}</span>
                        <div>
                            <h3 class="text-xl font-bold text-gray-800">${mascota.nombre}</h3>
                            <p class="text-gray-600 capitalize">${mascota.especie}</p>
                        </div>
                    </div>
                    <span class="px-3 py-1 rounded-full text-xs font-medium border ${estadoStyles[mascota.estado]}">
                        ${estadoEmoji[mascota.estado]} ${mascota.estado}
                    </span>
                </div>
                
                <div class="space-y-2 mb-4">
                    <div class="flex items-center text-gray-600">
                        <span class="font-medium mr-2">🎂 Edad:</span>
                        <span>${mascota.edad || 'No especificada'} años</span>
                    </div>
                    <div class="text-gray-600">
                        <span class="font-medium">📝 Descripción:</span>
                        <p class="mt-1 text-sm leading-relaxed">${mascota.descripcion || 'Sin descripción disponible'}</p>
                    </div>
                </div>
                
                <div class="flex gap-2">
                    <button onclick="editarMascota(${mascota.id})" 
                            class="flex-1 bg-yellow-500 text-white py-2 px-4 rounded-lg text-sm font-medium hover:bg-yellow-600 transition duration-200 flex items-center justify-center">
                        <span class="mr-1">✏️</span>
                        Editar
                    </button>
                    <button onclick="eliminarMascota(${mascota.id})" 
                            class="flex-1 bg-red-500 text-white py-2 px-4 rounded-lg text-sm font-medium hover:bg-red-600 transition duration-200 flex items-center justify-center">
                        <span class="mr-1">🗑️</span>
                        Eliminar
                    </button>
                </div>
            </div>
        `;
    }).join('');

    mascotasList.innerHTML = mascotasHTML;
}

async function manejarSubmit(e) {
    e.preventDefault();
    
    // Deshabilitar botón durante el envío
    submitBtn.disabled = true;
    submitBtn.classList.add('opacity-50');
    const originalText = submitText.textContent;
    submitText.textContent = 'Guardando...';
    
    const mascotaData = {
        nombre: document.getElementById('nombre').value.trim(),
        especie: document.getElementById('especie').value,
        edad: document.getElementById('edad').value ? parseInt(document.getElementById('edad').value) : null,
        descripcion: document.getElementById('descripcion').value.trim(),
        estado: document.getElementById('estado').value
    };

    try {
        let response;
        if (editingMascotaId) {
            response = await fetch(`${API_BASE}/mascotas/${editingMascotaId}`, {
                method: 'PUT',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(mascotaData)
            });
        } else {
            response = await fetch(`${API_BASE}/mascotas`, {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(mascotaData)
            });
        }

        if (!response.ok) throw new Error('Error al guardar mascota');

        const result = await response.json();
        showToast(result.message, 'success');
        
        mascotaForm.reset();
        cancelarEdicion();
        cargarMascotas();
    } catch (error) {
        console.error('Error:', error);
        showToast('Error al guardar la mascota', 'error');
    } finally {
        // Rehabilitar botón
        submitBtn.disabled = false;
        submitBtn.classList.remove('opacity-50');
        submitText.textContent = originalText;
    }
}

async function editarMascota(id) {
    try {
        const response = await fetch(`${API_BASE}/mascotas`);
        const mascotas = await response.json();
        const mascota = mascotas.find(m => m.id === id);
        
        if (!mascota) throw new Error('Mascota no encontrada');

        // Llenar formulario con datos existentes
        document.getElementById('nombre').value = mascota.nombre;
        document.getElementById('especie').value = mascota.especie;
        document.getElementById('edad').value = mascota.edad || '';
        document.getElementById('descripcion').value = mascota.descripcion || '';
        document.getElementById('estado').value = mascota.estado;

        editingMascotaId = id;
        formTitle.textContent = 'Editar Mascota';
        submitText.textContent = 'Actualizar Mascota';
        cancelBtn.style.display = 'block';
        
        // Scroll al formulario con animación suave
        document.querySelector('.container').scrollIntoView({ 
            behavior: 'smooth',
            block: 'start'
        });
        
        // Highlight del formulario
        const formSection = mascotaForm.closest('section');
        formSection.classList.add('ring-2', 'ring-primary', 'ring-opacity-50');
        setTimeout(() => {
            formSection.classList.remove('ring-2', 'ring-primary', 'ring-opacity-50');
        }, 2000);
        
    } catch (error) {
        console.error('Error:', error);
        showToast('Error al cargar datos de la mascota', 'error');
    }
}

function cancelarEdicion() {
    editingMascotaId = null;
    formTitle.textContent = 'Registrar Nueva Mascota';
    submitText.textContent = 'Registrar Mascota';
    cancelBtn.style.display = 'none';
    mascotaForm.reset();
}

async function eliminarMascota(id) {
    // Modal de confirmación personalizado
    if (!confirm('¿Estás seguro de que quieres eliminar esta mascota?\n\nEsta acción no se puede deshacer.')) return;

    try {
        const response = await fetch(`${API_BASE}/mascotas/${id}`, {
            method: 'DELETE'
        });

        if (!response.ok) throw new Error('Error al eliminar mascota');

        const result = await response.json();
        showToast(result.message, 'success');
        cargarMascotas();
    } catch (error) {
        console.error('Error:', error);
        showToast('Error al eliminar la mascota', 'error');
    }
}

// Datos externos
async function cargarDatosExternos() {
    try {
        const response = await fetch(`${API_BASE}/api/external-pet-data`);
        if (!response.ok) throw new Error('Error al cargar datos externos');
        
        const data = await response.json();
        
        // Mostrar razas de perros
        const dogBreedsHTML = data.dog_breeds.map(breed => 
            `<span class="inline-block bg-white bg-opacity-60 backdrop-blur-sm px-3 py-1 rounded-full text-sm font-medium text-gray-700 border border-gray-200 m-1 hover:bg-opacity-80 transition">${breed}</span>`
        ).join('');
        document.getElementById('dogBreeds').innerHTML = `<div class="flex flex-wrap -m-1">${dogBreedsHTML}</div>`;
        
        // Mostrar dato curioso de gatos
        document.getElementById('catFact').innerHTML = `
            <p class="text-gray-700 leading-relaxed italic">
                "${data.cat_fact}"
            </p>
        `;
        
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('dogBreeds').innerHTML = `
            <div class="text-red-500 text-center py-4">
                <span class="block text-2xl mb-2">😞</span>
                Error al cargar razas
            </div>
        `;
        document.getElementById('catFact').innerHTML = `
            <div class="text-red-500 text-center py-4">
                <span class="block text-2xl mb-2">😞</span>
                Error al cargar dato curioso
            </div>
        `;
    }
}

// Agregar efectos de hover y animaciones adicionales
document.addEventListener('DOMContentLoaded', function() {
    // Animación de entrada para el header
    const header = document.querySelector('header');
    header.style.opacity = '0';
    header.style.transform = 'translateY(-20px)';
    
    setTimeout(() => {
        header.style.transition = 'all 0.8s ease-out';
        header.style.opacity = '1';
        header.style.transform = 'translateY(0)';
    }, 100);
    
    // Animación escalonada para las secciones
    const sections = document.querySelectorAll('main section');
    sections.forEach((section, index) => {
        section.style.opacity = '0';
        section.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            section.style.transition = 'all 0.6s ease-out';
            section.style.opacity = '1';
            section.style.transform = 'translateY(0)';
        }, 200 + (index * 150));
    });
});
