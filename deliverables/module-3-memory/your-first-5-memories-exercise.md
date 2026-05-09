# Your First 5 Memories — Live Exercise

This is the exercise we run live in the community. You will write five real memory entries — one per category below — and submit them to your hosted brain. Time-on-task: 15 minutes if you're paying attention, 5 if you've done it before.

The point is to get past the "staring at an empty file" friction. After five entries, the next fifty are easy.

---

## Setup

Open two windows side by side:

1. Your dashboard at `<your-handle>.brain.aipocketagency.com`. Click **MEMORY.md** in the file tree, or open the relevant memory-type file under `memory-types/`.
2. This document, so you can read each prompt as you go.

If you're on a phone, swap between tabs instead of side-by-side.

---

## Entry 1 — `user.md` — what is the most important thing your agent should know about you?

The first thing every agent reads. If you have to pick one fact about yourself or your business, this is it.

**Prompt:** *In one sentence, what is the most important thing my agents should remember about me and my business?*

**Format:**

```
## YYYY-MM-DD — <one-line headline>

<one to three sentences>
```

**Examples to pattern from:**

- "I run a one-person operations business under <business name>. Most work is done from a phone."
- "I sell two distinct things — done-for-you builds, and a community for builders learning the system. Never blur the two in marketing copy."
- "Standard working block is 8a–6p Central. Outside that window I am async-only."

Submit it. You should see it appear at the top of `user.md` immediately.

---

## Entry 2 — `feedback.md` — the last time you corrected an agent

What's a mistake an agent has made recently that you do not want to keep correcting? Write the correction down once. The next session reads it and stops making the mistake.

**Prompt:** *What's the last thing I had to correct an AI on? Write the right answer down so I don't have to say it again.*

**Format:**

```
## YYYY-MM-DD — <one-line headline>

<the wrong pattern> <the right pattern> <why it matters>
```

**Examples to pattern from:**

- "Stop opening PRs. Push directly to main with my commit author and a `[YYYY-MM-DD] <agent>` prefix. PRs slow every change in this single-operator setup."
- "No emojis in shipped artifacts. They are fine in casual chat. They are not fine in code comments, docs, or sales copy."
- "When verification was incomplete, say so. 'Browser smoke test NOT performed' is the canonical phrasing."

Submit it.

---

## Entry 3 — `project.md` — a scope decision on your active project

Pick one project you are actively working on. What's a scope decision you have made — what is in, what is out? An agent reading this entry should know exactly where the boundary is.

**Prompt:** *On my active project, what is in scope and what is explicitly out of scope?*

**Format:**

```
## YYYY-MM-DD — <one-line headline>

<the decision in plain English> <what's in> <what's deferred>
```

**Examples to pattern from:**

- "Phase 1 covers signup → working dashboard → first memory entry. Anything else is deferred to Phase 1.5 or Phase 2+."
- "Single Supabase project, RLS-scoped per tenant. Project-per-tenant was considered and rejected on cost."
- "Phone-only UI for the field tool. Laptop screens are out of scope for this product surface."

If you don't have a project yet, write a scope decision about your business itself ("I sell only X. I do not sell Y."). Submit it.

---

## Entry 4 — `reference.md` — a doc the agent should be able to cite

What's an external reference you find yourself looking up over and over? A Stripe webhook list, a Supabase function reference, an OpenAPI spec, a tax form filing date. Drop a single entry pointing the agent at the canonical source.

**Prompt:** *What's a reference doc I keep needing the agent to cite? Give it the link.*

**Format:**

```
## YYYY-MM-DD — <one-line headline>

<one sentence on what the reference is and why it matters here>. Link: <url>.
```

**Examples to pattern from:**

- "Stripe webhook events reference. Use it when wiring a handler — never guess at event names. Link: https://docs.stripe.com/api/events/types"
- "OpenAPI 3.1 spec. The ChatGPT custom GPT builder consumes 3.0 or 3.1. Link: https://spec.openapis.org/oas/v3.1.0"

Submit it.

---

## Entry 5 — `MEMORY.md` — the cross-cutting fact

This is the entry that doesn't fit cleanly into one of the four typed files. Cross-cutting positioning locks, naming conventions, things you keep re-explaining. The headline `MEMORY.md` is the index for those.

**Prompt:** *What is one fact about my world that doesn't fit user, feedback, project, or reference — but every agent must respect?*

**Format:** same as the others — date, headline, body.

**Examples to pattern from:**

- "When I say 'the brain' without project context, default to <your-brain> (this repo)."
- "Sub-brand A sells outcome. Sub-brand B sells system. Never mix the two."
- "Every brain change must be visible on the brain dashboard. If a new file lives outside a path the dashboard scans, it doesn't count as shipped."

Submit it.

---

## What happens after you submit five entries

Open a new Claude Code session. Ask:

> Read my brain and tell me what it knows about me right now.

The agent's response should reflect every entry you wrote. If it doesn't, the wiring is wrong — debug from Module 1.

If it does, you have a working memory loop. Every future session reads what you wrote. Every correction you make in the future becomes one more `feedback.md` entry. The brain compounds.

---

## Common stuck points

- **"I don't know what to write."** Pick the last thing that frustrated you about an AI session. Write that. Memory is built from real friction, not theoretical preferences.
- **"My entry feels too short."** Short is fine. Two sentences is fine. The agent reads context, not novels.
- **"I want to edit a previous entry."** Don't. Memory is append-only. If a fact has changed, write a new entry above the old one that says "Supersedes the YYYY-MM-DD entry — <what changed>." The history matters.
- **"What about secrets / API keys?"** Never put secrets in memory. Memory is plain text in a hosted system. Reference the env var name, not the value.

---

## Where to go next

- Module 4 — clean handoffs between agents (Claude → Codex, Codex → ChatGPT, etc.)
- Module 5 — wire your business so every workflow runs through the brain
