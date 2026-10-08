# 🐭 Atajos — tmux

> Config en `~/.config/tmux/tmux.conf` · Prefijo: `Ctrl+a` (lo llamamos **C-a**)
> Barra de estado: **arriba**, sesión + ventanas centradas (sin reloj)

---

## 🚀 Arrancar / entrar / salir

| Qué hace | Atajo / comando |
|---|---|
| Crear sesión nueva | `tmux new -s nombre` |
| Ver sesiones activas | `tmux ls` |
| Volver a entrar a una sesión | `tmux attach -t nombre` |
| **Despegarte sin cerrar** (detach) | `C-a d` |
| Árbol de sesiones/ventanas (navegable) | `C-a s` |
| Sesión nueva con nombre (carpeta actual) | `C-a N` |
| Matar sesión (pide confirmación) | `C-a X` |
| Volver a la sesión anterior | `C-a B` |
| Renombrar sesión | `C-a $` |

---

## 💾 Sesiones que sobreviven reinicios (plugins)

| Qué hace | Atajo |
|---|---|
| **Guardar** el estado de todas las sesiones | `C-a C-s` |
| **Restaurar** lo guardado | `C-a C-r` |

> El **auto-restore está apagado** (`@continuum-restore off`): las sesiones fijas
> nacen de plantillas on-demand (sesiones fijas abajo), no de un snapshot. El
> guardado manual `C-a C-s` y el restore `C-a C-r` siguen activos; nvim vuelve con
> su sesión gracias a resurrect + strategy nvim.

---

## 📦 Sesiones fijas (presets on-demand)

`config/tmux/bin/sess-open <sesión>`: si la sesión no existe la construye con la
plantilla; si existe solo se adjunta. Yakuake adjunta `SAPE` y el kitty dev adjunta
`dev` (ambos resuelven `sess-open` por PATH, ~/.local/bin).

| Sesión | Para | Plantilla |
|---|---|---|
| `SAPE` | Yakuake | `terminal` (shell) · `IA` (pi en ~/workspace) |
| `dev` | kitty dev (Desarrollo) | `ws` paneles (nvim · shell · pi, ~/workspace) · `IA` (pi) |

---

## 🪟 Ventanas (tabs)

| Qué hace | Atajo |
|---|---|
| Ventana nueva (abre en la carpeta actual) | `C-a c` |
| Siguiente ventana | `C-a n` |
| Ventana anterior | `C-a p` |
| Renombrar ventana | `C-a ,` |
| Elegir ventana (listado) | `C-a w` |
| Cerrar ventana | `C-a &` |

> Las ventanas se **renumeran solas** al cerrar una (no quedan huecos).

---

## 🧩 Panes (divisiones)

| Qué hace | Atajo |
|---|---|
| Split **vertical** (lado a lado) | `C-a \|` |
| Split **horizontal** (arriba/abajo) | `C-a -` |
| Moverse entre panes **y splits de nvim** | `C-h` `C-j` `C-k` `C-l` |
| **Resize** del pane (pasos de 5, repetibles) | `C-a H` `J` `K` `L` |
| Zoom al pane (maximizar/restaurar) | `C-a z` |
| Escribir en **todos** los panes a la vez (toggle) | `C-a S` |
| Cerrar pane | `C-a x` |
| Terminal flotante **persistente** | `C-a f` |
| lazygit flotante | `C-a g` |

> 🎯 **Sin prefijo para moverse**: `C-h/j/k/l` cruzan panes de tmux y splits de
> nvim con la misma tecla (vim-tmux-navigator). Si el pane corre nvim, la tecla
> va a nvim; si no, cambia de pane.
> El flotante `C-a f` recuerda su estado: cerrar con `C-a d` adentro (la shell
> queda viva) y volvé a abrirlo cuando quieras con `C-a f`.

---

## 📋 Copiar / pegar (modo copia tipo vim)

| Qué hace | Atajo |
|---|---|
| Entrar al modo copia | `C-a [` o `C-a Escape` |

> ⚠️ `Esc` **suelto** (sin prefijo) NO es de tmux: atraviesa y le llega a zsh
> (modo normal de vi). Para copy-mode siempre con prefijo: `C-a Esc`.
| Empezar selección | `v` |
| Moverse | `h j k l` |
| **Copiar y salir** (→ portapapeles sistema) | `y` |
| Copiar sin salir | `Enter` |
| Pegar (dentro de tmux) | `C-a ]` |
| Buscar texto | `/` |
| Salir | `q` |

> Historial de scroll: **50.000 líneas** por pane. Con mouse: seleccionar copia
> directo al portapapeles (Wayland/wl-copy).

---

## 🛠️ Mantenimiento

| Qué hace | Atajo / comando |
|---|---|
| Recargar la config | `C-a r` |
| Ver **todos** los atajos cargados | `C-a ?` |
| Instalar plugins nuevos (TPM) | `C-a I` |
| Actualizar plugins (TPM) | `C-a U` |
| Matar todo tmux (cuidado) | `tmux kill-server` |

> Plugins en `~/.config/tmux/plugins/` (tpm vive en `~/.tmux/plugins/tpm`).

---

## 📌 Cheats globales de config (rápidos)

- Prefix: `C-a` · Doble `C-a C-a` = manda un Ctrl+a real a la app
- `mouse on` · splits/ventanas abren en la carpeta actual · índices desde `1`
- `escape-time 10`: nvim sin lag al salir de insert
- Barra arriba: sesión seguida de las ventanas (todo a la izquierda) · sin reloj · borde `#5f8787` debajo
- Dentro de tmux: `Alt+Enter` y `Shift+Enter` llegan a Pi como renglón nuevo (binds passthrough CSI u)

---

## 🗂️ Hojas

- [x] `tmux.md` · [x] `yazi.md` · [x] `zsh.md` · [x] `nvim.md` · [x] `kde.md`

> kitty queda fuera por decisión: tmux gestiona ventanas/paneles
