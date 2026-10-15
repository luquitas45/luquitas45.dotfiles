# 11 - Condicionales

## Datos
- **Video:** 14 - Condicionales
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 4/5
- **Fecha de completado:** 2026-10-14

## Apuntes del video

### Estructuras
- `if - else`
- `if - else if - else`
- Operador ternario: `(cond) ? true : false`
- `switch - case`

### Importante
- Dentro de una función, usar `return` para devolver el valor; `console.log` solo para mostrarlo afuera.
- Se pueden combinar operadores lógicos; los paréntesis ayudan a la legibilidad.

## Ejercicio práctico

### Enunciado
Crear una función que diga qué estación del año es según el mes (1-12).

### Mi solución
Archivo: `proyectos/01-fundamentos/11-condicionales.js`

```javascript
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
```

## Mis descubrimientos (en bruto)

> - Dentro de los `if` y `else` debo usar `return` y no `console.log`.
> - Puedo concatenar distintos operadores lógicos, usando paréntesis para ayudar la legibilidad.
> - Reforcé los `else if` y el uso de operadores lógicos combinados para necesidades más complejas.

## Corrección clave del guía

La función imprimía adentro con `console.log`, pero no devolvía nada. Por eso `console.log(estacionDelAnio(1))` mostraba el texto y después `undefined`. Corrección: devolver con `return` adentro y mostrar con `console.log` afuera.

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
- Los `else if` y el uso de operadores lógicos combinados para cumplir necesidades más complejas.

### ¿Qué te costó o qué error tuviste?
- Me costó incluir un número alejado que está fuera de un rango establecido, como el `12` en verano.
- También el error de imprimir adentro en vez de devolver con `return`.

### ¿Cuándo preferís switch sobre if-else?
Pendiente: todavía no lo comparaste en este ejercicio.

### ¿Qué te costó del operador ternario?
Pendiente: todavía no lo usaste en este ejercicio.

### ¿Qué calificación?
4/5

### Notas extra
─

## Links relacionados
- [[10-operadores]]
- [[12-loops]]
