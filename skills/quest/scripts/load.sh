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

read_required_abilities() {
  awk -v file="$1" '
    function fail(message) {
      printf "invalid abilities frontmatter in %s: %s\n", file, message > "/dev/stderr"
      failed = 1
      exit 2
    }
    NR == 1 {
      if ($0 == "---") frontmatter = 1
      else exit
      next
    }
    frontmatter && $0 == "---" {
      closed = 1
      exit
    }
    frontmatter {
      if (in_list) {
        if ($0 ~ /^[[:space:]]*$/) next
        if ($0 ~ /^  - [A-Za-z0-9._-]+[[:space:]]*$/) {
          ability = $0
          sub(/^  - /, "", ability)
          sub(/[[:space:]]+$/, "", ability)
          if (ability == "." || ability == "..") fail("invalid ability name: " ability)
          if (items[ability]++) fail("duplicate ability name: " ability)
          print ability
          count++
          next
        }
        if ($0 !~ /^[A-Za-z_][A-Za-z0-9_-]*:/) fail("expected an indented ability list item")
        in_list = 0
      }
      if ($0 ~ /^abilities([[:space:]]*):/) {
        if ($0 !~ /^abilities:[[:space:]]*$/) fail("use abilities: followed by indented ability list items")
        if (seen) fail("duplicate abilities field")
        seen = 1
        in_list = 1
        next
      }
    }
    END {
      if (failed) exit 2
      if (!frontmatter) exit 0
      if (!closed) {
        printf "invalid abilities frontmatter in %s: unclosed frontmatter\n", file > "/dev/stderr"
        exit 2
      }
      if (seen && count == 0) {
        printf "invalid abilities frontmatter in %s: abilities list is empty\n", file > "/dev/stderr"
        exit 2
      }
    }
  ' "$1"
}

if (($# == 0)); then
  usage
fi

names=("$@")
resolved_paths=()
declared_abilities=()
all_abilities=()
missing=()
for name in "${names[@]}"; do
  if ! safe_name "$name"; then
    missing+=("$name")
  elif [[ -f "$dir/$name.md" ]]; then
    resolved_paths+=("$dir/$name.md")
  elif [[ -f "$dir/${name}-quest.md" ]]; then
    resolved_paths+=("$dir/${name}-quest.md")
  else
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

for path in "${resolved_paths[@]}"; do
  if ! abilities=$(read_required_abilities "$path"); then
    exit 1
  fi
  declared_abilities+=("$abilities")
  if [[ -n "$abilities" ]]; then
    while IFS= read -r ability; do
      all_abilities+=("$ability")
    done <<< "$abilities"
  fi
done

if ((${#all_abilities[@]})); then
  ability_loader=$(CDPATH= cd -- "$(dirname -- "$0")/../../ability/scripts" && pwd)/load.sh
  if ! "$ability_loader" "${all_abilities[@]}" >/dev/null; then
    exit 1
  fi
fi

for index in "${!names[@]}"; do
  name=${names[$index]}
  printf '<quest name="%s">\n' "$name"
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -- "${resolved_paths[$index]}"
  printf '</quest>\n'
  if [[ -n "${declared_abilities[$index]}" ]]; then
    quest_abilities=()
    while IFS= read -r ability; do
      quest_abilities+=("$ability")
    done <<< "${declared_abilities[$index]}"
    "$ability_loader" "${quest_abilities[@]}"
  fi
done
