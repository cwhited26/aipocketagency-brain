# bin/ — brain operating scripts

Small shell scripts that operate on the brain itself. Each one codifies a convention from `memory-conventions/` so you don't have to apply the pattern by hand every time.

After you copy `templates/` into your own brain repo, these scripts run from the brain root.

---

## `lane-summary.sh`

Regenerate `<Lane>/Current_State.md` for one business lane.

A **lane** is any top-level subdirectory of your brain that represents a product, business line, or workstream — the things you'd give an agent as a context boundary. Each lane has its own `Decision_Log.md`, `Daily_Log.md`, and `Feature_Inventory.md` (the 4-Place Rule files, minus `Change_Log.md` which is usually global).

`lane-summary.sh` reads those three source files and writes a derived `Current_State.md` at the lane root: a single-file cold-start handoff. An agent dropped into the lane reads this one file and is roughly caught up.

```bash
bash bin/lane-summary.sh <lane-directory-name>

# Example
bash bin/lane-summary.sh demo-lane
```

The script is idempotent — re-runs overwrite the previous `Current_State.md` cleanly. Never hand-edit the output; edits are lost on the next regen. To change content, edit the source file (Decision Log entry, Daily Log entry, Feature Inventory open question) and re-run.

**Run cadence:** weekly per lane, or on-demand after a major lock day.

**Full convention:** `memory-conventions/lane-current-state.md`

---

## `stale-audit.sh`

Surface dependent docs whose declared upstreams have changed recently.

Cascade staleness is the problem where you correctly update an upstream fact (a decision, a memory entry, a spec section) but the downstream docs that *derived* from it silently drift out of date.

The fix is opt-in: docs that derive from upstream facts add a `**Depends on:**` block near the top, listing their load-bearing upstreams. Once a week you run `stale-audit.sh`. The script walks the dependency graph, checks `git log` for recent changes to declared upstreams, and reports dependent docs that are candidates for re-review.

```bash
bash bin/stale-audit.sh                # default 30-day window
bash bin/stale-audit.sh --since "7 days ago"
STALE_AUDIT_WINDOW="14 days ago" bash bin/stale-audit.sh
```

Output is informational. The script never auto-edits anything — it just shows you what to re-read. Re-review each candidate; if it has drifted, supersede it (per `memory-conventions/supersession-pattern.md`). If it's still accurate, no change needed.

**Run cadence:** weekly.

**Full convention:** `memory-conventions/cascade-staleness.md`

---

## `brain`

CLI for the ambient capture layer (Layer 2). Installed via `bash install-ambient.sh` at the brain root, which also symlinks it to `~/.local/bin/brain` so you can call it from anywhere.

```bash
brain status              # heartbeat + counts + last capture
brain search <query>      # ripgrep over sessions/ + memory/
brain consolidate         # send new sessions → Claude Haiku → memory/.proposed/ for review
brain sync                # git pull --rebase && git push
brain prune [days]        # archive sessions older than N days (default 90)
brain --help              # full reference
```

Configuration: `.brain-config.json` at the brain root controls capture toggle, project name, redaction patterns, and per-project client-name patterns. The Stop hook (Layer A) and pre-commit hook (Layer B) read the same config — edit once.

**Architectural rationale:** `Ambient_Brain_Architecture.md` (in the parent `whited-brain` repo) — covers the 12 decisions, 5 failure modes, retention policy, and Module 6 curriculum.

**Run cadence:**
- `brain status` — whenever; cheap and stateless.
- `brain consolidate` — weekly, then review `memory/.proposed/` and accept or reject each file.
- `brain sync` — between machines.
- `brain prune` — quarterly if `brain status` shows >500MB on `sessions/`.

---

## Adding your own scripts

The bar for adding a script here: it codifies a convention that lives in `memory-conventions/`. If a pattern is repeated by hand often enough that you keep getting it wrong, write a script for it and document the convention.

A new script should:

1. Have a long comment header explaining what it does and which convention it codifies
2. Use `set -euo pipefail` so failures don't masquerade as success
3. Be idempotent if it writes files (re-runs produce the same output)
4. Be safe to run from a cron / CI / `loop` skill without supervision
5. Fail loudly on missing inputs, not silently
