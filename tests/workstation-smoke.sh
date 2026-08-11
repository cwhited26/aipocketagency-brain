#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d /tmp/apa-workstation-smoke.XXXXXX)"

cleanup() {
  case "$TEST_ROOT" in
    /tmp/apa-workstation-smoke.*) rm -rf "$TEST_ROOT" ;;
    *) printf 'refusing to remove unexpected test path: %s\n' "$TEST_ROOT" >&2 ;;
  esac
}
trap cleanup EXIT

bash -n \
  "$SOURCE_DIR/install-workstation.sh" \
  "$SOURCE_DIR/install-ambient.sh" \
  "$SOURCE_DIR/templates/bin/workstation"

for profile in operator builder reviewer; do
  python3 -m json.tool "$SOURCE_DIR/profiles/$profile.json" >/dev/null
done

"$SOURCE_DIR/install-workstation.sh" \
  --dry-run \
  --profile reviewer \
  --brain-root "$TEST_ROOT/dry-run-brain" >/dev/null

APA_WORKSTATION_HOME="$TEST_ROOT" "$SOURCE_DIR/install-workstation.sh" \
  --source-dir "$SOURCE_DIR" \
  --brain-root "$TEST_ROOT/brain" \
  --profile builder \
  --skip-ambient >/dev/null

WORKSTATION="$TEST_ROOT/.local/bin/workstation"
APA_WORKSTATION_HOME="$TEST_ROOT" "$WORKSTATION" doctor >/dev/null
APA_WORKSTATION_HOME="$TEST_ROOT" "$WORKSTATION" verify "$TEST_ROOT/brain" >/dev/null

MISSION_PATH="$(APA_WORKSTATION_HOME="$TEST_ROOT" "$WORKSTATION" dispatch \
  --repo example/sample \
  --agent codex \
  --task "Inspect the build and report the cause without changing files.")"
python3 -m json.tool "$MISSION_PATH" >/dev/null

# A second pass proves brain files are preserved and the managed blocks remain singular.
APA_WORKSTATION_HOME="$TEST_ROOT" "$SOURCE_DIR/install-workstation.sh" \
  --source-dir "$SOURCE_DIR" \
  --brain-root "$TEST_ROOT/brain" \
  --profile builder \
  --skip-ambient >/dev/null

[[ "$(grep -c '^# BEGIN AI POCKET AGENCY WORKSTATION$' "$TEST_ROOT/.codex/AGENTS.md")" == "1" ]]
[[ "$(grep -c '^<!-- BEGIN AI POCKET AGENCY WORKSTATION -->$' "$TEST_ROOT/.claude/CLAUDE.md")" == "1" ]]

printf 'workstation smoke test passed\n'

