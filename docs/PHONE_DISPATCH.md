# Phone Dispatch

Phone dispatch is an adapter around the same workstation contract. It is not a separate agent with
its own rules.

## Flow

```text
phone shortcut / Telegram / internal dashboard
  -> authenticated dispatcher
  -> GitHub workflow_dispatch
  -> allowlisted repository on a self-hosted runner
  -> Codex or Claude reads global + brain + project rules
  -> workstation verify --full
  -> optional commit and push
  -> bounded callback to the dispatcher
```

`workstation dispatch` writes the same core mission envelope to `<brain>/dispatch/inbox/`. A local
watcher, internal dashboard, or GitHub adapter can claim that mission. Queueing is separate from
execution so a phone tap cannot silently widen agent permissions.

## Install the GitHub adapter

1. Copy `templates/github/phone-dispatch.yml` into the control repository at
   `.github/workflows/phone-dispatch.yml`.
2. Register a dedicated self-hosted runner. Do not use a general employee laptop without a
   dedicated operating-system account and a reviewed filesystem boundary.
3. Set repository variable `ALLOWED_REPOSITORIES` to a comma-separated allowlist.
4. Set `DISPATCH_GIT_NAME` and `DISPATCH_GIT_EMAIL` repository variables.
5. Resolve `CROSS_REPO_PAT` and `DISPATCH_CALLBACK_SECRET` from 1Password into GitHub Actions
   secrets. Do not paste them into the workflow, brain, phone shortcut, or chat.
6. Optionally set `DISPATCH_CALLBACK_URL` as a repository variable. The workflow does not accept a
   callback URL from the phone, preventing arbitrary outbound callbacks.
7. Test with `allow_write=false` against a disposable repository before enabling writes.

The GitHub identity behind `CROSS_REPO_PAT` should have access only to allowlisted repositories.
The allowlist is a second boundary, not a substitute for scoped credentials.

## Phone command shape

Your shortcut or bot needs only five fields:

```json
{
  "task": "Inspect the failing build and report the cause. Do not change files.",
  "agent": "codex",
  "target_repo": "owner/repository",
  "allow_write": false,
  "dispatch_id": "phone-generated-id"
}
```

Keep secrets and long source documents out of `task`. Put durable context in the brain or project
repo, then reference the artifact by path.

## Production gates

- Read-only is the default.
- Repositories are allowlisted twice: workflow validation and token scope.
- Write missions run full repository verification before commit.
- Deploy remains a separate provider-specific gate.
- Callback payloads are bounded to 4,000 result characters.
- Failed verification prevents commit and push.
- Raw mission output is evidence, not accepted memory.

