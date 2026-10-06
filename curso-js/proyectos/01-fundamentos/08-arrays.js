// Ejercicio 08 - Arreglos (Arrays)
// Ejecutar con: node 08-arrays.js

/*
  CONSIGNAS:
  1) Creá un array de colores: ["Rojo", "Verde", "Azul"].
     - Mostrá su longitud (.length)
     - Agregá "Negro" al final (.push())
     - Sacá el último (.pop()) y mostralo
     - Mostrá un elemento por su índice (ej: colores[1])

  2) Recorré el array con .forEach() y mostrá cada color con su posición:
     ej: "Rojo esta en la posicion 0"

  3) Jugá con los constructores:
     - Array.of("X", "Y", "Z") → ¿qué devuelve?
     - Array(10).fill("🧪") → ¿qué devuelve? ¿para qué serviría?

  4) Preguntas para comentar:
     - Declaraste el array con const... ¿pudiste hacer push? ¿Por qué?
     - ¿Cuál es la diferencia entre .push() y .pop()?
*/

// Escribí tu código acá 👇

const colores = ["Rojo", "Verde", "Azul"];
console.log(colores.length);

colores.push("Negro");
console.log(colores);

colores.pop();
console.log(colores);

colores.forEach(function (color, index){
  console.log(`${color} esta en la posicion ${index}`)
})

console.log(Array.of("X", "Y", "Z"));

console.log(Array(10).fill("67"));
