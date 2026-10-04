# Reloj digital Gorgoroth (shadow package)

El reloj stock (`org.kde.plasma.digitalclock`) está compilado (sin QML en disco),
así que para separar el COLOR de la fecha del de la hora se instala un
**shadow package**: una copia del source oficial de plasma-workspace
(`applets/digital-clock`, branch master ~6.7) con un solo cambio:

```qml
PlasmaComponents.Label {
    id: dateLabel
    color: "#5f8787"   # <- INYECTADO: fecha teal, hora queda con el color del theme
```

El paquete de usuario vence al plugin compilado (verificado por medición:
fila de la fecha = 800px de teal exacto en pantalla).

## Config de la sesión (appletsrc — en la máquina)

```
[Containments][N][Applets][M][Configuration][General]
dateFormat=custom
customDateFormat=λ d MMM
```

OJO: en Plasma 6.7 `dateFormat` es un **string** ("custom" | "isoDate" | "longDate" |
shortDate por omisión) — un int 3 no entra al branch custom (bug que ya
padecimos). Se define por GUI (Configurar reloj → Formato de fecha →
Personalizada) o con kwriteconfig6.

## Mantenimiento

- El shadow usa imports versionados de plasma (`org.kde.plasma.clock`,
  `org.kde.plasma.private.digitalclock`): sobreviven updates menores.
- Si un update de Plasma cambia el source del applet (API del QML), hay que
  re-sincronizar: clonar `https://github.com/KDE/plasma-workspace`, copiar
  `applets/digital-clock/*` a este paquete y volver a inyectar la línea
  `color: "#5f8787"` tras el `id: dateLabel`.
- El backup del estado original está en
  `~/.local/share/plasma/plasmoids/org.kde.plasma.digitalclock.orig-bak`
  (en las máquinas donde se instaló con el flujo anterior).