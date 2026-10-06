# 📦 Paquete de exportación — Curso JavaScript

Todo lo necesario para continuar el curso en tu notebook.

## 📁 Contenido

```
export-curso-js/
├── vault-obsidian/
│   └── js-curso-jonmircha/     ← EL VAULT COMPLETO (imporalo en Obsidian)
├── proyectos-ejercicios/       ← tu código práctica (01-fundamentos con 9 ejercicios)
├── skills/
│   └── js-curso-flujo/         ← la skill del flujo de trabajo
├── memoria/
│   └── memoria-curso-js.md     ← la memoria de Engram exportada (5 observaciones)
└── README-INSTRUCCIONES.md     ← este archivo
```

---

## 🚀 Cómo llevarlo a la notebook

### Opción 1 — GitHub (recomendada, si tenés el repo de dotfiles)
1. Subí la carpeta `export-curso-js/` a un repo (puede ser privado)
2. En la notebook: `git clone <repo>`
3. Si querés que el vault viva en tu repo de dotfiles también, podés agregar `/home/lucas/alejandria/js-curso-jonmircha/` como symlink o copiarlo

### Opción 2 — USB / Google Drive / Nextcloud
Copiá la carpeta completa y pegala en la notebook.

---

## 🔧 Instalación en la notebook

### 1. Vault de Obsidian
- En Obsidian: **Open folder as vault** → seleccioná `vault-obsidian/js-curso-jonmircha/`
- Vas a ver el canvas, las notas, los templates y el progreso en `01-fundamentos/README.md`

### 2. Proyecto de trabajo (código)
- Mové `proyectos-ejercicios/` donde quieras trabajar, ej: `~/workspace/js-curso-jonmircha/proyectos/`
- Necesitás **Node.js** (`node --version`). En CachyOS/Arch: `sudo pacman -S nodejs npm`
- Correr un ejercicio: `node 01-variables-let-const.js` (o F5 en nvim si tenés la keymap)

### 3. La skill (para usar Pi como guía)
La skill `js-curso-flujo` se usa como referencia para el flujo de trabajo. En la notebook:
- Tenés que tener instalado **pi** y **gentle-pi** (el paquete de el Gentleman)
- Copiá la skill a la carpeta skills de tu proyecto: `~/workspace/js-curso-jonmircha/skills/js-curso-flujo/`
- O usá la memoria exportada (paso 4) que describe el flujo y la metodología

### 4. La memoria (Engram)
La memoria de Engram **no se copia como archivo** — vive en el servidor local de Engram de cada máquina.
En la notebook, para reconstruirla:
1. Abrí Pi/el Gentleman en la carpeta del proyecto
2. Decile: *"Reconstruí la memoria del curso JS"*
3. Pi lee `memoria/memoria-curso-js.md` y vuelve a guardar las 5 observaciones con mem_save
4. O hacelo vos: tomá cada sección del documento y guardala con el nombre y topic_key indicados

---

## 📋 Estado actual (para no perder el ritmo)

- **9/95 videos completados** (bloque 1: hasta Objetos)
- **Siguiente:** Video 13 — Tipos de Operadores (10-operadores)
- **Metodología:** "Dale, intentá" (Opción A) — Pi da el enunciado, vos intentás solo, Pi guía con pistas y corrige con explicación
- **Formato notas:** template `templates/nota-video.md` con secciones de "descubrimientos en bruto" y "corrección del guía"

## 🎓 Link del curso
https://www.youtube.com/watch?v=2SetvwBV-SU&list=PLvq-jIkSeTUZ6QgYYO3MwG9EMqC-KoLXA