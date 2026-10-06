# 07 - Funciones

## Datos
- **Video:** 10 - Funciones
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 5/5

## Apuntes del video

{{para completar con la teoría del video si querés}}

### Conceptos clave
- **Función declarada:** `function f() {}` → hace hoisting completo, lista para usar desde el inicio del scope
- **Función expresada:** `const f = function() {}` → sufre las reglas de su variable (const): no se puede tocar antes de su línea
- **Parámetros por defecto:** `function f(nombre, edad = 0)` → si no pasás el argumento, usa el valor por defecto
- **`return`:** termina la ejecución de la función y devuelve un valor
- **Argumentos extra:** JS los ignora silenciosamente (no tira error)

## Ejercicio práctico

### Enunciado
Probar parámetros por defecto, hoisting (declarada vs expresada), return, y argumentos extra.

### Mi solución
Archivo: `proyectos/01-fundamentos/07-funciones.js`

```javascript
console.log(saludar("Lucas", 21));
console.log(saludar("Lucas"));

function saludar(nombre, edad = 0) {
  return `Hola, soy ${nombre}, y tengo ${edad} años.`;
}

// const f = function() {};  // ❌ si la invoco antes: "Cannot access 'f' before initialization"

function areaRectangulo(base, altura) {
  return base * altura;
}

console.log(areaRectangulo(2, 3, 4, 5));  // → 6 (ignora los extra)
```

## Mis descubrimientos (en bruto)

> - El valor predeterminado (edad = 0) anda a la perfección.
> - Pude ejecutar la función declarada antes de declararla. Pero no pude ejecutar la expresada antes de declararla.
> - **Pregunta que me replanteé: "¿Será que tiene una similitud a lo que pasa con var y let?"** → ¡SÍ! Es el mismo mecanismo de hoisting. La expresada es una const que guarda una función adentro, y sufre las reglas de su variable.
> - Los argumentos extra simplemente se ignoran, solo toma las primeras dos.

## Corrección clave del guía

Sin correcciones — el ejercicio salió perfecto. Se destacó en cambio la conexión que hizo el usuario solo entre hoisting de funciones y el comportamiento de var/let visto en el video 1.

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
- La diferencia entre funciones declaradas y expresadas
- El `return` mata la función (termina su ejecución)
- Las funciones expresadas sufren las reglas del tipo de variable al que fueron asignadas, a diferencia de las declaradas que hacen hoisting y están listas desde el principio
- Las variables que sobran se descartan silenciosamente

### ¿Qué te costó o qué error tuviste?
Creo que no me costó nada ni tuve errores.

### ¿Qué calificación?
5/5

### Notas extra
─

## Links relacionados
- [[06-undefined-null-nan]]
- [[08-arrays]]