// Ejercicio 10 - Tipos de Operadores
// Ejecutar con: node 10-operadores.js

/*
  CONSIGNAS:
  1) Creá una función llamada estaEnRangoPar(numero).
  2) Tiene que devolver true solamente si se cumplen estas tres condiciones:
     - el número está entre 10 y 50;
     - el número es par;
     - el número no es negativo.
  3) Usá operadores relacionales, lógicos y aritméticos.
  4) Probá la función con estos casos:
     - 12
     - 11
     - 9
     - 50
     - 51
     - -12
*/

// Escribí tu código acá 👇

function estaEnRangoPar(numero) {
  let verdad = false;
  let rango = false;
  let esPar = false;

  rango = numero >= 10 && numero <= 50;
  esPar = numero % 2 === 0;

  verdad = rango && esPar;
  return verdad;
}

console.log(estaEnRangoPar(12));
console.log(estaEnRangoPar(11));
console.log(estaEnRangoPar(9));
console.log(estaEnRangoPar(50));
console.log(estaEnRangoPar(51));
console.log(estaEnRangoPar(-12));
