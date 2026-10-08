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
> (kitty → glow en el directorio de hojas). El atajo `Meta+H` lo aplica
> `bash kde/apply-shortcuts.sh` (idempotente, verificado).

---

## 🖥️ Escritorios virtuales

| Qué hace | Atajo |
|---|---|
| Ir al escritorio 1 · **Principal** | `Meta+Z` |
| Entrar a **Desarrollo** y lanzar/reusar el kitty dev | `Meta+X` |

> El escritorio 1 sigue bindeado a la acción `Switch to Desktop 1` de KWin;
> `Meta+X` es un *command shortcut* propio (componente
> `net.local.dev-desktop.desktop`, acción `_launch`) registrado con `doRegister`
> + `setForeignShortcut` de `org.kde.kglobalaccel`, que aplica en caliente. Se
> aplica con `bash kde/apply-desktops.sh` (idempotente, verifica el readback).

---

## 🐱 Kitty dev (tmux)

| Qué hace | Cómo |
|---|---|
| Terminal de desarrollo con tmux (sesión `dev`, la adjunta si ya existe) | `Meta+X` o menú de apps → **Kitty Dev (tmux)** |
| Ya no arranca al login | El login queda en **Principal** (se eliminó el autostart) |

> `Meta+X` llama a `kde/dev-desktop.sh` (`~/.local/bin/dev-desktop`): resuelve el
> escritorio `Desarrollo` desde D-Bus (sin uuid hardcodeado), cambia a ese
> escritorio **primero** y `exec`ea `kde/dev-kitty.sh`. Si ya hay un kitty
> `devkitty` corriendo lo **reusa** (sin duplicados). El KWin script
> `kde/devkitty-to-desarrollo.js` ahora sólo garantiza noborder/colocación. El
> kitty normal sigue sin tmux porque `kitty.conf` no se toca.

---

## 🔻 Yakuake (terminal desplegable)

| Qué hace | Atajo |
|---|---|
| Abrir/retraer Yakuake (sesión tmux `main`) | `Meta+D` |

> Skin Gorgoroth + perfil Konsole `Kitty.profile` vienen del repo; arranca sola al
> login (autostart). `Meta+D` dejó de ser "Show Desktop". El atajo lo registra la
> propia app (acción `toggle-window-state`); lo aplica `bash kde/apply-shortcuts.sh`
> (idempotente, verificado), igual que `Meta+H` del glow.

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