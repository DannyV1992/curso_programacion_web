function procesarDato(dato, functionCallBack) {
    console.log("Procesando dato...")
    functionCallBack(dato)
}

procesarDato("mensaje", function (dato){
    console.log("Dato recibido...", dato.toUpperCase())
    }
)

//Destructuracion
const producto = {
    id:1,
    nombre:"Laptop",
    precio:750
}

const {id,nombre,precio} = producto;
console.log(`Producto: ${nombre} cuesta ${precio}`);

//Spread operator
const numero1 = [1,2,3];
const numero2 = [4,5,6];
const todos = [...numero1, ...numero2];
console.log("Todos los numeros", todos)