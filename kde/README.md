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

Cómo se colorean: los iconos resuelven el color **desde el scheme activo** vía
clases `ColorScheme-*` (913 usos) y el bloque `<style id="current-color-scheme">`,
que KSvg reemplaza al cargar — o sea que ese bloque es **inerte**. Lo que sí
estaba horneado eran restos de Breeze: 23 colores **pintados** (`fill:`/`stroke:`,
entre ellos los popups de OSD con `#3daee6` y `#7b7c7e`) y el resto sólo como
placeholders. `kde/plasma-icons/{palette.map,recolor.sh,verify.sh}` migró ambos:
los 66 SVG quedaron con **10 colores, todos de la paleta**
(`#888888` 68 · `#c1c1c1` 46 · `#5f8787` 44 · `#000000` 28 · `#8a4f4f` 23 ·
`#ddeecc` 16 · `#9b8d7f` 16 · `#222222` 12 · `#505050` 5 · `#aaaaaa` 3) y sin un
solo hex de Breeze en el directorio.

> Corrección: una versión anterior de este doc decía "29 de 66 todavía tienen azul
de Breeze". Ese conteo miraba **literales**, no colores pintados: esos azules
vivían dentro del bloque inerte de placeholders y no se renderizaban.

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
`sess-open dev` (que arma la plantilla fija, ver `atajos/tmux.md`). No toca
`kitty.conf`: todo va por línea de
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

El reinicio es seguro porque el perfil corre `sess-open SAPE`: el server de tmux
es un proceso aparte y Yakuake se reengancha al volver.

Rollback: `Skin=monochrome` + `ColorScheme=KittyMonochrome` y reiniciar (los dos
siguen vendorizados).

Atajo (toggle): la propia app registra `toggle-window-state` (default `F12`). En
estas máquinas se usa **`Meta+D`** — por lo tanto `Meta+D` deja de ser "Show
Desktop". Se aplica (idempotente, con readback) con `bash kde/apply-shortcuts.sh`.

> Nota: en esta máquina el doble escritorio usa la sesión fija `dev` (kitty
> `--class devkitty`) y Yakuake usa la sesión fija `SAPE`; ambas las arma
> `config/tmux/bin/sess-open` (ver `atajos/tmux.md`). Conviven sin pisarse.

## Aplicar

```bash
bash install.sh                # crea todos los symlinks (idempotente)
bash kde/apply-gorgoroth.sh    # aplica el look y recarga la sesión
bash kde/apply-shortcuts.sh    # atajos globales del repo (glow Meta+H, yakuake Meta+D)
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

## Login (plasmalogin) — paso manual, root

La pantalla de inicio de sesión **no** es SDDM: es **Plasma Login Manager**
(`plasmalogin.service`, paquete `plasma-login-manager`). Corre un greeter como el
usuario `plasmalogin` (home `/var/lib/plasmalogin`) con configuración **propia**:
no hereda nada de la sesión del usuario. Por eso fondo y colores van aparte y con
root.

Además el greeter no atraviesa el home del usuario (permisos 700): todo asset que
use tiene que estar en un path **world-readable** (`/usr`, `/usr/local`). Los
assets del repo ya viven ahí para el usuario; para el login hay que copiarlos.

### Fondo

Config en `/etc/plasmalogin.conf`, apuntando a una copia legible del PNG del repo:

```bash
sudo install -Dm644 ~/dotfiles/plasma/wallpapers/gorgoroth.png \
  /usr/local/share/wallpapers/gorgoroth.png
sudo kwriteconfig6 --file /etc/plasmalogin.conf \
  --group Greeter --key WallpaperPluginId org.kde.image
sudo kwriteconfig6 --file /etc/plasmalogin.conf \
  --group Greeter --group Wallpaper --group org.kde.image --group General \
  --key Image file:///usr/local/share/wallpapers/gorgoroth.png
```

Queda así:

```ini
[Greeter]
WallpaperPluginId=org.kde.image

[Greeter][Wallpaper][org.kde.image][General]
Image=file:///usr/local/share/wallpapers/gorgoroth.png
```

Va en `/etc/plasmalogin.conf` **directo**: los drop-ins en
`/etc/plasmalogin.conf.d/` todavía no respetan el wallpaper. (El fondo también se
puede elegir por GUI en Configuración del sistema → Pantalla de inicio de sesión.)

### Colores y Plasma style

Mismo color scheme y desktop theme del repo, pero system-wide y en la config del
greeter:

```bash
sudo install -Dm644 ~/dotfiles/plasma/colorschemes/Gorgoroth.colors \
  /usr/share/color-schemes/Gorgoroth.colors
sudo rm -rf /usr/share/plasma/desktoptheme/gorgoroth
sudo cp -a ~/dotfiles/plasma/desktoptheme/gorgoroth /usr/share/plasma/desktoptheme/gorgoroth
sudo chown -R root:root /usr/share/plasma/desktoptheme/gorgoroth

sudo cp -a /var/lib/plasmalogin/.config/kdeglobals /var/lib/plasmalogin/.config/kdeglobals.bak
sudo cp ~/dotfiles/plasma/colorschemes/Gorgoroth.colors /var/lib/plasmalogin/.config/kdeglobals
sudo kwriteconfig6 --file /var/lib/plasmalogin/.config/kdeglobals --group General --key accentColor "#c1c1c1"
sudo kwriteconfig6 --file /var/lib/plasmalogin/.config/kdeglobals --group General --key accentColorFromWallpaper false
sudo kwriteconfig6 --file /var/lib/plasmalogin/.config/kdeglobals --group Icons --key Theme Papirus-Dark
sudo kwriteconfig6 --file /var/lib/plasmalogin/.config/plasmarc --group Theme --key name gorgoroth
sudo chown plasmalogin:plasmalogin /var/lib/plasmalogin/.config/kdeglobals /var/lib/plasmalogin/.config/plasmarc
sudo chmod 600 /var/lib/plasmalogin/.config/kdeglobals /var/lib/plasmalogin/.config/plasmarc
```

> El `kdeglobals` del greeter usa exactamente los mismos grupos que el `.colors`,
> por eso se puede copiar tal cual. **No** aplicar el `LookAndFeelPackage`
> completo: un global theme arrastra su propio fondo y pisaría el wallpaper de
> arriba. Solo copiamos color scheme + Plasma style, que es lo que el greeter pinta.
>
> Las herramientas `plasma-apply-colorscheme/-desktoptheme/-lookandfeel` **no**
> sirven acá: son *session-aware* (consultan la sesión viva) y se niegan con
> "ya se está usando en la sesión actual".

Verificación (se ve recién en el próximo login/reboot; no reinicies
`plasmalogin.service`, te mata la sesión):

```bash
kreadconfig6 --file /var/lib/plasmalogin/.config/kdeglobals --group General --key ColorScheme  # Gorgoroth
kreadconfig6 --file /var/lib/plasmalogin/.config/plasmarc --group Theme --key name            # gorgoroth
sudo -u plasmalogin test -r /usr/local/share/wallpapers/gorgoroth.png && echo "fondo OK"
```

### Rollback

```bash
sudo rm -f /usr/local/share/wallpapers/gorgoroth.png
sudo rm -rf /usr/share/color-schemes/Gorgoroth.colors /usr/share/plasma/desktoptheme/gorgoroth
sudo rm -f /var/lib/plasmalogin/.config/plasmarc
# kdeglobals: restaurar kdeglobals.bak, o volver a Breeze Light desde Configuración del sistema
```

La **pantalla de bloqueo** es otra superficie aparte: `~/.config/kscreenlockerrc`
→ `[Greeter]` (hoy usa el default de Plasma).

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