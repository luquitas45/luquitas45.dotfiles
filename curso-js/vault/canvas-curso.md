```json
{
  "nodes":[
    {"id":"intro","type":"text","text":"Curso JavaScript - Jon Mircha","x":-100,"y":-300,"width":300,"height":60},
    {"id":"b1","type":"text","text":"Bloque 1: Fundamentos\nVariables, tipos, funciones, arrays, objetos, operadores, condicionales, loops, clases","x":-400,"y":-150,"width":250,"height":120},
    {"id":"b2","type":"text","text":"Bloque 2: Módulos y Asincronía\nES6 modules, setTimeout/setInterval, Event Loop, callbacks, promesas, async/await","x":-100,"y":-150,"width":250,"height":120},
    {"id":"b3","type":"text","text":"Bloque 3: Nuevos Tipos y this\nSymbols, Sets, Maps, WeakSets, WeakMaps, Generators, Proxies, this, call/apply/bind","x":200,"y":-150,"width":250,"height":120},
    {"id":"b4","type":"text","text":"Bloque 4: DOM y BOM\nSelección, manipulación, eventos, responsive, detección de dispositivos","x":-250,"y":50,"width":250,"height":100},
    {"id":"b5","type":"text","text":"Bloque 5: AJAX y Fetch\nXMLHttpRequest, Fetch API, CRUD con AJAX/Fetch/Axios","x":50,"y":50,"width":250,"height":100},
    {"id":"p1","type":"text","text":"Proyecto: Calculadora + Validador","x":-400,"y":200,"width":200,"height":60},
    {"id":"p2","type":"text","text":"Proyecto: App de Tareas","x":-100,"y":200,"width":200,"height":60},
    {"id":"p3","type":"text","text":"Proyecto: Gestor de Contactos","x":200,"y":200,"width":200,"height":60},
    {"id":"p4","type":"text","text":"Proyecto: Página Interactiva","x":-250,"y":300,"width":200,"height":60},
    {"id":"p5","type":"text","text":"Proyecto: CRUD con API","x":50,"y":300,"width":200,"height":60}
  ],
  "edges":[
    {"fromNode":"intro","fromSide":"bottom","toNode":"b1","toSide":"top"},
    {"fromNode":"intro","fromSide":"bottom","toNode":"b2","toSide":"top"},
    {"fromNode":"intro","fromSide":"bottom","toNode":"b3","toSide":"top"},
    {"fromNode":"b1","fromSide":"bottom","toNode":"b4","toSide":"top"},
    {"fromNode":"b2","fromSide":"bottom","toNode":"b4","toSide":"top"},
    {"fromNode":"b2","fromSide":"bottom","toNode":"b5","toSide":"top"},
    {"fromNode":"b3","fromSide":"bottom","toNode":"b5","toSide":"top"},
    {"fromNode":"b4","fromSide":"bottom","toNode":"p4","toSide":"top"},
    {"fromNode":"b5","fromSide":"bottom","toNode":"p5","toSide":"top"},
    {"fromNode":"b1","fromSide":"bottom","toNode":"p1","toSide":"top"},
    {"fromNode":"b2","fromSide":"bottom","toNode":"p2","toSide":"top"},
    {"fromNode":"b3","fromSide":"bottom","toNode":"p3","toSide":"top"}
  ]
}
```

## Progreso Visual

### Bloque 1: Fundamentos
- [ ] Videos 1-27
- [ ] Ejercicios de programación
- [ ] [[proyectos/calculadora-strings|Proyecto Calculadora + Validador]]

### Bloque 2: Módulos y Asincronía
- [ ] Videos 28-33
- [ ] [[proyectos/app-tareas|Proyecto App de Tareas]]

### Bloque 3: Nuevos Tipos y `this`
- [ ] Videos 34-43
- [ ] [[proyectos/gestor-contactos|Proyecto Gestor de Contactos]]

### Bloque 4: DOM y BOM
- [ ] Videos 44-58
- [ ] Ejercicios del DOM
- [ ] [[proyectos/pagina-interactiva|Proyecto Página Interactiva]]

### Bloque 5: AJAX y Fetch
- [ ] Videos 59+
- [ ] [[proyectos/crud-api|Proyecto CRUD con API]]
