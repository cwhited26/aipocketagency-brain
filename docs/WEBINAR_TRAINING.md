# Webinar: Build Your AI Workstation

## Promise

By the end, attendees understand the system, install a safe working version, and can show that two
different coding agents read the same source of truth. Phone dispatch is demonstrated as an adapter,
not as magic.

## 60-minute run of show

### 0-7 minutes: The real problem

- The bottleneck is repeated context reconstruction, not prompt writing.
- Show one task answered inconsistently by agents with isolated memory.
- Define the brain, project rules, active profile, mission, and verification evidence.

### 7-17 minutes: Tour the architecture

- Open `docs/WORKSTATION_ARCHITECTURE.md`.
- Show global instruction layers, then a project-local override.
- Explain why the brain holds the why and a product repo holds the code.
- Show reviewer, builder, and operator profiles as authority ceilings.

### 17-27 minutes: Install live

1. Run the installer with `--dry-run`.
2. Run the one-command install from `docs/INSTALL.md`.
3. Run `workstation doctor`, `workstation status`, and `workstation profile`.
4. Open the generated brain and replace the starter placeholders.
5. Point out timestamped backups and the two managed global blocks.

### 27-39 minutes: Work a real repository

- Open a small sample project with local `AGENTS.md`.
- Ask Codex to inspect before it changes anything.
- Run `workstation verify` and then `workstation verify --full`.
- Show the difference between a build passing and a deployment being proven.
- Update the four brain ledgers after accepting the change.

### 39-49 minutes: Dispatch from a phone

- Walk through `docs/PHONE_DISPATCH.md`.
- Send a read-only mission first.
- Show the mission ID, runner log, bounded result, and callback.
- Explain repository allowlists, scoped credentials, and why writes are opt-in.

### 49-56 minutes: Booster case study

- Install the external Booster profile.
- Show how the same workstation contract can open product context, compare deployed concepts, and
  run Booster-specific verification without copying private context into the public installer.
- Make clear what is reusable and what remains Booster-only.

### 56-60 minutes: Handoff

- Give attendees the repository and one-command installer.
- Assign the first-week exercise: customize the brain, add one project, record one decision, and run
  one read-only phone dispatch.
- Close with the limitations: credentials, provider commissioning, and human acceptance are still
  real gates.

## Presenter preparation

- Use a clean demo operating-system account with no personal secrets.
- Pre-register a disposable repository and read-only phone mission.
- Keep a recorded fallback of the install and dispatch in case a provider is unavailable.
- Never display 1Password item values, shell history containing credentials, or private brain data.
- Test every command from a clean temporary home directory before the webinar.

