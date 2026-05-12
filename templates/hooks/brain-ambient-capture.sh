#!/usr/bin/env bash
# brain-ambient-capture.sh — Claude Code Stop hook (ambient brain layer)
#
# Reads the Stop-hook JSON payload from stdin (Claude Code provides it on every
# Stop event), locates the nearest .brain-config.json by walking up from cwd,
# and writes a redacted markdown transcript to sessions/YYYY-MM-DD/.
#
# Fail-safe: ANY error in this script exits 0 so Claude Code never hangs.
# All diagnostics go to /tmp/brain-ambient-capture.log.
#
# Expected Stop-event payload (Claude Code 2026-05):
#   {
#     "session_id": "<uuid>",
#     "transcript_path": "/path/to/conversation.jsonl",
#     "cwd": "/path/where/claude/ran",
#     "hook_event_name": "Stop",
#     "stop_hook_active": false
#   }
#
# Reference: docs.anthropic.com/en/docs/claude-code/hooks

set +e

LOG=/tmp/brain-ambient-capture.log

{
  echo "=== $(date -u +%FT%TZ) brain-ambient-capture start ==="

  # Buffer the hook payload into a tempfile so the Python invocation can read
  # script source from heredoc and the JSON payload via argv path.
  PAYLOAD_TMP="$(mktemp -t brain-ambient.XXXXXX)"
  trap 'rm -f "$PAYLOAD_TMP"' EXIT
  cat > "$PAYLOAD_TMP"

  python3 - "$PAYLOAD_TMP" <<'PYEOF'
import json
import os
import re
import sys
import hashlib
import pathlib
import subprocess
from datetime import datetime, timezone

# --- Read Stop-hook payload from tempfile path passed as argv[1] ---
payload_path = sys.argv[1]
try:
    with open(payload_path) as f:
        payload = json.loads(f.read() or "{}")
except Exception as e:
    print(f"could not parse payload JSON: {e}")
    sys.exit(0)

session_id = payload.get("session_id", "") or ""
transcript_path = payload.get("transcript_path", "") or ""
cwd = payload.get("cwd", os.getcwd()) or os.getcwd()
hook_event = payload.get("hook_event_name", "")

print(f"session_id={session_id[:8]} cwd={cwd} transcript={transcript_path}")

# --- Locate .brain-config.json by walking up from cwd ---
def find_config(start):
    p = pathlib.Path(start).resolve()
    while True:
        cfg = p / ".brain-config.json"
        if cfg.is_file():
            return cfg
        if p.parent == p:
            return None
        p = p.parent

cfg_path = find_config(cwd)
if cfg_path is None:
    print(f"no .brain-config.json above {cwd}; skipping")
    sys.exit(0)

try:
    config = json.loads(cfg_path.read_text())
except Exception as e:
    print(f"config parse error: {e}")
    sys.exit(0)

if not config.get("capture_enabled", True):
    print("capture_enabled=false; skipping")
    sys.exit(0)

if os.environ.get("BRAIN_AMBIENT_CAPTURE", "on") == "off":
    print("BRAIN_AMBIENT_CAPTURE=off env var; skipping")
    sys.exit(0)

repo_root = cfg_path.parent
project_name = config.get("project_name") or repo_root.name
patterns = list(config.get("redaction_patterns", []))
client_names = list(config.get("client_name_patterns", []))
verbose_tools = bool(config.get("verbose_tool_calls", False))

# --- Load transcript JSONL ---
if not transcript_path or not os.path.exists(transcript_path):
    print(f"transcript not found at {transcript_path}; skipping")
    sys.exit(0)

messages = []
try:
    with open(transcript_path) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                messages.append(json.loads(line))
            except Exception:
                pass
except Exception as e:
    print(f"transcript read error: {e}")
    sys.exit(0)

if not messages:
    print("empty transcript; skipping")
    sys.exit(0)

# --- Compile redaction patterns ---
compiled = []
for p in patterns:
    if isinstance(p, dict):
        name = p.get("name", "secret")
        rx_src = p.get("regex", "")
    elif isinstance(p, str):
        name = "secret"
        rx_src = p
    else:
        continue
    try:
        compiled.append((name, re.compile(rx_src)))
    except re.error as e:
        print(f"bad regex skipped ({rx_src!r}): {e}")

for cname in client_names:
    if not cname:
        continue
    try:
        compiled.append(("client_name", re.compile(re.escape(cname), re.IGNORECASE)))
    except re.error:
        pass

def redact(text):
    if not isinstance(text, str):
        return str(text)
    for name, rx in compiled:
        try:
            text = rx.sub(f"[REDACTED:{name}]", text)
        except Exception:
            pass
    return text

def short_tool_summary(name, tool_input):
    if not isinstance(tool_input, dict):
        return f"{name}(...)"
    if name == "Bash":
        cmd = tool_input.get("command", "") or ""
        first = cmd.splitlines()[0] if cmd else ""
        return f"Bash({first[:120]})"
    if name in ("Read", "Edit", "Write", "NotebookEdit"):
        return f"{name}({tool_input.get('file_path', '')})"
    if name == "Glob":
        return f"Glob({tool_input.get('pattern', '')})"
    if name == "Grep":
        return f"Grep({tool_input.get('pattern', '')})"
    if name == "TodoWrite":
        return "TodoWrite(...)"
    if name == "WebFetch":
        return f"WebFetch({tool_input.get('url', '')})"
    if name == "WebSearch":
        return f"WebSearch({tool_input.get('query', '')})"
    keys = list(tool_input.keys())[:2]
    return f"{name}({', '.join(keys)})"

# --- Walk messages, build ordered turn list ---
ordered = []
started_at = None
ended_at = None
model = ""

for msg in messages:
    msg_type = msg.get("type", "")
    ts = msg.get("timestamp")
    if ts:
        if started_at is None:
            started_at = ts
        ended_at = ts

    if msg_type == "user":
        inner = msg.get("message", {}) or {}
        content = inner.get("content", "")
        parts = []
        if isinstance(content, list):
            for c in content:
                if isinstance(c, dict):
                    if c.get("type") == "text":
                        parts.append(c.get("text", ""))
                    # tool_result echoes are noise; skip
                elif isinstance(c, str):
                    parts.append(c)
        elif isinstance(content, str):
            parts.append(content)
        body = "\n".join(p for p in parts if p).strip()
        if body:
            ordered.append(("User", redact(body)))

    elif msg_type == "assistant":
        inner = msg.get("message", {}) or {}
        if not model:
            model = inner.get("model", "") or ""
        content = inner.get("content", "")
        text_parts = []
        if isinstance(content, list):
            for c in content:
                if not isinstance(c, dict):
                    continue
                if c.get("type") == "text":
                    text_parts.append(c.get("text", ""))
                elif c.get("type") == "tool_use":
                    if verbose_tools:
                        text_parts.append(
                            f"```tool\n{c.get('name', '?')}: "
                            f"{redact(json.dumps(c.get('input', {}))[:1000])}\n```"
                        )
                    else:
                        text_parts.append(
                            f"- {redact(short_tool_summary(c.get('name', ''), c.get('input', {})))}"
                        )
        elif isinstance(content, str):
            text_parts.append(content)
        body = "\n".join(p for p in text_parts if p).strip()
        if body:
            ordered.append(("Assistant", redact(body)))

if not ordered:
    print("no captured turns; skipping")
    sys.exit(0)

# --- Compute file path ---
now = datetime.now(timezone.utc)
date_str = now.strftime("%Y-%m-%d")
time_str = now.strftime("%H%M%S")
short_id = (session_id or "unknown")[:8] or hashlib.md5(str(now).encode()).hexdigest()[:8]

sessions_dir = repo_root / "sessions" / date_str
sessions_dir.mkdir(parents=True, exist_ok=True)
out_path = sessions_dir / f"{time_str}-{short_id}.md"

# --- Branch / metadata ---
branch = ""
try:
    branch = subprocess.check_output(
        ["git", "-C", str(repo_root), "rev-parse", "--abbrev-ref", "HEAD"],
        stderr=subprocess.DEVNULL, text=True,
    ).strip()
except Exception:
    pass

frontmatter_lines = [
    "---",
    f"session_id: {short_id}",
    f"started_at: {started_at or now.isoformat()}",
    f"ended_at: {ended_at or now.isoformat()}",
    "agent: claude-code",
]
if model:
    frontmatter_lines.append(f"model: {model}")
frontmatter_lines += [
    f"cwd: {cwd}",
    f"project: {project_name}",
]
if branch:
    frontmatter_lines.append(f"branch: {branch}")
frontmatter_lines += [
    f"turns: {len(ordered)}",
    "captured_by: stop-hook-v1",
    f"event: {hook_event}",
    "---",
    "",
]

lines = ["\n".join(frontmatter_lines) + "\n"]
for role, body in ordered:
    lines.append(f"## {role}\n\n{body}\n\n")

out_path.write_text("".join(lines))
print(f"wrote {out_path} ({len(ordered)} turns)")

# --- Heartbeat (FM-1 detection) ---
heartbeat = repo_root / "sessions" / ".heartbeat"
heartbeat.write_text(now.isoformat() + " " + str(out_path) + "\n")
PYEOF

  rc=$?
  echo "=== exit $rc ==="
} >> "$LOG" 2>&1

# Always exit 0 so Claude Code never hangs on our hook.
exit 0
