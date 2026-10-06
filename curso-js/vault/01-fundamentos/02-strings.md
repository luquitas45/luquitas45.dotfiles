# 02 - Cadenas de Texto (Strings)

## Datos
- **Video:** 5 - Cadenas de Texto
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 4/5

## Apuntes del video

{{para completar con la teoría del video si querés}}

### Conceptos clave
- `.length` → longitud
- `.toUpperCase()` / `.toLowerCase()` → mayúsculas/minúsculas
- `.includes()` → busca substring, devuelve true/false
- `.split(" ")` → convierte el string en un array
- `.trim()` → elimina espacios al inicio y al final

### Dato clave: los métodos viven en cada tipo de dato
- `.trim()`, `.toUpperCase()`, `.includes()`, `.split()` → son métodos de **Strings**
- Un **Array** NO tiene `.trim()` → aplicar un método de string a un array da error `trim is not a function`

## Ejercicio práctico

### Enunciado
Crear una función que reciba un string y muestre longitud, mayúsculas, minúsculas, si contiene "JavaScript", cantidad de palabras y versión sin espacios.

### Mi solución (primera versión)
Archivo: `proyectos/01-fundamentos/02-strings.js`

```javascript
const texto = " Hola como estas, yo bien y vos, yo tambien que bueno ";

// Versión con 6 funciones separadas (una por método)
function longitudString(string) {
  console.log(string.length);
}
// ... y así para mayus, minus, includes, split, trim
```

### Mi solución (refactor final — una sola función)
```javascript
function analizarTexto(string) {
  console.log(string.length);
  console.log(string.toUpperCase());
  console.log(string.toLowerCase());
  console.log(string.includes("JavaScript"));
  const trimString = string.trim();
  console.log(trimString.split(" ").length);
  console.log(trimString);
}

analizarTexto(texto);
```

### Aprendizajes del proceso
- Contar palabras: hay que aplicar `.trim()` **antes** de `.split()` para no contar los espacios vacíos del inicio/final (que generan elementos vacíos en el array)
- El **orden de los métodos importa**: `split().trim()` da error porque al invertirlo, `.trim()` se aplica sobre un array
- Refactor: 6 funciones iguales → 1 sola función que recibe el string. Guardar el resultado intermedio (`trimString`) para no repetir la operación (DRY)

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
Que hay que tener cuidado con los métodos que se aplican a cada tipo de dato, ya que cada tipo de dato tiene sus propios métodos. También aprendí cómo funciona cada método de los strings.

### ¿Qué te costó o qué error tuviste?
El error del `split` (aplicar `.trim()` a un array). Igual no me costó mucho, fue bastante intuitivo.

### ¿Qué calificación?
4/5

## Links relacionados
- [[01-variables-let-const]]
- [[03-template-strings]]