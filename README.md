# dotfiles

Configuración del entorno de `lucas` (CachyOS + KDE Plasma):

- **tmux** — barra arriba, tema Gorgoroth, plugins TPM (navigator/resurrect/continuum)
- **zsh** — oh-my-zsh + powerlevel10k, vi-mode, fzf, zoxide, yazi integrada `y()`
- **kitty** — tema Gorgoroth (black-metal-gorgoroth.conf incluido)
- **yazi** — theme.toml Gorgoroth portado a yazi 26
- **nvim** — LazyVim 16 con extras (picker, markdown/json/yaml/typescript, prettier), yazi.nvim y navegación tmux↔nvim
- **pi** — tema Gorgoroth para Pi
- **kde** — atajo global Meta+H → hojas de atajos (glow), escritorios Principal/Desarrollo y kitty dev on-demand
- **plasma** — desktop theme, color scheme y look-and-feel Gorgoroth, y el **wallpaper versionado** (`plasma/wallpapers/gorgoroth.png`)
- **atajos/** — las hojas de atajos (`~/Documentos/atajos`, linkeadas como carpeta: nueva hoja = se versiona sola)
- **curso-js/** — curso de JavaScript de Jon Mircha: vault de Obsidian (`~/alejandria/js-curso-jonmircha`, linkeado), ejercicios de práctica, skill del flujo Pi y memoria exportada

## Instalación

Guía completa (paquetes, pasos manuales, rollback): [`docs/install-cachyos.md`](docs/install-cachyos.md).

```bash
cd ~/dotfiles
bash install.sh                # symlinks (idempotente, nunca pisa archivos reales)
bash kde/apply-gorgoroth.sh    # tema global + Kvantum + panel + blur, después relogin
bash kde/apply-wallpaper.sh    # fondo de pantalla versionado (a la actividad actual)
```

El primer script crea **symlinks** desde el repo hacia `$HOME` (el repo es la
única fuente: editar la config real edita el repo). Arma el plan completo antes
crear nada y es **all-or-nothing**: si un destino existe sin ser symlink, lista
todos los conflictos con la receta para resolverlos y no crea ningún link.
`bash install.sh --check` sólo imprime el plan.

## Agregar una config nueva

1. Copiá el archivo al repo manteniendo la jerarquía de `$HOME`
   (`home/.algo` o `config/app/algo`).
2. Agregá el par al array `LINKS` de `install.sh`.
3. Corré `bash install.sh` de nuevo.

## Notas

- `config/nvim/` se linkea como **directorio completo** (su contenido crece;
  lazy.nvim escribe `lazy-lock.json` ahí con cada update).
- Los plugins de nvim viven en `~/.local/share/nvim` (fuera del repo); acá
  solo la configuración.
- `~/Documentos/atajos/` es un symlink a `atajos/` del repo: las hojas de
  atajos (accesibles con Meta+H → glow) se versionan junto con el resto.
- `Meta+H` funciona con cualquier home: el `.desktop` expande `$HOME` en runtime.
- `scripts/check-portable.sh` falla si un archivo machine-read hardcodea
  `/home/<usuario>`.