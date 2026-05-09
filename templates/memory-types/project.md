# Memory: project

Project-specific facts that scope a single product or engagement. If you have multiple active projects, copy this file and rename it per project (e.g., `project-alpha.md`, `project-bravo.md`).

Append-only inside each entry. New entries at the top. Date every entry.

---

## Format

```
## YYYY-MM-DD — short headline

One sentence stating the fact. Two or three sentences of detail. Link to canonical spec or decision-log entry if one exists.
```

---

## What belongs here

- Project identity (codename, stakeholders, goal, success criteria)
- Locked decisions specific to this project (architecture, naming, scope boundaries)
- Hard rules accumulated during the build ("no SDKs in server routes — REST fetch only")
- Open questions that need a follow-up call to resolve
- Pivots and supersessions (always with a link to the prior entry)

---

## What does NOT belong here

- Daily activity → `Daily_Log.md`
- General agent rules → `Decision_Log.md` or `feedback.md`
- Facts about you or the business → `user.md`
- External documentation references → `reference.md`

---

## Example entries

```
## 2026-05-09 — Phase 1 scope locked

Phase 1 covers signup → working hosted brain in <60 seconds → first memory in <5 minutes → agent-readable from any major coding agent. Anything not on the path to that loop is deferred to Phase 1.5 or Phase 2+. Canonical: spec doc §5.
```

```
## 2026-05-09 — Single Supabase project, RLS-scoped per tenant

Single project for cost and operational simplicity. RLS pattern: JWT custom claim `tenant_id` is set on `auth.users.raw_app_meta_data.tenant_id` during provisioning. Every tenant-scoped table gets four RLS policies (read / insert / update / delete). Memory entries get only read + insert — no update, no delete policies, by design.
```

```
## 2026-05-09 — Magic-link auth, not password

The audience does not want a password. Magic link via the auth provider is the locked answer. On first sign-in after the payment webhook, the JWT hook embeds `tenant_id` in the JWT claim; subsequent sign-ins reuse it.
```

```
## 2026-05-09 — Cancel-grace contract

On cancellation event → tenant flips to grace, with `grace_until = now() + 90 days`. API returns 200 for read, 402 Payment Required for write. At `grace_until`, status flips to suspended; only export endpoint stays open. Hard delete at 12 months from suspension. Never sooner.
```
