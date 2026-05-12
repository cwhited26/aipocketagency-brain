#!/usr/bin/env bash
#
# stale-audit.sh — surface dependent docs whose declared upstreams have changed
#
# Convention: docs in your brain that derive from upstream facts can opt in to
# the cascade-staleness audit by including a `**Depends on:**` block near the
# top, listing one upstream reference per line (paths or "Decision_Log.md
# Decision N" style). See memory-conventions/cascade-staleness.md for the full
# spec.
#
# This script:
#   1. Walks the brain tree for files that contain `**Depends on:**`
#   2. Parses the upstream references out of each block
#   3. For each upstream that resolves to a real file path, checks `git log
#      --since="$WINDOW"` for that path
#   4. Reports dependent docs whose upstreams were touched in the window
#
# Output: one section per stale candidate. Re-review the doc; supersede if the
# upstream change invalidates it (per memory-conventions/supersession-pattern.md).
#
# Usage:
#   bash bin/stale-audit.sh                # default 30-day window
#   bash bin/stale-audit.sh --since "7 days ago"
#   STALE_AUDIT_WINDOW="14 days ago" bash bin/stale-audit.sh
#
# Exit codes:
#   0 — ran cleanly (regardless of whether candidates were found)
#   1 — fatal error (not in a git repo, missing dependency, etc.)
#
# Run cadence: weekly. Output is informational, never auto-edits anything.

set -euo pipefail

WINDOW="${STALE_AUDIT_WINDOW:-30 days ago}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --since)
      WINDOW="$2"
      shift 2
      ;;
    --since=*)
      WINDOW="${1#--since=}"
      shift
      ;;
    -h|--help)
      sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "stale-audit: unknown arg '$1'" >&2
      exit 1
      ;;
  esac
done

# Resolve the brain root: the dir containing this script, one level up.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BRAIN_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

if ! git -C "$BRAIN_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
  echo "stale-audit: $BRAIN_ROOT is not a git repo" >&2
  exit 1
fi

cd "$BRAIN_ROOT"

echo "# Cascade Staleness Audit"
echo
echo "**Brain root:** \`$BRAIN_ROOT\`"
echo "**Window:** changes since \`$WINDOW\`"
echo "**Generated:** $(date '+%Y-%m-%d %H:%M:%S %z')"
echo
echo "---"
echo

# Find every file that declares Depends on. -l for files only; exclude .git and worktrees.
# Use a while-read loop instead of `mapfile` (bash 4+) for macOS bash 3.2 compatibility.
DEPENDENT_FILES=()
while IFS= read -r line; do
  DEPENDENT_FILES+=("$line")
done < <(
  grep -rl --exclude-dir=.git --exclude-dir=.claude --include='*.md' \
    -- '**Depends on:**' . 2>/dev/null \
    | sed 's|^\./||' \
    | sort
)

if [[ ${#DEPENDENT_FILES[@]} -eq 0 ]]; then
  echo "_No files declare \`**Depends on:**\` yet. Pattern is opt-in; see \`memory-conventions/cascade-staleness.md\`._"
  exit 0
fi

CANDIDATE_COUNT=0

for dep_file in "${DEPENDENT_FILES[@]}"; do
  # Extract the Depends-on block: from the line containing **Depends on:** to
  # the next blank line. Pull bullet items out.
  REFS=()
  while IFS= read -r ref_line; do
    REFS+=("$ref_line")
  done < <(
    awk '
      /\*\*Depends on:\*\*/ { in_block = 1; next }
      in_block && NF == 0 { in_block = 0 }
      in_block && /^[[:space:]]*-[[:space:]]/ {
        sub(/^[[:space:]]*-[[:space:]]+/, "")
        print
      }
    ' "$dep_file"
  )

  if [[ ${#REFS[@]} -eq 0 ]]; then
    continue
  fi

  STALE_REFS=()
  for ref in "${REFS[@]}"; do
    # Extract the first backtick-quoted token from the line; that's the path.
    # Falls back to the first whitespace-delimited token if no backticks.
    path=$(printf '%s\n' "$ref" | sed -n 's/.*`\([^`]*\)`.*/\1/p' | head -1)
    if [[ -z "$path" ]]; then
      path=$(printf '%s\n' "$ref" | awk '{print $1}')
    fi

    # Strip "Decision N" suffix if the ref points at a decision-log entry.
    base_path="${path%% *}"

    if [[ ! -f "$base_path" ]]; then
      continue
    fi

    # Check git log for changes to this path within the window.
    if git log --since="$WINDOW" --pretty=format:%H -- "$base_path" 2>/dev/null | grep -q .; then
      STALE_REFS+=("$ref")
    fi
  done

  if [[ ${#STALE_REFS[@]} -gt 0 ]]; then
    CANDIDATE_COUNT=$((CANDIDATE_COUNT + 1))
    echo "## \`$dep_file\`"
    echo
    echo "Upstreams touched within window:"
    echo
    for ref in "${STALE_REFS[@]}"; do
      echo "- $ref"
    done
    echo
  fi
done

echo "---"
echo
if [[ $CANDIDATE_COUNT -eq 0 ]]; then
  echo "_No re-review candidates. ${#DEPENDENT_FILES[@]} dependent doc(s) scanned; no declared upstreams touched in window._"
else
  echo "_$CANDIDATE_COUNT re-review candidate(s) across ${#DEPENDENT_FILES[@]} scanned dependent doc(s). Walk each one above; supersede per \`memory-conventions/supersession-pattern.md\` if drift is real._"
fi
