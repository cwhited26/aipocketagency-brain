# Brain Ask — iOS Shortcut Recipe

**Module:** Output Pack O7 — Plain-English Decision Query
**Surface:** iPhone (manual tap, Lock Screen widget, or "Hey Siri" voice trigger)
**Backend:** the `brain ask "<question>"` CLI from this template running on your Mac

The CLI is the source of truth: `brain ask "<question>"` hybrid-searches your brain (`memory/`, `sessions/`, and any top-level project sub-directories), ranks the hits, and passes the top matches to Claude Haiku for a cited answer. The Shortcut is the mobile surface — it SSHes into your Mac, runs the CLI, and shows the answer back on your phone.

This recipe assumes the public AI Pocket Agency brain template is already cloned and installed (`bin/brain` on PATH, `.brain-config.json` at the repo root, `ANTHROPIC_API_KEY` set in your shell).

---

## TL;DR — recommended path

**Path 1: SSH via Tailscale (recommended, three-minute build).** Free for personal use. The Mac stays the source of truth; the Shortcut SSHes in and runs the CLI directly. No paid app, no server, no token to rotate.

**Path 2: Vercel route + GitHub Actions runner (deferred, Mac-free).** If you need the brain reachable when your Mac is asleep or off. Documented as a v1.1 Saturday-build.

---

## Path 1 — SSH via Tailscale (RECOMMENDED)

### Prereqs

- Tailscale installed on iPhone + Mac, both signed in to the same tailnet ([tailscale.com](https://tailscale.com), free for personal use).
- Mac awake when you ask (toggle System Settings → Battery → "Prevent your Mac from sleeping automatically when the display is off").
- The `brain` CLI from this template installed on PATH on the Mac (you should already be running `brain ask "<question>"` locally before wiring the phone surface).
- `ANTHROPIC_API_KEY` exported in your shell rc (e.g. `~/.zshrc`) so it's available to non-interactive SSH sessions.

### One-time setup

**Step 1.** Drop a small wrapper at `~/your-brain/bin/ask-remote.sh` (replace `~/your-brain` with wherever you cloned the template) and `chmod +x` it:

```bash
#!/usr/bin/env bash
# ask-remote.sh — SSH entry point for the iOS "Brain Ask" Shortcut.
# Invokes `brain ask "<question>"` against the local brain repo.
set -euo pipefail
QUESTION="${*:-}"
if [[ -z "$QUESTION" ]]; then
  echo "ask-remote.sh: empty question" >&2
  exit 1
fi
cd "$HOME/your-brain"
exec "$HOME/your-brain/bin/brain" ask "$QUESTION"
```

The wrapper handles two things SSH-from-Shortcut doesn't get for free: a login shell so `PATH` finds the `brain` CLI, and a clean exit so the SSH session closes.

**Step 2.** Open Shortcuts.app → tap `+` → name it "Brain Ask" → add these actions in order:

1. **Ask for Input** — Prompt: "What do you want to ask the brain?" → Input Type: "Text" → Allow Multiline: on → Default Answer: blank.
2. **Run Script Over SSH** — Host: your Mac's Tailscale hostname (e.g. `your-mac.tail-scale.ts.net`). User: your Mac username. Authentication: SSH key (Shortcuts generates one; copy the public key into `~/.ssh/authorized_keys` on the Mac). Port: 22. Script:
   ```
   ~/your-brain/bin/ask-remote.sh "[Provided Input]"
   ```
   Replace `[Provided Input]` with the magic-variable picker pointing at the Ask for Input result.
3. **Show Result** — Input: "Shell Script Result". Pops the answer as readable text on the phone.
4. (Optional) **Speak Text** — Input: "Shell Script Result". Siri reads the answer aloud. Useful when driving.

**Step 3.** Save the Shortcut. To enable voice: long-press the Shortcut tile → "Add to Siri" → record a phrase you'll remember ("Ask the brain", "Brain query", whatever).

### Daily use

- **Tap:** Shortcuts.app → Brain Ask → type the question → done.
- **Voice:** "Hey Siri, ask the brain." Siri prompts for the question. You speak it. Answer shows on screen and reads aloud (if Speak Text is on).
- **Lock screen:** add the Shortcut to a Lock Screen widget for one-tap access.

### Trade-offs

- **Pro:** Works from anywhere on the tailnet. No paid app. No GitHub PAT to rotate. Same pipeline as the desktop CLI — answers come from the live brain, not a stale snapshot.
- **Con:** Mac must be awake. If your Mac is closed or off, the Shortcut fails — there is no offline queue. Tailscale must be running on both ends.

---

## Path 2 — Vercel route + GitHub Actions runner (DEFERRED, NOT YET BUILT)

### Concept

A Vercel route on your own domain accepts `POST` with `{question}` and a shared-secret header. The route triggers a GitHub Action that clones your brain repo (private, with a fine-scoped PAT) or operates on a public mirror, runs `brain ask "<question>"`, and returns the answer.

This path makes the brain reachable when the Mac is asleep — but it requires a fine-scoped GitHub PAT, an Anthropic API key in GitHub Actions secrets, a Vercel deployment, and a shared-secret header on the iOS side. Worth building when the SSH path runs into real Mac-off friction. The SSH path covers most real use cases.

---

## Failure modes

- **`brain: no .brain-config.json found above $(pwd)`** — your SSH session is running in the wrong directory. The `ask-remote.sh` wrapper handles this; if you're invoking `brain ask` directly without the wrapper, prepend `cd ~/your-brain && ` to the SSH script line.
- **`ERROR: ANTHROPIC_API_KEY not set.`** — your shell rc isn't being loaded in the non-interactive SSH session. Either export the key in `~/.zshrc` (or `~/.bashrc` if you use bash) so it's available to login shells, or hard-code the export inside `ask-remote.sh` (less secure — only on a single-user Mac).
- **Answer cites a wrong file** — open the file. The citation is the trust mechanism. If the source is stale, accept the corrected memory entry and run `brain consolidate` to refresh.
- **No answer for a question you know the brain has** — the keyword filter dropped too many words. Rephrase using the proper nouns the brain actually uses (project names, file paths, customer names) rather than generic ones ("the client", "the project").

---

## Recommendation

Build Path 1 today. Three minutes — SSH key, Shortcut actions, "Add to Siri." You'll use it within the hour. Path 2 is the upgrade when you want the brain reachable while your Mac sleeps.
