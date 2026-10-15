# Instalar en una CachyOS nueva

Guía para reproducir este entorno en otra máquina con **CachyOS + KDE Plasma 6**.
El repo versiona todo el look; lo que queda afuera son tres pasos manuales
(marcados abajo) y los paquetes.

## 1. Requisitos

| Paquete | Para qué |
|---|---|
| `kvantum` | Widget style de Qt — el tema global pinea `widgetStyle=kvantum` |
| `plasma-workspace` | `kwriteconfig6`, `qdbus6`, `plasma-apply-lookandfeel` (viene con Plasma) |
| `papirus-icon-theme` | Iconos que pinea el tema global (`Papirus-Dark`) |
| `breeze-cursors` | Cursor `breeze_cursors` (lo pinea el tema global) |
| `kitty`, `tmux`, `zsh`, `yazi`, `neovim`, `fzf` | Terminal y shell |
| `ttf-meslo-nerd` | Fuente de kitty (`MesloLGS Nerd Font Mono`) y glifos del status de tmux / p10k |
| `cachyos-zsh-config` | oh-my-zsh + powerlevel10k del sistema (`/usr/share/cachyos-zsh-config`) |
| `yakuake` | Terminal desplegable; su skin y el perfil de Konsole que usa están versionados |
| `zoxide` | `z` (salto rápido a directorios) |
| `glow` | Hojas de atajos del atajo global `Meta+H` |
| `obsidian` | Abre el vault del repo (`~/alejandria/js-curso-jonmircha`) |
| `jq` | `obsidian/register-vault.sh` lo usa para mergear el registro de vaults |

La mayoría viene en CachyOS por defecto; `kvantum`, `yazi` y `glow` dependen de
la edición que hayas instalado.

## 2. Instalación

```bash
git clone https://github.com/luquitas45/luquitas45.dotfiles ~/dotfiles
cd ~/dotfiles
bash install.sh                # crea los symlinks (idempotente, nunca pisa archivos reales)
bash kde/apply-gorgoroth.sh    # tema global + Kvantum + panel translúcido + blur
bash kde/apply-wallpaper.sh    # fondo de pantalla versionado (a la actividad actual)
bash obsidian/register-vault.sh  # con Obsidian CERRADO: lo apunta al vault del repo
# cerrar sesión y volver a entrar
```

> **Mientras el PR siga abierto**, el look completo (tema global, Kvantum y
> Aurorae recolorados, `apply-gorgoroth.sh` delegado) vive en la branch
> `feat/gorgoroth-global-theme`. Cloná con `-b feat/gorgoroth-global-theme`, o
> esperá el merge a `main`.

`install.sh` ahora:

- arma el **plan completo** antes de tocar nada y es **all-or-nothing**: con
  cualquier destino ocupado no crea ni un link;
- `bash install.sh --check` imprime el plan sin crear nada (sale 1 si hay conflictos);
- avisa si faltan las herramientas del look (nunca instala paquetes).

## 3. Pasos manuales (no versionables)

| Qué | Por qué | Doc |
|---|---|---|
| Layout del panel | los IDs de containment son por máquina | `kde/fancytasks-panel.md` |
| Login (`plasmalogin`): fondo + tema | requiere root (`/usr`, `/etc`, `~plasmalogin`); script `kde/apply-login.sh` | `kde/README.md` |
| Plugin manager de tmux (TPM) | los plugins no están en el repo | abajo |
| Widget FancyTasks (opcional) | hay que agregarlo al panel | `kde/fancytasks-panel.md` |

TPM, una sola vez:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# dentro de tmux: prefijo (C-a) + I  instala navigator/resurrect/continuum
```

Login de Plasma (`plasmalogin`), root:

```bash
sudo bash kde/apply-login.sh    # fondo + tema Gorgoroth del login
```

## 4. Si `install.sh` reclama

Nunca sobreescribe un archivo real. Si un destino ya existe (por ejemplo un
Kvantum o un plasmoid bajado aparte), imprime la receta exacta:

```bash
mv '~/.config/Kvantum/Monochrome' '~/.config/Kvantum/Monochrome.orig'
bash install.sh
```

## 5. Cambiar la paleta

Los temas derivados se generan con scripts deterministas; el punto de edición es
siempre un `palette.map`:

```bash
# Kvantum -> Gorgoroth, GorgorothBlur, GorgorothSolid
$EDITOR kde/kvantum/palette.map && bash kde/kvantum/recolor.sh && bash kde/kvantum/verify.sh

# Aurorae -> decoración Gorgoroth (hex en los SVG + tripletas RGB en el .rc)
$EDITOR kde/aurorae/palette.map && bash kde/aurorae/recolor.sh && bash kde/aurorae/verify.sh

# Iconos del shell (Plasma desktop theme): restos de Breeze -> paleta
# (migración en el lugar; incluye el bloque inerte de placeholders)
bash kde/plasma-icons/recolor.sh && bash kde/plasma-icons/verify.sh
```

`verify.sh` falla si queda un color de la paleta vieja. Detalles de cada mapeo
(qué se preserva y por qué) en `kde/README.md`.

## 6. Volver atrás

```bash
plasma-apply-lookandfeel -a Monochrome   # tema, scheme, acento, iconos, cursor, decoración
kvantummanager --set MonochromeBlur      # el widget style es independiente del global theme
# panel opaco de nuevo (el id del containment, p.ej. 23):
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc \
  --group Containments --group 23 --group General --key opacity ""
```

## 7. Notas

- Los temas vendorizados (Kvantum y Aurorae de Monochrome) son GPLv3 de Patrik
  Wyde: se conservan `AUTHORS` y `LICENSE` en cada carpeta.
- `scripts/check-portable.sh` falla si alguien vuelve a meter una ruta
  `/home/<usuario>` en un archivo machine-read: usá `$HOME` en runtime (dentro de
  `sh -c`) o un helper resuelto por PATH.
- `config/nvim/` se linkea como directorio completo; los plugins viven en
  `~/.local/share/nvim` (fuera del repo).
- El wallpaper vive en el repo (`plasma/wallpapers/gorgoroth.png`) y `install.sh`
  lo linkea a `~/.local/share/wallpapers/gorgoroth.png`. `kde/apply-wallpaper.sh`
  lo aplica a la actividad actual con `plasma-apply-wallpaperimage`; Plasma lo
  direcciona por ruta absoluta, por eso se resuelve vía `$HOME` y nunca con un
  `/home/<usuario>` hardcodeado.
- **Obsidian**: `install.sh` linkea el vault `curso-js/vault` a
  `~/alejandria/js-curso-jonmircha`. El registro de vaults de la app
  (`~/.config/obsidian/obsidian.json`) guarda rutas **absolutas** y Obsidian lo
  reescribe en runtime, así que no se versiona: `obsidian/register-vault.sh` lo
  regenera por máquina (idempotente, `--check`, `--no-open`). Requiere Obsidian
  **cerrado** porque la app pisa el archivo al salir. La config del vault
  (`.obsidian/`, que cae en el repo vía el symlink) sí se versiona, salvo
  `workspace.json` y `workspace-mobile.json` (ver `.gitignore`).
