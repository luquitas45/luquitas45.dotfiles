# 01 - Variables: var vs let vs const

## Datos
- **Video:** 3 - Variables: var 🥊VS🥊 let
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 4/5 (siempre se puede saber más)

## Apuntes del video

{{para completar con la teoría del video si querés}}

### Conceptos clave
- `var`: escapa del bloque `{}` → se va al scope global/función. Se puede redeclarar y reasignar.
- `let`: scope de bloque. NO se puede redeclarar en el mismo scope. SÍ se puede reasignar.
- `const`: scope de bloque. NO se puede redeclarar NI reasignar.

## Observaciones del proceso (mías, en bruto)

> - En la segunda invocación no me dejó redefinir `let` ni `const` con la misma palabra. `var` no tuvo ningún problema.
> - Al principio dudaba si estaba redeclarando bien, pero seguí.
> - Al reasignar con valores distintos, `const` no puede cambiar al redefinir; el resto sí puede.
> - Al redefinir dentro de un bloque se imprimieron todas, pero SOLO la `var` seguía cambiada afuera.
> - Imprimiendo dentro del bloque cambiaron todas → se manejan dentro de los bloques, excepto `var`, que lo transforma en un cambio global.
> - Descubrí que **redeclarar ≠ reasignar**: reasignar es usar solo el nombre de la variable sin la palabra clave.
> - Conclusión final: usar `let` para variables que vayan a cambiar y `const` para variables fijas.

## Ejercicio práctico

### Enunciado
Crear 3 variables con var, let y const. Probar redeclaración, reasignación y scope de bloque.

### Mi solución
Archivo: `proyectos/01-fundamentos/01-variables-let-const.js`

```javascript
var varVariable = "var";
let letVariable = "let";
const constVariable = "const";

// 2da invocación: redeclaración
var varVariable = "var";          // ✅ var sí permite
// let letVariable = "let";       // ❌ error: ya fue declarada
// const constVariable = "const"; // ❌ error: ya fue declarada

// 3ra invocación: reasignación (sin la palabra clave)
varVariable = "1";                // ✅ var sí
letVariable = "2";                // ✅ let sí
// constVariable = "3";           // ❌ error: const no se reasigna

// 4ta invocación: bloque {}
{
  var varVariable = "rock";       // escapa al scope global
  let letVariable = "pop";        // queda dentro del bloque
  const constVariable = "blues";  // shadowing: nueva variable que oculta a la global
  // console.log: todas cambiaron DENTRO del bloque
}
// console.log: afuera solo varVariable quedó en "rock"
```

## Cuestionario post-ejercicio

### ¿Qué aprendiste de este video?
`const` no puede cambiar al reasignar, `let` y `var` sí. `var` se va al scope global. La regla práctica: `let` para variables que cambian, `const` para variables fijas.

### ¿Qué te costó o qué error tuviste?
Al principio confundí redeclarar con reasignar. Con la pista del guía descubrí que reasignar es usar solo el nombre de la variable, sin la palabra clave.

### ¿Qué diferencia principal notaste entre var y let?
`var` ignora el bloque `{}` y "escapa" al scope global. `let` se mantiene dentro del bloque.

### Snippet útil
Sin snippet por ahora — fue un ejercicio básico de comprensión. Las observaciones del proceso valen más que el código.

## Links relacionados
- [[02-strings]]
- [[07-funciones]]