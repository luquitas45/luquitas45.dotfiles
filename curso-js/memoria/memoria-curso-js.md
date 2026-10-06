# Memoria exportada — Curso JavaScript (Engram)

> Exportación manual de las observaciones de Engram del proyecto "Curso JavaScript de Jon Mircha".
> Generada el 2026-10-0X desde la sesión de Pi.
> Re-importar en la notebook: volver a guardar cada observación con la herramienta de memoria (mem_save) o simplemente dejar este documento como referencia.

---

## 1. Configurar vault de Obsidian para curso JS (decision)
**Obs ID:** 31

**What:** Se creó un vault de Obsidian completo para seguir el curso de JavaScript de Jon Mircha con enfoque práctico.

**Why:** El usuario quiere aprender JS haciendo proyectos y que Pi lo guíe con cuestionarios post-tarea para llenar las notas automáticamente.

**Where:**
- Vault: /home/lucas/alejandria/js-curso-jonmircha/
- Proyecto de trabajo: /home/lucas/workspace/js-curso-jonmircha/
- Skill: /home/lucas/workspace/js-curso-jonmircha/skills/js-curso-flujo/SKILL.md

**Learned:**
- El usuario prefiere formato mixto: ejercicios chicos por video + proyectos integradores por bloque
- Vault opción B: Mapa + proyectos + código (recomendado)
- Vanilla JS puro, sin frameworks
- Nivel actual: sabe variables, funciones, POO básica. No sabe DOM.
- El curso tiene ~75+ videos divididos en 5 bloques temáticos
- El repositorio oficial está en github.com/jonmircha/youtube-js

**Estructura del vault:**
- 01-fundamentos/ (27 videos + 27 ejercicios + proyecto calculadora)
- 02-modulos-asincronia/ (6 videos + proyecto app tareas)
- 03-nuevos-tipos-this/ (10 videos + proyecto gestor contactos)
- 04-dom-bom/ (3 videos + 15 ejercicios DOM + proyecto página interactiva)
- 05-ajax-fetch/ (5 videos + proyecto CRUD API)
- proyectos/ (notas de cada proyecto integrador)
- templates/ (plantilla nota-video.md)
- canvas-curso.md (mapa visual de progreso)

**Skill creado:** js-curso-flujo con cuestionario post-tarea de 5 preguntas estándar.

---

## 2. Metodología de guía: Opción A para curso JS (preference)
**Obs ID:** 32 | topic_key: js-curso-metodologia-guia

**What:** El usuario eligió la metodología "Dale, intentá" (Opción A) como forma de guía para el curso de JavaScript.

**Why:** Prefiere un estilo donde él intenta resolver solo primero, y Pi actúa como mentor que revisa, da pistas y guía sin dar la respuesta directamente.

**Metodología concreta:**
1. Pi da el enunciado del ejercicio
2. El usuario intenta resolverlo solo
3. Cuando muestra su código, Pi revisa y guía (no resuelve por él)
4. Si se traba mucho, da pistas progresivas
5. Al final, si funciona, ofrece refactor o mejora

**Qué NO hacer:**
- No escribir el código por el usuario
- No dar la solución completa de una
- No saltear al resultado final

**Qué SÍ hacer:**
- Explicar conceptos antes de usarlos
- Plantear enunciados paso a paso
- Revisar código del usuario y señalar errores con explicación
- Dar pistas cuando se traba
- Refactorizar al final si el usuario lo pide

**Applies to:** js-curso-jonmircha project only

---

## 3. Convención de código del curso JS (pattern)
**Obs ID:** 38 | topic_key: js-curso-convencion-codigo

**What:** Se definió la convención de dónde se guarda el código del curso JS (ejercicios y proyectos).

**Where:** /home/lucas/workspace/js-curso-jonmircha/proyectos/

**Convención:**
- Ejercicios chicos por video → un archivo `NN-tema.js` en `proyectos/{bloque}/`
- Proyectos integradores → carpeta propia en `proyectos/integradores/{nombre}/`
- Para correr un ejercicio: `node NN-tema.js` desde la terminal
- Los bloques 4-5 (DOM) vuelven a `.html` porque necesitan navegador

**Learned:** La metodología "Dale, intentá" se aplica también al espacio de código: Pi crea el esqueleto con consignas como comentarios, el usuario escribe el código, y Pi revisa y guía sin resolver.

---

## 4. Progreso curso JS - 9 videos completados (discovery - topic evolutivo)
**Obs ID:** 40 | topic_key: js-curso-progreso

**Progreso:**
- ✅ 01 - Variables — 4/5
- ✅ 02 - Strings — 4/5
- ✅ 03 - Template Strings — 3/5
- ✅ 04 - Números — 4/5
- ✅ 05 - Booleans — 4/5
- ✅ 06 - undefined, null & NaN — 4/5
- ✅ 07 - Funciones — 5/5
- ✅ 08 - Arrays — 4/5
- ✅ 09 - Objetos — 4/5 (aprendizajes: this, acceso por punto vs corchetes dinámico, objetos anidados, Object.keys/values)
- ➡️ Siguiente: 10 - Tipos de Operadores (Video 13 del curso)

**Nivel del usuario:** 9/95 videos completados. Corrigió el concepto de corchetes (dinámico vs viejo). Entiende bien anidación y this. Estable en 4/5. Terminó el primer "sub-grupo" de tipos de datos (variables, strings, números, booleans, null/undefined, funciones, arrays, objetos).

---

## 5. Libertad de ajuste + template notas actualizado (decision)
**Obs ID:** 41 | topic_key: js-curso-flujo-notas

**What:** El usuario dio libertad a el Gentleman para seguir ajustando el flujo del curso JS sin pedir permiso cada vez.

**Detalles:**
- Template de notas actualizado en /home/lucas/alejandria/js-curso-jonmircha/templates/nota-video.md con la estructura REAL que funciona:
  1. Datos (video, bloque, estado, calificación)
  2. Apuntes del video + Conceptos clave
  3. Ejercicio práctico (enunciado + solución)
  4. **Mis descubrimientos (en bruto)** ← la sección más valiosa, proceso mental del usuario
  5. **Corrección clave del guía** ← errores conceptuales corregidos
  6. Cuestionario post-ejercicio
  7. Links relacionados
- De ahora en más todas las notas salen de ese template (consistencia)
- El usuario autoriza ajustes futuros sin consulta previa

**Learned:** El usuario valora el feedback honesto del guía y las correcciones documentadas. La sección "descubrimientos en bruto" (citas de su proceso mental) es lo más valioso del vault.

---

## Resumen de claves de contexto (topic_keys)
- `js-curso-metodologia-guia` → Metodología Opción A "Dale, intentá"
- `js-curso-convencion-codigo` → Dónde vive el código
- `js-curso-progreso` → Progreso del curso (evolutivo, se actualiza en cada video)
- `js-curso-flujo-notas` → Template y libertad de ajuste
- `js-curso-jonmircha-setup` → Configuración inicial del vault