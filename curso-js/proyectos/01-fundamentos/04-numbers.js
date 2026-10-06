// Ejercicio 04 - Números
// Ejecutar con: node 04-numbers.js

/*
  CONSIGNAS:
  1) Declará un número con decimales (ej: 7.1987).
     Mostrá sus decimales redondeados a 1, 2 y 3 posiciones usando .toFixed().
     Fijate qué tipo de dato devuelve .toFixed() (¿número o string?) — investigá con typeof.

  2) Declará un STRING numérico (ej: "5.6") y un número real (ej: 2).
     Sumalos. ¿Qué pasa? Ahora convertí el string a número y sumalo de nuevo.
     Probá las 3 formas de conversión:
     - parseInt()
     - parseFloat()
     - Number()

  3) Mostrá con console.log y typeof() qué tipo de dato es:
     - un número entero
     - un número con decimales
     - un string numérico
     - parseInt() de un string
     - parseFloat() de un string

  Preguntas para responder en comentarios:
  - ¿Qué diferencia hay entre parseInt() y parseFloat()?
  - ¿Qué pasa si sumás "5.6" + 2 sin convertir? ¿Por qué?
*/

const A = 7.1987;

console.log(typeof(A.toFixed(1)));
console.log(A.toFixed(1));
console.log(A.toFixed(2));
console.log(A.toFixed(3));

const B = "5.6";
const C = 2;

console.log(B + C);
console.log(parseInt(B) + C);
console.log(parseFloat(B) + C);
console.log(Number(B) + C);

const D = 5;
const E = 4.5;
const F = "2";
const G = parseInt("3");
const H = parseFloat("4.3");

console.log(typeof(D));
console.log(typeof(E));
console.log(typeof(F));
console.log(typeof(G));
console.log(typeof(H));

// Escribí tu código acá 👇
