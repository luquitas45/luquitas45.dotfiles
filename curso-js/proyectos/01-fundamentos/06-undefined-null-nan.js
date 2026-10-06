// Ejercicio 06 - undefined, null & NaN
// Ejecutar con: node 06-undefined-null-nan.js

/*
  CONSIGNAS:
  1) undefined:
     - Declará una variable SIN asignarle valor y mostrala.
     - ¿Qué tipo tiene? (typeof)

  2) null:
     - Declará una variable con valor null y mostrala.
     - ¿Qué tipo tiene? (typeof) → este es EL detalle famoso del video.

  3) NaN (Not a Number):
     - Generalo: "hola" * 3.7 → ¿qué devuelve?
     - ¿Qué tipo tiene? (typeof)

  4) Investigación:
     - ¿Es NaN igual a NaN? probá: NaN === NaN
     - ¿Cómo se verifica si algo es NaN? (investigá sobre Number.isNaN() o isNaN())

  5) Preguntas para responder en comentarios:
     - ¿Cuál es la diferencia entre undefined y null?
     - ¿Cuándo usarías cada uno?
*/

// Escribí tu código acá 👇

let indefinida;
console.log(indefinida);
console.log(typeof(indefinida));

let nulo = null;
console.log(nulo);
console.log(typeof(nulo));

console.log("hola" * 3.7);
console.log(typeof("hola" * 3.7));

console.log(NaN === NaN);
