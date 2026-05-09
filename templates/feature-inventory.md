# Feature Inventory

The canonical list of every feature in the product, with its status, last-verified SHA, and the source-of-truth file pointer. Updated whenever a feature ships, is deprecated, or moves between status tiers.

This is one of the **4-Place Rule** files. Every feature change lands here in addition to the Daily Log, the Change Log, and (when applicable) the Decision Log.

---

## Status definitions

- **full** — feature is shipped, tested end-to-end, and verified working in production.
- **partial** — feature is shipped but has known limitations, missing edge cases, or incomplete verification. Always note what is missing in the entry.
- **planned** — feature is scoped or specced but not yet shipped. Include the canonical spec link.

If a feature has been removed or deprecated, write a new entry with status **deprecated** explaining why and pointing to the replacement (if any). Do not delete the row.

---

## Format

```
| Feature | Status | Last verified SHA | Date | Source of truth |
| :--- | :--- | :--- | :--- | :--- |
| <feature name> | full / partial / planned | `<sha>` or `—` | YYYY-MM-DD | <path or link> |
```

---

## Example table

| Feature | Status | Last verified SHA | Date | Source of truth |
| :--- | :--- | :--- | :--- | :--- |
| Magic-link sign-in | full | `a1b2c3d` | 2026-05-09 | `auth/sign-in.ts` |
| Tenant subdomain resolution | full | `9876abc` | 2026-05-08 | `middleware.ts` |
| Onboarding wizard | partial | `e5f6g7h` | 2026-05-09 | `app/onboarding/*` — step 5 confetti screen pending |
| Always-on export endpoint | planned | — | 2026-05-09 | `Hosted_Brain_Stack_Architecture.md` §1.7 |
| MCP server wrapper | planned | — | 2026-05-09 | `Hosted_Brain_Stack_Architecture.md` §1.3 (Phase 1.5) |
| Pro Brain tier (multi-brain) | planned | — | 2026-05-09 | `Hosted_Brain_Stack_Architecture.md` §2 (Phase 2+) |

---

## Conventions

- One row per feature. If a feature has sub-features, list them as separate rows with a clear naming convention (e.g., `Onboarding wizard / step 4`).
- Status changes get a daily-log entry plus a change-log entry. Don't update this table silently.
- If a feature is `partial`, the entry must say what is missing. "partial — flaky in Safari iOS" or "partial — missing copy for the empty state" is the right level of detail.
- If a feature is `planned`, the source-of-truth file must link to the spec. No spec, no row.
- Last-verified SHA must come from `git log` on the repo where the feature lives. Trust nothing else.
