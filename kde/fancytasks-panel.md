# Panel con FancyTasks (barra Gorgoroth)

El taskbar de la sesión es **FancyTasksNG** (fork de daydve del clásico FancyTasks,
estilo dash-to-panel) en un panel único con kickoff + pager + bandeja.

## Qué vive en el repo

| Pieza | Ruta del repo | Rol |
|---|---|---|
| Plasmoid FancyTasksNG | `kde/plasmoids/io.github.daydve.fancytasksng` | el widget (versión exacta, sin depender de la tienda) |
| Config del applet | `kde/fancytasks-config.sh` | aplica las keys (indicador abajo, sin fondos, etc.) al applet que hostea el plugin |
| Tema Gorgoroth | `plasma/desktoptheme/gorgoroth` | todo el shell (marco, iconos teal, tasks sin fondo) |

## Instalación (máquina nueva)

1. `bash ~/dotfiles/install.sh` — ya linkea el plasmoid (par en `install.sh`).
2. Crear un panel inferior (click derecho en el escritorio → "Añadir panel" → "Panel vacío").
3. Añadir widgets al panel: **FancyTasks** (de "Añadir widgets" → instalado), Kickoff, Pager (escritorios), Bandeja del sistema.
4. `bash ~/dotfiles/kde/fancytasks-config.sh` — aplica la configuración Gorgoroth.
5. Ordenar los applets arrastrándolos (kickoff · pager · tasks · bandeja) y ajustar el tamaño del panel a gusto.
6. `plasmashell --replace &` o reiniciar sesión.

## Configuración que aplica el script

- Indicador del app activo: **abajo** (`indicatorLocation=1`), tamaño 2, alineación inner, atenuado para inactivos, animado con `indicatorOverride=true`.
- Sin fondos en botones inactivos (`disableButtonInactiveSvg=true`), sin bordes (`useBorders=false`), sin efecto hover (`taskHoverEffect=false`).
- Separación agrupada: `groupingStrategy=0`.

## Notas

- El fondo del botón **activo** se quita por el theme: los grupos `focus-*` de
  `widgets/tasks.svg` están en `opacity="0"` (tema Gorgoroth).
- La posición del indicador vive en `indicatorLocation`: 0=arriba, 1=abajo, 2=izquierda, 3=derecha.
- El layout del panel (appletsrc) NO se versiona: tiene IDs de máquina. El orden se rearma a mano en 30 segundos.
- El config del widget se toca desde: click derecho en FancyTasks → Configurar → páginas (Apariencia / Indicadores / Comportamiento).