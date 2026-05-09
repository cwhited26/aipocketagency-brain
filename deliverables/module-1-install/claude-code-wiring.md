# Claude Code Wiring — Connect Your Agent to the Brain

This is the copy-paste configuration that wires Claude Code (or any agent that respects an `AGENTS.md`-style instruction file) to read your hosted brain on every session.

You will do this once per machine. After that, every Claude Code session in any directory inside your home folder reads the brain first and treats it as context.

---

## Prerequisites

You need:

1. **Claude Code installed.** Run `claude --version` in a terminal. If it prints a version, you're set. If not, install from `claude.ai/code`.
2. **Your hosted brain provisioned.** You should have a working dashboard at `<your-handle>.brain.aipocketagency.com` and an API key from the onboarding wizard.
3. **A terminal open in your home folder.** That is `~` or `/Users/<you>` on macOS / Linux, `C:\Users\<you>` on Windows.

---

## Step 1 — Save your API key

Save the API key as an environment variable so no script ever has to hardcode it. Open your shell config file (one of `~/.zshrc`, `~/.bashrc`, or `~/.config/fish/config.fish`) and add:

```bash
export APA_BRAIN_API_KEY="sk_live_..."
export APA_BRAIN_API_HOST="https://api.brain.aipocketagency.com"
export APA_BRAIN_HANDLE="<your-handle>"
```

Reload the shell:

```bash
source ~/.zshrc      # or ~/.bashrc, or your fish config
```

Verify:

```bash
echo $APA_BRAIN_API_KEY | head -c 10 ; echo
```

You should see the first 10 characters of the key. If you see nothing, the export did not take effect. Restart your terminal and try again.

---

## Step 2 — Create a global Claude Code instructions file

Claude Code reads a `~/.claude/CLAUDE.md` file (note the dot prefix) on every session as global instructions. Create it:

```bash
mkdir -p ~/.claude
touch ~/.claude/CLAUDE.md
```

Then paste this into `~/.claude/CLAUDE.md`:

```markdown
# Claude Code — global instructions

I run multiple projects under one operator setup. Before doing any non-trivial work, you read my brain at the API endpoint configured in the env vars `APA_BRAIN_API_HOST` and `APA_BRAIN_API_KEY`.

## On every session

1. Read `CLAUDE.md` from my brain via `GET $APA_BRAIN_API_HOST/v1/brain/files/CLAUDE.md` with the Bearer token.
2. Read `AGENTS.md` from my brain.
3. Read `MEMORY.md` from my brain.
4. If the task involves a specific project, also read that project's `project.md` from `memory-types/`.
5. Confirm you read these files in your first reply by saying: "<my-handle> brain context loaded — <count> files read."

## Standing rules

- No `any` types in TypeScript. If unavoidable, comment why.
- No `console.log` in production code.
- No silent catches.
- Commit author is my name and email exactly as configured in git.
- Commit format is `[YYYY-MM-DD] Claude Code — <description>`.
- Push directly to `main`. Do not open PRs unless I ask.

## Brain writes

- Every meaningful change lands in 4 places: `Daily_Log.md`, `Change_Log.md`, `Decision_Log.md` (if it's a decision), `Feature_Inventory.md` (if feature status changes).
- Memory entries go to `MEMORY.md` via `POST /v1/brain/memory`. Append-only.
- Standing facts about me go to `memory-types/user.md`.
- Things I correct you on go to `memory-types/feedback.md`.
- Project-specific scope goes to `memory-types/project.md` (one file per project).
```

That's the global wiring. Adjust the standing rules section to match your own.

---

## Step 3 — Per-project agent skill (optional but recommended)

For each working repo, drop a `.claude/agents/brain-sync.md` file that scopes the brain reads to that project. The structure:

```bash
cd /path/to/your-repo
mkdir -p .claude/agents
cat > .claude/agents/brain-sync.md <<'EOF'
---
name: brain-sync
description: Sync this project's state with the hosted brain. Use at the start of every session and after every meaningful change.
---

# brain-sync

Sync the local repo state with the hosted brain.

## Reads

On invocation, read:

1. `memory-types/project.md` — project-specific scope and decisions
2. `Daily_Log.md` — last 7 days
3. `Decision_Log.md` — last 5 decisions
4. `Feature_Inventory.md` — current feature state

## Writes

After any code change, before responding to the user:

1. Append a daily-log entry summarizing what changed.
2. If a decision was made (architecture, naming, scope), write a `Decision_Log.md` entry.
3. If a feature shipped or moved status, update the `Feature_Inventory.md` row.
4. If a commit was made, append a `Change_Log.md` entry with the SHA.

Reference the brain endpoints in `APA_BRAIN_API_HOST`. Bearer token from `APA_BRAIN_API_KEY`.
EOF
```

This makes brain-sync a named skill you can invoke with `/brain-sync` mid-session.

---

## Step 4 — Verify the wiring

Open a fresh terminal, navigate to a project repo, and start Claude Code:

```bash
cd /path/to/your-repo
claude
```

In the first message, ask:

> What is in my brain right now? Read CLAUDE.md, AGENTS.md, and MEMORY.md and summarize.

If the wiring is correct, Claude Code's first reply will start with `"<your-handle> brain context loaded — 3 files read."` and then summarize the three files.

If it does not, debug in this order:

1. **Env vars.** `echo $APA_BRAIN_API_KEY` in the same terminal that ran `claude`. If empty, your shell config did not load.
2. **Network.** `curl -H "Authorization: Bearer $APA_BRAIN_API_KEY" $APA_BRAIN_API_HOST/v1/me`. You should get a JSON response with your handle. If you get 401, the key is wrong. If you get a connection error, check the host URL.
3. **Instructions file.** `cat ~/.claude/CLAUDE.md`. The contents should match what you pasted in Step 2.

---

## Variations for other agents

- **ChatGPT custom GPT.** Use the OpenAPI spec at `$APA_BRAIN_API_HOST/v1/openapi.json` as the GPT's action. Paste the API key as the Bearer auth value.
- **Cursor.** Add the same env vars to your shell config; Cursor inherits them from the parent process.
- **Codex.** Set `OPENAI_API_KEY` for Codex itself; the same `APA_BRAIN_API_KEY` env var is read by Codex's tool calls when wired.
- **Manus / Dispatch.** Add the env vars in the agent's runtime config UI.

The wiring is the same shape regardless of which agent: env var for credentials, instructions file for context, brain reads on every session.

---

## What's next

- **Module 2** — learn the conventions your brain expects (System Map, Decision Log, Daily Log, Feature Inventory, Change Log).
- **Module 3** — write your first real memory entries.
- **Module 4** — hand a task off cleanly between Claude and Codex (or any two agents).
- **Module 5** — wire your business into the brain so every workflow runs through it.
