# KDE / Plasma — capa Gorgoroth

Qué versiona el repo para la sesión Plasma y cómo se aplica.

> Instalación en una máquina nueva (paquetes, pasos manuales, rollback):
> [`docs/install-cachyos.md`](../docs/install-cachyos.md).

## Componentes

| Componente | En el repo | Linkeado a |
|---|---|---|
| Plasma style (desktop theme) | `plasma/desktoptheme/gorgoroth` | `~/.local/share/plasma/desktoptheme/gorgoroth` |
| Color scheme | `plasma/colorschemes/Gorgoroth.colors` | `~/.local/share/color-schemes/Gorgoroth.colors` |
| Global theme | `plasma/look-and-feel/org.lucas.gorgoroth` | `~/.local/share/plasma/look-and-feel/org.lucas.gorgoroth` |
| Kvantum (widget style) | `kde/kvantum/` | `~/.config/Kvantum/*` |
| Aurorae (decoración de ventanas) | `kde/aurorae/` | `~/.local/share/aurorae/themes/*` |
| FancyTasksNG (taskbar) | `kde/plasmoids/io.github.daydve.fancytasksng` | `~/.local/share/plasma/plasmoids/…` |
| Panel / taskbar | `kde/fancytasks-panel.md` | — |
| Yakuake (terminal desplegable) | `kde/yakuake/` | `~/.config/yakuakerc`, `~/.local/share/yakuake/skins/*` |
| Konsole (perfil + schemes) | `kde/konsole/` | `~/.local/share/konsole/{Kitty.profile,*.colorscheme}` |

## Iconos

| Capa | Theme | Dónde | Versionado |
|---|---|---|---|
| Iconos de apps (menú, launcher, taskbar) | `Papirus-Dark` | paquete `papirus-icon-theme` | no: paquete, lo pinea el global theme |
| Iconos del shell / bandeja (batería, red, volumen, notificaciones…) | propios del theme | `plasma/desktoptheme/gorgoroth/icons/` (66 SVG) | **sí, en el repo** |
| Cursor | `breeze_cursors` | paquete `breeze-cursors` | no: paquete, lo pinea el global theme |
| Botón de Kickoff | `org.cachyos.hello` | paquete de CachyOS, per-widget | no (parte del layout del panel) |
| Launchers de FancyTasks | icono de cada app | su `.desktop` (resuelto por Papirus-Dark) | n/a |

Detalle que importa: en Plasma, los iconos que trae el **desktop theme** ganan
sobre el icon theme para los widgets del shell. Por eso la bandeja (batería, red,
volumen, notificaciones) se dibuja con los SVG del repo y no con Papirus — y por
eso recolorearlos ahí tiene efecto real.

Estado de la paleta en esos 66 iconos: 33 ya usan el teal `#5f8787`; **29 todavía
tienen azul de Breeze** (`#3daee6`/`#93cee9`) — `osd.svg` completo (36
ocurrencias) y 2 en cada uno de otros 28. Pendiente: extender la recoloración a
estos SVG con su propio `palette.map` + `recolor.sh` + `verify.sh`, igual que
Kvantum y Aurorae.

## Yakuake y Konsole

El terminal desplegable y su paleta, versionados y derivados de la misma fuente
que kitty (`config/kitty/black-metal-gorgoroth.conf`).

| Pieza | Origen (vendored) | Derivado | Verify |
|---|---|---|---|
| Skin de Yakuake | `kde/yakuake/skins/upstream-monochrome/` | `kde/yakuake/skins/Gorgoroth/` | `kde/yakuake/verify.sh` |
| Scheme de Konsole | `kde/konsole/colorschemes/KittyMonochrome.colorscheme` | `kde/konsole/colorschemes/Gorgoroth.colorscheme` | `kde/konsole/colorschemes/verify.sh` |

Detalles de cada formato:

- La skin de Yakuake es del **formato viejo** (sin metadata): `title.skin` y
  `tabs.skin` con geometría, rutas a SVG y el color de texto **por componente**
  (`red=170 green=170 blue=172`). El recolor toca los hex de los SVG, esos tres
  componentes, y aplica un override a `tabs/tab_selected.svg` para que la
  pestaña activa lleve el teal `#5f8787`.
- El scheme de Konsole se **genera por sección**, no por sustitución de valores:
  el Monochrome usa el mismo triplet (`30,30,32`) en `[Background]` y `[Color0]`,
  que deben terminar en valores distintos. Cada slot sale de kitty
  (`[ColorN]` = slot normal, `[ColorNIntense]` = bright) y `verify.sh` compara
  los 16 slots + background/foreground contra el conf de kitty, así los dos
  terminales no pueden divergir.

Aplicar (los dos archivos son symlinks del repo, así que el cambio aplica solo):

```bash
# Skin de Yakuake
kwriteconfig6 --file yakuakerc --group Appearance --key Skin gorgoroth
# Scheme del perfil que usa Yakuake
kwriteconfig6 --file ~/.local/share/konsole/Kitty.profile --group Appearance --key ColorScheme Gorgoroth
# Yakuake 26.08 no expone reload por DBus: reiniciar (las sesiones tmux sobreviven)
kill $(pgrep -x yakuake | head -1); setsid yakuake >/dev/null 2>&1 &
```

El reinicio es seguro porque el perfil corre `tmux new-session -A -s main`: el
server de tmux es un proceso aparte y Yakuake se reengancha al volver.

Rollback: `Skin=monochrome` + `ColorScheme=KittyMonochrome` y reiniciar (los dos
siguen vendorizados).

## Aplicar

```bash
bash install.sh                # crea todos los symlinks (idempotente)
bash kde/apply-gorgoroth.sh    # aplica el look y recarga la sesión
```

`apply-gorgoroth.sh` delega el look en el global theme
(`plasma-apply-lookandfeel -a org.lucas.gorgoroth`) y sólo escribe a mano lo
que un paquete look-and-feel no puede setear: transparencia del panel, blur de
KWin y la selección de tema de Kvantum (que vive en `kvantum.kvconfig`).

## Kvantum: recolor determinista

```
kde/kvantum/palette.map    # mapeo Monochrome -> Gorgoroth (hex, con roles)
kde/kvantum/recolor.sh     # genera Gorgoroth, GorgorothBlur, GorgorothSolid
kde/kvantum/verify.sh      # falla si sobrevive un hex legacy
```

- `#ff00ff` se preserva: es el marcador funcional `menu-shadow-hint`.
- `alt.base.color` y `highlight.text.color` se fuerzan por rol después del pase.
- Los valores con alpha (`#aaaaac78`) sobreviven porque el reemplazo es por
  substring de 6 hex.

## Aurorae: recolor determinista

```
kde/aurorae/palette.map    # hex para los SVG + tripletas RGB para el rc
kde/aurorae/recolor.sh     # genera la decoración Gorgoroth
kde/aurorae/verify.sh
```

- El rc de Aurorae usa **tripletas RGB**, no hex: el mapa se aplica en las dos
  formas.
- `*TextShadowColor=255,255,255,255` se preserva (funcional).
- `MonochromeBlur` no se deriva: su id upstream (`Monochrome Blur`) tiene un
  espacio y no round-trips limpio.

## SDDM (pantalla de login) — paso manual, root

El tema de login **no** está versionado porque vive en rutas root:

- tema: `/usr/share/sddm/themes/monochrome`
- selección: `/etc/sddm.conf.d/theme.conf` → `[Theme] Current=monochrome`

Para reproducirlo en otra máquina hay que copiar el tema y el `.conf` a mano
(con `sudo`). Pendiente evaluar versionarlo en `sddm/` con un install
documentado.

## Rollback

```bash
plasma-apply-lookandfeel -a Monochrome   # tema, scheme, acento, iconos, cursor y decoración
kvantummanager --set MonochromeBlur      # el widget style es independiente del global theme
# panel opaco de nuevo (id del containment del panel, p.ej. 23):
kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc \
  --group Containments --group 23 --group General --key opacity ""
bash kde/apply-gorgoroth.sh              # volver al look Gorgoroth
```

Ojo: `plasma-apply-lookandfeel -a Monochrome` **no** toca Kvantum (lee su
propio `kvantum.kvconfig`), por eso el rollback completo lleva los dos comandos.
El global theme `Monochrome` es de la KDE Store y vive en
`~/.local/share/plasma/look-and-feel/Monochrome`.

Backups de la migración: `~/dotfiles-backup/2026-10-06-gorgoroth-*`.
