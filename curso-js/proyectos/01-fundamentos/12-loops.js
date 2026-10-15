// Ejercicio 12 - Ciclos (Loops)
// Ejecutar con: node 12-loops.js

/*
  CONSIGNAS:
  1) Creá una función llamada tablaDeMultiplicar(numero).
  2) Tiene que devolver la tabla de multiplicar del 1 al 10.
  3) Hacé una versión con for.
  4) Después hacé la misma tabla con while.
  5) Si querés, probá también con do while.
  6) Probá con el número 5 y mostrá los resultados.
*/

// Escribí tu código acá 👇

function tablaDeMultiplicar(numero) {
  for (let i = 1; i <= 10; i++) {
    console.log(`${numero} por ${i} = ${numero * i}`);
  }
  console.log(`Esa fue con for, ahora con while`);
  let contador = 1;
  while (contador <= 10) {
    console.log(`${numero} por ${contador} = ${numero * contador}`);
    contador++;
  }
}

tablaDeMultiplicar(5);
