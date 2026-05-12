#!/usr/bin/env bash
#
# lane-summary.sh — regenerate <Lane>/Current_State.md for one business lane
#
# Convention: every lane (a top-level subdirectory in your brain that represents
# a product, business line, or workstream) gets a derived Current_State.md
# auto-generated from its Decision Log + Daily Log + Feature Inventory. The file
# is a single-file cold-start handoff for an agent dropped into the lane.
# See memory-conventions/lane-current-state.md for the full spec.
#
# What it pulls:
#   - Top 5 most recent Decision Log entries (by `## Decision ...` headers)
#   - Top 3 most recent Daily Log entries  (by `## YYYY-MM-DD ...` headers)
#   - Top 5 open questions from Feature Inventory's `Open Questions` section
#
# Naming conventions handled:
#   - Tries <Lane>/Decision_Log.md first, then <Lane>/<Lane>_Decision_Log.md
#   - Same fallback for Daily_Log.md and Feature_Inventory.md
#   - Missing files are noted in output rather than aborting
#
# Usage:
#   bash bin/lane-summary.sh <Lane>
#   bash bin/lane-summary.sh demo-lane
#
# Exit codes:
#   0 — wrote Current_State.md (even with partial sources)
#   1 — fatal error (no lane arg, lane dir doesn't exist)
#
# Idempotent: re-runs overwrite the previous Current_State.md cleanly.

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "lane-summary: usage: $0 <lane>" >&2
  echo "  e.g. $0 demo-lane" >&2
  exit 1
fi

LANE="$1"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BRAIN_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
LANE_DIR="$BRAIN_ROOT/$LANE"

if [[ ! -d "$LANE_DIR" ]]; then
  echo "lane-summary: lane directory not found: $LANE_DIR" >&2
  exit 1
fi

# Resolve a source file by trying both naming conventions.
resolve_file() {
  local kind="$1"
  if [[ -f "$LANE_DIR/${kind}.md" ]]; then
    printf '%s' "$LANE_DIR/${kind}.md"
  elif [[ -f "$LANE_DIR/${LANE}_${kind}.md" ]]; then
    printf '%s' "$LANE_DIR/${LANE}_${kind}.md"
  else
    printf ''
  fi
}

DECISION_FILE="$(resolve_file Decision_Log)"
DAILY_FILE="$(resolve_file Daily_Log)"
FEATURE_FILE="$(resolve_file Feature_Inventory)"

OUTPUT="$LANE_DIR/Current_State.md"
NOW="$(date '+%Y-%m-%d %H:%M:%S %z')"
TODAY="$(date '+%Y-%m-%d')"

# Build source-files block (skip lines for missing files).
build_sources_block() {
  local lines=()
  if [[ -n "$DECISION_FILE" ]]; then
    lines+=("- \`${DECISION_FILE#$BRAIN_ROOT/}\`")
  else
    lines+=("- _Decision_Log.md not found in lane directory_")
  fi
  if [[ -n "$DAILY_FILE" ]]; then
    lines+=("- \`${DAILY_FILE#$BRAIN_ROOT/}\`")
  else
    lines+=("- _Daily_Log.md not found in lane directory_")
  fi
  if [[ -n "$FEATURE_FILE" ]]; then
    lines+=("- \`${FEATURE_FILE#$BRAIN_ROOT/}\`")
  else
    lines+=("- _Feature_Inventory.md not found in lane directory_")
  fi
  printf '%s\n' "${lines[@]}"
}

# Pull top N decision-log entries. Each entry is a `## Decision ...` header
# plus the lines until the next `## ` header (or EOF). We emit the header line
# + the first non-blank body line as a one-line summary.
extract_decisions() {
  local file="$1"
  local n="$2"
  if [[ -z "$file" ]]; then
    echo "_(Decision Log not present in this lane.)_"
    return
  fi
  awk -v limit="$n" '
    /^## Decision / {
      if (count >= limit) { exit }
      if (header != "") {
        printf("- %s\n", header)
        if (body != "") { printf("  - %s\n", body) }
      }
      header = $0
      sub(/^## /, "", header)
      body = ""
      count++
      next
    }
    /^## / && count > 0 {
      # Hit a non-decision H2 after we started; flush and stop.
      printf("- %s\n", header)
      if (body != "") { printf("  - %s\n", body) }
      header = ""
      exit
    }
    count > 0 && body == "" && /^\*\*Decision:\*\*/ {
      line = $0
      sub(/^\*\*Decision:\*\*[[:space:]]*/, "", line)
      body = line
    }
    END {
      if (header != "") {
        printf("- %s\n", header)
        if (body != "") { printf("  - %s\n", body) }
      }
    }
  ' "$file"
}

# Pull top N daily-log entries. Daily Log headers are `## YYYY-MM-DD ...`.
extract_daily() {
  local file="$1"
  local n="$2"
  if [[ -z "$file" ]]; then
    echo "_(Daily Log not present in this lane.)_"
    return
  fi
  awk -v limit="$n" '
    /^## [0-9]{4}-[0-9]{2}-[0-9]{2}/ {
      if (count >= limit) { exit }
      header = $0
      sub(/^## /, "", header)
      printf("- %s\n", header)
      count++
    }
  ' "$file"
}

# Pull top N entries from the Feature Inventory's "Open Questions" section.
extract_open_questions() {
  local file="$1"
  local n="$2"
  if [[ -z "$file" ]]; then
    echo "_(Feature Inventory not present in this lane.)_"
    return
  fi
  awk -v limit="$n" '
    BEGIN { in_section = 0; count = 0 }
    /^## Open Questions/ { in_section = 1; next }
    in_section && /^## / { exit }
    in_section && /^[[:space:]]*[0-9]+\.[[:space:]]/ {
      if (count >= limit) { exit }
      line = $0
      sub(/^[[:space:]]*[0-9]+\.[[:space:]]+/, "", line)
      printf("%d. %s\n", count + 1, line)
      count++
    }
  ' "$file"
}

DECISIONS_BLOCK="$(extract_decisions "$DECISION_FILE" 5)"
DAILY_BLOCK="$(extract_daily "$DAILY_FILE" 3)"
OPEN_QUESTIONS_BLOCK="$(extract_open_questions "$FEATURE_FILE" 5)"
SOURCES_BLOCK="$(build_sources_block)"

cat > "$OUTPUT" <<EOF
# $LANE — Current State

**Last regenerated:** $NOW (script: \`bin/lane-summary.sh $LANE\`)
**Source files:**
$SOURCES_BLOCK

> This file is **auto-generated**. Do not hand-edit — edits are overwritten on next regen. To change content here, edit the source file and re-run the script. See \`memory-conventions/lane-current-state.md\` for the full convention.

---

## Top 5 most recent decisions

$DECISIONS_BLOCK

---

## 3 most recent daily-log entries

$DAILY_BLOCK

---

## Top 5 open questions / onboarding deltas

$OPEN_QUESTIONS_BLOCK

---

_Snapshot date: $TODAY. Regenerate with \`bash bin/lane-summary.sh $LANE\`._
EOF

echo "lane-summary: wrote $OUTPUT"
