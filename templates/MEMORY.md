# MEMORY — <your-brain>

Standing facts and positioning locks that future agent sessions must respect. **Append-only — never rewrite or delete entries.** New entries go at the top.

Format: each entry has a date, a one-line headline, and 2–5 sentences of detail. If a memory is superseded, do NOT delete it — append a new entry above it noting the supersession and link back to the older entry.

This file is the index. The bulk of memory content lives in `memory-types/` (user, feedback, project, reference). Use this file for cross-cutting standing facts that do not fit cleanly into a single memory type.

---

## YYYY-MM-DD — example: short headline of a standing fact

The first sentence states the fact in plain English. The next two or three sentences explain enough detail that a future session can act on it without re-deriving the reasoning. Reference the canonical doc if one exists.

If this memory ever gets superseded, do not delete it — write a new entry above it that says "Supersedes the YYYY-MM-DD entry" and explain what changed.

---

## Memory file convention

- Append-only. Never edit an old entry.
- New entries at the top.
- Date in `YYYY-MM-DD` format. ISO sorts cleanly.
- Headline is one short, declarative line. The reader should know what the entry is about without reading the body.
- Body is 2–5 sentences. If you need more, the entry probably belongs in a longer-form doc and gets a one-paragraph summary here pointing to it.
- Link to canonical references. Memory points; specs explain.
- Supersession is explicit. Never silent.

---

## What belongs in MEMORY.md

- Positioning locks ("BOS sells outcome, APA sells system — never mix")
- Naming conventions ("the brain defaults to `<your-brain>` when ambiguous")
- Renamed-things ("the old `org_id` is now `tenant_id` everywhere")
- Architectural stances that do not yet have a full spec doc
- Things you keep re-explaining to agents

## What does NOT belong here

- Daily activity → `Daily_Log.md`
- Decisions with rationale + alternatives → `Decision_Log.md`
- Code-level changes → `Change_Log.md`
- Feature status → `Feature_Inventory.md`
- User preferences and biographical facts → `memory-types/user.md`
- Project-specific scope → `memory-types/project.md`

---

## Cross-references

- `memory-types/user.md` — facts about you and your business
- `memory-types/feedback.md` — preferences captured from interactions with agents
- `memory-types/project.md` — project-specific context
- `memory-types/reference.md` — external knowledge you want agents to be able to cite
- `Decision_Log.md` — for decisions, not facts
