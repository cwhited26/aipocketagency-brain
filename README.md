# aipocketagency-brain

The source of truth for AI Pocket Agency members — templates, deliverables, and the install pattern.

This repo is the public-facing companion to the AI Pocket Agency Skool community at `skool.com/ai-pocket-agency`. Every deliverable referenced inside the classroom modules lives here at a stable URL so members can read, download, copy, or fork without having to log back in to Skool.

## What is in here

```
aipocketagency-brain/
├── README.md                    ← this file
├── LICENSE                      ← MIT
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
    ├── memory-types/            ← four memory-file conventions
    │   ├── user.md
    │   ├── feedback.md
    │   ├── project.md
    │   └── reference.md
    ├── memory-conventions/      ← ready-to-paste brain operating conventions
    │   ├── README.md
    │   ├── four-place-rule.md
    │   ├── supersession-pattern.md
    │   ├── cascade-staleness.md
    │   ├── lane-current-state.md
    │   ├── cloudflare-token-verify-gotcha.md
    │   └── vercel-sensitive-env-gotcha.md
    ├── bin/                     ← brain operating scripts
    │   ├── README.md
    │   ├── lane-summary.sh      ← auto-roll <Lane>/Current_State.md
    │   └── stale-audit.sh       ← surface drift from changed upstreams
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
