# Your First Memory Entry — Format and Walkthrough

Memory is what turns "Claude on a fresh session" into "Claude that remembers what your business is." The first memory entry you write is the most important. It teaches you the format and gives the agent something durable to read on the next session.

---

## The format

Every memory entry has three parts:

```
## YYYY-MM-DD — short headline

The fact, in plain English. One sentence is fine. Two or three is fine. The point is to give an agent reading this in three months exactly what they need to act on it without re-deriving the reasoning.
```

That's it. No metadata. No tags. No category fields. Just date, headline, body.

The reason the format is this simple: **the file gets written in Slack-fast bursts**, often from a phone, often after a phone call where you remembered something the agent should have known. Friction kills the habit. The format has to survive that.

---

## What makes a good first memory

Pick a fact that is:

1. **True today** — not something you wish or plan.
2. **Likely to stay true** — at least for a few months.
3. **Useful to an agent** — it changes how an agent would respond.
4. **Specific** — names, numbers, exact phrases, not generalities.

A few good first-memory examples:

- "I run a one-person operations business under the name Acme Operations LLC. Most work is done from a phone."
- "My standard working block is 8a–6p Central. Anything after 8p Central is async only — no synchronous expectations."
- "I sell two distinct things — done-for-you builds for clients, and a community for builders learning the system. Never blur the two in marketing copy."
- "We use direct push to main. Do not open PRs unless I explicitly ask for one."
- "Every client gets four logs: Daily Log, Change Log, Decision Log, Feature Inventory. Every meaningful change lands in all four of the relevant ones."

---

## What does NOT make a good first memory

Avoid:

- **Vague preferences.** "Prefer concise outputs" — what does concise mean to you? Be specific: "Replies under 150 words unless I ask for detail."
- **Stale plans.** "Planning to launch the SaaS in Q3" — by Q4, that memory is wrong. Memory is for facts, not intentions.
- **Things the agent should infer.** "I like good code" — useless. Replace with the actual rule: "No `any` types in TypeScript."
- **Long stories.** If it takes a paragraph, it's a doc, not a memory. Write the doc, then a one-line memory pointing to it.

---

## The first-memory walkthrough

In your dashboard:

1. Click **MEMORY.md** in the file tree.
2. Click **Append memory entry**.
3. The form has three fields: date (auto-filled), headline (one line), body (2–5 sentences).
4. Type one fact you want every future agent session to know.
5. Submit.

The entry appears at the top of `MEMORY.md` and is immediately readable by the API. Any agent that reads the brain on its next session will see it.

---

## A starter pack you can paste in

If staring at an empty editor is the friction, here are six entries you can adapt and submit in 5 minutes. Read each one, change what doesn't match, leave the structure alone.

```
## YYYY-MM-DD — Business identity

I run <business name>. The legal entity is <legal name>. We are based in <city, state>. Primary product: <one sentence>. Team size: <number, including me>.
```

```
## YYYY-MM-DD — Working hours

Standard working block is <start>–<end> <time zone>. Outside that window I am async-only — no synchronous response expectations. Court days, school pickup, jobsite hours all live inside this window.
```

```
## YYYY-MM-DD — How we ship

We push directly to `main`. We do not open PRs unless I explicitly ask. Commits use my name and email exactly as configured in git, prefixed with `[YYYY-MM-DD] <agent>`.
```

```
## YYYY-MM-DD — Code standards

No `any` types in TypeScript. No `console.log` in production code. No silent catches. Wrap `.toLocaleString()` with `Number()` to prevent runtime crashes.
```

```
## YYYY-MM-DD — Tone

Operator voice. No emojis in shipped artifacts. No exclamation points. Plain prose over bullet points in chat replies. Bullets are fine when they earn their keep.
```

```
## YYYY-MM-DD — The 4-Place Rule

Every meaningful change lands in 4 places: Daily Log (timeline), Change Log (commit ledger), Decision Log (when it's a decision), Feature Inventory (when feature status changes). Don't ship and forget to log.
```

---

## What's next

After your first memory lands, your agent has something durable to read. The rest of the modules teach you what else to write down, when to write it, and how to keep the brain coherent as the volume grows. Module 3 covers the four memory-file types in depth, with twenty real examples you can pattern from.
