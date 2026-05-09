# Memory: feedback

Preferences captured from interactions with agents. The first time you correct an agent, write the correction down here so the next session does not need the same correction.

This is the highest-leverage memory file. Every "no, do it like this" gets one entry. Within a few weeks the agent stops making the same mistakes.

Append-only. New entries at the top. Date every entry.

---

## Format

```
## YYYY-MM-DD — short headline

The pattern the agent did wrong. The pattern you actually want. Why the right pattern is right. Optionally, the canonical doc that codifies it.
```

---

## What belongs here

- Tone preferences ("operator voice, not designer-y" / "no exclamation points" / "no emojis in outputs")
- Format preferences ("never end an email with 'cheers'" / "always use ISO dates" / "prefer plain prose over bullet points in chat replies")
- Workflow preferences ("commit directly to main, never open a PR" / "always run the build before committing")
- Anti-patterns the agent keeps falling into ("stop suggesting Tailwind plugins that need a Tailwind config rebuild")
- Things you have to keep re-saying out loud

---

## What does NOT belong here

- Strategic decisions → `Decision_Log.md`
- Standing facts about you or the business → `user.md`
- Project-specific context → `project.md`

---

## Example entries

```
## 2026-05-09 — Commit directly to main, no PRs

Default workflow is direct push to `main` with the commit author set to my name and a `[YYYY-MM-DD] <agent>` prefix. Do NOT open pull requests unless I explicitly ask for one. PRs add an extra approval step that does not exist in this single-operator setup and slows every change.
```

```
## 2026-05-09 — Run the build before claiming "done"

Before saying a change is shipped, run `npm run build` (or `pnpm build` if the repo uses pnpm) and confirm it passes. A clean lint or type-check is not enough — the build catches things both miss. If the build fails after a change you made, fix it; do not hand back a broken state and apologize later.
```

```
## 2026-05-09 — No emojis in shipped artifacts

Emojis are fine in casual chat. They do not belong in any file that ships — code comments, docs, sales copy, repo readmes. The brand voice is operator, not designer-y. If the prompt explicitly asks for emojis, then yes; otherwise default to none.
```

```
## 2026-05-09 — When verification was not possible, say so

If a feature was tested at the SQL/RLS layer but not end-to-end through the browser, the daily-log entry has to say so explicitly. "Browser smoke test NOT performed" is the canonical phrasing. Never claim a layer was tested when it was not.
```
