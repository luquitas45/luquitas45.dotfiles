/* Ejecutar con: node 01-variables-let-const.js

/*
  CONSIGNAS:
  1) Declará 3 variables: una con var, una con let y una con const.
  2) Probá REDECLARAR cada una (declararla 2 veces con el mismo nombre).
     ¿Cuáles te dejan? ¿Cuáles te dan error?
  3) Probá REASIGNARLE un valor diferente a cada una.
     ¿Cuáles te dejan cambiar el valor?
  4) Dentro de un bloque {} declará otra vez cada una con un valor distinto.
     Fuera del bloque, ¿qué valor tiene cada una?
  5) Usá console.log() para mostrar todo lo que vaya pasando.
*/

var varVariable = 'var';
let letVariable = 'let';
const constVariable = 'const';

console.log('Primer invocacion: ', varVariable);
console.log('Primer invocacion: ', letVariable);
console.log('Primer invocacion: ', constVariable);

var varVariable = 'var';
// let letVariable = "let";
// const constVariable = "const";

console.log('Segunda invocacion: ', varVariable);
console.log('Segunda invocacion: ', letVariable);
console.log('Segunda invocacion: ', constVariable);

varVariable = '1';
letVariable = '2';
// constVariable = "3";

console.log('Tercera invocacion: ', varVariable);
console.log('Tercera invocacion: ', letVariable);
console.log('Tercera invocacion: ', constVariable);

{
  var varVariable = 'rock';
  let letVariable = 'pop';
  const constVariable = 'blues';

  console.log('Cuarta invocacion: ', varVariable);
  console.log('Cuarta invocacion: ', letVariable);
  console.log('Cuarta invocacion: ', constVariable);
}

console.log('Cuarta invocacion: ', varVariable);
console.log('Cuarta invocacion: ', letVariable);
console.log('Cuarta invocacion: ', constVariable);
// Escribí tu código acá 👇
