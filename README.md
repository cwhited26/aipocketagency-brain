# aipocketagency-brain

The source of truth for AI Pocket Agency members: templates, deliverables, the brain pattern, and a
repeatable AI workstation installer.

This repo is the public-facing companion to the AI Pocket Agency Skool community at `skool.com/ai-pocket-agency`. Every deliverable referenced inside the classroom modules lives here at a stable URL so members can read, download, copy, or fork without having to log back in to Skool.

## Install the complete workstation

This is the fastest path from a clean machine to one shared rule system for Codex, Claude Code,
project repositories, and optional phone dispatch:

```bash
curl -fsSL https://raw.githubusercontent.com/cwhited26/aipocketagency-brain/main/install-workstation.sh \
  | bash -s -- --profile operator --brain-root "$HOME/ai-brain"
```

Then run:

```bash
workstation doctor
workstation status
```

The installer is additive and safe to rerun. It preserves existing brain files, backs up changed
global agent files, writes no credentials, and keeps its own changes inside marked blocks. Start
with [the installation guide](docs/INSTALL.md), read [the architecture](docs/WORKSTATION_ARCHITECTURE.md),
and enable [phone dispatch](docs/PHONE_DISPATCH.md) only after the local system is verified.

The included operator, builder, and reviewer profiles are generic. A company or product can provide
an external profile without forking the installer. `docs/WEBINAR_TRAINING.md` is the repeatable
training outline for teaching the same system outside Booster.

Maintainers can verify installer syntax, JSON profiles, an isolated install, idempotent rerun, CLI
diagnostics, repository verification, and mission creation with:

```bash
bash tests/workstation-smoke.sh
```

## What is in here

```
aipocketagency-brain/
├── README.md                    ← this file
├── LICENSE                      ← MIT
├── install-ambient.sh           ← Layer 2 install — Stop hook + pre-commit + brain CLI
├── .brain-config.json.example   ← starter config for the ambient capture layer
├── sessions/                    ← (empty placeholder) where Layer 2 writes transcripts
├── memory/                      ← (empty placeholder) members' brain entries land here
│   └── .proposed/               ← consolidate-pass output awaiting review
├── deliverables/                ← per-module classroom assets (PDFs + markdown)
│   ├── module-1-install/        ← first-5-min checklist, dashboard tour, wiring snippet, first memory
│   ├── module-2-conventions/    ← cheat sheet, wrong/right gallery, apply-to-your-business worksheet
│   ├── module-3-memory/         ← decision tree, twenty real memory examples, your first 5 exercise
│   ├── module-4-handoff/        ← parallel-lane runbook, agent role matrix, prompt bridges
│   └── module-5-wire-up/        ← business map worksheet, wedge case studies, MCP cheat sheet, walkthrough
└── templates/                   ← raw, paste-ready brain files
    ├── CLAUDE.md                ← master context — agent's first read
    ├── AGENTS.md                ← cross-agent rules
    ├── MEMORY.md                ← append-only fact ledger (index)
    ├── memory-types/            ← four memory-file conventions (user / feedback / project / reference)
    ├── memory-conventions/      ← ready-to-paste brain operating conventions
    ├── bin/                     ← brain operating scripts
    │   ├── README.md
    │   ├── lane-summary.sh      ← auto-roll <Lane>/Current_State.md
    │   ├── stale-audit.sh       ← surface drift from changed upstreams
    │   └── brain                ← Layer 2 ambient memory CLI (status / search / consolidate / sync / prune)
    ├── hooks/                   ← Claude Code Stop hook source
    │   └── brain-ambient-capture.sh
    ├── git-hooks/               ← pre-commit safety net for sessions/
    │   └── pre-commit
    ├── prompts/                 ← LLM prompt templates
    │   └── consolidate.txt
    ├── handoff-doc.md           ← session handoff template
    ├── daily-log.md             ← append-only timeline of what happened
    ├── decision-log.md          ← decisions with rationale + alternatives
    ├── change-log.md            ← commit-style ledger
    └── feature-inventory.md     ← feature status (full / partial / planned)
```

## How to use this repo

You do not need to fork or clone this repo to use the system. Three ways to consume:

1. **Inside the Skool classroom.** Each module links directly to the file you need. Click and you are reading the most recent version.
2. **Direct raw URLs.** Every file is reachable at `https://raw.githubusercontent.com/cwhited26/aipocketagency-brain/main/<path>`. Use these in scripts, agent skills, and your own brain.
3. **Copy a template into your brain.** Open the file on GitHub, click *Raw*, copy, paste into your own brain-shaped repo. Templates are written to drop in clean.

## The pattern this repo teaches

Every brain — yours, the one running each Custom Build, the one running each Pocket Agency client — has the same shape:

- **CLAUDE.md** is the master context. Every agent reads it first.
- **AGENTS.md** is the cross-agent rules — what Claude does, what Codex does, what ChatGPT does, when to hand off.
- **MEMORY.md** is the append-only fact ledger. Standing facts that persist across sessions.
- **The 4-Place Rule** says every meaningful change lands in four files: `Daily_Log.md`, `Change_Log.md`, `Decision_Log.md`, `Feature_Inventory.md`.
- **The brain dashboard** renders all of this as a real interface. Members get a hosted version at `<handle>.brain.aipocketagency.com`.

The five modules in `deliverables/` walk you through installing this pattern, learning the conventions, writing memory the right way, handing off cleanly between agents, and wiring it to your own business.

## Install your first brain in five steps

If you want to skip the classroom and get hands-on right now, here's the shortest path. Total time: ~15 minutes.

### 1. Clone or fork this repo

```bash
git clone https://github.com/cwhited26/aipocketagency-brain.git my-brain
cd my-brain
```

(Or fork it on GitHub and clone your fork.)

### 2. Strip the deliverables, keep the templates

```bash
rm -rf deliverables README.md
mv templates/* .
rmdir templates
```

Your brain root now has `CLAUDE.md`, `AGENTS.md`, `MEMORY.md`, the four log/inventory templates, `memory-types/`, `memory-conventions/`, and `bin/`. Open the repo in your editor (Cursor, VS Code, Claude Code's terminal interface — any of them).

### 3. Read CLAUDE.md, then customize

Open `CLAUDE.md` first. Replace every `<your-brain>`, `<your-product>`, and `<your-domain>` placeholder with your real names. Fill in §2 Repository map, §3 Current state (one entry — what you're starting on today), and §6 Commit conventions. Leave §4 Standing code rules and §5 Brain conventions alone — those are universal.

### 4. Write your first memory entry

Make a `memory/` directory at the brain root. Pick one preference you've already had to correct an agent on — "always use ISO dates" or "never end emails with cheers" — and write it as a feedback memory:

```bash
mkdir memory
```

Create `memory/feedback_first.md`:

```markdown
---
name: <short headline>
description: <one line for the index>
type: feedback
---

<the rule>

**Why:** <the past mistake or preference that triggered the rule>

**How to apply:** <when this kicks in>
```

Add a line to `MEMORY.md`:

```markdown
- [feedback_first.md](memory/feedback_first.md) — <one-line hook>
```

That's a working brain. Every agent that reads this repo from this point forward sees that preference and applies it.

### 5. Try the scripts

Make a fake lane to test the `bin/` scripts:

```bash
mkdir demo-lane
touch demo-lane/Decision_Log.md demo-lane/Daily_Log.md demo-lane/Feature_Inventory.md
bash bin/lane-summary.sh demo-lane
```

You should see `demo-lane/Current_State.md` written with placeholder "not present" notes (because the source files are empty). Open it; this is what an agent reads when they're dropped into the lane cold.

Then run the staleness audit:

```bash
git init && git add -A && git commit -m "init"
bash bin/stale-audit.sh
```

You should see `_No files declare `**Depends on:**` yet._` — the pattern is opt-in, and your fresh brain hasn't opted in to anything yet. Read `memory-conventions/cascade-staleness.md` to learn when to add a `**Depends on:**` block.

You now have a working brain with the four log/inventory files, a starter memory entry, and the two operating scripts wired. Each module in `deliverables/` walks deeper into one slice of this pattern.

## Install ambient capture (Layer 2)

Layer 1 above is the **intentional** brain — files you deliberately edit. Layer 2 is the **ambient** brain — every Claude Code session captured automatically to `sessions/`, then consolidated periodically into the intentional layer via a human-reviewed pass. Together they make a complete brain: nothing important from your conversations is lost.

Architectural rationale, failure modes, and the Module 6 curriculum live in `Ambient_Brain_Architecture.md` in the parent (`whited-brain`) repo. The implementation ships here.

### Prerequisites

- Claude Code installed and on your PATH (`which claude` returns a path)
- `python3` (system Python on macOS / Linux is fine)
- `ANTHROPIC_API_KEY` resolved through your secret manager when you want to run `brain consolidate`
- *Optional but recommended:* `brew install gitleaks` for a second commit-time scan

### Install

From the brain root (your cloned/forked copy of this template):

```bash
bash install-ambient.sh
```

The script is idempotent and safe to re-run. It:

1. Copies the Stop hook to `~/.claude/hooks/brain-ambient-capture.sh`.
2. Merges a `Stop` hook entry into `~/.claude/settings.json` (preserves all existing hooks).
3. Writes `.brain-config.json` at the brain root *only if absent* (mirrors `.brain-config.json.example`).
4. Creates `sessions/.gitkeep` and `memory/.proposed/.gitkeep`.
5. Installs `.git/hooks/pre-commit` (backs up any existing one).
6. Symlinks `~/.local/bin/brain` to your `bin/brain` so the CLI is on PATH.

After install, ensure `~/.local/bin` is on your PATH (`echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc`) and verify:

```bash
brain status
```

You should see your brain root, project name, and a "Hook heartbeat: (none yet)" line. Open a Claude Code session in this repo, exchange a few messages, exit Claude Code, and re-run `brain status` — the heartbeat updates and your transcript appears at `sessions/YYYY-MM-DD/HHmmss-*.md`.

### The brain CLI

```
brain status              heartbeat check + counts
brain search <query>      ripgrep over sessions/ and memory/
brain consolidate         send new sessions to Claude Haiku → memory/.proposed/ for review
brain sync                git pull --rebase && git push
brain prune [days]        archive sessions older than N days (default 90)
brain --help              full reference
```

### Tuning redaction

`.brain-config.json` controls what the Stop hook redacts at write time and what the pre-commit hook blocks at commit time. Out of the box it catches the common secret patterns (Stripe, Anthropic, GitHub, Cloudflare, 1Password, generic base64). Add client names and proprietary identifiers to `client_name_patterns`:

```json
"client_name_patterns": [
  "(?i)AcmeCorp",
  "(?i)customer-internal-id-prefix"
]
```

Both layers (Layer A in the hook, Layer B in pre-commit) read the same list. Edit once.

### Review workflow

After running `brain consolidate`:

```bash
ls memory/.proposed/                            # see what Haiku proposed
cat memory/.proposed/<file>                     # inspect each
mv memory/.proposed/<file> memory/<file>        # accept → then add a line to MEMORY.md
rm memory/.proposed/<file>                      # reject
```

Human review is mandatory — never accept proposals blind. Each proposal carries a `source_sessions:` frontmatter field so you can trace back the transcripts it summarizes.

## Brain operating conventions

Once you've installed the brain, these are the conventions that keep it from rotting. Each is a ready-to-paste memory entry in `templates/memory-conventions/`:

- **4-Place Rule** — every meaningful change lands in four files (Daily / Change / Decision / Feature Inventory). If a change isn't in all four places, it isn't shipped.
- **Supersession pattern** — when a decision or memory entry is replaced, never delete the old version. Mark it superseded and leave a forward pointer. Preserves the audit chain.
- **Cascade staleness** — docs that derive from upstream facts declare a `**Depends on:**` block. `bin/stale-audit.sh` surfaces dependents whose upstreams just changed.
- **Per-lane Current_State** — each lane auto-rolls a `Current_State.md` from its Decision + Daily + Feature files. Generated by `bin/lane-summary.sh`; never hand-edited.

Two of these are tool-backed (cascade staleness, lane current-state). Run the scripts weekly and your brain stays in shape without effort.

## Stable URL pattern

```
https://raw.githubusercontent.com/cwhited26/aipocketagency-brain/main/<path>
```

Examples:

- `…/main/templates/CLAUDE.md`
- `…/main/templates/bin/lane-summary.sh`
- `…/main/templates/memory-conventions/supersession-pattern.md`
- `…/main/deliverables/module-1-install/first-5-minutes-checklist.pdf`
- `…/main/deliverables/module-3-memory/twenty-real-memory-examples.md`

The Skool classroom uses these URLs directly. They will not change.

## License

MIT. Use any template, any worksheet, any cheat sheet inside any project — commercial, personal, client work, paid product. Attribution appreciated, not required.

## Context

- AI Pocket Agency: `aipocketagency.com`
- Community: `skool.com/ai-pocket-agency`
- Pricing: $47/mo founding 50, then $97/mo
- Founder: Chase Whited
- Parent: Whited Consulting
