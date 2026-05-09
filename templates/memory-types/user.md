# Memory: user

Facts about you, your team, your business, and how you prefer to work. The agent reads this on every session and treats it as authoritative.

Append-only. New entries at the top. Date every entry. Never silently overwrite — if a fact changes, write a new entry that supersedes the old one.

---

## Format

```
## YYYY-MM-DD — short headline

One sentence stating the fact. One or two more sentences with the detail an agent needs to act on it. Reference the canonical doc if one exists.
```

---

## Categories that belong here

- **Identity.** Legal name, preferred name, email, phone, business name, business legal entity, location, time zone.
- **Business shape.** Industry, size, revenue range, current customer count, primary product line, secondary product lines.
- **Schedule.** Standard working hours, days off, weekly cadence, monthly cadence, quarterly checkpoints.
- **Communication preferences.** Where you live (Slack / iMessage / email / inside the brain dashboard). What channel for what type of message. Async vs. synchronous defaults.
- **Stack.** Tools you use daily (editor, terminal, browser, agents). Tools you have but rarely touch. Tools you are evaluating.
- **Constraints.** Physical (no laptop on jobsite — phone only), legal (specific compliance regimes), financial (budget caps), time (court days, school pickup).

---

## What does NOT belong here

- Project-specific context → `project.md`
- External knowledge sources → `reference.md`
- Preferences captured from agent interactions → `feedback.md`
- Decisions with alternatives → `Decision_Log.md`

---

## Example entries

```
## 2026-05-09 — Phone-first operator

Most work happens from a phone — voice memos, photo capture, lightweight chat. Laptop time is reserved for build sessions and reviews. Default to outputs that read well on a 6-inch screen and assume voice input on the way in.
```

```
## 2026-05-09 — Two distinct revenue lines

The agency runs two distinct revenue lines under one parent: a done-for-you service line and a community + system line. Do not blur the two when drafting outreach, sales copy, or positioning.
```

```
## 2026-05-09 — Working hours

Standard working block is 8a–6p Central, with a hard stop for evening family time. Async work after 8p is fair game for queued tasks but no synchronous expectations.
```
