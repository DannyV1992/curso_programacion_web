const frutas = ["Manzanas", "Banana", "Piña", "Sandia"];

console.log("Frutas: ", frutas);
console.log("Frutas: ", frutas[0])

//Metodos array
frutas.push("Uva");
console.log("Frutas: ", frutas);

frutas.splice(1,1);
console.log("Frutas: ", frutas);

//Objetos
const persona = {
    nombre: "Carlos",
    edad: 55,
    profesion: "Ingeniero",
    saludar: function(){
        return "Hola soy " + this.nombre;
    }
}

console.log(persona.saludar())

//Map
const longitudes = frutas.map(e => e.length);
console.log("Longitudes de las frutas: ", longitudes);

//forEach
frutas.forEach(
    (fruta, indice) => {
        console.log(`Fruta ${indice + 1}: ${fruta}`);
    }
);