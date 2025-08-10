document.addEventListener("DOMContentLoaded", () => {
    const contentSection = document.getElementById("content-section");
    
    // Configuración de rutas RELATIVAS correctas
    const routes = {
        home: { 
            html: 'frontend/htmls/home-content.html',
            css: 'frontend/css/home.css',
            isHome: true
        },
        tasks: { 
            html: 'frontend/htmls/tareas.html',
            css:'frontend/css/tareas.css'
        },
        pets: { 
            html: 'frontend/htmls/mascotas.html',
            css: 'frontend/css/mascotas.css'
        },
        adopters: { 
            html: 'frontend/htmls/adoptantes.html',
            css: 'frontend/css/adoptantes.css'
        },
        vets: { 
            html: 'frontend/htmls/veterinarios.html',
            css: 'frontend/css/veterinarios.css'
        },
        volunteers: { 
            html: 'frontend/htmls/voluntarios.html',
            css: 'frontend/css/voluntarios.css'
        },
        inventory: { 
            html: 'frontend/htmls/inventario.html',
            css: 'frontend/css/inventario.css'
        },
        donations: { 
            html: 'frontend/htmls/donaciones.html',
            css: 'frontend/css/donaciones.css'
        }
    };

    // Función mejorada para cargar contenido
    const loadContent = async (url) => {
        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error(`Error ${response.status}`);
            return await response.text();
        } catch (error) {
            console.error('Error al cargar:', url, error);
            return `
                <div class="error-content">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Error al cargar</h3>
                    <p>${error.message}</p>
                    <p>Archivo: ${url}</p>
                </div>
            `;
        }
    };

    // Cargar sección
    const loadSection = async (section) => {
        const route = routes[section];
        if (!route) return;

        contentSection.innerHTML = `<div class="loading">Cargando...</div>`;
        
        try {
            const html = await loadContent(route.html);
            contentSection.innerHTML = html;
            
            // Cargar CSS dinámico
            document.querySelectorAll('link[data-dynamic-css]').forEach(link => link.remove());
            const link = document.createElement('link');
            link.rel = 'stylesheet';
            link.href = route.css;
            link.setAttribute('data-dynamic-css', 'true');
            document.head.appendChild(link);

        } catch (error) {
            console.error('Error:', error);
            contentSection.innerHTML = `
                <div class="error-content">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Error en ${section}</h3>
                    <p>${error.message}</p>
                </div>
            `;
        }
    };

    // Configurar eventos del menú lateral
    document.querySelectorAll(".nav-item").forEach(item => {
        item.addEventListener("click", (e) => {
            e.preventDefault();
            const section = item.getAttribute("data-section");

            document.querySelectorAll(".nav-item").forEach(el => 
                el.classList.remove("active"));
            item.classList.add("active");

            loadSection(section);
        });
    });

    // Agregar soporte a botones internos de tipo .btn-cta
    document.addEventListener("click", (e) => {
        if (e.target.classList.contains("btn-cta")) {
            const section = e.target.dataset.section;
            const targetNav = document.querySelector(`.nav-item[data-section="${section}"]`);
            if (targetNav) targetNav.click(); // Dispara el mismo comportamiento del menú lateral
        }
    });

    // Carga inicial
    const hash = window.location.hash.substring(1);
    const defaultSection = routes[hash] ? hash : 'home';
    document.querySelector(`.nav-item[data-section="${defaultSection}"]`).click();
});
