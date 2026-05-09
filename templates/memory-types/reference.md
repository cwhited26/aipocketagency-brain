# Memory: reference

External documentation, third-party docs, and authoritative sources you want agents to be able to cite. Not things you decided — things someone else decided that you must respect.

Append-only. New entries at the top. Date every entry.

---

## Format

```
## YYYY-MM-DD — short headline

One sentence describing what the reference is and why it matters here. The link or canonical citation. Optionally, a one-line note about how to interpret it ("the v2 docs supersede v1 — ignore v1 examples on Stack Overflow").
```

---

## What belongs here

- Provider documentation pages your agents need to cite ("Stripe webhook event reference," "Supabase Auth JWT hook docs")
- API references for tools you depend on ("Twilio messaging service quickstart," "Resend domain setup guide")
- Compliance / legal references ("A2P 10DLC registration overview")
- Industry-standard specs ("OpenAPI 3.1 spec," "JSON Schema draft 2020-12")
- Books, blog posts, or videos that codify a pattern you have adopted

---

## What does NOT belong here

- Your own decisions → `Decision_Log.md`
- Project-specific scope → `project.md`
- Personal facts → `user.md`

---

## Example entries

```
## 2026-05-09 — Stripe webhook events reference

Authoritative list of every Stripe event we might subscribe to. Use it when wiring a webhook handler — never guess at event names. Link: https://docs.stripe.com/api/events/types
```

```
## 2026-05-09 — OpenAPI 3.1 spec

Spec your agent should match when generating an OpenAPI document for the REST API. Especially relevant for ChatGPT custom GPT setup — the GPT builder consumes 3.0 or 3.1, not Swagger 2.0. Link: https://spec.openapis.org/oas/v3.1.0
```

```
## 2026-05-09 — Supabase Auth JWT hook

The Auth JWT hook lets you embed custom claims (like `tenant_id`) on every issued JWT. We use it to scope every authenticated request to the correct tenant via RLS. Link: https://supabase.com/docs/guides/auth/auth-hooks/custom-access-token-hook
```

```
## 2026-05-09 — A2P 10DLC overview

US carriers require Application-to-Person 10-digit-long-code SMS to be registered. Skipping this gets messages dropped silently. Use the brand registration → campaign registration → number assignment sequence. Twilio's docs are the canonical source.
```
