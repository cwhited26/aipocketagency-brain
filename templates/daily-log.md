# Daily Log

Append-only timeline of what happened, in plain English. New entries at the top. Date every entry. The reader should be able to scroll through this file and reconstruct the last week of work without opening anything else.

This is one of the **4-Place Rule** files. Every meaningful change lands here, in `Change_Log.md`, in `Decision_Log.md` (if it is a decision), and in `Feature_Inventory.md` (if it changes feature status).

---

## Format

```
## YYYY-MM-DD — one-line headline of the day

Two or three short paragraphs describing what happened. Concrete. Names of files, repo SHAs, decisions, surprises. The point is so a future you (or a new agent picking up the thread) can read this entry and know what was done without opening every file.

If the day produced a decision, link to the Decision Log entry. If it produced a commit, name the SHA. If it broke something, say what.
```

---

## Conventions

- Date in `YYYY-MM-DD` format, ISO so it sorts cleanly.
- New entries at the top. Never edit an old entry except to add a follow-up note.
- One day = one entry. If the day had multiple distinct work streams, separate them with `###` subheadings inside the day's entry.
- Link, don't restate. If a long doc was created, link to it; don't reproduce it here.
- "Browser smoke test NOT performed" is the right phrasing when verification was incomplete.

---

## Example entries

```
## 2026-05-09 — Hosted dashboard architecture locked

Wrote `Hosted_Stack_Architecture.md`. Eight architectural decisions answered: domain, subdomain pattern, API surface (REST first, MCP wrapper later), storage (single managed database with row-level security), auth (magic link), dashboard (fork-and-retrofit existing internal dashboard), data ownership on cancel (90-day grace + always-on export), self-host upgrade path (data shape only in v1).

Did not start the build. Lane 1 (tenant + auth + provisioning) is next. Largest cost-saver: prior multi-tenant infra patterns from an internal project already cover ~80% of what's needed. Decision logged at Decision Log Decision #N.
```

```
## 2026-05-08 — Founding-50 paywall live

Stripe products created: Founding 50 ($47/mo), Standard ($97/mo). Checkout pages live at `<your-domain>/start`. Membership cap on the founding SKU is enforced via webhook count check before each checkout — once 50 active subscriptions are on the founding SKU, the checkout flips to the Standard SKU automatically.

Sales page copy unchanged. No marketing push yet. First five founding members coming from existing audience invites.
```

```
## 2026-05-07 — Lane 3 item 12 shipped

Commit `<sha>` on `main` of `<your-product-repo>`. Post-milestone sequence picker added — sequences pre-load by job stage and you can override per-job before sending. RLS test added for the new `sequence_picks` table. Build passes.

Browser smoke test NOT performed (no logged-in client session in scope today). End-to-end browser verification is on the operator to confirm tomorrow.
```
