#!/usr/bin/env bash
# Print the YAML frontmatter of every ability, in filename order.
set -euo pipefail

shopt -s nullglob

dir=$(CDPATH= cd -- "$(dirname -- "$0")/../abilities" && pwd)

if (($# != 0)); then
  echo "usage: skills/ability/scripts/list.sh" >&2
  exit 2
fi

# Print the YAML frontmatter, including the --- lines.
# Exit 2 if the first line is --- and no later line is ---.
# Print nothing when the file has no frontmatter.
read_frontmatter() {
  awk '
    NR == 1 && $0 == "---" { on = 1; buf = $0 ORS; next }
    on && $0 == "---" { printf "%s%s%s", buf, $0, ORS; closed = 1; exit 0 }
    on { buf = buf $0 ORS; next }
    END { if (on && !closed) exit 2 }
  ' "$1"
}

names=()
blocks=()
open=()

for path in "$dir"/*.md; do
  names+=("$(basename -- "$path" .md)")
done
if ((${#names[@]})); then
  mapfile -t names < <(printf '%s\n' "${names[@]}" | LC_ALL=C sort)
fi

for name in "${names[@]+"${names[@]}"}"; do
  if block=$(read_frontmatter "$dir/$name.md"); then
    blocks+=("$block")
  else
    open+=("$name")
  fi
done

if ((${#open[@]})); then
  for name in "${open[@]}"; do
    printf 'unclosed frontmatter: %s\n' "$name" >&2
  done
  exit 1
fi

for block in "${blocks[@]+"${blocks[@]}"}"; do
  [[ -n "$block" ]] || continue
  printf '%s\n' "$block"
done
