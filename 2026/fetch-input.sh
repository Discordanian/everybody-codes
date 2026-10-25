#!/bin/bash
# Fetch unlocked Everybody Codes 2026 inputs into the Godot user:// folder.
# Usage: ./fetch-input.sh QUEST [QUEST...]

# Everytime I have AI audit my scripts, it wants to add this `set` param.
set -euo pipefail

YEAR=2026
ECD="${HOME}/.local/bin/ecd"
DEST="${HOME}/Library/Application Support/Godot/app_userdata/Everybody Codes ${YEAR}"

if [[ $# -lt 1 ]]; then
	echo "usage: $(basename "$0") QUEST [QUEST...]" >&2
	echo "quest numbers are 1-20. Year is ${YEAR}." >&2
	exit 2
fi

if [[ ! -x "$ECD" ]]; then
	echo "ecd not found at ${ECD}" >&2
	exit 1
fi

mkdir -p "$DEST"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

for quest in "$@"; do
	if [[ ! "$quest" =~ ^([1-9]|1[0-9]|20)$ ]]; then
		echo "quest must be 1-20, got: ${quest}" >&2
		exit 2
	fi

	if ! "$ECD" "$quest" "$YEAR" >"$tmp"; then
		echo "ecd failed for quest ${quest}" >&2
		exit 1
	fi

  # Running a python3 script on the fly using a HEREDOC
	python3 - "$DEST" "$YEAR" "$quest" "$tmp" <<'PY'
import json
import sys
from pathlib import Path

dest = Path(sys.argv[1])
year = int(sys.argv[2])
quest = int(sys.argv[3])
data = json.loads(Path(sys.argv[4]).read_text())

written: list[str] = []
waiting: list[str] = []
for part in ("1", "2", "3"):
    filename = f"everybody_codes_e{year:04d}_q{quest:02d}_p{part}.txt"
    if part in data:
        (dest / filename).write_text(data[part])
        written.append(part)
    else:
        waiting.append(part)

wrote = ", ".join(f"p{part}" for part in written) or "nothing"
held = ", ".join(f"p{part}" for part in waiting) or "nothing"
print(f"quest {quest:02d}: wrote {wrote}; not available yet: {held}")
PY
done
