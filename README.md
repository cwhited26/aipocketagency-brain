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
3. **Copy a template into your brain.** Open the file on GitHub, click *Raw*, copy, paste into your own `whited-brain`-shaped repo. Templates are written to drop in clean.

## The pattern this repo teaches

Every brain — yours, the one running TVE, the one running AthleteOS, the one running each Custom Build — has the same shape:

- **CLAUDE.md** is the master context. Every agent reads it first.
- **AGENTS.md** is the cross-agent rules — what Claude does, what Codex does, what ChatGPT does, when to hand off.
- **MEMORY.md** is the append-only fact ledger. Standing facts that persist across sessions.
- **The 4-Place Rule** says every meaningful change lands in four files: `Daily_Log.md`, `Change_Log.md`, `Decision_Log.md`, `Feature_Inventory.md`.
- **The brain dashboard** renders all of this as a real interface. Members get a hosted version at `<handle>.brain.aipocketagency.com`.

The five modules in `deliverables/` walk you through installing this pattern, learning the conventions, writing memory the right way, handing off cleanly between agents, and wiring it to your own business.

## Stable URL pattern

```
https://raw.githubusercontent.com/cwhited26/aipocketagency-brain/main/<path>
```

Examples:

- `…/main/templates/CLAUDE.md`
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
