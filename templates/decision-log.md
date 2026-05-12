# Decision Log

Append-only record of every decision worth remembering, with the why and the alternatives considered. New entries at the top. Number entries sequentially.

This is one of the **4-Place Rule** files. Decisions also get a one-line entry in `Daily_Log.md` on the day they were made. If a decision changes feature status, the corresponding row in `Feature_Inventory.md` updates too.

---

## Format

```
**Decision #<n>** — YYYY-MM-DD
**Title:** <short headline>

**Context:** What problem this decision solves. What was the situation before?

**Decision:** What we are doing. State it as a positive sentence the agent can act on.

**Alternatives considered:** Real options, each with one sentence on why it lost.

**Rationale:** The why. Reference any constraints (cost, time, customer expectation, prior commitment) that drove the call.

**Decided by:** Names of the humans + agents in the room when the decision was made.

**References:** Links to the canonical spec, the daily log entry, the relevant code, related decisions.
```

---

## Conventions

- Number sequentially. The number is forever — never reorder, never reuse.
- Append-only. If a decision is later reversed, write a new entry that says "Supersedes Decision #<n>" and explains what changed and why.
- One decision per entry. If something looks like two decisions, split it.
- Date is the date the decision was made, not the date it was written.
- Link, don't restate. The canonical spec lives elsewhere; the decision log just records that the decision was made.

---

## Example entry

```
**Decision #1** — 2026-05-09
**Title:** Hosted dashboard fork-and-retrofit, not greenfield

**Context:** The hosted product needs a dashboard at `<handle>.<your-domain>`. Two paths: greenfield rewrite, or fork an existing internal dashboard and swap the data layer.

**Decision:** Fork-and-retrofit. Copy the internal dashboard source into a new app repo and swap reads + writes from the local filesystem to the REST API.

**Alternatives considered:**
- Greenfield rewrite — clean code but throws away every UI bug already fixed.
- Multi-tenant the existing repo in place — couples the internal tool to the hosted product; the internal tool has different scope.

**Rationale:** The existing dashboard already has the file tree, inline markdown viewer, quick-links editor, and interactive task-board patterns. A rewrite re-introduces every UI bug already fixed. Forking preserves the investment, swaps only the data layer, and lets the internal tool stay on its own infra.

**Decided by:** <operator> / <agent>

**References:** `Hosted_Stack_Architecture.md` §1.6, `Daily_Log.md` 2026-05-09 entry.
```
