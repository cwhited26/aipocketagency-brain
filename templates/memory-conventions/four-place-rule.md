---
name: 4-Place Rule (every change lands in four files)
description: Every meaningful change to a product or lane lands in four files — Daily Log, Change Log, Decision Log (if a decision was made), Feature Inventory (if feature status changed). If a change isn't in all four places, it isn't shipped.
type: feedback
---

# The 4-Place Rule

Every meaningful change to a product, lane, or system lands in **four files**:

1. **`Daily_Log.md`** — what happened today (point-in-time)
2. **`Change_Log.md`** — the commit-style ledger across all repos
3. **`Decision_Log.md`** — if the change involved a decision worth remembering (with the why and alternatives)
4. **`Feature_Inventory.md`** — if feature status changed (planned → partial → full, or a new row)

**Why:** Each file answers a different question for a different reader.

- *"What did we do today?"* → Daily Log (chronological, lived-in)
- *"When did this code change?"* → Change Log (commit-anchored, grep-friendly)
- *"Why did we choose this approach?"* → Decision Log (rationale + alternatives + supersession chain)
- *"Is this feature shipped?"* → Feature Inventory (status + last verified SHA)

If a change only lands in one file, the other three readers can't find what they need. If you skip the Decision Log on something that *was* a decision, future-you can't reconstruct why. If you skip the Feature Inventory on a status change, you tell yourself a feature is shipped that actually isn't.

## How to apply

When you complete any of these, hit all four places before moving on:

- Ship a feature → Daily Log + Change Log + Feature Inventory update (and Decision Log if there were trade-offs)
- Reverse a prior decision → Daily Log + Decision Log (new entry referencing the superseded one)
- Pivot scope or pricing → Daily Log + Decision Log + Feature Inventory (mark deprecated rows)
- Discover an upstream is wrong → Daily Log + Decision Log (correction entry) + cascade audit (see `cascade-staleness.md`)

If the change is purely operational (server restart, dependency bump with no scope impact) — Daily Log + Change Log is enough. Skip Decision/Feature when they don't apply, but never skip the first two.

## Why not just one file?

Two reasons.

**Different time-shapes.** Daily Log is browsed in days. Change Log is browsed in SHAs. Decision Log is browsed by topic ("why did we decide X?"). Feature Inventory is browsed by status ("what's shipped?"). One mega-file optimizes for none of them.

**Different supersession rules.** Daily Log and Change Log are append-only ledgers — old entries are always true at their date. Decision Log and Feature Inventory make claims about *current* state — entries get superseded, deprecated, updated. The append-only files are read forward; the state files are read at-head.

## Where this DOES NOT apply

- One-shot experiments that won't ship → notes in a session handoff are enough
- Doc-only edits (typo fixes, formatting) → Change Log only
- Daily-driver chat with an agent that didn't produce an artifact → nowhere
- Spec drafts that haven't been adopted → live in the spec file itself, no log entries yet

The rule is for changes that someone, three months from now, would need to find again.

## Related

- `supersession-pattern.md` — the "how do I revise without rewriting history" rule that makes Decision Log and Feature Inventory honest
- `lane-current-state.md` — the derived file that uses the three state files as input
