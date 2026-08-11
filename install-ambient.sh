#!/usr/bin/env bash
#
# install-ambient.sh — install the ambient capture layer into a brain repo.
#
# Idempotent. Safe to re-run. Does NOT delete user data.
#
# What it does:
#   1. Verifies prerequisites (claude CLI; jq optional, python3 fallback).
#   2. Copies templates/hooks/brain-ambient-capture.sh -> ~/.claude/hooks/
#   3. Safe-merges a Stop hook entry into ~/.claude/settings.json (preserves existing hooks).
#   4. Writes <brain>/.brain-config.json (only if absent — never overwrites).
#   5. Creates <brain>/sessions/.gitkeep + <brain>/memory/.proposed/.gitkeep.
#   6. Installs pre-commit hook into <brain>/.git/hooks/ (backs up any existing one).
#   7. Symlinks the brain CLI into ~/.local/bin/brain (handles both layouts).
#
# Usage:
#   bash install-ambient.sh [brain-root]
#
# If [brain-root] is omitted, uses $PWD.
#
# Spec: Ambient_Brain_Architecture.md (Lanes 1-2).

set -euo pipefail

BRAIN_ROOT="${1:-$PWD}"
BRAIN_ROOT="$(cd "$BRAIN_ROOT" && pwd)"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOOKS_SOURCE_DIR="$SCRIPT_DIR/templates/hooks"
GITHOOKS_SOURCE_DIR="$SCRIPT_DIR/templates/git-hooks"

AMBIENT_HOME="${APA_WORKSTATION_HOME:-$HOME}"
CLAUDE_DIR="$AMBIENT_HOME/.claude"
CLAUDE_HOOKS_DIR="$CLAUDE_DIR/hooks"
CLAUDE_SETTINGS="$CLAUDE_DIR/settings.json"

say()  { printf '\033[36m[ambient-install]\033[0m %s\n' "$*"; }
warn() { printf '\033[33m[ambient-install] WARN:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[31m[ambient-install] ERROR:\033[0m %s\n' "$*" >&2; exit 1; }

# 1. Preflight ---------------------------------------------------------------

if ! command -v claude >/dev/null 2>&1; then
  warn "claude CLI not on PATH — the Stop hook only fires when Claude Code is installed."
fi

command -v python3 >/dev/null 2>&1 || die "python3 is required."

[ -d "$BRAIN_ROOT" ] || die "brain root not found: $BRAIN_ROOT"
[ -d "$HOOKS_SOURCE_DIR" ] || die "missing source: $HOOKS_SOURCE_DIR (run from the brain repo containing install-ambient.sh)"

# Find brain CLI source — supports both layouts:
#   Layout A (active operator):     bin/brain
#   Layout B (fresh public template): templates/bin/brain
if [ -f "$SCRIPT_DIR/bin/brain" ]; then
  BRAIN_CLI_SRC="$SCRIPT_DIR/bin/brain"
elif [ -f "$SCRIPT_DIR/templates/bin/brain" ]; then
  BRAIN_CLI_SRC="$SCRIPT_DIR/templates/bin/brain"
else
  die "brain CLI not found (expected bin/brain or templates/bin/brain)"
fi

say "brain root: $BRAIN_ROOT"

# 2. ~/.claude/hooks/brain-ambient-capture.sh --------------------------------

mkdir -p "$CLAUDE_HOOKS_DIR"
install -m 755 "$HOOKS_SOURCE_DIR/brain-ambient-capture.sh" "$CLAUDE_HOOKS_DIR/brain-ambient-capture.sh"
say "wrote $CLAUDE_HOOKS_DIR/brain-ambient-capture.sh"

# 3. ~/.claude/settings.json — safe merge -----------------------------------

if [ ! -f "$CLAUDE_SETTINGS" ]; then
  echo '{}' > "$CLAUDE_SETTINGS"
fi

HOOK_CMD="$CLAUDE_HOOKS_DIR/brain-ambient-capture.sh"

python3 - "$CLAUDE_SETTINGS" "$HOOK_CMD" <<'PYEOF'
import json, os, sys

settings_path, hook_cmd = sys.argv[1], sys.argv[2]

try:
    data = json.load(open(settings_path))
except Exception as e:
    print(f"settings parse error: {e}", file=sys.stderr)
    sys.exit(1)

hooks = data.setdefault("hooks", {})
stop = hooks.setdefault("Stop", [])
if not isinstance(stop, list):
    stop = []
    hooks["Stop"] = stop

found = False
for matcher in stop:
    if not isinstance(matcher, dict):
        continue
    for h in matcher.get("hooks", []) or []:
        if isinstance(h, dict) and h.get("command", "").endswith("brain-ambient-capture.sh"):
            h["command"] = hook_cmd
            h.setdefault("type", "command")
            found = True

if not found:
    stop.append({
        "matcher": "",
        "hooks": [
            {"type": "command", "command": hook_cmd}
        ]
    })

with open(settings_path, "w") as f:
    json.dump(data, f, indent=2)
PYEOF
say "merged Stop hook into $CLAUDE_SETTINGS"

# 4. <brain>/.brain-config.json ---------------------------------------------

BRAIN_CONFIG="$BRAIN_ROOT/.brain-config.json"
if [ -f "$BRAIN_CONFIG" ]; then
  say "$BRAIN_CONFIG already exists — leaving in place"
else
  PROJECT_NAME="$(basename "$BRAIN_ROOT")"
  cat > "$BRAIN_CONFIG" <<JSON
{
  "capture_enabled": true,
  "project_name": "$PROJECT_NAME",
  "redaction_patterns": [
    "(?i)sk_(test|live)_[a-zA-Z0-9_]{20,}",
    "(?i)rk_(test|live)_[a-zA-Z0-9_]{20,}",
    "(?i)pk_(test|live)_[a-zA-Z0-9_]{20,}",
    "sk-ant-[a-zA-Z0-9_-]{40,}",
    "(?i)whsec_[a-zA-Z0-9_]{15,}",
    "[Bb]earer [a-zA-Z0-9._~+/=_-]{20,}",
    "gh[pousr]_[A-Za-z0-9_]{36,}",
    "cfat?_[A-Za-z0-9_-]{30,}",
    "ops_[A-Za-z0-9._-]{30,}",
    "AKIA[0-9A-Z]{16}",
    "sk-[A-Za-z0-9]{20,}",
    "[A-Za-z0-9+/]{40,}={0,2}"
  ],
  "verbose_tool_calls": false,
  "client_name_patterns": []
}
JSON
  say "wrote $BRAIN_CONFIG (project: $PROJECT_NAME)"
fi

# 5. sessions + memory/.proposed scaffolding --------------------------------

mkdir -p "$BRAIN_ROOT/sessions"
[ -f "$BRAIN_ROOT/sessions/.gitkeep" ] || : > "$BRAIN_ROOT/sessions/.gitkeep"

mkdir -p "$BRAIN_ROOT/memory/.proposed"
[ -f "$BRAIN_ROOT/memory/.proposed/.gitkeep" ] || : > "$BRAIN_ROOT/memory/.proposed/.gitkeep"

say "ensured $BRAIN_ROOT/sessions/ + $BRAIN_ROOT/memory/.proposed/"

# 6. pre-commit hook --------------------------------------------------------

if [ -d "$BRAIN_ROOT/.git" ] && [ -d "$GITHOOKS_SOURCE_DIR" ]; then
  PRECOMMIT_DEST="$BRAIN_ROOT/.git/hooks/pre-commit"
  if [ -f "$PRECOMMIT_DEST" ] && ! grep -q "brain-ambient" "$PRECOMMIT_DEST" 2>/dev/null; then
    cp "$PRECOMMIT_DEST" "$PRECOMMIT_DEST.bak.$(date +%s)"
    warn "existing pre-commit hook backed up to $PRECOMMIT_DEST.bak.*"
  fi
  install -m 755 "$GITHOOKS_SOURCE_DIR/pre-commit" "$PRECOMMIT_DEST"
  say "installed pre-commit hook at $PRECOMMIT_DEST"
else
  warn "skipping pre-commit hook (not a git repo or templates/git-hooks missing)"
fi

# 7. Symlink brain CLI ------------------------------------------------------

# If layout B (templates/bin/brain), also stage at bin/brain for stable symlinking
if [ "$BRAIN_CLI_SRC" != "$BRAIN_ROOT/bin/brain" ]; then
  mkdir -p "$BRAIN_ROOT/bin"
  cp "$BRAIN_CLI_SRC" "$BRAIN_ROOT/bin/brain"
  BRAIN_CLI_SRC="$BRAIN_ROOT/bin/brain"
fi
chmod +x "$BRAIN_CLI_SRC"

LOCAL_BIN="$AMBIENT_HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
ln -sf "$BRAIN_CLI_SRC" "$LOCAL_BIN/brain"
say "symlinked $LOCAL_BIN/brain -> $BRAIN_CLI_SRC"

# 8. Final report -----------------------------------------------------------

cat <<EOF

ambient capture installed.

  hook script:      $CLAUDE_HOOKS_DIR/brain-ambient-capture.sh
  Claude settings:  $CLAUDE_SETTINGS  (Stop hook registered)
  brain config:     $BRAIN_CONFIG
  sessions dir:     $BRAIN_ROOT/sessions/
  proposals dir:    $BRAIN_ROOT/memory/.proposed/
  brain CLI:        $LOCAL_BIN/brain (symlink -> $BRAIN_CLI_SRC)

next:
  1. ensure ~/.local/bin is on PATH:
     echo 'export PATH="\$HOME/.local/bin:\$PATH"' >> ~/.zshrc && source ~/.zshrc
  2. configure ANTHROPIC_API_KEY through your secret manager when you use
     'brain consolidate'. Do not paste the value into this repo or shell history.
  3. run a Claude Code session inside $BRAIN_ROOT — your transcript will land at
     sessions/$(date +%Y-%m-%d)/HHmmss-*.md.
  4. verify with: brain status
EOF
