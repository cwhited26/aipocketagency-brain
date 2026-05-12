---
name: Supersession pattern (never delete superseded entries)
description: When a memory entry, decision, or spec section is replaced by new information, mark the old entry as superseded with a forward pointer to the new entry. Never delete the old content.
type: feedback
---

# Supersession pattern — preserve the audit chain

When a fact, decision, memory entry, or spec section is replaced by new information, **never delete the old version**. Mark it superseded and leave the original text in place.

**Why:** The brain is a thinking-and-deciding repo, not a state machine. Future-you (or any agent picking up the work cold) needs to be able to answer "what did we believe last month vs this month, and why did it change?" That question is unanswerable if old entries get rewritten in place. The audit chain is load-bearing for client communication, post-mortems, decision-rule evolution, and onboarding new agents into a lane.

## How to apply

**Memory files (`memory/feedback_*.md`, `memory/project_*.md`):** if a rule changes, append the new rule at the top with a date marker, leave the old text below under a `## Superseded` section, and add a `**Superseded by:** <link to new entry or commit>` line at the very top of the old block.

**Decision Logs:** when a numbered decision is reversed or revised, do not edit the original entry's body. Add a new decision (next number in the sequence) that explicitly references the prior decision number, and append `**Superseded by:** Decision NN` to the top of the original entry. Both decisions stay in the log permanently.

**Spec docs:** when pricing, scope, or architectural choice changes within a section, prepend the new content with a `**Supersedes:** <prior section / SHA>` note, and append `**Superseded by:** <new section / SHA>` to the end of the old section. Don't rewrite the old paragraphs in place.

**MEMORY.md index:** new entries already go at the top per the standing convention. When a new entry contradicts an older one, the new entry's body should explicitly say "Supersedes the YYYY-MM-DD entry below ('<title>')" and the older entry should get a `**Superseded by:** <date and title above>` line prepended to its body.

## Forward-pointer format

Use one of these two forms — pick whichever the surrounding doc style favors:

- Inline link: `**Superseded by:** [YYYY-MM-DD entry above](#yyyy-mm-dd-headline-anchor)`
- Plain reference: `**Superseded by:** YYYY-MM-DD entry above ("<title>") — commit <sha>`

## Don't apply to

Append-only logs do not need supersession. The shape "new entry on top, old entries below, all true at their date" is already the supersession pattern at file granularity. Specifically:

- **Daily Logs** — entries are point-in-time records, not claims about current state.
- **Change Logs** — same: ledger of what happened when.
- **Voice-of-Customer / Competitive Intel files** — each is a snapshot of one source at one time. New intel goes in a new dated file; the old file is not "superseded," it's just historical.

The supersession marker is for documents that make load-bearing claims about *current* state — memory entries, decisions, specs, conventions.
