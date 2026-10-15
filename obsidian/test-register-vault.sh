#!/usr/bin/env bash
# Tests for obsidian/register-vault.sh
#
# Runs everything against a throwaway HOME: the real ~/.config/obsidian is
# never touched. No Obsidian required.
#
# Usage: bash obsidian/test-register-vault.sh
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$REPO_DIR/obsidian/register-vault.sh"
VAULT_REL="alejandria/js-curso-jonmircha"

PASS=0
FAIL=0

ok()   { PASS=$((PASS + 1)); printf '  ok   %s\n' "$1"; }
bad()  { FAIL=$((FAIL + 1)); printf '  FAIL %s\n' "$1"; [ $# -gt 1 ] && printf '       %s\n' "$2"; }
check(){ if [ "$2" = "$3" ]; then ok "$1"; else bad "$1" "esperado [$3] · obtenido [$2]"; fi; }

# Fresh sandbox: fake HOME + a real vault directory inside it.
# Hermetic process guard: the host may or may not have Obsidian running, so the
# sandbox always provides its own pgrep. Default: not running.
ORIGINAL_PATH="$PATH"

set_obsidian_running() {
  local bin="$SANDBOX/fakebin"
  mkdir -p "$bin"
  printf '#!/usr/bin/env bash\nexit %s\n' "$1" > "$bin/pgrep"
  chmod +x "$bin/pgrep"
  PATH="$bin:$ORIGINAL_PATH"
  export PATH
}

new_sandbox() {
  SANDBOX="$(mktemp -d)"
  export HOME="$SANDBOX"
  export XDG_CONFIG_HOME="$SANDBOX/.config"
  unset OBSIDIAN_VAULT_PATH
  mkdir -p "$HOME/$VAULT_REL"
  VAULT_ABS="$HOME/$VAULT_REL"
  CONFIG="$HOME/.config/obsidian/obsidian.json"
  set_obsidian_running 1
}

cleanup() { [ -n "${SANDBOX:-}" ] && rm -rf "$SANDBOX"; }

echo "register-vault.sh"

# --- 1. Missing config file is created ---------------------------------------
new_sandbox
if bash "$SCRIPT" >/dev/null 2>&1; then ok "corre con obsidian.json ausente"; else bad "corre con obsidian.json ausente"; fi
if [ -f "$CONFIG" ]; then ok "crea el config dir y obsidian.json"; else bad "crea el config dir y obsidian.json"; fi
if jq -e . "$CONFIG" >/dev/null 2>&1; then ok "el JSON resultante es válido"; else bad "el JSON resultante es válido"; fi
check "registra exactamente un vault" "$(jq -r '.vaults | length' "$CONFIG")" "1"
check "guarda la ruta absoluta del vault" \
  "$(jq -r '.vaults[] | .path' "$CONFIG")" "$VAULT_ABS"
check "marca el vault como abierto" "$(jq -r '.vaults[] | .open' "$CONFIG")" "true"
check "el id es hex de 16 caracteres" \
  "$(jq -r '.vaults | keys[0] | test("^[0-9a-f]{16}$")' "$CONFIG")" "true"
check "guarda un ts en epoch-ms" \
  "$(jq -r '.vaults[] | .ts | type' "$CONFIG")" "number"
cleanup

# --- 2. Idempotent: a second run adds nothing --------------------------------
new_sandbox
bash "$SCRIPT" >/dev/null 2>&1
id_first="$(jq -r '.vaults | keys[0]' "$CONFIG")"
first="$(cat "$CONFIG")"
out="$(bash "$SCRIPT" 2>&1)"
second="$(cat "$CONFIG")"
check "segunda corrida no duplica el vault" "$(jq -r '.vaults | length' "$CONFIG")" "1"
check "el id se mantiene estable entre corridas" "$(jq -r '.vaults | keys[0]' "$CONFIG")" "$id_first"
case "$out" in
  *"already registered"*) ok "la segunda corrida reporta skip" ;;
  *) bad "la segunda corrida reporta skip" "salida: $out" ;;
esac
if [ "$first" = "$second" ]; then
  ok "la segunda corrida no modifica el archivo"
else
  bad "la segunda corrida no modifica el archivo"
fi
cleanup

# --- 3. Preserves foreign vaults, moves the open marker ----------------------
new_sandbox
mkdir -p "$(dirname "$CONFIG")"
cat > "$CONFIG" <<EOF
{"vaults":{"aaaaaaaaaaaaaaaa":{"path":"$HOME/otro-vault","ts":1111111111111,"open":true}}}
EOF
bash "$SCRIPT" >/dev/null 2>&1
check "preserva el vault ajeno" \
  "$(jq -r '.vaults["aaaaaaaaaaaaaaaa"].path' "$CONFIG")" "$HOME/otro-vault"
check "conserva el ts del vault ajeno" \
  "$(jq -r '.vaults["aaaaaaaaaaaaaaaa"].ts' "$CONFIG")" "1111111111111"
check "quita open del vault ajeno" \
  "$(jq -r '.vaults["aaaaaaaaaaaaaaaa"].open // "absent"' "$CONFIG")" "absent"
check "abre el vault del repo" "$(jq -r '.vaults[] | select(.path=="'"$VAULT_ABS"'") | .open' "$CONFIG")" "true"
cleanup

# --- 4. --no-open registers without stealing the open marker -----------------
new_sandbox
mkdir -p "$(dirname "$CONFIG")"
cat > "$CONFIG" <<EOF
{"vaults":{"bbbbbbbbbbbbbbbb":{"path":"$HOME/otro-vault","ts":1111111111111,"open":true}}}
EOF
bash "$SCRIPT" --no-open >/dev/null 2>&1
check "--no-open no abre el vault del repo" \
  "$(jq -r '.vaults[] | select(.path=="'"$VAULT_ABS"'") | .open // "absent"' "$CONFIG")" "absent"
check "--no-open respeta el open ajeno" \
  "$(jq -r '.vaults["bbbbbbbbbbbbbbbb"].open' "$CONFIG")" "true"
cleanup

# --- 5. --check plans without writing ----------------------------------------
new_sandbox
bash "$SCRIPT" --check >/dev/null 2>&1
if [ -f "$CONFIG" ]; then bad "--check no escribe obsidian.json"; else ok "--check no escribe obsidian.json"; fi
cleanup

# --- 6. Guard: refuses to run while Obsidian is open ------------------------
new_sandbox
set_obsidian_running 0
if bash "$SCRIPT" >/dev/null 2>&1; then
  bad "se niega a correr con Obsidian abierto"
else
  ok "se niega a correr con Obsidian abierto"
fi
if [ -f "$CONFIG" ]; then bad "no escribe nada con Obsidian abierto"; else ok "no escribe nada con Obsidian abierto"; fi
cleanup

# --- 7. Guard: --force overrides the running check --------------------------
new_sandbox
set_obsidian_running 0
if bash "$SCRIPT" --force >/dev/null 2>&1 && [ -f "$CONFIG" ]; then
  ok "--force escribe con Obsidian abierto"
else
  bad "--force escribe con Obsidian abierto"
fi
cleanup

# --- 8. Missing vault directory is an error ---------------------------------
new_sandbox
rmdir "$VAULT_ABS"
if bash "$SCRIPT" >/dev/null 2>&1; then bad "falla si el vault no existe"; else ok "falla si el vault no existe"; fi
cleanup

# --- 9. No hardcoded home paths in a machine-read file ----------------------
if grep -q '/home/' "$SCRIPT" 2>/dev/null; then
  bad "el script no hardcodea /home/<usuario>"
else
  ok "el script no hardcodea /home/<usuario>"
fi

echo ""
echo "  $PASS ok, $FAIL failed"
[ "$FAIL" -eq 0 ]
