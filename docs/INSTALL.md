# Install the AI Workstation

The installer supports macOS, Linux, and WSL. It does not request or write secret values.

## The one-command path

```bash
curl -fsSL https://raw.githubusercontent.com/cwhited26/aipocketagency-brain/main/install-workstation.sh \
  | bash -s -- --profile operator --brain-root "$HOME/ai-brain"
```

That command creates a brain from the public templates, installs layered global instructions for
Codex and Claude Code, installs the `brain` and `workstation` commands, and enables ambient Claude
session capture. Existing agent files are backed up before the installer replaces its own managed
block. Existing brain files are never overwritten.

To connect an existing private brain instead:

```bash
bash install-workstation.sh \
  --profile operator \
  --brain-root "$HOME/company-brain" \
  --brain-repo git@github.com:your-company/company-brain.git
```

To install a project profile:

```bash
bash install-workstation.sh \
  --brain-root "$HOME/company-brain" \
  --profile-file /path/to/project/operator-profile.json
```

Run a harmless plan preview first with `--dry-run`.

## What is changed

- `~/.codex/AGENTS.md`: one marked, replaceable workstation block
- `~/.claude/CLAUDE.md`: one marked, replaceable workstation block
- `~/.claude/hooks/`: ambient capture hook when enabled
- `~/.config/aipocketagency/workstation.json`: paths and active profile, never credentials
- `~/.local/bin/brain` and `~/.local/bin/workstation`
- the selected brain root, but only missing template files

Every changed pre-existing global file receives a timestamped sibling backup. Rerunning the
installer updates only its managed global blocks and installer-owned commands.

## Verify the installation

```bash
workstation doctor
workstation status
workstation profile
```

`doctor` checks the contract layers, CLI availability, GitHub authentication, and whether
1Password is currently unlocked. It never reads or prints secret values.

## Verify a project

```bash
workstation verify /path/to/project
workstation verify --full /path/to/project
```

The quick form checks repository state and `git diff --check`. The full form also runs declared
`typecheck`, `test`, and `build` package scripts in that order. A repository's own instructions may
require additional gates.

## Update

```bash
workstation update
```

The update command refuses to overwrite a locally modified installer checkout. It pulls a clean
checkout with fast-forward only, then reruns the idempotent installer.

