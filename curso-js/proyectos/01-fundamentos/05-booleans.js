// Ejercicio 05 - Booleans
// Ejecutar con: node 05-booleans.js

/*
  CONSIGNAS:
  1) Mostrá con Boolean() qué devuelve cada uno de estos valores (son los "falsy" clásicos):
     - 0
     - ""
     - null
     - undefined
     - NaN
     - false (directo)
     ¿Qué tienen en común?

  2) Ahora probá estos (los "truthy"):
     - -7
     - " " (un espacio)
     - []
     - {}
     - "false" (string con la palabra)
     ¿Algo te sorprende?

  3) Bonus — lógica con valores falsy:
     Sin usar if/else, mostrá el resultado de:
     - false || "valor por defecto"
     - 0 || 42
     - "hola" && "mundo"
     - "" && "nunca llego"
     - null || "café"
     Pregunta para comentar: ¿qué patrón ves con || y con &&?
*/

console.log(Boolean(0));
console.log(Boolean(""));
console.log(Boolean(null));
console.log(Boolean(undefined));
console.log(Boolean(NaN));
console.log(Boolean(false));

console.log(Boolean(-7));
console.log(Boolean(" "));
console.log(Boolean([]));
console.log(Boolean({}));
console.log(Boolean("false"));

console.log("------------------------------------------------------")

console.log(Boolean(false || "valor por defecto"));
console.log(Boolean(0 || 42));
console.log(Boolean("hola" && "mundo"));
console.log(Boolean("" && "nunca llego"));
console.log(Boolean(null || "café"));

// Escribí tu código acá 👇
