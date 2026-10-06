// Ejercicio 02 - Cadenas de Texto (Strings)
// Ejecutar con: node 02-strings.js

/*
  CONSIGNAS:
  Creá una función que reciba una cadena de texto y devuelva (mostrá todo con console.log):
  1) La longitud del string (.length)
  2) La versión en MAYÚSCULAS (.toUpperCase())
  3) La versión en minúsculas (.toLowerCase())
  4) Si contiene la palabra "JavaScript" (.includes())
  5) La cantidad de palabras, convirtiendo el string a un array (.split(" "))
  6) El string sin espacios de más al inicio y al final (.trim())

  Consejo: probá tu función con un string que tenga espacios al inicio y al final,
  así ves para qué sirve .trim().
*/

const texto = ' Hola como estas, yo bien y vos, yo tambien que bueno ';

function analizarTexto(string) {
  console.log(string.length);
  console.log(string.toUpperCase());
  console.log(string.toLowerCase());
  console.log(string.includes('JavaScript'));
  const trimString = string.trim();
  console.log(trimString.split(' ').length);
  console.log(trimString);
}

analizarTexto(texto);
// Escribí tu código acá 👇
