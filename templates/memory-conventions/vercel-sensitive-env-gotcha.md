---
name: Vercel Sensitive env vars are unreadable via API — don't assume missing
description: When a Vercel env var is marked Sensitive, `vercel env ls` / pull / API returns null or omits the value even with decrypt. Verify via runtime smoke test, not the env list.
type: feedback
---

# Vercel Sensitive env vars don't show up in the CLI/API

When a Vercel env var is marked **Sensitive** in the Vercel UI, the Vercel API returns `null` for its value — and `vercel env ls` / `vercel env pull` may either omit the var entirely or show it with no value — **even with decrypt**. The variable IS set; you just can't read it from outside the runtime.

**Why this matters:** It is very easy to assume a deployment is broken because the env list doesn't show your secret. The deployment is fine — Sensitive just hides the value from the CLI/API surface.

## How to apply

- **Don't conclude a Vercel env var is missing** just because `vercel env ls` doesn't show a value or doesn't list it. Sensitive vars hide.
- **To verify a Sensitive env var is wired up:** do a runtime smoke test — hit the deployed endpoint that uses the var and confirm the response is what you'd expect when the var is present (e.g. POST to an API route that needs a Stripe key and confirm Stripe answers).
- **If you need to confirm value-level presence** (not just runtime behavior), the source of truth should live in your password manager (1Password, Bitwarden, etc.) — fetch via a CLI helper. Do not print values; just confirm presence.
- **Never print or echo Sensitive values** to stdout / stderr regardless of source, including in agent logs.

## Why mark a var Sensitive at all

Sensitive flagging in Vercel does three things:

1. Hides the value from the CLI / API
2. Hides it from the build logs
3. Hides it from Pull Request preview "env diff" views

If a var holds a real secret (live API keys, signing secrets, JWTs that should never appear in screenshots), mark it Sensitive even though it's slightly harder to debug. The runtime-smoke-test discipline is a small cost for the leak prevention.
