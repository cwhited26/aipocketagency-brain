# Change Log

Commit-style ledger of every product-repo SHA and every brain commit affecting this project or product. New entries at the top. Group by date.

This is one of the **4-Place Rule** files. The change log is the receipt that something shipped. The daily log says what happened in plain English; the change log shows the SHAs and file diffs.

---

## Format

```
## YYYY-MM-DD

- `<repo>` `<sha>` — short headline
  - what changed (one or two sentences max)
  - migration applied / no migration
  - tests added / updated / none

- `<repo>` `<sha>` — short headline
  - …
```

---

## Conventions

- Group by date. Most recent date at the top.
- One bullet per commit. The bullet is the SHA + a one-line headline.
- Sub-bullets cover what changed, whether a migration ran, and whether tests changed.
- Brain commits go in this same file when they affect this product (e.g., a new lane plan was logged into the brain). Use `<your-brain>` as the repo name in those rows.
- If a commit was reverted, write the revert as its own entry pointing at the original SHA.

---

## Example entries

```
## 2026-05-09

- `<your-product>` `a1b2c3d` — feat: onboarding wizard step 4 — first memory entry
  - Added `<FirstMemoryStep>` component; wires `POST /v1/brain/memory` on submit.
  - No migration.
  - Vitest unit tests for the form validator added; Playwright E2E updated to cover the wizard happy path.

- `<your-brain>` `e5f6g7h` — docs: lane 3 dashboard retrofit plan
  - New file `lane-3-action-plan.md`. Status: awaiting operator greenlight on fire order.
  - No code changes.

## 2026-05-08

- `<your-product>` `9876abc` — feat: subdomain tenant resolution middleware
  - Reads `<handle>` from `Host` header, looks up `tenants` row, sets `tenant_id` on the request context for downstream handlers.
  - No migration.
  - Vitest test added covering wildcard match + reserved-root-paths bypass.
```
