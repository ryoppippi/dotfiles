#!/usr/bin/env bash
# Audit every local skill for the mechanical, countable parts of skill-creator's
# conventions: SKILL.md length, frontmatter name/description length, and whether
# references/ and scripts/ exist. Prints one row per skill and flags violations
# with "<<". Judgement-based checks (duplication, doc links, repo-file pointers)
# are NOT covered here — see references/audit-checks.md for those.
#
# Usage: scripts/audit.sh [SKILLS_DIR]
#   SKILLS_DIR defaults to the agents/skills directory this script lives under.
set -euo pipefail

# Thresholds. Hard limits come from Anthropic's frontmatter validation; soft
# limits encode skill-creator guidance. See references/audit-checks.md.
readonly LINE_SOFT=150 # consider splitting into references/ above this
readonly LINE_HARD=500 # Anthropic hard ceiling for the SKILL.md body
readonly NAME_MAX=64   # frontmatter name hard limit
readonly DESC_MAX=1024 # frontmatter description hard limit
readonly DESC_SOFT=350 # keep descriptions tight (~20-35 words); flag above this

# Default to agents/skills (two levels up from this scripts/ directory).
script_dir="$(cd "$(dirname "$0")" && pwd)"
skills_dir="${1:-$(cd "$script_dir/../.." && pwd)}"

if [[ ! -d $skills_dir ]]; then
  echo "Skills directory not found: $skills_dir" >&2
  exit 1
fi

# Extract a single-line frontmatter value (name: / description:) from a SKILL.md.
# Reads only the block between the first two '---' fences.
frontmatter_value() {
  local file="$1" key="$2"
  awk -v key="$key" '
    NR == 1 && $0 == "---" { in_fm = 1; next }
    in_fm && $0 == "---" { exit }
    in_fm && $0 ~ "^" key ":" {
      sub("^" key ": *", "")
      print
      exit
    }
  ' "$file"
}

printf "%-28s %6s %5s %5s  %-4s %-4s\n" "SKILL" "lines" "name" "desc" "refs" "scrp"
printf -- "%.0s-" {1..60}
echo

issues=0
# Iterate skill directories in sorted order for stable output.
for dir in "$skills_dir"/*/; do
  skill="$(basename "$dir")"
  file="$dir/SKILL.md"
  [[ -f $file ]] || {
    printf "%-28s  %s\n" "$skill" "<< no SKILL.md"
    issues=$((issues + 1))
    continue
  }

  lines=$(wc -l <"$file" | tr -d ' ')
  name="$(frontmatter_value "$file" name)"
  desc="$(frontmatter_value "$file" description)"
  name_len=${#name}
  desc_len=${#desc}
  has_refs="-"
  [[ -d "$dir/references" ]] && has_refs="yes"
  has_scrp="-"
  [[ -d "$dir/scripts" ]] && has_scrp="yes"

  flags=""
  ((lines > LINE_HARD)) && {
    flags+=" lines>${LINE_HARD}!"
    issues=$((issues + 1))
  }
  ((lines > LINE_SOFT && lines <= LINE_HARD)) && {
    flags+=" lines>${LINE_SOFT}"
    issues=$((issues + 1))
  }
  ((name_len == 0)) && {
    flags+=" name-missing!"
    issues=$((issues + 1))
  }
  ((name_len > NAME_MAX)) && {
    flags+=" name>${NAME_MAX}!"
    issues=$((issues + 1))
  }
  ((desc_len == 0)) && {
    flags+=" desc-missing!"
    issues=$((issues + 1))
  }
  ((desc_len > DESC_MAX)) && {
    flags+=" desc>${DESC_MAX}!"
    issues=$((issues + 1))
  }
  ((desc_len > DESC_SOFT && desc_len <= DESC_MAX)) && {
    flags+=" desc>${DESC_SOFT}"
    issues=$((issues + 1))
  }

  printf "%-28s %6s %5s %5s  %-4s %-4s%s\n" \
    "$skill" "$lines" "$name_len" "$desc_len" "$has_refs" "$has_scrp" \
    "${flags:+   <<$flags}"
done

echo
if ((issues > 0)); then
  echo "Flagged $issues item(s). '!' = hard violation, others = review against references/audit-checks.md."
else
  echo "No mechanical violations. Still run the judgement checks in references/audit-checks.md."
fi
