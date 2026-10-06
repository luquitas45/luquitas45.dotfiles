# 05 - Booleans

## Datos
- **Video:** 8 - Booleans
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 4/5

## Apuntes del video

{{para completar con la teoría del video si querés}}

### Conceptos clave
- **Falsy:** `false`, `0`, `""`, `null`, `undefined`, `NaN` → representan "nada"/ausencia
- **Truthy:** todo lo demás → representan "algo que existe"
  - Ojo: `[]` (array vacío) y `{}` (objeto vacío) son truthy porque EXISTEN
- `Boolean(valor)` → devuelve true/false (¿es truthy o falsy?)
- **Cortocircuito (|| y &&):** devuelven VALORES, no booleanos:
  - `||` devuelve el primer valor truthy (`0 || 42` → `42`)
  - `&&` devuelve el primer valor falsy (`"" && "x"` → `""`)
  - Sirven para cortar procesos y poner valores por defecto

## Ejercicio práctico

### Enunciado
Probar valores falsy y truthy con Boolean(). Bonus: entender el cortocircuito de || y &&.

### Mi descubrimiento del bonus
Usé `Boolean()` pensando que había que ver si la salida era true/false, pero `||` y `&&` **no pasan por Boolean()**: devuelven el valor crudo. Por eso `0 || 42` da `42` (número), no `true`.

## Mis descubrimientos (en bruto)

> - En el primer punto todos dieron falsos: todos representan un dato vacío o ausencia de datos. Considerando que nada es lo contrario a algo.
> - En el segundo punto todos dieron true: todos tienen algún valor existente considerado como "algo". Me sorprendió que [] y {} sean true aunque no tengan nada, pero su true representa su existencia, ya sea con algo o sin nada.
> - Bonus: en `||` si al menos un valor es true devuelve true; en `&&` ambos tienen que ser true. *(corregido por el guía: devuelven valores, no booleanos)*

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
- La diferencia entre truthy y falsy, y por qué [] y {} son truthy (existen)
- El cortocircuito: `||` y `&&` cortan procesos y devuelven valores. "Interesante cómo || y && se utilizan para cortar procesos, a tener en cuenta"

### ¿Qué te costó o qué error tuviste?
Casi nada, solo el error conceptual del bonus: usé Boolean() cuando no hacía falta. Aprendí que || y && devuelven el valor, no true/false.

### ¿Qué calificación?
4/5

## Links relacionados
- [[04-numbers]]
- [[11-condicionales]]