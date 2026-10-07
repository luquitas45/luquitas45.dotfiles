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
| Dev kitty (launcher + autostart) | `kde/dev-kitty.sh` + `kde/net.local.kitty.dev.desktop` | `~/.local/bin/dev-kitty` + `~/.local/share/applications/` + `~/.config/autostart/` |
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
| 1 | `Principal` | `Meta+Z` |
| 2 | `Desarrollo` | `Meta+X` |

```bash
bash kde/apply-desktops.sh   # crea lo que falte, renombra, bindea y verifica
```

Los atajos se aplican con `setForeignShortcut` de `org.kde.kglobalaccel` (en
Plasma 6 lo expone el propio KWin; es el único mecanismo que aplica en caliente)
y después se **verifican leyéndolos de vuelta**: el script sale con error si el
readback no muestra `Meta+Z`/`Meta+X` como activos. Seguro de re-ejecutar: no
duplica escritorios ni falla si ya está todo aplicado.

## Kitty dev (tmux) en Desarrollo

Un segundo kitty dedicado a desarrollo: abre (o adjunta) la sesión tmux `dev`
con `tmux new-session -A -s dev`, arranca solo al login vía autostart y una
regla de KWin lo fuerza al escritorio **Desarrollo**, sin borde. No toca
`kitty.conf`: todo va por línea de comandos (`--class devkitty`) y por regla de
ventana, así que el kitty normal sigue abriendo un shell pelado.

La ventana queda **visible** en Desarrollo, pero ya no te arrastra allí al
loguéate: son dos mecanismos en paralelo. La regla KWin le pone
`fsplevel=4`/`fsplevelrule=2` (Focus stealing prevention en *Extreme*), que
**niega** la petición de foco y evita que KWin siga a la ventana al otro
escritorio; y el `.desktop` ejecuta el wrapper `kde/dev-kitty.sh`, que se
acuerda del escritorio activo antes del lanzamiento, deja mapear la ventana y
lo devuelve a donde estaba. `install.sh` linkea el wrapper en
`~/.local/bin/dev-kitty`.

```bash
bash kde/apply-dev-kitty.sh   # crea/actualiza la regla y verifica el readback
```

El script lee el UUID del escritorio Desarrollo en runtime por D-Bus (nada
hardcodeado) y escribe la regla en la ruta real del repo:
`~/.config/kwinrulesrc` es un symlink y `kwriteconfig6` escribe con tmp+rename,
así que apuntar al symlink lo reemplazaría con un archivo real — el script
verifica después que el symlink siga intacto. Idempotente: localiza la regla
por `wmclass=devkitty` (o por su `Description`) y la actualiza en el sitio;
sólo la agrega si no existe, manteniendo `[General] count`/`rules` consistentes.

Si la regla se acaba de crear, un re-login asegura que KWin la cargue y la
aplique a las ventanas nuevas.

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
