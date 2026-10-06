// Ejercicio 03 - Template Strings
// Ejecutar con: node 03-template-strings.js

/*
  CONSIGNAS:
  1) Creá una tarjeta de presentación usando template strings (backticks):
     - Nombre, edad, profesión y ciudad como variables
     - Usá interpolación ${} para meterlas en el texto
     - Ej: "Hola, mi nombre es X y tengo X años..."

  2) Mostrá el resultado en una sola línea (concatenación) vs. en varias líneas
     (template string multilínea). Compará las dos formas.

  3) Bonus: dentro de un template string podés meter código inline:
     - Mostrá el doble de tu edad con ${edad * 2}
     - Mostrá "¿puede votar?" según tu edad usando un ternario ${edad >= 18 ? "sí" : "no"}
*/

const nombre = "Lucas Ortiz";
const edad = 21;
const profesion = "programador";
const ciudad = "Plottier";

let presentacion = `Hola, mi nombre es ${nombre} y tengo ${edad} años. Soy un ${profesion} de ${ciudad}.`;
console.log(presentacion);

presentacion = nombre + "\n" + edad + "\n" + profesion + "\n" + ciudad;
console.log(presentacion);

presentacion = `${nombre}
${edad}
${profesion}
${ciudad}`;
console.log(presentacion);

presentacion = `Hola, soy ${nombre}, y ahora tengo ${edad * 2} años. ${edad >= 18 ? "Si" : "No"} puedo votar`;
console.log(presentacion);

// Escribí tu código acá 👇
