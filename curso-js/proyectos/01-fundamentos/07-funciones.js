// Ejercicio 07 - Funciones
// Ejecutar con: node 07-funciones.js

/*
  CONSIGNAS:
  1) Declará una función DECLARADA (function saludar()) que reciba un nombre
     y un parámetro por defecto (edad = 0). Que muestre:
     "Hola, mi nombre es X y tengo X años."
     - Llamala con nombre y edad
     - Llamala solo con nombre (para ver el valor por defecto)

  2) Ahora la parte del hoisting:
     - Invocá una función DECLARADA ANTES de su declaración en el código.
       ¿Funciona? ¿Por qué?
     - Después, intentá invocar una función EXPRESADA (const f = function() {})
       antes de su definición. ¿Qué error da?

  3) Creá una función que calcule el área de un rectángulo
     (base * altura) y devuelva el resultado (usá return).

  4) Bonus: ¿podés pasarle más argumentos de los que tiene la función?
     Probá una función de 2 parámetros y llamala con 4 argumentos.
     ¿Qué pasa con los argumentos extra?
*/

// Escribí tu código acá 👇

console.log(saludar("Lucas", 21));
console.log(saludar("Lucas"));

function saludar(nombre, edad = 0) {
  return `Hola, soy ${nombre}, y tengo ${edad} años.`;
}

// console.log(f);
//
// const f = function() {};

 function areaRectangulo(base, altura) {
   return (base * altura);
 }

console.log(areaRectangulo(2, 3));
