// Ejercicio 11 - Condicionales
// Ejecutar con: node 11-condicionales.js

/*
  CONSIGNAS:
  1) Creá una función llamada estacionDelAnio(mes).
  2) Recibe un número del 1 al 12 y devuelve la estación del año.
  3) Usá hemisferio sur:
     - 12, 1, 2: verano
     - 3, 4, 5: otoño
     - 6, 7, 8: invierno
     - 9, 10, 11: primavera
  4) Si el mes no está entre 1 y 12, devolvé "mes inválido".
  5) Hacelo primero con if / else if / else.
  6) Probá la función con estos casos:
     - 1
     - 4
     - 7
     - 10
     - 12
     - 13
*/

// Escribí tu código acá 👇

function estacionDelAnio(mes) {
  if ((mes >= 1 && mes <= 2) || mes === 12) {
    return `Estas en verano`;
  } else if (mes >= 3 && mes <= 5) {
    return `Estas en otoño`;
  } else if (mes >= 6 && mes <= 8) {
    return `Estas en invierno`;
  } else if (mes >= 9 && mes <= 11) {
    return `Estas en primavera`;
  } else {
    return `Mes invalido`;
  }
}

console.log(estacionDelAnio(1));
console.log(estacionDelAnio(4));
console.log(estacionDelAnio(7));
console.log(estacionDelAnio(10));
console.log(estacionDelAnio(12));
console.log(estacionDelAnio(13));
