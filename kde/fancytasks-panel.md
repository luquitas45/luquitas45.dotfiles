# Panel inferior y taskbar (barra Gorgoroth)

> El nombre del archivo quedó por historia: hoy el panel NO usa FancyTasksNG.
> El widget real de tareas es el **Icons-Only Task Manager** de Plasma
> (`org.kde.plasma.icontasks`). FancyTasksNG sigue versionado en el repo como
> alternativa (ver abajo), por si se retoma.

Panel único abajo con: Kickoff · Task Manager (solo iconos) · Mostrar escritorio ·
Reloj · Bandeja del sistema.

## Cómo se pintan los botones de tareas

El widget dibuja cada botón con un frame 9-slice de
`plasma/desktoptheme/gorgoroth/widgets/tasks.svg`, elegido por un prefijo que
depende del **estado** de la tarea y de la **ubicación del panel**:

| Estado de la tarea | Prefijo |
|---|---|
| Corriendo, no activa | `normal` |
| Ventana activa | `focus` |
| Pide atención | `attention` |
| Minimizada | `minimized` |
| Fijada pero no corriendo (launcher) | sin prefijo → sin fondo |

Para un panel abajo, `TaskTools.taskPrefix` resuelve a `south-<estado>` y cae al
`<estado>` sin ubicación: por eso los grupos **plain** (`normal-*`, `focus-*`, …)
son el set del panel inferior.

Cada frame tiene 9 elementos (`left/right/center/top/bottom` + las 4 esquinas).
La **barrita indicadora** es el borde que mira al contenido del escritorio, y se
pinta con más opacidad que el resto del fondo:

| Panel | Borde indicador |
|---|---|
| Abajo | `top` (+ `topleft`/`topright`) |
| Arriba | `bottom` (+ esquinas) |
| Izquierda | `right` (+ esquinas) |
| Derecha | `left` (+ esquinas) |

### Aspecto actual (Gorgoroth)

- `normal-*`: rectángulo gris completo → `ColorScheme-Text` en `opacity=".15"`.
- `focus-*`: el mismo gris `.15` **+ barra** en `ColorScheme-ButtonFocus`
  `opacity=".90"`.
- **Según qué se ve en apps abiertas vs. activa**, es sólo la diferencia entre el
  fondo gris y el fondo gris + barra de acento.

### Los colores salen del esquema, no del SVG

El bloque `<style id="current-color-scheme">` de `tasks.svg` **no manda**: KSvg
lo reemplaza al cargar por los colores del esquema activo
(`~/.local/share/color-schemes/Gorgoroth.colors`). Lo que importa en el SVG es
la **clase** (`ColorScheme-Text`, `ColorScheme-ButtonFocus`, …) y la **opacidad**.

| Clase | Esquema | Valor Gorgoroth |
|---|---|---|
| `ColorScheme-Text` | Foreground Normal | `#c1c1c1` |
| `ColorScheme-ButtonFocus` | Decoration Focus (acento) | `#5f8787` |

### Hover desactivado (a propósito)

`TaskTools.taskPrefixHovered` arma la cadena `<estado>-hover → hover → <estado>`.
Como el tema sólo define `hover-*`, el frame de hover **reemplazaba** al del
estado (el fondo y la barra aparecían sólo al pasar el mouse). Se removieron los
`hover-*-center` de `tasks.svg`: sin centro, `hasElementPrefix("hover")` da falso
y KSvg cae al frame del estado. Es el equivalente de tema a
`taskHoverEffect=false`, que en Plasma 6.7 no está expuesto en la GUI.

Si se quiere recuperar feedback de hover **sin** que la activa pierda la barra,
hay que agregar frames por estado (`focus-hover-*`, `normal-hover-*`).

### Recargar

```bash
plasmashell --replace &
```

## FancyTasksNG (alternativa versionada)

Se mantiene el plasmoid exacto en `kde/plasmoids/io.github.daydve.fancytasksng`
(linkeado por `install.sh`). Fue el taskbar original del setup; se lo puede
volver a poner desde "Añadir widgets → instalado".

- Config del applet: `bash ~/dotfiles/kde/fancytasks-config.sh` (indicador abajo,
  sin fondos inactivos, sin hover).
- Lo que aporta sobre icontasks: barra indicadora con el **color dominante de
  cada app** (`buttonColorizeDominant` / `indicatorColor`), cosa que icontasks no
  hace (usa sólo el acento del esquema).

## Notas

- El layout del panel (appletsrc) NO se versiona: tiene IDs de máquina
  (containment/applet). El orden se rearma a mano en 30 segundos.
- El config del widget se toca con click derecho en el panel → "Configurar
  gestor de tareas".
