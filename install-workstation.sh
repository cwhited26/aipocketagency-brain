#!/usr/bin/env bash
# AI Pocket Agency Workstation installer.
# Idempotent, non-destructive, and safe to rerun on macOS, Linux, and WSL.

set -euo pipefail

VERSION="0.1.0"
REPOSITORY_URL="https://github.com/cwhited26/aipocketagency-brain.git"
WORKSTATION_HOME="${APA_WORKSTATION_HOME:-$HOME}"
DEFAULT_SOURCE_DIR="$WORKSTATION_HOME/.local/share/aipocketagency/workstation-source"
DEFAULT_CONFIG_FILE="$WORKSTATION_HOME/.config/aipocketagency/workstation.json"

PROFILE_ID="operator"
PROFILE_FILE=""
BRAIN_ROOT="$WORKSTATION_HOME/ai-brain"
BRAIN_REPO=""
SOURCE_DIR=""
SKIP_AMBIENT="false"
DRY_RUN="false"

say() { printf '\033[36m[workstation]\033[0m %s\n' "$*"; }
warn() { printf '\033[33m[workstation] WARN:\033[0m %s\n' "$*" >&2; }
fail() { printf '\033[31m[workstation] ERROR:\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
AI Pocket Agency Workstation installer

Usage:
  bash install-workstation.sh [options]

Options:
  --profile operator|builder|reviewer  Built-in access profile (default: operator)
  --profile-file PATH_OR_URL           External project profile
  --brain-root PATH                    Authoritative brain directory (default: ~/ai-brain)
  --brain-repo URL                     Clone an existing brain when the root is absent
  --source-dir PATH                    Use an existing installer checkout
  --skip-ambient                       Do not install Claude ambient session capture
  --dry-run                            Print the resolved plan without changing the machine
  -h, --help                           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE_ID="${2:-}"; shift ;;
    --profile-file) PROFILE_FILE="${2:-}"; shift ;;
    --brain-root) BRAIN_ROOT="${2:-}"; shift ;;
    --brain-repo) BRAIN_REPO="${2:-}"; shift ;;
    --source-dir) SOURCE_DIR="${2:-}"; shift ;;
    --skip-ambient) SKIP_AMBIENT="true" ;;
    --dry-run) DRY_RUN="true" ;;
    -h|--help) usage; exit 0 ;;
    *) fail "unknown option: $1" ;;
  esac
  shift
done

case "$PROFILE_ID" in
  operator|builder|reviewer) ;;
  *) [[ -n "$PROFILE_FILE" ]] || fail "unknown built-in profile: $PROFILE_ID" ;;
esac

command -v git >/dev/null 2>&1 || fail "git is required"
command -v python3 >/dev/null 2>&1 || fail "python3 is required"

BRAIN_ROOT="$(python3 - "$BRAIN_ROOT" <<'PY'
import os, sys
print(os.path.abspath(os.path.expanduser(sys.argv[1])))
PY
)"

if [[ "$DRY_RUN" == "true" ]]; then
  say "dry run; no files will be changed"
  say "version: $VERSION"
  say "brain root: $BRAIN_ROOT"
  say "brain repository: ${BRAIN_REPO:-new local brain from templates}"
  say "profile: ${PROFILE_FILE:-$PROFILE_ID}"
  say "source: ${SOURCE_DIR:-$DEFAULT_SOURCE_DIR or current checkout}"
  say "ambient capture: $([[ "$SKIP_AMBIENT" == "true" ]] && printf skipped || printf installed)"
  exit 0
fi

resolve_source() {
  if [[ -n "$SOURCE_DIR" ]]; then
    SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"
    [[ -f "$SOURCE_DIR/install-workstation.sh" ]] || fail "source directory is not a workstation checkout: $SOURCE_DIR"
    return
  fi

  local script_path candidate
  script_path="${BASH_SOURCE[0]:-}"
  if [[ -f "$script_path" ]]; then
    candidate="$(cd "$(dirname "$script_path")" && pwd)"
    if [[ -d "$candidate/profiles" && -d "$candidate/templates" ]]; then
      SOURCE_DIR="$candidate"
      return
    fi
  fi

  SOURCE_DIR="$DEFAULT_SOURCE_DIR"
  mkdir -p "$(dirname "$SOURCE_DIR")"
  if [[ -d "$SOURCE_DIR/.git" ]]; then
    if git -C "$SOURCE_DIR" diff --quiet && git -C "$SOURCE_DIR" diff --cached --quiet; then
      git -C "$SOURCE_DIR" pull --ff-only
    else
      warn "cached installer source has local changes; leaving it unchanged"
    fi
  elif [[ -e "$SOURCE_DIR" ]]; then
    fail "source path exists but is not a git checkout: $SOURCE_DIR"
  else
    git clone --depth 1 "$REPOSITORY_URL" "$SOURCE_DIR"
  fi
}

resolve_source
say "source ready: $SOURCE_DIR"

CONFIG_DIR="$(dirname "$DEFAULT_CONFIG_FILE")"
mkdir -p "$CONFIG_DIR"

if [[ -n "$PROFILE_FILE" ]]; then
  PROFILE_DEST="$CONFIG_DIR/profile-external.json"
  case "$PROFILE_FILE" in
    https://*|http://*)
      command -v curl >/dev/null 2>&1 || fail "curl is required for a remote profile"
      curl -fsSL "$PROFILE_FILE" -o "$PROFILE_DEST"
      ;;
    *)
      PROFILE_FILE="$(python3 - "$PROFILE_FILE" <<'PY'
import os, sys
print(os.path.abspath(os.path.expanduser(sys.argv[1])))
PY
)"
      [[ -f "$PROFILE_FILE" ]] || fail "profile file not found: $PROFILE_FILE"
      if [[ "$PROFILE_FILE" != "$PROFILE_DEST" ]]; then
        cp "$PROFILE_FILE" "$PROFILE_DEST"
      fi
      ;;
  esac
  PROFILE_FILE="$PROFILE_DEST"
  PROFILE_ID="$(python3 - "$PROFILE_FILE" <<'PY'
import json, pathlib, sys
data = json.loads(pathlib.Path(sys.argv[1]).read_text())
if data.get("schema_version") != 1 or not isinstance(data.get("id"), str):
    raise SystemExit("profile must contain schema_version 1 and a string id")
print(data["id"])
PY
)"
else
  PROFILE_FILE="$SOURCE_DIR/profiles/$PROFILE_ID.json"
fi

python3 -m json.tool "$PROFILE_FILE" >/dev/null || fail "invalid profile JSON: $PROFILE_FILE"
say "profile ready: $PROFILE_ID"

install_if_absent() {
  local source="$1" destination="$2" mode="${3:-644}"
  if [[ -e "$destination" ]]; then
    say "preserved existing $destination"
    return
  fi
  mkdir -p "$(dirname "$destination")"
  install -m "$mode" "$source" "$destination"
  say "installed $destination"
}

if [[ -n "$BRAIN_REPO" && ! -e "$BRAIN_ROOT" ]]; then
  mkdir -p "$(dirname "$BRAIN_ROOT")"
  git clone "$BRAIN_REPO" "$BRAIN_ROOT"
fi

mkdir -p "$BRAIN_ROOT"
if [[ -n "$BRAIN_REPO" && ! -d "$BRAIN_ROOT/.git" ]]; then
  fail "brain root exists but is not the requested git brain: $BRAIN_ROOT"
fi

install_if_absent "$SOURCE_DIR/templates/AGENTS.md" "$BRAIN_ROOT/AGENTS.md"
install_if_absent "$SOURCE_DIR/templates/CLAUDE.md" "$BRAIN_ROOT/CLAUDE.md"
install_if_absent "$SOURCE_DIR/templates/MEMORY.md" "$BRAIN_ROOT/MEMORY.md"
install_if_absent "$SOURCE_DIR/templates/daily-log.md" "$BRAIN_ROOT/Daily_Log.md"
install_if_absent "$SOURCE_DIR/templates/change-log.md" "$BRAIN_ROOT/Change_Log.md"
install_if_absent "$SOURCE_DIR/templates/decision-log.md" "$BRAIN_ROOT/Decision_Log.md"
install_if_absent "$SOURCE_DIR/templates/feature-inventory.md" "$BRAIN_ROOT/Feature_Inventory.md"
install_if_absent "$SOURCE_DIR/templates/handoff-doc.md" "$BRAIN_ROOT/handoff-doc.md"
install_if_absent "$SOURCE_DIR/.brain-config.json.example" "$BRAIN_ROOT/.brain-config.json"

for directory in memory-types memory-conventions prompts; do
  if [[ ! -e "$BRAIN_ROOT/$directory" ]]; then
    cp -R "$SOURCE_DIR/templates/$directory" "$BRAIN_ROOT/$directory"
    say "installed $BRAIN_ROOT/$directory"
  else
    say "preserved existing $BRAIN_ROOT/$directory"
  fi
done

mkdir -p "$BRAIN_ROOT/bin" "$BRAIN_ROOT/dispatch/inbox" "$BRAIN_ROOT/dispatch/results"
for script in brain lane-summary.sh stale-audit.sh; do
  install_if_absent "$SOURCE_DIR/templates/bin/$script" "$BRAIN_ROOT/bin/$script" 755
done

python3 - "$BRAIN_ROOT/.brain-config.json" "$(basename "$BRAIN_ROOT")" <<'PY'
import json, pathlib, sys
path = pathlib.Path(sys.argv[1])
data = json.loads(path.read_text())
if not data.get("project_name") or data.get("project_name") == "your-brain":
    data["project_name"] = sys.argv[2]
    path.write_text(json.dumps(data, indent=2) + "\n")
PY

if ! git -C "$BRAIN_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git -C "$BRAIN_ROOT" init
  say "initialized git at $BRAIN_ROOT"
fi

merge_managed_block() {
  local target="$1" block="$2" begin="$3" end="$4"
  python3 - "$target" "$block" "$begin" "$end" "$BRAIN_ROOT" "$PROFILE_FILE" <<'PY'
import datetime, pathlib, shutil, sys
target, block_path, begin, end, brain_root, profile_file = sys.argv[1:]
target = pathlib.Path(target)
block = pathlib.Path(block_path).read_text().replace("<brain-root>", brain_root).replace("<profile-file>", profile_file).strip() + "\n"
target.parent.mkdir(parents=True, exist_ok=True)
current = target.read_text() if target.exists() else ""
start = current.find(begin)
finish = current.find(end, start + len(begin)) if start >= 0 else -1
if start >= 0 and finish >= 0:
    finish += len(end)
    updated = current[:start] + block.rstrip() + current[finish:]
else:
    updated = current.rstrip() + ("\n\n" if current.strip() else "") + block
if updated.rstrip() + "\n" != current:
    if target.exists():
        stamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        shutil.copy2(target, target.with_name(target.name + f".bak.{stamp}"))
    target.write_text(updated.rstrip() + "\n")
PY
  say "merged managed layer into $target"
}

merge_managed_block \
  "$WORKSTATION_HOME/.codex/AGENTS.md" \
  "$SOURCE_DIR/templates/global/codex-agents-block.md" \
  "# BEGIN AI POCKET AGENCY WORKSTATION" \
  "# END AI POCKET AGENCY WORKSTATION"

merge_managed_block \
  "$WORKSTATION_HOME/.claude/CLAUDE.md" \
  "$SOURCE_DIR/templates/global/claude-context-block.md" \
  "<!-- BEGIN AI POCKET AGENCY WORKSTATION -->" \
  "<!-- END AI POCKET AGENCY WORKSTATION -->"

if [[ "$SKIP_AMBIENT" == "false" ]]; then
  bash "$SOURCE_DIR/install-ambient.sh" "$BRAIN_ROOT"
else
  say "ambient capture skipped"
fi

LOCAL_BIN="$WORKSTATION_HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
install -m 755 "$SOURCE_DIR/templates/bin/workstation" "$LOCAL_BIN/workstation"
ln -sf "$BRAIN_ROOT/bin/brain" "$LOCAL_BIN/brain"

python3 - "$DEFAULT_CONFIG_FILE" "$VERSION" "$SOURCE_DIR" "$BRAIN_ROOT" "$PROFILE_ID" "$PROFILE_FILE" <<'PY'
import datetime, json, pathlib, shutil, sys
path = pathlib.Path(sys.argv[1])
payload = {
    "schema_version": 1,
    "installer_version": sys.argv[2],
    "source_dir": sys.argv[3],
    "brain_root": sys.argv[4],
    "profile_id": sys.argv[5],
    "profile_file": sys.argv[6],
    "installed_at": datetime.datetime.now(datetime.timezone.utc).isoformat()
}
if path.exists():
    try:
        current = json.loads(path.read_text())
    except json.JSONDecodeError:
        current = {}
    for key, value in current.items():
        payload.setdefault(key, value)
    stamp = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    shutil.copy2(path, path.with_name(path.name + f".bak.{stamp}"))
path.parent.mkdir(parents=True, exist_ok=True)
path.write_text(json.dumps(payload, indent=2) + "\n")
PY

say "installed $LOCAL_BIN/workstation"
if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
  warn "$LOCAL_BIN is not on PATH; add it to your shell profile"
fi

cat <<EOF

AI workstation installed.

  brain:       $BRAIN_ROOT
  profile:     $PROFILE_ID
  config:      $DEFAULT_CONFIG_FILE
  commands:    $LOCAL_BIN/workstation, $LOCAL_BIN/brain

Next:
  1. Customize $BRAIN_ROOT/CLAUDE.md and $BRAIN_ROOT/AGENTS.md.
  2. Run: workstation doctor
  3. Run: workstation verify --full /path/to/a/project
  4. Configure phone dispatch only after completing docs/PHONE_DISPATCH.md.

No secret values were requested or written by this installer.
EOF
