---
name: Cloudflare account-scoped token verify endpoint
description: Account-scoped Cloudflare tokens verify at /accounts/<id>/tokens/verify, NOT /user/tokens/verify. The /user endpoint returns 1000 Invalid for these tokens even when they are valid.
type: feedback
---

# Cloudflare token verify endpoint depends on scope

When verifying a Cloudflare API token, the endpoint depends on the token's scope:

| Token prefix       | Scope          | Verify endpoint                                     |
| ------------------ | -------------- | --------------------------------------------------- |
| `cft_` or no prefix| User-scoped    | `/client/v4/user/tokens/verify`                     |
| `cfa_`             | Account-scoped | `/client/v4/accounts/<account_id>/tokens/verify`    |

**Why this matters:** If you probe a freshly-created account-scoped token against `/user/tokens/verify`, Cloudflare returns:

```json
{"success": false, "errors": [{"code": 1000, "message": "Invalid API Token"}]}
```

The token is **not** actually invalid. It's being asked at the wrong endpoint. The fix is to use the account-scoped verify endpoint with the account ID baked in.

## How to apply

When probing a Cloudflare token in scripts, agent skills, or build lanes:

1. Try `/accounts/<id>/tokens/verify` first if you have an account ID, OR
2. Check the token prefix — `cfa_` means account-scoped, route accordingly
3. A 1000 error from `/user/tokens/verify` is **not** proof the token is invalid. Test via an actual operation (list zones, list DNS records, etc.) before concluding the token is bad.

The most reliable smoke test is to call an actual operation the token should be able to perform. If that succeeds, the token is fine and any "verify" failure was an endpoint-mismatch noise.

## Where this came from

A real cascade where a freshly-issued account-scoped token failed verify with code 1000 but successfully wrote DNS records on the same call cycle. The verify endpoint mismatch was the issue, not the token itself. Saved future debugging time by writing it down.
