#!/usr/bin/env bash
# Print each named ability as an <ability> element.
set -euo pipefail

shopt -s nullglob

dir=$(CDPATH= cd -- "$(dirname -- "$0")/../abilities" && pwd)

usage() {
  echo "usage: skills/ability/scripts/load.sh <name> [<name>...]" >&2
  exit 2
}

existing_names() {
  local path
  local names=()
  for path in "$dir"/*.md; do
    [[ -L "$path" ]] && continue
    names+=("$(basename -- "$path" .md)")
  done
  if ((${#names[@]})); then
    printf '%s\n' "${names[@]}" | LC_ALL=C sort
  fi
}

safe_name() {
  [[ "$1" =~ ^[A-Za-z0-9._-]+$ && "$1" != "." && "$1" != ".." ]]
}

if (($# == 0)); then
  usage
fi

missing=()
invalid=()
for name in "$@"; do
  if ! safe_name "$name"; then
    missing+=("$name")
  elif [[ -L "$dir/$name.md" ]]; then
    invalid+=("$name")
  elif [[ ! -f "$dir/$name.md" ]]; then
    missing+=("$name")
  fi
done

if ((${#missing[@]} || ${#invalid[@]})); then
  for name in "${missing[@]+"${missing[@]}"}"; do
    printf 'missing ability: %s\n' "$name" >&2
  done
  for name in "${invalid[@]+"${invalid[@]}"}"; do
    printf 'invalid ability file (symbolic link): %s\n' "$name" >&2
  done
  existing_names >&2
  exit 1
fi

for name in "$@"; do
  printf '<ability name="%s">\n' "$name"
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -- "$dir/$name.md"
  printf '</ability>\n'
done
