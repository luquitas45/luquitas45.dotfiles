# 🖥️ Atajos — KDE Plasma

> Hoja del sistema · los atajos de las apps viven en sus hojas (tmux/zsh/nvim/yazi)
> Personalización: System Settings → Atajos (teclas)

---

## ⭐ Lo que configuramos

| Qué hace | Atajo |
|---|---|
| **Ver las hojas de atajos** (glow browser sobre `~/Documentos/atajos`) | `Meta+H` |
| Confirmación visual | Se abre una ventana kitty con el listado de hojas · Enter para cerrar |

> El wrapper vive en `~/.local/share/applications/net.local.kitty.desktop`
> (kitty → glow en el directorio de hojas).

---

## 🖥️ Escritorios virtuales

| Qué hace | Atajo |
|---|---|
| Ir al escritorio 1 · **Principal** | `Meta+Z` |
| Ir al escritorio 2 · **Desarrollo** | `Meta+X` |

> Se crean y bindean con `bash kde/apply-desktops.sh` (idempotente, verifica el readback).

---

## 🐱 Kitty dev (tmux)

| Qué hace | Cómo |
|---|---|
| Terminal de desarrollo con tmux (sesión `dev`, la adjunta si ya existe) | Arranca sola al login · escritorio **Desarrollo**, sin borde |
| Lanzarla a mano | Menú de apps → **Kitty Dev (tmux)** |

> Sin reglas de ventana: el `.desktop` ejecuta el wrapper `kde/dev-kitty.sh`
> (`~/.local/bin/dev-kitty`), que lanza kitty y carga el KWin script
> `kde/devkitty-to-desarrollo.js`: mueve la ventana `devkitty` a Desarrollo y la
> deja sin borde **sin cambiar el escritorio activo** (una regla sí lo cambiaría).
> El kitty normal NO abre tmux: es un `.desktop` aparte, `kitty.conf` no se toca.

---

## 🧰 Clásicos de Plasma (defaults)

| Qué hace | Atajo |
|---|---|
| Lanzador (KRunner: escribí y Enter) | `Alt+F2` |
| Menú de aplicaciones | `Meta` |
| Cambiar de ventana | `Alt+Tab` |
| Siguiente **actividad** (ocupada → la hoja quedó en Meta+H) | `Meta+A` |
| Configuración de pantallas | `Meta+P` |
| Administrador de procesos | `Ctrl+Esc` |
| Cerrar la ventana/panel enfocado | `Alt+F4` |

---

## 🗂️ Hojas

- [x] `tmux.md` · [x] `yazi.md` · [x] `zsh.md` · [x] `nvim.md` · [x] `kde.md`

> kitty fuera por decisión: tmux gestiona ventanas/paneles