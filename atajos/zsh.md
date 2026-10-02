# 🐚 Atajos — Zsh

> Shell por defecto · prompt p10k (Gorgoroth) · **vi-mode activo** (`bindkey -v`)
> Config en `~/.zshrc` + `~/.p10k.zsh` + base CachyOS (`/usr/share/cachyos-zsh-config`)

---

## ⌨️ vi-mode (edición de comandos estilo vim)

> (Se desactivó y **se reactivó** el 10-oct: al final sí, va con vi-mode.)

Arrancás en **insert mode** (tipeás normal). Con `Esc` pasás a **normal mode**:

> **¿En qué modo estás?** El `λ` del prompt cambia de color: **verde** = insert · **teal** = normal · **gris** = visual
>
> ⚠️ `Esc` **solo** = modo normal de zsh. `C-a Esc` es de **tmux** (modo copia) — no confundirlos.

| Normal mode | Qué hace |
|---|---|
| `h l` | moverte un carácter |
| `b w` | saltar palabra atrás / adelante |
| `0 $` | inicio / fin de línea |
| `x` | borrar carácter |
| `dw` / `cw` | borrar / cambiar palabra |
| `dd` | borrar toda la línea |
| `u` | deshacer |
| **`k` / `j`** | historial: anterior / siguiente (con el prefijo que tipeaste — substring search) |
| **`v`** | editar el comando en **nvim** (sale y lo ejecuta) |
| `i` / `a` | volver a insert mode (antes / después del cursor) |

| Insert mode | Qué hace |
|---|---|
| `Ctrl+W` | borrar palabra anterior |
| `Ctrl+D` | borrar carácter (o salir de la shell si está vacío) |
| `Ctrl+R` | historial con **fzf** |
| `Ctrl+T` | insertar **archivo** con fzf |
| `Alt+C` | **cd** un directorio con fzf |
| `Ctrl+E` | aceptar la **autosugerencia** (la gris de la derecha) |
| `Ctrl+F` | aceptar una palabra de la autosugerencia |
| `Ctrl+L` | limpiar pantalla |

> En vi-mode los `Ctrl+A`/`Ctrl+E` de emacs ya no existen: usá `0`/`$` en normal mode.

---

## 📁 Navegación y archivos

| Qué hace | Comando |
|---|---|
| Entrar a yazi y **cd al salir** | `y` |
| Salto rápido de directorio (zoxide) | `z <fragmento>` |
| Editar con nvim | `v` (alias `nvim`) |
| Actualizar sistema | `update` |
| "Por favor" → sudo | `please <comando>` |

---

## 🧭 fzf (ya activo)

| Atajo | Qué hace |
|---|---|
| `Ctrl+R` | buscar comando en el historial (fuzzy) |
| `Ctrl+T` | buscar archivo → pega la ruta |
| `Alt+C` | buscar directorio → cd |

---

## 📌 Datos de la config actual

- **Historial**: 100k entradas, timestamps, append inmediato, ignora dups/junk
- **Completado**: menú interactivo (`menu select`) + colores por tipo de archivo
- **Autosugestiones** en gris comentario (`#505050`) — aceptar con `Ctrl+E`
- `EDITOR=nvim` · alias `v=nvim` · `DISABLE_AUTO_UPDATE` on
- Instant prompt p10k activo (arranque ~0,5s)

---

## 🗂️ Hojas

- [x] `tmux.md` · [x] `yazi.md` · [x] `zsh.md` · [x] `nvim.md` · [x] `kde.md`

> kitty fuera por decisión: tmux gestiona ventanas/paneles