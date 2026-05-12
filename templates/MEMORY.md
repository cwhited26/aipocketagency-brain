# MEMORY — <your-brain>

Standing facts and positioning locks that future agent sessions must respect. **Append-only — never rewrite or delete entries.** New entries go at the top.

Format: each entry has a date, a one-line headline, and 2–5 sentences of detail. If a memory is superseded, do NOT delete it — append a new entry above it noting the supersession and link back to the older entry (see `memory-conventions/supersession-pattern.md`).

This file is the **index**. The bulk of memory content lives in `memory-types/` (user, feedback, project, reference) and `memory-conventions/` (brain-operating conventions). Use this file for cross-cutting standing facts and as the pointer list to per-topic memory files.

---

## YYYY-MM-DD — example: short headline of a standing fact

The first sentence states the fact in plain English. The next two or three sentences explain enough detail that a future session can act on it without re-deriving the reasoning. Reference the canonical doc if one exists.

If this memory ever gets superseded, do not delete it — write a new entry above it that says "Supersedes the YYYY-MM-DD entry" and explain what changed. See `memory-conventions/supersession-pattern.md` for the full pattern.

---

## Memory file convention

- **Append-only.** Never edit an old entry.
- **New entries at the top.** Newest information is the first thing the next session reads.
- **Date in `YYYY-MM-DD`.** ISO sorts cleanly.
- **Headline is one short, declarative line.** The reader should know what the entry is about without reading the body.
- **Body is 2–5 sentences.** If you need more, the entry probably belongs in a longer-form doc and gets a one-paragraph summary here pointing to it.
- **Link to canonical references.** Memory points; specs explain.
- **Supersession is explicit.** Never silent. See `memory-conventions/supersession-pattern.md`.

---

## File-level memory layout

`MEMORY.md` is the **index**. Each line is one pointer to a per-topic memory file:

```markdown
- [feedback_no_silent_catch.md](memory/feedback_no_silent_catch.md) — every catch block must handle or rethrow; bare catch hides bugs
- [project_demo_lane.md](memory/project_demo_lane.md) — demo-lane stack, deploy targets, on-call escalation
- [reference_password_manager.md](memory/reference_password_manager.md) — vault layout: where each secret lives + retrieval CLI
```

Entries are ~150 chars max per line. The index is loaded into every session's context — keep it lean.

Per-topic memory files live in `memory/` (one file per topic, named by type prefix):

- `memory/user_<topic>.md` — facts about you and your business
- `memory/feedback_<topic>.md` — preferences captured from interactions with agents
- `memory/project_<topic>.md` — project-specific scope, deadlines, motivations
- `memory/reference_<topic>.md` — pointers to external systems (Linear projects, Grafana dashboards, etc.)

The four memory types and what belongs in each are documented in `memory-types/` (one explainer file per type).

---

## What belongs in MEMORY.md (the index)

- Cross-cutting positioning locks (one-line)
- Renamed-things ("the old `org_id` is now `tenant_id` everywhere")
- Pointers to per-topic memory files
- Pointers to architectural stance docs that don't yet have a full spec

## What does NOT belong here

- Daily activity → `Daily_Log.md`
- Decisions with rationale + alternatives → `Decision_Log.md`
- Code-level changes → `Change_Log.md`
- Feature status → `Feature_Inventory.md`
- Long-form memory content → individual files under `memory/`

---

## Memory and other forms of persistence

Memory is one of several persistence mechanisms. The distinction is that memory is recalled in **future** sessions — it should not be used for information that only matters within the current session.

- **Plans (in-session):** for the current conversation's implementation strategy. If the plan changes mid-conversation, update the plan, not memory.
- **Task lists (in-session):** for breaking the current conversation's work into steps. Tasks are the work-in-progress ledger; memory is the long-term record.
- **Logs (Daily / Change / Decision):** for the historical record. These are persistent AND structured — agents read them as time-ordered ledgers.
- **Memory:** standing facts, rules, and pointers that change behavior across sessions. If a fact should affect how a future session acts, write it to memory; otherwise leave it in the conversation.

Before writing to memory, ask: *will this be useful three sessions from now?* If no, leave it out.

---

## Sensitive personal information

Some categories should never be written to memory — write them down only in encrypted secret storage (a password manager) and reference them by pointer:

- API keys, tokens, signing secrets, JWTs, passwords
- Personally identifiable information (PII) about people who haven't consented to be in your brain: full SSNs, government ID numbers, full payment-card numbers, medical records
- Live financial figures tied to identified third parties (specific deal amounts, individual people's compensation, account balances) unless they are public or you have the third party's consent
- Anything that would embarrass you, a client, or a teammate if the brain repo became publicly readable

Public business decisions, product strategy, anonymized lessons, and your own preferences are fine. The bar: "would I be okay if this entry was in a screenshot of the brain that leaked?" If no, it doesn't belong in memory.

---

## Cross-references

- `memory-types/user.md` — what belongs in user-type memory
- `memory-types/feedback.md` — what belongs in feedback-type memory
- `memory-types/project.md` — what belongs in project-type memory
- `memory-types/reference.md` — what belongs in reference-type memory
- `memory-conventions/` — brain-operating conventions (supersession, cascade staleness, etc.)
- `Decision_Log.md` — for decisions, not facts
