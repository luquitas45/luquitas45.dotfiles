# dotfiles

Configuración del entorno de `lucas` (CachyOS + KDE Plasma):

- **tmux** — barra arriba, tema Gorgoroth, plugins TPM (navigator/resurrect/continuum)
- **zsh** — oh-my-zsh + powerlevel10k, vi-mode, fzf, zoxide, yazi integrada `y()`
- **kitty** — tema Gorgoroth (black-metal-gorgoroth.conf incluido)
- **yazi** — theme.toml Gorgoroth portado a yazi 26
- **nvim** — LazyVim 16 con extras (picker, markdown/json/yaml/typescript, prettier), yazi.nvim y navegación tmux↔nvim
- **pi** — tema Gorgoroth para Pi
- **kde** — atajo global Meta+H → hojas de atajos (glow)
- **atajos/** — las hojas de atajos (`~/Documentos/atajos`, linkeadas como carpeta: nueva hoja = se versiona sola)
- **curso-js/** — curso de JavaScript de Jon Mircha: vault de Obsidian (`~/alejandria/js-curso-jonmircha`, linkeado), ejercicios de práctica, skill del flujo Pi y memoria exportada

## Instalación

```bash
cd ~/dotfiles
bash install.sh
```

El script crea **symlinks** desde el repo hacia `$HOME` (el repo es la única
fuente: editar la config real edita el repo). Es idempotente y nunca pisa
archivos reales: si un destino existe sin ser symlink, avisa y sale.

## Agregar una config nueva

1. Copiá el archivo al repo manteniendo la jerarquía de `$HOME`
   (`home/.algo` o `config/app/algo`).
2. Agregá el par al array `LINKS` de `install.sh`.
3. Corré `bash install.sh` de nuevo.

## Notas

- `config/nvim/` se linkea como **directorio completo** (su contenido crece;
  lazy.nvim escribe `lazy-lock.json` ahí con cada update).
- `kde/net.local.kitty.desktop` embebe rutas absolutas de `lucas` (el wrapper
  de Meta+H del KDE global-shortcut). Ajustar si cambia el usuario.
- Los plugins de nvim viven en `~/.local/share/nvim` (fuera del repo); acá
  solo la configuración.
- `~/Documentos/atajos/` es un symlink a `atajos/` del repo: las hojas de
  atajos (accesibles con Meta+H → glow) se versionan junto con el resto.