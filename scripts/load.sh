#!/usr/bin/env bash
# Load ability or quest files as XML, or print their YAML frontmatter.
set -euo pipefail

shopt -s nullglob

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

usage() {
  echo "usage: scripts/load.sh ability <name> [<name>...]" >&2
  echo "       scripts/load.sh quest <name> [<name>...]" >&2
  echo "       scripts/load.sh list ability|quest" >&2
  exit 2
}

kind_dir() {
  case "$1" in
    ability) printf '%s\n' "$root/skills/ability/abilities" ;;
    quest) printf '%s\n' "$root/skills/quest/quests" ;;
    *) return 1 ;;
  esac
}

existing_names() {
  local dir=$1
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

print_frontmatter() {
  awk '
    NR == 1 && $0 == "---" { on = 1; print; next }
    on { print; if ($0 == "---") exit }
  ' "$1"
}

load_kind() {
  local kind=$1
  shift
  local dir name
  local missing=()

  if (($# == 0)); then
    usage
  fi
  dir=$(kind_dir "$kind")

  for name in "$@"; do
    if ! safe_name "$name" || [[ ! -f "$dir/$name.md" ]]; then
      missing+=("$name")
    fi
  done

  if ((${#missing[@]})); then
    for name in "${missing[@]}"; do
      printf 'missing %s: %s\n' "$kind" "$name" >&2
    done
    existing_names "$dir" >&2
    exit 1
  fi

  for name in "$@"; do
    printf '<%s name="%s">\n' "$kind" "$name"
    sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -- "$dir/$name.md"
    printf '</%s>\n' "$kind"
  done
}

list_kind() {
  local kind=$1
  local dir name
  dir=$(kind_dir "$kind")
  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    print_frontmatter "$dir/$name.md"
  done < <(existing_names "$dir")
}

if (($# < 1)); then
  usage
fi

case "$1" in
  list)
    if (($# != 2)) || ! kind_dir "$2" >/dev/null; then
      usage
    fi
    list_kind "$2"
    ;;
  ability|quest)
    kind=$1
    shift
    load_kind "$kind" "$@"
    ;;
  *)
    usage
    ;;
esac
