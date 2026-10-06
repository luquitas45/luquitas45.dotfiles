# 03 - Template Strings

## Datos
- **Video:** 6 - Template Strings
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 3/5

## Apuntes del video

{{para completar con la teoría del video si querés}}

### Conceptos clave
- Backticks `` ` `` en vez de comillas simples/dobles
- Interpolación con `${variable}` para meter variables en el texto
- **Multilínea**: los saltos de línea se escriben directo (Enter), sin necesitar `\n`
- **Expresiones inline**: dentro de `${}` se puede meter cualquier expresión:
  - Operaciones: `${edad * 2}`
  - Ternarios: `${edad >= 18 ? "sí" : "no"}`

## Ejercicio práctico

### Enunciado
Crear una tarjeta de presentación con template strings. Comparar concatenación vs template string (una línea vs multilínea). Bonus: expresiones inline.

### Mi solución
Archivo: `proyectos/01-fundamentos/03-template-strings.js`

```javascript
const nombre = "Lucas Ortiz";
const edad = 21;
const profesion = "programador";
const ciudad = "Plottier";

// Interpolación en una línea
let presentacion = `Hola, mi nombre es ${nombre} y tengo ${edad} años. Soy un ${profesion} de ${ciudad}.`;

// Concatenación multilínea (la "sufrida" 😄)
presentacion = nombre + "\n" + edad + "\n" + profesion + "\n" + ciudad;

// Template string multilínea (mucho más legible)
presentacion = `${nombre}
${edad}
${profesion}
${ciudad}`;

// Bonus: expresiones inline
presentacion = `Hola, soy ${nombre}, y ahora tengo ${edad * 2} años. ${edad >= 18 ? "Si" : "No"} puedo votar`;
```

### Mejora sugerida por el guía
El ternario en el bonus quedaba literal: "42 años... Si puedo votar". Mejor pensar la frase completa y que el ternario elija palabras que la completen:
```javascript
`Soy ${edad >= 18 ? "mayor" : "menor"} de edad`
```

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
- Usar backticks es mucho mejor que concatenar
- Se puede usar código inline dentro de los templates
- Se pueden hacer saltos de línea directos con templates, en vez de usar `\n`

### ¿Qué te costó o qué error tuviste?
La concatenación multilínea me costó, más que nada por entender conceptualmente a qué se refería.

### ¿Qué calificación?
3/5

### A tomar en cuenta
La calificación bajó de 4 (strings) a 3. La dificultad fue más conceptual (entender el planteo del ejercicio) que técnica. Posible repaso o ejercicio extra si se siente flojo el tema.

## Links relacionados
- [[02-strings]]
- [[01-variables-let-const]]