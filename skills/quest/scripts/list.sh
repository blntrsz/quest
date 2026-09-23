#!/usr/bin/env bash
# Print every quest type and description as XML, in filename order.
set -euo pipefail

shopt -s nullglob

dir=$(CDPATH= cd -- "$(dirname -- "$0")/../quests" && pwd)

if (($# != 0)); then
  echo "usage: skills/quest/scripts/list.sh" >&2
  exit 2
fi

# Read the YAML frontmatter, including the --- lines.
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
quest_names=()
descriptions=()
open=()

for path in "$dir"/*.md; do
  names+=("$(basename -- "$path" .md)")
done
if ((${#names[@]})); then
  sorted_names=()
  while IFS= read -r name; do
    sorted_names+=("$name")
  done < <(printf '%s\n' "${names[@]}" | LC_ALL=C sort)
  names=("${sorted_names[@]}")
fi

for name in "${names[@]+"${names[@]}"}"; do
  if block=$(read_frontmatter "$dir/$name.md"); then
    if [[ -n "$block" ]]; then
      quest_name=$(printf '%s\n' "$block" | awk '
        /^name:[[:space:]]*/ {
          sub(/^name:[[:space:]]*/, "")
          print
          exit
        }
      ')
      description=$(printf '%s\n' "$block" | awk '
        /^description:[[:space:]]*/ {
          sub(/^description:[[:space:]]*/, "")
          print
          exit
        }
      ')
      quest_names+=("$quest_name")
      descriptions+=("$description")
    fi
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

xml_escape_text() {
  printf '%s' "$1" | sed \
    -e 's/&/\&amp;/g' \
    -e 's/</\&lt;/g' \
    -e 's/>/\&gt;/g'
}

xml_escape_attribute() {
  xml_escape_text "$1" | sed -e 's/"/\&quot;/g'
}

printf '<quests>\n'
for ((i = 0; i < ${#quest_names[@]}; i++)); do
  name=$(xml_escape_attribute "${quest_names[$i]}")
  description=$(xml_escape_text "${descriptions[$i]}")
  printf '<quest name="%s">%s</quest>\n' "$name" "$description"
done
printf '</quests>\n'
