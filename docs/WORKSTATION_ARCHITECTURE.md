# AI Workstation Architecture

The system is deliberately small. It makes context and authority predictable across tools without
pretending every agent is the same product.

```text
authoritative brain
  AGENTS.md + CLAUDE.md + MEMORY.md + four ledgers
              |
              v
global tool layers
  ~/.codex/AGENTS.md       ~/.claude/CLAUDE.md
              |
              v
project-local rules
  project/AGENTS.md + project/CLAUDE.md
              |
              v
active profile + mission
  operator / builder / reviewer + one scoped task
              |
              v
verification evidence
  status + diff check + typecheck + tests + build + optional publish gates
```

## Why every lane sees the same rules

The global layer points every supported agent to one authoritative brain before non-trivial work.
The agent then reads the target project's rules. This follows Codex's documented instruction
layering: global guidance applies first, project files apply from the repository root toward the
working directory, and closer instructions take precedence.

The brain holds system-wide context and the reason behind decisions. Product repositories hold the
implementation and their local constraints. A mission adds the exact task; it does not duplicate
the entire brain into a prompt.

## Profiles are authority ceilings

Profiles are machine-readable limits, not personas. The included profiles are:

- `reviewer`: read and diagnose only
- `builder`: make scoped local changes and verify them
- `operator`: build and commit locally; push and deploy remain explicit gates by default

Project profiles can narrow these permissions and add expected verification. They should never
contain credentials, private customer data, or machine-specific secret paths.

## What the installer does not solve

- It does not grant access to GitHub, hosting, databases, or a password manager.
- It does not make an unreviewed agent safe to run with unrestricted permissions.
- It does not convert raw session transcripts into accepted memory automatically.
- It does not prove a deployment. Production claims still require provider and runtime evidence.

## Brain write contract

Meaningful accepted changes update four durable views: daily log, change log, decision log, and
feature inventory. Raw agent output, call transcripts, and stakeholder reactions remain source
material until a human or authorized operator promotes them into a decision.

