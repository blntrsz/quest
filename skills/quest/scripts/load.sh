#!/usr/bin/env bash
# Print each named quest as a <quest> element.
set -euo pipefail

shopt -s nullglob

dir=$(CDPATH= cd -- "$(dirname -- "$0")/../quests" && pwd)

usage() {
  echo "usage: skills/quest/scripts/load.sh <name> [<name>...]" >&2
  exit 2
}

existing_names() {
  local path
  local names=()
  for path in "$dir"/*.md; do
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
for name in "$@"; do
  if ! safe_name "$name" || [[ ! -f "$dir/$name.md" ]]; then
    missing+=("$name")
  fi
done

if ((${#missing[@]})); then
  for name in "${missing[@]}"; do
    printf 'missing quest: %s\n' "$name" >&2
  done
  existing_names >&2
  exit 1
fi

for name in "$@"; do
  printf '<quest name="%s">\n' "$name"
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -- "$dir/$name.md"
  printf '</quest>\n'
done
