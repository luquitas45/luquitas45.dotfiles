# 10 - Tipos de Operadores

## Datos
- **Video:** 13 - Tipos de Operadores
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 4/5
- **Fecha de completado:** 2026-10-14

## Apuntes del video

### Operadores
- Aritméticos: `+ - * / % ()`
- Relacionales: `> < >= <= == === != !==`
- Lógicos: `! || &&`
- Incremento/decremento: `++ --`

### Importante
- `==` compara valor
- `===` compara valor Y tipo
- `=` asigna; no sirve para comparar

## Ejercicio práctico

### Enunciado
Crear una función que valide si un número está entre 10 y 50, es par, y no es negativo.

### Mi solución
Archivo: `proyectos/01-fundamentos/10-operadores.js`

```javascript
function estaEnRangoPar(numero) {
  let verdad = false;
  let rango = false;
  let esPar = false;

  rango = numero >= 10 && numero <= 50;
  esPar = numero % 2 === 0;

  verdad = rango && esPar;
  return verdad;
}

console.log(estaEnRangoPar(12));
console.log(estaEnRangoPar(11));
console.log(estaEnRangoPar(9));
console.log(estaEnRangoPar(50));
console.log(estaEnRangoPar(51));
console.log(estaEnRangoPar(-12));
```

## Mis descubrimientos (en bruto)

> - Siempre debo usar `===`, ya que es buena práctica.
> - Me sirvió hacer funciones para las cosas que necesito comparar o usar.
> - Incluyo 10 y 50, ya que se consideran inclusivos.

## Corrección clave del guía

`numero % 2 = 0` no compara: el `=` intenta asignar. Para saber si es par hay que comparar el resto con `=== 0`. Además, “entre 10 y 50” quedó definido como inclusivo: `>= 10 && <= 50`.

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
- Usar `===` como buena práctica.
- Separar validaciones en variables/funciones: rango por un lado, par por otro.

### ¿Qué te costó o qué error tuviste?
- Me trabé con el módulo para ver si era par.
- Primero usé `=` y después `==`; faltaba guardar el cambio a `===`.

### ¿Qué snippet te sirve para el futuro?
- Validación de rango y validación de par, por separado.

```javascript
numero >= 10 && numero <= 50
numero % 2 === 0
```

### ¿Qué calificación?
4/5

### Notas extra
─

## Links relacionados
- [[09-objetos]]
- [[11-condicionales]]
