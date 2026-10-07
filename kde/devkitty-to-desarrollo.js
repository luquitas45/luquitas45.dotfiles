// KWin helper for the dev kitty (load via /Scripting from kde/dev-kitty.sh).
//
// Moves every window with class "devkitty" to the "Desarrollo" desktop and
// keeps it borderless. Moving a window AFTER it was created does NOT switch the
// current desktop (unlike a forced-desktop window rule, which makes KWin follow
// the new window). That is why this is a script and not a rule.

function devkitty(w) {
  if (String(w.resourceClass) !== "devkitty") {
    return;
  }
  var desktops = workspace.desktops;
  var target = null;
  for (var i = 0; i < desktops.length; i++) {
    if (desktops[i].name === "Desarrollo") {
      target = desktops[i];
      break;
    }
  }
  if (!target) {
    return;
  }
  w.desktops = [target];
  w.noBorder = true;
  print("DEVKITTY " + w.caption + " -> " + w.desktops[0].name + " noBorder=" + w.noBorder);
}

workspace.windowAdded.connect(devkitty);

// Handle windows that already exist when this script loads.
var existing = workspace.windowList();
for (var i = 0; i < existing.length; i++) {
  devkitty(existing[i]);
}

print("DEVKITTY helper active");
