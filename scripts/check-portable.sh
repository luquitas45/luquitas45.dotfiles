#!/usr/bin/env bash
# Fails if a tracked, machine-read file hardcodes a /home/<user> path.
#
# Exemptions (never read as a path at runtime):
#   - documentation (*.md): may quote paths as examples
#   - comment lines (leading #, after file:line:)
#   - Inkscape export metadata (inkscape:export-filename=...) inside SVG assets
#
# Usage: bash scripts/check-portable.sh
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

offenders="$(
  git ls-files -z \
    | grep -zv '\.md$' \
    | xargs -0 grep -In '/home/' 2>/dev/null \
    | grep -v 'inkscape:export-filename' \
    | grep -vE '^[^:]+:[0-9]+:[[:space:]]*#' \
    || true
)"

if [ -n "$offenders" ]; then
  echo "FAIL: hardcoded home paths in machine-read files:" >&2
  echo "$offenders" >&2
  echo "" >&2
  echo "Use \$HOME at runtime (inside sh -c) or a PATH-resolved helper instead." >&2
  exit 1
fi

echo "check-portable: OK (no hardcoded home paths)"
