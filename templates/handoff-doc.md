# Session Handoff

Use this template every time you stop work in the middle of a multi-step task and expect another agent (or another version of the same agent in a future session) to pick up. The handoff is what keeps the work going while you sleep, drive, or take a meeting.

Save copies under `sessions/Session_<YYYY-MM-DD>_<short-name>.md`. New file per session. Never overwrite.

---

# Session Handoff — <YYYY-MM-DD> — <short topic>

**Outgoing agent:** Claude / Codex / Cursor / ChatGPT / Manus / Dispatch
**Incoming agent:** (intended next agent — leave blank if open)
**Window:** <start> → <end>
**Status:** in-flight / blocked / paused / complete

---

## 1. Where we are

A 3–5 sentence summary of the current state. Assume the incoming agent has read nothing else from this session. The first sentence should answer: what task is in motion right now?

---

## 2. What shipped this session

Concrete artifacts that landed.

- Commit `<sha>` on `<branch>` of `<repo>` — short description
- Doc `<path>` updated — what changed
- Decision logged at `Decision_Log.md` Decision #<n> — title

If nothing shipped, write that.

---

## 3. What is next

Ranked list of next actions, in order. Each item is one or two sentences and includes the file path or command an agent would run.

1. <action 1> — `<file path or command>`
2. <action 2> — …
3. <action 3> — …

---

## 4. What is blocked

Things that cannot move without human input or an external dependency.

- **<blocker>** — what we need (an answer, an account credential, a customer reply, a sync call)
- **<blocker>** — …

---

## 5. Open questions

Questions the next agent should not guess at. The right move is to ask before proceeding.

- <question>
- <question>

---

## 6. Files touched this session

A flat list of every file that was created, edited, or deleted. Useful for the incoming agent to verify the current state matches what this handoff describes.

- `<path>` — created / edited / deleted

---

## 7. Verification status

State which layers were verified for the work done this session.

- **Lane-report layer.** The agent says it shipped.
- **Disk layer.** Local commit confirmed.
- **Remote layer.** Push confirmed (`git ls-remote origin <branch>` matches local HEAD).
- **Behavior-verified layer.** End-to-end smoke test through the actual UI.

If a layer was not reachable this session, say so explicitly. "Browser smoke test NOT performed — UI verification on the operator / client" is the canonical phrasing.

---

## 8. Notes for the next session

Anything that does not fit the structured sections above. Pitfalls noticed, side-quests identified, things that surprised you.
