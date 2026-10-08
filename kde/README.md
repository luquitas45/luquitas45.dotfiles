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
| Dev kitty (launcher + atajo) | `kde/dev-kitty.sh` + `kde/dev-desktop.sh` + `kde/net.local.kitty.dev.desktop` + `kde/net.local.dev-desktop.desktop` | `~/.local/bin/` + `~/.local/share/applications/` |
| Reglas KWin de ventanas | `kde/kwinrulesrc` | `~/.config/kwinrulesrc` |

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

## Aplicar

```bash
bash install.sh                # crea todos los symlinks (idempotente)
bash kde/apply-gorgoroth.sh    # aplica el look y recarga la sesión
```

`apply-gorgoroth.sh` delega el look en el global theme
(`plasma-apply-lookandfeel -a org.lucas.gorgoroth`) y sólo escribe a mano lo
que un paquete look-and-feel no puede setear: transparencia del panel, blur de
KWin y la selección de tema de Kvantum (que vive en `kvantum.kvconfig`).

## Escritorios virtuales

Dos escritorios fijos, creados y nombrados de forma idempotente leyendo el
estado vivo de KWin por D-Bus (los ids se leen en runtime, nada hardcodeado):

| Escritorio | Nombre | Atajo |
|---|---|---|
| 1 | `Principal` | `Meta+Z` (acción `Switch to Desktop 1` de KWin) |
| 2 | `Desarrollo` | `Meta+X` — entra a Desarrollo y lanza/reusa el kitty dev |

```bash
bash kde/apply-desktops.sh   # crea lo que falte, renombra, bindea y verifica
```

`Meta+Z` sigue bindeado a la acción de KWin `Switch to Desktop 1`. `Meta+X` ya no
es `Switch to Desktop 2`: ahora dispara un *command shortcut* propio. Ambos se
aplican en caliente con `setForeignShortcut` de `org.kde.kglobalaccel` (en Plasma
6 lo expone el propio KWin) y después se **verifican leyéndolos de vuelta**: el
script sale con error si el readback no muestra `Meta+Z` con la tecla
`268435546`, si el componente dev no tiene `268435544`, o si KWin todavía
conserva `268435544` en `Switch to Desktop 2`. Seguro de re-ejecutar: no duplica
escritorios ni falla si ya está todo aplicado.

### Cómo se registra un command shortcut

Además del `.desktop` en `~/.local/share/applications/` con
`X-KDE-GlobalAccel-CommandShortcut=true`, KGlobalAccel necesita dos llamadas por
D-Bus: `doRegister` (componente + acción `_launch` + nombre) y
`setForeignShortcut` (bindea la tecla en caliente, sin re-login). `Meta+X` se
bindea al componente `net.local.dev-desktop.desktop` **antes** de liberarlo de
KWin, para que la tecla nunca quede muerta en el medio.

## Kitty dev (tmux) en Desarrollo

Un kitty dedicado a desarrollo: abre (o adjunta) la sesión tmux `dev` con
`tmux new-session -A -s dev`. No toca `kitty.conf`: todo va por línea de
comandos (`--class devkitty`), así que el kitty normal sigue abriendo un shell
pelado. **Ya no arranca al login** (se eliminó el autostart
`~/.config/autostart/net.local.kitty.dev.desktop`), por eso el login queda en
**Principal**. Se abre con `Meta+X` o desde el menú de apps.

`Meta+X` dispara el command shortcut `net.local.dev-desktop.desktop` →
`kde/dev-desktop.sh` (linkeado a `~/.local/bin/dev-desktop`), que:

1. resuelve el escritorio `Desarrollo` desde el listado vivo de D-Bus (sin uuid
hardcodeado; falla con un mensaje claro si no existe), y
2. cambia a ese escritorio **primero**, y
3. `exec`ea `kde/dev-kitty.sh` (resuelto relativo a `BASH_SOURCE`).

Cambiar primero garantiza que una ventana nueva nazca en Desarrollo. Si ya hay
un kitty `devkitty` corriendo, el wrapper lo **reusa** en vez de abrir un
duplicado (`pgrep -f -- '--class[= ]devkitty'`) y sale 0.

`kde/dev-kitty.sh` sigue cargando `kde/devkitty-to-desarrollo.js` como KWin
script (idempotente: se asegura aunque reuse), que deja **toda** ventana
`devkitty` sin borde y en Desarrollo. Ahora ese helper **sólo** garantiza
noborder/colocación; entrar a Desarrollo lo hace `dev-desktop.sh` antes de
lanzar. **Por qué un KWin script y no una regla de ventana**: una regla que
*fuerza* el escritorio hace que KWin **siga** la ventana nueva a Desarrollo (te
roba el escritorio); mover la ventana **después** de creada no cambia el
escritorio actual. Además las reglas de KWin sólo cargan al iniciar KWin y una
clave inválida puede descartar el archivo entero, así que no dependemos de ellas
para esto.

`~/.config/kwinrulesrc` conserva sólo la regla `[1]` (kitty común, sin borde).

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
