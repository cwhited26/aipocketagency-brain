# Cross-Agent Prompt Bridges

When work moves from one agent to another, context loss is the killer. These bridge templates close the loss. Paste the right one when you hand off; the receiving agent reads it and picks up where the sending agent stopped.

Every bridge has the same shape:

1. **Source agent + window** — who was working, when did the work happen.
2. **What's done** — concrete artifacts (commits, files, decisions).
3. **What's next** — the action the receiving agent should take.
4. **What's blocked** — anything not movable without input.
5. **Brain pointers** — the files in the brain to read for full context.
6. **Verification status** — what was tested and what wasn't.

The templates below are tuned per-direction. Copy the one matching your handoff.

---

## Claude → Codex

Claude planned and architected. Codex executes. The bridge tells Codex: here's the plan, here's the brain context, run it.

```
## Handoff — Claude → Codex — <YYYY-MM-DD> — <topic>

You are picking up work I (Claude) just finished planning. Read the brain context first, then run the plan.

### Brain context to read (in order)
1. CLAUDE.md
2. AGENTS.md
3. <project>/CLAUDE.md (if applicable)
4. memory-types/project.md
5. <plan doc path>

Confirm by replying first with: "<handle> brain context loaded — <count> files read. Ready to execute <topic>."

### What's done
- <plan doc path> — locked plan, awaiting execution
- Brain entries logged: Daily Log <date>, Decision Log Decision #<n>

### What's next (in order)
1. <action 1> — file: <path>
2. <action 2> — file: <path>
3. <action 3> — file: <path>

### What's blocked
None / <blocker description if any>

### Verification expected
- pnpm build green
- All tests in <test path> green
- Round-trip smoke test on <flow>

### When done
- Commit each logical unit separately with message format `[<date>] Codex — <description>`
- Push to main directly. No PR.
- Append a Daily Log entry summarizing what shipped, with SHAs.
- Update Feature_Inventory rows that changed.
- If verification was incomplete, say so explicitly: "Browser smoke test NOT performed — UI verification on Chase."
```

---

## Codex → Claude

Codex shipped. Claude reviews, decides what's next, plans the next lane.

```
## Handoff — Codex → Claude — <YYYY-MM-DD> — <topic>

I (Codex) just finished shipping <topic>. You (Claude) are reviewing what shipped, deciding what's next, and writing the plan for the next lane.

### Brain context to read (in order)
1. CLAUDE.md
2. AGENTS.md
3. <project>/CLAUDE.md
4. Daily_Log.md (last 3 entries)
5. Change_Log.md (last 5 commits on relevant repo)

Confirm by replying first with: "<handle> brain context loaded. Reviewing <topic>."

### What I shipped
- <repo> <sha> — <description>
- <repo> <sha> — <description>
- Daily Log entry appended at <date>
- Feature Inventory rows updated: <list>

### Verification status
- Lane-report layer: ✓
- Disk layer: ✓ (commits confirmed locally)
- Remote layer: ✓ (push confirmed)
- Behavior-verified layer: <✓ / partial / NOT performed — explain>

### What surprised me
- <observation 1 — anything unexpected during the build>
- <observation 2>

### What I think is next
- <suggestion 1 — but you decide, not me>
- <suggestion 2>

### Open questions for Chase
- <question if any — surface to Chase, don't decide>

### Your job
1. Review the diffs at <repo> commits <sha>..HEAD
2. Confirm or adjust the verification claims
3. Decide the next lane
4. Write the plan as <plan doc path> with status "Awaiting Chase greenlight on fire order"
```

---

## Claude → ChatGPT

Claude has the technical context. ChatGPT writes long-form output (sales copy, blog post, customer email, summary memo). The bridge gives ChatGPT exactly enough to write without the technical baggage.

```
## Handoff — Claude → ChatGPT — <YYYY-MM-DD> — <topic>

You are writing <output type> based on work that just shipped. I (Claude) am giving you the source material and the constraints. You produce the draft.

### Brain context to read
- memory-types/user.md (especially the tone/voice entries)
- memory-types/feedback.md (every entry tagged "tone" or "voice")
- <one canonical doc path that summarizes what shipped>

### What I shipped (one paragraph for context — not for inclusion in the draft)
<3–5 sentence summary of the technical work>

### Output you produce
- Format: <email / LinkedIn post / sales-page section / customer comms / etc.>
- Length: <word count or section count>
- Audience: <who reads this>
- Goal: <what you want the reader to do or feel>

### Voice constraints (from feedback.md)
- Operator voice. No designer-y flourishes.
- No emojis.
- No exclamation points.
- Plain prose. Bullets only when they earn their keep.
- Short paragraphs. Phone-readable.

### Things to leave out
- Internal SHAs, file paths, technical jargon (unless audience is technical)
- Any client name not green-lit for public mention
- Future plans not yet shipped (unless the output is explicitly forward-looking)

### Things to include
- <bullet 1>
- <bullet 2>
- <bullet 3>

### Deliverable
Reply with the draft. Do not preface it with explanation. I will tell you what to change after I read it.
```

---

## ChatGPT → Claude

ChatGPT drafted long-form. Claude reviews for accuracy against the technical work, redlines what's wrong, and signals what to log into the brain.

```
## Handoff — ChatGPT → Claude — <YYYY-MM-DD> — <topic>

I (ChatGPT) drafted <output type> for <audience>. You (Claude) review against the actual technical state and tell me what to fix.

### Brain context to read
- The same canonical doc I drafted from: <path>
- Daily_Log.md last 3 entries
- Feature_Inventory.md (current state of any feature mentioned in the draft)

### My draft
<paste the draft inline>

### Things to verify
- Every technical claim matches Feature_Inventory.md status (full / partial / planned). Flag anything overclaimed.
- Every name, SHA, file path is real. Flag anything I made up.
- Voice matches feedback.md tone constraints. Flag drift.
- Length is reasonable for the audience.

### Reply format
- "Approved" + optional minor edits inline, OR
- "Needs revision" + a numbered list of specific things to fix

If approved, also tell me whether anything in the draft should land in the brain as a memory entry or a Daily_Log addition.
```

---

## Cursor → Claude (handing off mid-IDE work)

Cursor was pair-programming. Claude is taking over the same task in a non-IDE context, or reviewing what Cursor produced.

```
## Handoff — Cursor → Claude — <YYYY-MM-DD> — <topic>

I (Cursor) was working in the IDE on <topic>. Handing off to you (Claude) because <reason: I'm leaving the laptop / this needs broader context / I'm stuck>.

### Files I touched this session
- <path> — <created/edited/deleted>
- <path> — …

### What works
- <feature/test 1> — passes
- <feature/test 2> — passes

### What doesn't
- <feature/test 1> — fails with <error>
- <feature/test 2> — flaky

### Where I got stuck
<one paragraph — what you tried, what didn't work, what you suspect>

### Brain context to read
- memory-types/project.md
- Daily_Log.md (last 3 entries)
- Feature_Inventory.md

### Your job
- Read what I touched
- Decide whether to fix forward or revert
- If fix forward, write the plan; I (or Codex) will execute
- If revert, identify the cleanest revert commit
```

---

## Manus / Dispatch → Claude (handing off long-running work)

A long-running orchestration agent shipped a batch overnight. Claude reviews and decides what to do next.

```
## Handoff — Manus → Claude — <YYYY-MM-DD> — <topic>

I (Manus) ran <task> overnight. Here's the result.

### Brain context to read
- Daily_Log.md (the entry I just appended)
- Change_Log.md (the entries I just appended)
- <relevant project doc>

### What ran
- <step 1> — succeeded
- <step 2> — succeeded
- <step 3> — failed with <error> — retried <n> times — gave up

### What landed
- <repo> <sha> — <description>
- <repo> <sha> — <description>
- <doc path> — created/edited

### What didn't
- <step that failed and why>

### Open questions
- <question 1 — needs Chase>
- <question 2 — needs Chase>

### Your job
- Review what landed
- Decide what to do about the failed step
- Write the plan for the next batch
```

---

## A few rules for any bridge

1. **Always read the brain first.** No exceptions. Even fast handoffs include the brain reads.
2. **Confirm by saying you read it.** A single line at the top of the receiving agent's reply confirms the wiring worked.
3. **Verification status is non-negotiable.** Every bridge says what was tested and what wasn't. "NOT performed" is the canonical phrasing for incomplete verification.
4. **Brain pointers are paths, not contents.** Don't paste files into the bridge. Paste paths. The receiving agent fetches the current version.
5. **One bridge per logical unit.** Don't bundle three handoffs into one prompt. Each handoff gets its own bridge.

These templates are conventions, not rules. Adjust the field names, drop sections you don't need, add sections specific to your stack. The shape is what matters: who, what shipped, what's next, what's blocked, what to read, what was tested.
