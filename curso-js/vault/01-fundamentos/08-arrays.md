# 08 - Arreglos (Arrays)

## Datos
- **Video:** 11 - Arreglos
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 4/5

## Apuntes del video

{{para completar con la teoría del video si querés}}

### Conceptos clave
- `.length` → cantidad de elementos
- `.push(item)` → agrega al final (no devuelve nada útil)
- `.pop()` → saca el último y **lo devuelve**
- `.forEach(function(el, index) {})` → recorre el array; primer parámetro = elemento, segundo = posición
- `Array.of(...)` → crea array con los valores dados
- `Array(n).fill(valor)` → crea array de n posiciones rellenas con valor (útil para grillas, tableros)
- Acceso por índice: `colores[1]`

### ⚠️ Punto fino: const NO protege el contenido
`const colores` protege la **variable** (la "etiqueta"), no lo que hay dentro de la "caja":
- `colores.push("Negro")` ✅ funciona (muta el contenido)
- `colores[0] = "Amarillo"` ✅ funciona (modifica un elemento)
- `colores = ["Otro"]` ❌ error (no podés reasignar la variable)
- **const ≠ inmutable.** Solo significa que la variable siempre apunta a la misma cosa.

## Ejercicio práctico

### Enunciado
Crear array de colores, probar length/push/pop/acceso por índice, recorrer con forEach, probar Array.of y Array().fill.

### Mi solución
Archivo: `proyectos/01-fundamentos/08-arrays.js`

```javascript
const colores = ["Rojo", "Verde", "Azul"];
console.log(colores.length);   // 3

colores.push("Negro");         // muta el array (const lo permite)
colores.pop();                 // saca el último

colores.forEach(function (color, index) {
  console.log(`${color} esta en la posicion ${index}`);
});

console.log(Array.of("X", "Y", "Z"));
console.log(Array(10).fill("67"));
```

## Mis descubrimientos (en bruto)

> - Los métodos simplemente analizan o modifican el array. Bastante fácil.
> - En el forEach usé `index` para la posición y `color` para los elementos.
> - `Array(10).fill()` rellena los 10 huecos del array con la palabra de entrada.
> - Creé el array con const y pude hacer push: **pensé que era "porque en esencia sigue siendo un arreglo sin importar lo que haya en su interior"** → el guía afinó: const protege la variable (etiqueta), no el contenido (caja).

## Corrección clave del guía

El razonamiento "const no importa el interior" era correcto en resultado pero impreciso en causa. La razón exacta: **const protege la referencia (a qué apunta la variable), no la mutación interna del array**. `push()` no reasigna la variable, muta el contenido. `const ≠ inmutable`.

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
- Los arrays están sujetos al tipo de variable por el cual está definido: con const puedo añadir y sacar cosas con push y pop
- A recorrer un array con forEach

### ¿Qué te costó o qué error tuviste?
- Entender por qué podía cambiar el array si estaba en const (ya lo entendí)
- Armar el forEach porque va con una función adentro (pero lo pude hacer)

### ¿Qué calificación?
4/5

### Notas extra
─

## Links relacionados
- [[07-funciones]]
- [[09-objetos]]