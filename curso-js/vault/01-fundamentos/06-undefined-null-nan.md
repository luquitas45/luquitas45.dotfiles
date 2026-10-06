# 06 - undefined, null & NaN

## Datos
- **Video:** 9 - undefined, null & NaN
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 4/5

## Apuntes del video

{{para completar con la teoría del video si querés}}

### Conceptos clave
- **undefined**: tipo `undefined`. Lo pone JavaScript automáticamente: variable sin inicializar, propiedad inexistente, función sin return, parámetro no provisto. **Nunca se asigna intencionalmente.**
- **null**: tipo `object` *(dato curioso: bug histórico de JS)*. Valor vacío **intencional**, lo pone el programador.
- **NaN** (Not a Number): tipo `number`. Resultado de operación inválida (`"hola" * 3.7`). Es el único valor que no es igual a sí mismo: `NaN === NaN` → `false`.

### isNaN vs Number.isNaN (buena práctica)
- `isNaN()` → **convierte** el valor a número primero, eso puede generar errores/engaños:
  - `isNaN("hola")` → true (convierte a NaN)
  - `isNaN("5")` → false (convierte a 5, que sí es número)
- `Number.isNaN()` → **no convierte**, espera un valor tipo número literal:
  - `Number.isNaN(NaN)` → true
  - `Number.isNaN("hola")` → false (un string no es NaN)
- ✅ **Recomendado: `Number.isNaN()`** — menos sujeto a errores sin la conversión.

### Regla de oro
| Situación | Qué usar |
|-----------|----------|
| No lo puse yo, lo puso JS | `undefined` (aparece solo) |
| El valor no existe intencionalmente | `null` (lo escribo yo) |

## Ejercicio práctico

### Enunciado
Crear variable sin inicializar (undefined), con null, generar NaN, investigar NaN === NaN, y diferencias entre isNaN/Number.isNaN.

### Mi solución
Archivo: `proyectos/01-fundamentos/06-undefined-null-nan.js`

```javascript
// variable indefinida → salida: undefined, typeof: undefined
// variable con null → salida: null, typeof: object (bug histórico)
// "hola" * 3.7 → salida: NaN, typeof: number
// NaN === NaN → false
```

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
- La diferencia entre null y undefined: **null es el que debo usar**, representa un valor vacío intencional
- **No debería usar undefined** — es un valor entregado por JavaScript, tengo que cuidarme de él
- `isNaN()` convierte el valor de entrada a número y eso puede generar errores
- Es más recomendable usar **`Number.isNaN()`**, espera siempre un valor tipo número y está menos sujeto a errores sin la conversión

### ¿Qué te costó o qué error tuviste?
- Me costó entender un poco isNaN vs Number.isNaN, pero ya lo entendí
- También pensé inicialmente que undefined se podía usar intencionalmente, pero para eso existe null

### ¿Qué calificación?
4/5

### Notas extra
- Dato curioso: `typeof null` es `"object"` (bug histórico de JS)
- Buenas prácticas: con undefined/null usar null para ausencia intencional; con isNaN/Number.isNaN usar siempre Number.isNaN().

## Links relacionados
- [[05-booleans]]
- [[04-numbers]]