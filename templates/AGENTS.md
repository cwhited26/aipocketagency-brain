# AGENTS.md — <your-brain>

This is the cross-agent rules file. Every coding agent reads it after `CLAUDE.md`. It tells the agent who is responsible for what, when to hand off, and what is off-limits.

This is NOT a product repo. This is the single source of truth for system-wide rules, architectural decisions, changelogs, and cross-project documentation.

---

## Agent roles

The pattern that scales: each agent owns a narrow band of work, and handoffs are explicit.

- **Claude (planning + architecture + reasoning).** Writes specs, reviews code, designs systems, decides between options. Does not execute build commands by default — produces the plan that another agent runs.
- **Codex / Claude Code (execution + file changes + commands).** Runs the build, edits files, ships commits. Reads the plan, executes it, surfaces verification.
- **ChatGPT (research + summarization + writing).** Long-form synthesis, customer-facing copy, sales material, documentation passes.
- **Cursor (in-IDE pair programming).** Tight feedback-loop work where you are already in the editor and want fast suggestions.
- **Manus / Dispatch (long-running orchestration).** Multi-step work that needs to keep going while you are away.

Adjust the list to your stack. Delete the agents you do not use.

---

## Behavior rules

1. Treat all files in this repo as authoritative.
2. Preserve all historical information.
3. Return only relevant context when asked.
4. Identify gaps instead of guessing.
5. Do not implement product code in this repo (it is a thinking repo).
6. Do not invent missing rules.
7. Do not modify this repo unless explicitly instructed.

---

## How agents connect

- This repo (`your-brain`) feeds every working repo.
- Always use this repo to understand context BEFORE making changes anywhere else.
- Working repos hold the implementation; this repo holds the why.

---

## Runtime execution layer

When operating across repositories, apply the following:

### Startup behavior

Before any non-trivial work:

1. Identify the target repo
2. Check `git status`
3. If dirty:
   - Separate staged / unstaged / untracked
   - Explain in plain English
   - Do NOT modify anything automatically

### Multi-repo awareness

- This repo is the global system context.
- Working repos contain implementation details.
- Always:
  1. Read this file (global context)
  2. Read the target repo's `AGENTS.md`
  3. Follow repo-local rules for execution

### Execution rules

- Only implement the specific task given.
- Do not explore unnecessarily.
- Do not refactor unrelated code.
- Keep changes minimal and scoped.
- Follow existing patterns exactly.

### Agent coordination

- One agent at a time on a given file unless an explicit handoff is made.
- Handoffs go through `handoff-doc.md` — never silently.
- If unclear, stop and surface the question.

### Safety rules

- Do not invent missing rules.
- Do not modify this repo unless explicitly instructed.
- Preserve all system history and documentation.

---

## Confirm by saying

"<your-brain> execution layer active"

This single line in the agent's first response confirms it read this file before doing work.
