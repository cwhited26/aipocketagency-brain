---
name: Cascade staleness pattern (Depends on: + bin/stale-audit.sh)
description: Convention docs, specs, and feature inventories that derive from upstream facts can declare a Depends on field. When upstream entries are superseded, bin/stale-audit.sh surfaces dependent docs as re-review candidates.
type: feedback
---

# Cascade staleness — surface downstream drift when upstream changes

When upstream facts (decisions, memory entries, specs) are superseded or significantly updated, downstream docs that derived from them become silently stale. The cascade-staleness pattern makes that drift visible.

**Why:** The most common brain-rot failure mode is this: you correctly update the source-of-truth (a decision-log entry, a memory rule, a pricing line in a spec), but the derivative docs that referenced the old fact keep the stale number until a human notices. Future agents reading the derivatives act on outdated info. The source update was correct; the derivatives drift.

The fix is to make the dependency graph explicit and tooled. Docs that derive from upstream facts opt in by adding a `**Depends on:**` line. A weekly audit script crosses the dependency map against recently-modified upstream files and reports candidates that may need re-review.

## How to apply

**Add `**Depends on:**` to docs that derive from upstream facts:**

- Convention docs (`memory/feedback_*.md`) that codify behavior locked in a Decision Log entry
- Spec docs that build on a numbered decision
- Feature Inventories that summarize state captured in upstream Decision Logs
- Tool / vendor reviews that recommend an action conditional on an unrelated standing decision

Format — one or more lines, near the top of the doc, before the body:

```
**Depends on:**
- `<lane>/Decision_Log.md` Decision <lane>-N (<short title>)
- `<lane>/Decision_Log.md` Decision <lane>-M (<short title>)
- `memory/feedback_<topic>.md`
```

Each entry points to a specific upstream — the fact this doc would be wrong about if the upstream changed. Keep it tight; don't list every adjacent reference, only the load-bearing dependencies.

**Run `bin/stale-audit.sh` weekly:**

The script walks the brain tree for `**Depends on:**` lines, parses the referenced upstream paths, and cross-references against `git log --since="30 days ago"` for those files. Output is a list of dependent docs whose declared upstreams have been touched recently — re-review candidates, not automatic edits.

**When you supersede an upstream entry:** run `bin/stale-audit.sh` and walk the cascade. Each dependent doc gets a quick read; if it's still accurate, no edit needed. If it's drifted, supersede it (per `supersession-pattern.md`) and update.

## Don't apply to

Standalone reference docs that don't derive from anything else don't need a `**Depends on:**` field:

- Raw competitive-intel snapshots
- Tool reviews that don't condition recommendations on other standing decisions
- Voice-of-customer files
- Daily Logs, Change Logs, session handoffs (point-in-time records)
- Brain-root architecture docs that are themselves the upstream (the source-of-truth should not declare dependencies on itself)

The pattern is opt-in. Docs that don't declare a `**Depends on:**` are simply not in the audit graph.

## Tooling

- Script: `bin/stale-audit.sh` (run from the brain root)
- Run cadence: weekly (manual; can be wired to a recurring schedule once the output is informative-but-quiet for your brain)
- Expected output volume: low. Most weeks the report should be a small handful of candidates, not a wall of text. If it gets noisy, tighten the `--since` window or audit which docs over-declare dependencies.

## Related

- `supersession-pattern.md` — what to do when an upstream changes
- `lane-current-state.md` — the per-lane derived file that benefits most from cascade visibility
