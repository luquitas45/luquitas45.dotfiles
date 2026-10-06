# 09 - Objetos

## Datos
- **Video:** 12 - Objetos
- **Bloque:** 1 - Fundamentos
- **Estado:** ✅ Completado
- **Calificación:** 4/5

## Apuntes del video

{{para completar con la teoría del video si querés}}

### Conceptos clave
- **Atributos** = variables dentro del objeto; **métodos** = funciones dentro del objeto
- **`this`**: dentro de un método, se refiere al objeto que contiene el método
- Acceso por **punto** (`persona.nombre`) → nombre fijo que conocés
- Acceso por **corchetes** (`persona["edad"]` o `persona[claveVariable]`) → nombre **dinámico** (viene de una variable)
  - ❌ `persona.clave` busca la propiedad literal "clave" → undefined
  - ✅ `persona[clave]` usa el VALOR de la variable
- **Anidación:** arrays dentro de objetos y objetos dentro de objetos
- `Object.keys(obj)` → las claves (atributos y métodos)
- `Object.values(obj)` → los valores (un método aparece como función)
- `.hasOwnProperty("prop")` → true/false si el objeto tiene esa propiedad

### const y objetos (etiqueta vs caja)
- Se pueden modificar/agregar propiedades libremente
- NO se puede reasignar la variable a otro objeto
- "No se puede cambiar el nombre del objeto, ya que está ligado a un const"

## Ejercicio práctico

### Enunciado
Crear objeto persona con atributos, método con this, objeto anidado (contacto), array anidado (pasatiempos). Acceder por punto, corchetes y anidado. Explorar con Object.keys/values y hasOwnProperty.

### Mi solución
Archivo: `proyectos/01-fundamentos/09-objetos.js`

```javascript
const persona = {
  nombre: "Lucas",
  apellido: "Ortiz",
  edad: 21,
  pasatiempos: ["Codear", "Tocar la guitarra", "Jugar a la pelota"],
  contacto: {
    email: "lucaseortiz45@gmail.com",
    x: "lucass45"
  },
  saludar: function () {
    console.log(`Hola, me llamo ${this.nombre} ${this.apellido} y tengo ${this.edad} años`);
  }
}

console.log(persona.nombre);            // por punto
console.log(persona["edad"]);           // por corchetes
console.log(persona.contacto.email);    // anidado
console.log(Object.keys(persona));
console.log(Object.values(persona));    // el método aparece como función
console.log(persona.hasOwnProperty("nombre"));   // true
console.log(persona.hasOwnProperty("mascota"));  // false
// persona.saludar();  ← llamar al método para ver this en acción
```

## Mis descubrimientos (en bruto)

> - Es bastante intuitivo acceder a los datos de distintas formas.
> - Para llamar atributos dentro del mismo objeto tengo que usar `this.`; desde fuera, el nombre del objeto (persona).
> - Creí que `persona.nombre` era mejor que `persona["edad"]`, que "probablemente así se hacía antes" → **corrección del guía**: corchetes es la forma DINÁMICA (cuando el nombre de la propiedad está en una variable), no es vieja.
> - Object.keys te da las llaves; values los valores (el método aparece como función).
> - hasOwnProperty sirve para saber si el objeto tiene la propiedad pasada entre paréntesis.

## Corrección clave del guía

La notación de corchetes NO es una forma vieja/obsoleta: es la forma **dinámica**. Punto = nombre fijo conocido; corchetes = nombre que viene como variable con `persona[clave]`. Cada una tiene su caso.

## Cuestionario post-ejercicio

### ¿Qué aprendiste o reforzaste?
- Crear objetos, crear propiedades en forma de métodos y atributos
- Las dos formas (fija y dinámica) de llamar a las propiedades de un objeto
- Se pueden crear arrays dentro de los objetos y objetos dentro de los objetos

### ¿Qué te costó o qué error tuviste?
Tuve un error conceptual sobre el llamado de las propiedades (el que me corrigió el guía). Después nada, todo bien.

### ¿Qué calificación?
4/5

### Notas extra
─

## Links relacionados
- [[08-arrays]]
- [[10-operadores]]