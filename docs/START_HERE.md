# Start Here: AI Workstation

This guide is for someone who is comfortable copying a command but does not want to learn the
underlying frameworks before the workstation becomes useful.

## What you are installing

The AI Workstation gives Codex and Claude Code one shared place to learn how you work.

- Your brain folder holds the rules, memory, decisions, current state, and handoff documents.
- Global instruction layers tell each supported agent to read that brain before it works.
- The `workstation` command checks the setup, verifies projects, updates the installer, and prepares
  dispatch missions.
- Optional ambient capture can preserve Claude Code sessions for later human-reviewed memory work.

It does not install private client context, client-specific profiles, sales material, presenter
training, or secret values. Those stay outside the generic public package.

## The whole journey

```text
Paste one install command
        |
        v
Run workstation guide
        |
        v
Run workstation doctor
        |
        v
Personalize two brain files
        |
        v
Ask an agent to read the brain
        |
        v
Use workstation verify before shipping work
```

## 1. Open Terminal

On a Mac, press Command and Space, type `Terminal`, and press Return. On Linux or WSL, open the
terminal application you normally use.

## 2. Paste the installer

Copy the complete command below, paste it into Terminal, and press Return:

```bash
curl -fsSL https://raw.githubusercontent.com/cwhited26/aipocketagency-brain/main/install-workstation.sh \
  | bash -s -- --profile operator --brain-root "$HOME/ai-brain"
```

The installer checks for Git and Python, creates the brain only where files are missing, installs
the workstation commands, and adds marked instruction blocks for Codex and Claude Code. It does not
ask for passwords or secret values.

## 3. Let the workstation show the next step

Run:

```bash
workstation guide
```

This prints the exact brain path on your machine, the local copy of this guide, and the next safe
commands. You can run it again whenever you lose your place. `workstation start` is an alias for the
same command.

If Terminal says `workstation: command not found`, run this once and then try again:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

To keep that path after restarting Terminal, add the same line to your shell profile. On most Macs:

```bash
printf '%s\n' 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
```

## 4. Check the setup

Run:

```bash
workstation doctor
```

The important first-pass rows are:

- `brain root`: should say `ready`.
- `brain contract`: should say `ready`.
- `profile`: should say `ready`.
- `Codex layer` and `Claude layer`: should say `ready`.
- `git` and `python3`: should say `ready`.

Other tools are optional until you need them. `GitHub auth: not signed in`, `1Password auth: locked
or not signed in`, or a missing agent CLI does not mean the brain installation failed. It means that
specific integration still needs its normal sign-in or installation step.

## 5. Personalize the brain

Your default brain is:

```text
~/ai-brain
```

Open `CLAUDE.md` and `AGENTS.md` in that folder. Replace the visible placeholders for your name,
business, products, repositories, and working preferences. Keep the safety and verification rules
unless you understand why you are changing them.

To find remaining placeholders, run:

```bash
grep -R -n '<your-' "$HOME/ai-brain/CLAUDE.md "$HOME/ai-brain/AGENTS.md"
```

If you already had either file, the installer preserves it. That is intentional. Merge the useful
template sections into your existing file instead of deleting your own working context.

## 6. Run the first agent test

Open Codex or Claude Code from the brain folder:

```bash
cd "$HOME/ai-brain"
```

Then give the agent this prompt:

```text
Read AGENTS.md, CLAUDE.md, and MEMORY.md. Tell me in plain English who I am, how this brain is
supposed to work, which rules you must follow, and what information is still missing. Do not change
any files.
```

A successful answer names your brain, repeats the important rules, distinguishes known facts from
missing information, and does not start editing files.

## 7. Add the first useful memory

Start with one preference you have already had to repeat to an assistant. Add it to a clearly named
file under `memory/`, then add a one-line link to it in `MEMORY.md`. Good first memories are concrete:

- how you want progress updates;
- what “shipped” must prove;
- your preferred writing tone;
- a business rule that should apply in every project.

Never put passwords, API keys, or other secret values in the brain.

## 8. Use the workstation on a project

Before asking an agent to ship code, move into the project and run:

```bash
workstation verify /path/to/project
```

Before a final handoff, run the full declared checks:

```bash
workstation verify --full /path/to/project
```

Repository-specific instructions still win. The command provides a consistent baseline, not a
replacement for the project's own tests and deployment checks.

## What success looks like

You are ready for normal work when all of the following are true:

- `workstation guide` shows the correct brain path.
- The core `workstation doctor` rows say `ready`.
- `CLAUDE.md` and `AGENTS.md` describe you rather than template placeholders.
- A read-only agent test accurately explains your rules and current context.
- You can run `workstation verify` inside a real Git repository.

Phone dispatch comes later. Finish this local path first, then follow [Phone Dispatch](PHONE_DISPATCH.md).

## If you need help

Run these two commands and send their output to the person helping you:

```bash
workstation doctor
workstation status
```

They report paths, installed tools, authentication status, and repository state. They do not print
secret values. Do not send `.env` files, API keys, passwords, or the contents of your secret manager.

For a clean update later, run:

```bash
workstation update
```
