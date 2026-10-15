# 12 - Ciclos (Loops)

## Datos
- **Video:** 15 - Ciclos
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 4/5
- **Fecha de completado:** 2026-10-14

## Apuntes del video

### Tipos de loops
- `while`
- `do while`
- `for`
- `for...in` (objetos)
- `for...of` (iterables)

### Importante
- Si la función imprime adentro, se la llama sin `console.log` afuera; si no, aparece `undefined`.
- Cuidar el inicio del contador para no incluir valores fuera del rango pedido.

## Ejercicio práctico

### Enunciado
Crear una función que reciba un número y devuelva la tabla de multiplicar de ese número usando diferentes tipos de loops.

### Mi solución
Archivo: `proyectos/01-fundamentos/12-loops.js`

```javascript
function tablaDeMultiplicar(numero) {
  for (let i = 1; i <= 10; i++) {
    console.log(`${numero} por ${i} = ${numero * i}`);
  }
  console.log(`Esa fue con for, ahora con while`);
  let contador = 1;
  while (contador <= 10) {
    console.log(`${numero} por ${contador} = ${numero * contador}`);
    contador++;
  }
}

tablaDeMultiplicar(5);
```

## Mis descubrimientos (en bruto)

> - Reforcé la creación de los `for` y los `while`.
> - El `for` me parece más intuitivo; por lo que vi en el video es el que más se usa.
> - `while` y `do while` cayeron un poco en desuso.

## Corrección clave del guía

`console.log(tablaDeMultiplicar(5))` mostraba `undefined` al final porque la función imprimía adentro y no devolvía nada. Corrección: llamarla como `tablaDeMultiplicar(5)`. Además, el `while` arrancaba en `0`; se corrigió a `1` para que la tabla sea del 1 al 10.

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
- La creación de los `for` y los `while`.

### ¿Qué te costó o qué error tuviste?
- Errores de sintaxis leves.
- Tuve que pensar la estructura del `for` hasta que me acordé.

### ¿Qué loop te resultó más intuitivo?
- El `for`.

### ¿Cuándo usarías for...in vs for...of?
Pendiente: todavía no lo comparaste en este ejercicio.

### ¿Qué calificación?
4/5

### Notas extra
─

## Links relacionados
- [[11-condicionales]]
- [[14-break-continue]]
