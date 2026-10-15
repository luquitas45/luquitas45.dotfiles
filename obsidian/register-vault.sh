#!/usr/bin/env bash
# Register the dotfiles Obsidian vault in the local Obsidian app.
#
# The vault lives in this repo (`curso-js/vault`) and is symlinked into $HOME by
# install.sh as `~/alejandria/js-curso-jonmircha`. Obsidian keeps its own vault
# registry in `$XDG_CONFIG_HOME/obsidian/obsidian.json`, which holds ABSOLUTE
# paths and is rewritten by the app at runtime — so it is NOT versioned. This
# script regenerates that entry per machine, idempotently.
#
# Obsidian must be closed: it keeps the registry in memory and overwrites the
# file on exit. Override with --force only if you know what you are doing.
#
# Usage:
#   bash obsidian/register-vault.sh            register and open the vault
#   bash obsidian/register-vault.sh --no-open  register without opening it
#   bash obsidian/register-vault.sh --check    print the plan, write nothing
#   bash obsidian/register-vault.sh --force    skip the "Obsidian is running" guard
#   bash obsidian/register-vault.sh --vault <path>   register another vault
#
# Env:
#   OBSIDIAN_VAULT_PATH   overrides the default vault path
set -euo pipefail

DEFAULT_VAULT="$HOME/alejandria/js-curso-jonmircha"
VAULT_PATH="${OBSIDIAN_VAULT_PATH:-$DEFAULT_VAULT}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/obsidian"
CONFIG_FILE="$CONFIG_DIR/obsidian.json"

OPEN=1
CHECK_ONLY=0
FORCE=0

die() { echo "register-vault: $*" >&2; exit 1; }

usage() { sed -n '2,22p' "${BASH_SOURCE[0]}"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --vault)     [ $# -ge 2 ] || die "--vault needs a path"; VAULT_PATH="$2"; shift 2 ;;
    --vault=*)   VAULT_PATH="${1#*=}"; shift ;;
    --no-open)   OPEN=0; shift ;;
    --check)     CHECK_ONLY=1; shift ;;
    --force)     FORCE=1; shift ;;
    -h|--help)   usage; exit 0 ;;
    *)           die "unknown argument: $1 (try --help)" ;;
  esac
done

# --- preconditions -----------------------------------------------------------

command -v jq >/dev/null 2>&1 || die "jq is required (sudo pacman -S jq)"

[ -d "$VAULT_PATH" ] || die "vault directory not found: $VAULT_PATH
  Run 'bash install.sh' first to create the ~/alejandria symlink."

# Normalize to an absolute path without resolving the final symlink: Obsidian
# should store the stable $HOME path, not the repo path behind the symlink.
case "$VAULT_PATH" in
  /*) ;;
  *) VAULT_PATH="$PWD/$VAULT_PATH" ;;
esac

obsidian_running() {
  pgrep -f 'obsidian/app\.asar' >/dev/null 2>&1
}

if [ "$FORCE" != 1 ] && obsidian_running; then
  die "Obsidian is running and will overwrite $CONFIG_FILE on exit.
  Quit Obsidian and re-run, or pass --force."
fi

# --- read the current registry ----------------------------------------------

if [ -s "$CONFIG_FILE" ]; then
  jq -e . "$CONFIG_FILE" >/dev/null 2>&1 \
    || die "$CONFIG_FILE is not valid JSON; fix or move it aside and retry."
  DOC="$(cat "$CONFIG_FILE")"
else
  DOC='{"vaults":{}}'
fi

# --- plan --------------------------------------------------------------------

ID="$(od -An -N8 -tx1 /dev/urandom | tr -d ' \n')"
[ "${#ID}" -eq 16 ] || die "could not generate a 16-hex vault id"
TS="$(date +%s%3N)"

NEW_DOC="$(
  jq -c \
    --arg path "$VAULT_PATH" \
    --arg id "$ID" \
    --argjson ts "$TS" \
    --argjson open "$OPEN" '
    def clear_open:
      .vaults = ((.vaults // {}) | with_entries(.value |= del(.open)));

    . as $doc
    | (($doc.vaults // {}) | to_entries | map(select(.value.path == $path)) | .[0]) as $hit
    | if $hit == null then
        ($doc
         | (if $open == 1 then clear_open else . end)
         | .vaults = ((.vaults // {}) + {
             ($id): ({path: $path, ts: $ts}
                     + (if $open == 1 then {open: true} else {} end))
           }))
      elif $open == 1 and ($hit.value.open != true) then
        ($doc | clear_open | .vaults[$hit.key].open = true)
      else
        $doc
      end
    | .vaults //= {}
  ' <<<"$DOC"
)"

BEFORE="$(jq -Sc . <<<"$DOC")"
AFTER="$(jq -Sc . <<<"$NEW_DOC")"
IDENT="$(jq -r --arg p "$VAULT_PATH" '.vaults | to_entries | map(select(.value.path == $p)) | .[0].key // "none"' <<<"$NEW_DOC")"

if [ "$CHECK_ONLY" = 1 ]; then
  echo "check only: nothing written."
  echo "  vault:  $VAULT_PATH"
  echo "  config: $CONFIG_FILE"
  if [ "$BEFORE" = "$AFTER" ]; then
    echo "  state:  already registered (no change)"
  else
    echo "  state:  would register as $IDENT"
  fi
  exit 0
fi

if [ "$BEFORE" = "$AFTER" ]; then
  echo "skip (already registered): $VAULT_PATH  [$IDENT]"
  exit 0
fi

# --- write atomically --------------------------------------------------------

mkdir -p "$CONFIG_DIR"
TMP="$(mktemp "$CONFIG_DIR/.obsidian.json.XXXXXX")"
trap 'rm -f "$TMP"' EXIT
printf '%s\n' "$NEW_DOC" > "$TMP"
chmod 600 "$TMP"
mv -f "$TMP" "$CONFIG_FILE"
trap - EXIT

echo "registered: $VAULT_PATH  [$IDENT]"
echo "  config: $CONFIG_FILE"
if [ "$OPEN" = 1 ]; then
  echo "  open:   this vault (others cleared)"
fi
echo ""
echo "Launch Obsidian to pick it up: obsidian &"
