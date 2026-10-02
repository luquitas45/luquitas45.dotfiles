# 🗂️ Atajos — Yazi

> Gestor de archivos en terminal · Config en `~/.config/yazi/`
> Para entrar con cd-al-cerrar usá **`y`** (función en `~/.zshrc`)
> Adentro de yazi: **`?` muestra TODOS los atajos**

---

## 🧭 Navegación

| Qué hace | Tecla |
|---|---|
| Moverte (como vim) | `h j k l` o flechas |
| Entrar carpeta / abrir | `l` o `Enter` |
| Subir un nivel | `h` (o `Backspace` / `-`) |
| Ir a inicio / fin de lista | `gg` / `G` |
| Ir a la carpeta home | `~` |
| Mostrar/ocultar archivos ocultos | `.` (punto) |

---

## ✅ Selección y acciones

| Qué hace | Tecla |
|---|---|
| Seleccionar archivo (toggle) | `Espacio` |
| Modo selección visual | `v` |
| Copiar (yank) | `y` |
| Cortar | `x` |
| Pegar | `p` |
| Borrar (→ **papelera** de Plasma) | `dd` |
| Renombrar | `r` |
| Crear archivo | `a` |

---

## 🔎 Búsqueda y comandos

| Qué hace | Tecla |
|---|---|
| Buscar por nombre (usa `fd`) | `f` |
| Filtrar la lista | `/` |
| Comando de shell | `;` |
| Ordenar (cicla) | `s` |
| Ordenar en reversa | `S` |
| Marcador | `m` · ver marcadores: `M` |

---

## 🚪 Salir

| Qué hace | Tecla |
|---|---|
| Salir (y si entraste con `y`, quedás en esa carpeta) | `q` |
| Ayuda completa | `?` |

---

## 📌 Datos útiles

- **Previews**: en kitty directo usa el protocolo nativo (imágenes full); **dentro de tmux** cae a chafa/unicode (normal).
- `dd` borra a la **papelera del sistema** (misma que Dolphin) — recuperable.
- Búsquedas potentes con `fd` y `ripgrep` (ya instalados).
- Config mínima inicial: ninguna — yazi anda de fábrica.

---

## 🗂️ Próximas hojas

- [x] `tmux.md` · [x] `yazi.md` · [x] `zsh.md` · [x] `nvim.md` · [x] `kde.md`

> kitty fuera por decisión: tmux gestiona ventanas/paneles