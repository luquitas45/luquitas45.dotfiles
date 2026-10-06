# 04 - Números

## Datos
- **Video:** 7 - Números
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 4/5

## Apuntes del video

{{para completar con la teoría del video si querés}}

### Conceptos clave
- `.toFixed(n)` → redondea y **devuelve un STRING** (no un número)
- `parseInt()` → convierte string a número entero (descarta decimales)
- `parseFloat()` → convierte string a número con decimales
- `Number()` → conversión completa
- ⚠️ El operador `+` con un string **concatena**, no suma: `"5.6" + 2` → `"5.62"` (no `7.6`)
- `-`, `*`, `/` sí fuerzan conversión a número automática

## Ejercicio práctico

### Enunciado
Probar toFixed con decimales, sumar string + número, probar las 3 conversiones, investigar typeof.

### Mi solución
Archivo: `proyectos/01-fundamentos/04-numbers.js`

```javascript
const A = 7.1987;
console.log(A.toFixed(1));  // "7.2" (string)
console.log(A.toFixed(2));  // "7.20"
console.log(A.toFixed(3));  // "7.199"

const B = "5.6";
const C = 2;
console.log(B + C);            // "5.62" ← concatenación, no suma
console.log(parseInt(B) + C);  // 7
console.log(parseFloat(B) + C); // 7.6
console.log(Number(B) + C);    // 7.6
```

## Mis descubrimientos (en bruto)

> - `toFixed` devuelve string, interesante.
> - A veces redondea cuando hay menos decimales: con toFixed(2) y toFixed(1) me redondeó a 7.20 y 7.2.
> - Las tres formas de conversión dieron bien, con el detalle de que parseInt solo mantiene los números enteros.
> - Todos dieron `number` excepto el string numérico, que dio `string`.
> - parseInt sirve para la parte entera; parseFloat usa entera y decimal.

## Corrección clave del guía

Mi conclusión inicial: "el string y el número se sumaron bien" → **incorrecta**. `"5.6" + 2` da `"5.62"` porque JS **concatena** cuando hay un string en un `+`. La suma real es `7.6` y solo se logra convirtiendo antes (parseFloat/Number). El operador `+` es el único que concatena; `- * /` fuerzan conversión.

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
- `.toFixed()` devuelve string
- La diferencia entre parseInt y parseFloat
- El concepto de concatenación vs suma con `+` (corregido por el guía)

### ¿Qué te costó o qué error tuviste?
Creí que `"5.6" + 2` sumaba bien; era concatenación. Concepto clave aprendido.

### ¿Qué calificación?
4/5

## Links relacionados
- [[02-strings]]
- [[05-booleans]]