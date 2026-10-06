// Ejercicio 09 - Objetos
// Ejecutar con: node 09-objetos.js

/*
  CONSIGNAS:
  1) Creá un objeto persona con:
     - nombre, apellido, edad (atributos)
     - pasatiempos: un ARRAY con 3 hobbies (anidando lo del video anterior)
     - contacto: un OBJETO adentro con email y twitter (objeto anidado)
     - un método saludar() que use this para mostrar:
       "Hola, me llamo NOMBRE APELLIDO y tengo EDAD años"

  2) Accedé a:
     - Una propiedad por punto (persona.nombre)
     - Una propiedad por corchetes (persona["edad"])
     - Una propiedad anidada (persona.contacto.twitter)
     - Un elemento del array de pasatiempos

  3) Mostrá con Object.keys() y Object.values() qué tiene el objeto.
     Y probá: persona.hasOwnProperty("nombre") y persona.hasOwnProperty("mascota")

  4) Preguntas para comentar:
     - ¿Podés usar this dentro de un método? ¿Qué hace?
     - ¿Los objetos con const se pueden modificar? (conexión con el video anterior)
*/

// Escribí tu código acá 👇

const persona = {
  nombre: "Lucas",
  apellido: "Ortiz",
  edad: 21,
  pasatiempos: ["Codear", "Tocar la guitarra", "Jugar a la pelota"],
  contacto: {
    email: "lucaseortiz45@gmail.com",
    x: "lucass45"
  },
  saludar: function () {
    console.log(`Hola, me llamo ${this.nombre} ${this.apellido} y tengo ${this.edad} años`);
  }
}

console.log(persona.nombre);

console.log(persona["edad"]);

console.log(persona.contacto.email);

console.log(persona.pasatiempos[1]);

console.log(Object.keys(persona));

console.log(Object.values(persona));

console.log(persona.hasOwnProperty("nombre"));
console.log(persona.hasOwnProperty("mascota"));
