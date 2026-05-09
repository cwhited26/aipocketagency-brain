# Twenty Real Memory Examples

Twenty entries pulled from working brains and sanitized for shape. Five per memory type — `user.md`, `feedback.md`, `project.md`, `reference.md`. Names, domains, and specifics have been genericized; the structure and reasoning are exactly as they appear in production.

Read these to internalize the format. Pattern your own entries from these.

---

## `user.md` — facts about the operator and the business

### 1. Two distinct revenue lines under one parent

```
## 2026-05-09 — Two distinct revenue lines

The agency runs two distinct revenue lines under one parent. Line A is done-for-you operations builds for service-business clients, sold per-build. Line B is a community + system membership at a monthly subscription. Do not blur the two in marketing copy, sales calls, or roadmap conversations — the audiences and commitment levels are different.
```

### 2. Phone-first operator

```
## 2026-05-09 — Phone-first operator

Most work happens from a phone — voice memos, photo capture, lightweight chat. Laptop time is reserved for build sessions and reviews. Default to outputs that read well on a 6-inch screen and assume voice input on the way in. Long lists of bullets do not survive on a phone — short paragraphs do.
```

### 3. Working hours

```
## 2026-05-09 — Working hours

Standard working block is 8a–6p Central. Outside that window I am async-only — no synchronous response expectations. Family time is hard-walled after 6p; queued tasks running overnight are fine.
```

### 4. Operating-business showcase customer

```
## 2026-05-09 — Operating-business showcase

The contracting business I own outright runs on the same operations system I sell to clients. It is the showcase customer — every public reference goes through it before going through any actual paying client. Do not mention specific paying-client names in any public-facing content unless I have explicitly green-lit that name.
```

### 5. Stack defaults

```
## 2026-05-09 — Stack defaults

Default stack for every new product: Next.js + TypeScript + Supabase + Vercel + Stripe. Tailwind for styling. React Query for server state. Bun for package management on new projects, pnpm on legacy. Sentry for error monitoring. Resend for transactional email. Twilio for SMS. Reach for these by default; deviate only with a written reason.
```

---

## `feedback.md` — preferences captured from agent interactions

### 6. Push directly to main

```
## 2026-05-09 — Commit directly to main, no PRs

Default workflow is direct push to `main` with the commit author set to my name and a `[YYYY-MM-DD] <agent>` prefix. Do NOT open pull requests unless I explicitly ask. PRs add an extra approval step that does not exist in this single-operator setup and slows every change.
```

### 7. Run the build before claiming "done"

```
## 2026-05-09 — Run the build before "done"

Before saying a change is shipped, run `pnpm build` (or `npm run build` if the repo uses npm) and confirm it passes. Lint and type-check are not enough — the build catches things both miss. If the build fails after a change you made, fix it; do not hand back a broken state and apologize later.
```

### 8. Verification layer must be stated explicitly

```
## 2026-05-09 — State verification layer

When you say "shipped," tell me which layers were verified. The four layers are lane-report (the agent says it shipped), disk (`git log` shows the commit locally), remote (`git ls-remote origin main` matches local HEAD), and behavior-verified (end-to-end smoke test through the actual UI). If a layer was not reachable, the canonical phrasing is "Browser smoke test NOT performed" — use it.
```

### 9. No emojis in shipped artifacts

```
## 2026-05-09 — No emojis in shipped artifacts

Emojis are fine in casual chat. They do not belong in any file that ships — code comments, docs, sales copy, repo readmes, commit messages. The brand voice is operator, not designer-y. If a prompt explicitly asks for emojis, then yes; default to none.
```

### 10. The 4-Place Rule

```
## 2026-05-09 — The 4-Place Rule

Every meaningful change lands in four files: Daily Log (timeline), Change Log (commit ledger), Decision Log (when it's a decision), Feature Inventory (when feature status changes). The first time you ship something without all four entries, I'll catch it. Don't ship and forget to log.
```

---

## `project.md` — project-specific scope and decisions

### 11. Phase 1 scope locked

```
## 2026-05-09 — Phase 1 scope locked

Phase 1 covers signup → working hosted brain in <60 seconds → first memory in <5 minutes → agent-readable from any major coding agent. Anything not on the path to that loop is deferred to Phase 1.5 (MCP wrapper, weekly export emails, realtime cross-agent sync) or Phase 2+ (multi-brain, custom domain, Pro tier). Canonical: hosted brain architecture spec §5.
```

### 12. Single-project RLS pattern

```
## 2026-05-09 — Single Supabase project, RLS-scoped per tenant

Single project for cost and operational simplicity. RLS pattern: JWT custom claim `tenant_id` is set on `auth.users.raw_app_meta_data.tenant_id` during provisioning. Every tenant-scoped table gets four RLS policies (read / insert / update / delete). Memory entries get only read + insert — no update, no delete policies, by design.
```

### 13. Magic-link auth, not password

```
## 2026-05-09 — Magic-link auth

The audience does not want a password. Magic link via Supabase Auth is the locked answer. On first sign-in after the Stripe payment webhook, the JWT hook embeds `tenant_id` in the JWT claim; subsequent sign-ins reuse it. Do not propose password auth or social OAuth for this product.
```

### 14. Cancel-grace contract

```
## 2026-05-09 — Cancel-grace 90/365

On cancellation event → tenant flips to grace, with `grace_until = now() + 90 days`. API returns 200 for read, 402 Payment Required for write. At `grace_until`, status flips to suspended; only the export endpoint stays open. Hard delete at 12 months from suspension. Never sooner.
```

### 15. No "Chase will build this for you" upsell inside the community

```
## 2026-05-09 — No done-for-you upsells in the community

The community product sells the system + community + lives. Done-for-you, hosted, and bespoke work all stay reserved for the sister agency line, by referral. The community must never offer a "we'll build this for you" upsell — it cannibalizes the higher-margin sister line and drifts the brand. Canonical: brand architecture doc Decision #32.
```

---

## `reference.md` — external authoritative sources

### 16. Stripe webhook events reference

```
## 2026-05-09 — Stripe webhook events reference

Authoritative list of every Stripe event we might subscribe to. Use it when wiring a webhook handler — never guess at event names. Link: https://docs.stripe.com/api/events/types
```

### 17. OpenAPI 3.1 spec

```
## 2026-05-09 — OpenAPI 3.1 spec

Spec your generated OpenAPI documents must match. Especially relevant for ChatGPT custom GPT setup — the GPT builder consumes 3.0 or 3.1, not Swagger 2.0. Link: https://spec.openapis.org/oas/v3.1.0
```

### 18. Supabase Auth JWT hook

```
## 2026-05-09 — Supabase Auth JWT hook

The Auth JWT hook lets you embed custom claims (like `tenant_id`) on every issued JWT. We use it to scope every authenticated request to the correct tenant via RLS. Link: https://supabase.com/docs/guides/auth/auth-hooks/custom-access-token-hook
```

### 19. A2P 10DLC overview

```
## 2026-05-09 — A2P 10DLC overview

US carriers require Application-to-Person 10-digit-long-code SMS to be registered. Skipping this gets messages dropped silently. Use the brand registration → campaign registration → number assignment sequence. Twilio's docs are the canonical source.
```

### 20. RLS recursion gotcha

```
## 2026-05-09 — RLS recursion gotcha

When an RLS policy on table A queries table B, and table B has an RLS policy that queries A, you have an infinite recursion that returns 500s only under specific auth contexts. Avoid by using a `SECURITY DEFINER` helper function for cross-table reads inside a policy. Lesson learned the hard way; locked as a project rule.
```

---

## How to read these

Notice the patterns:

- **Every entry has a date** — ISO format, top of the entry.
- **Every entry has a one-line headline** — declarative, scannable.
- **Body is 2–5 sentences** — enough to act on, not a wall of text.
- **No nesting, no metadata fields, no tags.** The format is intentionally flat. The dashboard renders it by date order; the API consumes it by date order.

Notice what's missing:

- No "category" tags. The file you save the entry into is the category.
- No status fields. Memory is permanent. If a fact changes, you write a new entry that supersedes the old one.
- No author fields. Git tracks that. Memory is about content, not authorship.

The simplicity is the feature. Twenty entries in, you stop thinking about the format and start thinking about what's worth writing.
