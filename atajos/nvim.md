# 🎮 Atajos — nvim (LazyVim)

> Config en `~/.config/nvim` · Leader: `Espacio` (lo llamamos `<space>`) · Tema Gorgoroth
> Casi todo arranca con el leader: **`<space> + tecla`**

---

## 🧭 Movimiento (modo normal)

| Qué hace | Atajo |
|---|---|
| Moverse | `h j k l` |
| Saltar palabra atrás / adelante | `b w` |
| Inicio / fin de línea | `0` / `$` |
| Inicio / fin del archivo | `gg` / `G` |
| Media página abajo / arriba | `Ctrl+d` / `Ctrl+u` |
| Ir a la línea N | `N gg` |
| Deshacer / rehacer | `u` / `Ctrl+r` |
| Buscar texto | `/texto` · `n` = siguiente · `N` = anterior |
| Repetir último cambio | `.` |
| Salir del modo normal al insert | `i` (donde estás) · `a` (adelante) · `A` (fin de línea) · `o` (línea nueva) · `cc` (cambiar línea) |

---

## 🪟 Ventanas (splits)

| Qué hace | Atajo |
|---|---|
| Split **horizontal** (abajo) | `<space>-` |
| Split **vertical** (derecha) | `<space>\|` |
| Moverse entre ventanas (tmux↔nvim) | `Ctrl+h j k l` |
| Redimensionar (pasos de 2) | `Ctrl+↑↓←→` |
| Zoom ventana (max/restaurar) | `Ctrl+w z` |
| Cerrar ventana / buffer sin guardar | `Ctrl+w q` |

---

## 🗂️ Archivos (picker)

| Qué hace | Atajo |
|---|---|
| **Buscar archivos** | `<space><space>` o `<space>ff` |
| Buscar archivos del repo (git) | `<space>fg` |
| Archivos recientes | `<space>fr` |
| **Buscar texto en el proyecto** (grep) | `<space>/` |
| Buffers abiertos | `<space>fb` (o `<space>,`) |
| Historial de comandos | `<space>:` |
| Cambiar de proyecto | `<space>fp` |
| **yazi flotante** (tus atajos de yazi) | `<space>e` · toggle: `<space>E` |

---

## 💾 Buffers (archivos abiertos)

| Qué hace | Atajo |
|---|---|
| Buffer anterior / siguiente | `Shift+h` / `Shift+l` |
| Alternar con el último buffer | `<space>bb` |
| Cerrar buffer | `<space>bd` |
| Cerrar buffer y ventana | `<space>bD` |

---

## 🐙 Git

| Qué hace | Atajo |
|---|---|
| **lazygit** (repo actual) | `<space>gg` |
| Estado de cambios | `<space>gs` |
| Diff de cambios | `<space>gd` |
| Blame de la línea | `<space>gb` |
| Log del repo | `<space>gl` |

---

## 🔬 LSP (con servidor del lenguaje activo)

| Qué hace | Atajo |
|---|---|
| Ir a la **definición** | `gd` |
| Ver **referencias** | `gr` |
| Documentación (hover) | `K` |
| **Acción de código** (fix rápido) | `<space>ca` |
| Renombrar símbolo | `<space>cr` |
| Renombrar archivo | `<space>cR` |
| Diagnóstico de la línea | `<space>cd` |
| Siguiente / anterior diagnóstico | `]d` / `[d` |

---

## ✍️ Edición

| Qué hace | Atajo |
|---|---|
| Guardar | `Ctrl+s` |
| Mover línea / bloque arriba-abajo | `Alt+j` / `Alt+k` |
| Comentar / descomentar línea | `gcc` |
| Comentar un movimiento (p. ej. `gcw`) | `gc + movimiento` |
| Archivo nuevo | `<space>fn` |
| Menú de plugins (actualizar, instalar) | `<space>l` |
| Formatear archivo | `<space>cf` |

---

## 🛠️ Mantenimiento

| Qué hace | Comando / atajo |
|---|---|
| Abrir nvim | `nvim` o `nvim archivo` |
| Instalar/actualizar plugin extra (Mason) | `:Mason` |
| Menú completo de atajos | `<space>` (esperá: aparece which-key) |

> Después de editar `lua/plugins/*.lua` reiniciá nvim (instala solo lo nuevo).
> La primera apertura tras activar extras descarga plugins + servidores — paciencia.

---

## 🗂️ Hojas

- [x] `tmux.md` · [x] `yazi.md` · [x] `zsh.md` · [x] `nvim.md` · [x] `kde.md`
