# Brain Inbox — iOS Shortcut Recipe

**Module:** Capture Pack C3 — Share Sheet URL → Brain
**Surface:** iPhone Share Sheet (Safari, Facebook, X, LinkedIn, anywhere with the system Share button)
**Backend:** the `brain consolidate` pipeline from this template — drops a markdown file into `sessions/inbox/`, the Haiku pass turns it into a memory proposal

The inbox door is wired into this template: `sessions/inbox/` is iterated by `brain consolidate` (it loops every non-underscore, non-dot subdirectory of `sessions/`, so the inbox folder is picked up alongside the daily `YYYY-MM-DD/` capture folders). Drop a markdown file there, wait for the next consolidate pass, get a memory proposal in `memory/.proposed/`.

---

## TL;DR — recommended path

**Path 1: Working Copy + Shortcuts (three-minute build).** Requires the Working Copy iOS app ($20 one-time, App Store). Works offline. Touches your brain repo on the phone, commits and pushes, your Mac picks it up on the next `git pull` or `brain sync`.

If you don't have Working Copy and don't want to buy it, skip to **Path 3** (Vercel route — Mac-free, build effort ~20 minutes). **Path 2** (SSH via Tailscale) is documented for completeness but requires your Mac awake whenever you capture.

This recipe assumes the public AI Pocket Agency brain template is already cloned and pushed to a Git remote you own (a private GitHub repo is fine; the Working Copy + Shortcut talks to that remote, not the public template).

---

## Path 1 — Working Copy + Shortcuts (RECOMMENDED)

### One-time setup

**Step 1.** Install Working Copy from the App Store ($20 one-time).

**Step 2.** Open Working Copy → tap `+` → "Clone repository" → paste your own brain repo's SSH URL (e.g. `git@github.com:your-username/your-brain.git`) → add an SSH key (Working Copy generates one; copy the public key to your GitHub SSH settings). Clone the repo. Working Copy keeps the clone on-device.

**Step 3.** Open Shortcuts.app → tap `+` → name it "Brain Inbox" → add these actions in order:

1. **Receive** — set "Receive: URLs, Text from Share Sheet" (toggle Share Sheet on at the top).
2. **Get URLs from Input** — Input: "Shortcut Input".
3. **Ask for Input** — Prompt: "Tag (optional, one line)" → Input Type: "Text" → Default Answer: blank.
4. **Get Current Date** — Format: Custom → ISO `yyyy-MM-dd'T'HH:mm:ss'Z'`.
5. **Get Current Date** (second copy) — Format: Custom `yyyy-MM-dd-HHmmss`. Use this for the filename.
6. **Text** — paste this block, using the magic-variable picker for each placeholder:
   ```
   ---
   source: ios-share-sheet
   tag: [Provided Input]
   captured_at: [Current Date #1]
   ---

   URL: [URLs]

   (No notes — captured from Share Sheet)
   ```
7. **Working Copy → Write File** — Repository: `your-brain` → File Path: `sessions/inbox/share-[Current Date #2].md` → Content: the Text block above → Overwrite: off.
8. **Working Copy → Commit Repository** — Repository: `your-brain` → Message: `iOS Share — inbox capture` (use a date variable here so each commit timestamps itself).
9. **Working Copy → Push Repository** — Repository: `your-brain`.
10. **Show Notification** — Title: "Brain inbox", Body: "Captured + pushed".

**Step 4.** Save the Shortcut. From now on:
- In Safari: tap Share → "Brain Inbox" → optional tag → captured.
- In Facebook: tap the post's `…` → Share → Share to… → "Brain Inbox" → captured.

### On the Mac

Run `brain sync` (or `cd ~/your-brain && git pull`) before your next consolidate pass. The inbox markdown is now visible to `brain consolidate`, which will propose a memory entry into `memory/.proposed/` next time you run it.

### Trade-offs

- **Pro:** Works offline. No server. No tokens to rotate. The brain repo on your phone is the source of truth — same surface as the Mac.
- **Con:** $20 one-time for Working Copy. Push requires cell or Wi-Fi (offline captures queue and push on next connection). You must remember `brain sync` on the Mac before the next consolidate.

---

## Path 2 — SSH via Tailscale (NOT RECOMMENDED unless you already use it)

### Prereqs
- Tailscale running on iPhone + Mac (free for personal use).
- Mac must be awake to receive the SSH command.

### One-time setup

1. Drop this helper at `~/your-brain/bin/inbox-capture.sh` (replace `~/your-brain` with wherever you cloned the template) and `chmod +x` it:
   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   URL="${1:-}"
   TAG="${2:-}"
   [[ -z "$URL" ]] && { echo "usage: inbox-capture.sh URL [TAG]" >&2; exit 1; }
   STAMP="$(date +%Y-%m-%d-%H%M%S)"
   ISO="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
   FILE="$HOME/your-brain/sessions/inbox/share-${STAMP}.md"
   mkdir -p "$(dirname "$FILE")"
   cat > "$FILE" <<EOF
   ---
   source: ios-ssh
   tag: ${TAG}
   captured_at: ${ISO}
   ---

   URL: ${URL}
   EOF
   cd "$HOME/your-brain" && git add "$FILE" && git commit -m "iOS SSH — inbox capture" && git push
   ```

2. Shortcuts.app → new "Brain Inbox" Shortcut:
   - Receive URLs from Share Sheet.
   - Ask for Input (Tag).
   - **Run Script Over SSH** — Host: your Tailscale hostname → User: your Mac username → Authentication: SSH key (generate in Shortcuts) → Script:
     ```
     ~/your-brain/bin/inbox-capture.sh "[URLs]" "[Provided Input]"
     ```
   - Show Notification on success.

### Trade-offs
- **Pro:** No paid app. Captures hit the brain on the Mac directly — no `brain sync` step.
- **Con:** Requires Tailscale on both ends. Mac must be on. SSH key management on iOS is friction. If your Mac is asleep or off, the capture fails (no offline queue).

---

## Path 3 — Vercel route + GitHub API (HOSTED, BUILD YOURSELF)

### Concept

- A Vercel route on a domain you own accepts `POST` with `{url, tag}` and a shared-secret header.
- The route uses a fine-scoped GitHub PAT to PUT a file into your brain repo at `sessions/inbox/share-<timestamp>.md` via the Contents API.
- The Shortcut posts directly to the endpoint.

### Stub (drop into your dashboard project's API route)

```ts
import { NextResponse } from "next/server";

const GITHUB_REPO = "your-username/your-brain";  // your own repo
const INBOX_PATH = "sessions/inbox";

export async function POST(req: Request) {
  const secret = req.headers.get("x-brain-inbox-secret");
  if (!secret || secret !== process.env.BRAIN_INBOX_SECRET) {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const body = (await req.json()) as { url?: string; tag?: string };
  const url = (body.url ?? "").trim();
  const tag = (body.tag ?? "").trim();
  if (!url) {
    return NextResponse.json({ error: "url required" }, { status: 400 });
  }

  const now = new Date();
  const iso = now.toISOString();
  const stamp = iso.replace(/[-:T.Z]/g, "").slice(0, 14);
  const file = `${INBOX_PATH}/share-${stamp}.md`;
  const md = [
    "---",
    "source: ios-vercel",
    `tag: ${tag}`,
    `captured_at: ${iso}`,
    "---",
    "",
    `URL: ${url}`,
    "",
  ].join("\n");

  const ghToken = process.env.GITHUB_INBOX_TOKEN;
  if (!ghToken) {
    return NextResponse.json({ error: "server missing token" }, { status: 500 });
  }

  const ghRes = await fetch(`https://api.github.com/repos/${GITHUB_REPO}/contents/${file}`, {
    method: "PUT",
    headers: {
      Authorization: `Bearer ${ghToken}`,
      Accept: "application/vnd.github+json",
      "User-Agent": "brain-inbox",
    },
    body: JSON.stringify({
      message: `iOS Vercel — inbox capture`,
      content: Buffer.from(md, "utf8").toString("base64"),
      branch: "main",
    }),
  });

  if (!ghRes.ok) {
    const detail = await ghRes.text();
    return NextResponse.json({ error: "github write failed", detail }, { status: 502 });
  }

  return NextResponse.json({ ok: true, file });
}
```

### Shortcut actions for Path 3
1. Receive URLs from Share Sheet.
2. Ask for Input (Tag).
3. **Get Contents of URL** — your Vercel endpoint → Method: POST → Headers: `x-brain-inbox-secret: <secret>`, `content-type: application/json` → Request Body (JSON):
   ```json
   {"url": "[URLs]", "tag": "[Provided Input]"}
   ```
4. Show Notification.

### Trade-offs
- **Pro:** Works from anywhere. No paid app, no Mac dependency, no Tailscale. Captures land in main directly via GitHub commit — `brain sync` on the Mac picks them up.
- **Con (cost flag):** Requires (a) a Vercel project you own, (b) a fine-scoped GitHub PAT with `contents: write` on your brain repo (rotate annually), (c) a `BRAIN_INBOX_SECRET` env var on Vercel and in the Shortcut header, (d) the Vercel route deployed and verified. Build effort: ~20 minutes the first session.

---

## Once a capture lands

```bash
cd ~/your-brain
brain sync                  # pull the new file onto the Mac
brain consolidate           # Haiku pass over sessions/inbox/share-*.md → proposals
ls memory/.proposed/        # review the proposed memory entries
mv memory/.proposed/<file> memory/<file>   # accept
rm memory/.proposed/<file>                 # reject
```

`brain consolidate` requires `ANTHROPIC_API_KEY` exported in your shell. Set it in your shell rc (`~/.zshrc` or `~/.bashrc`) so every new terminal picks it up:

```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

---

## Recommendation

Pick **Path 1** today if you'll buy Working Copy. It's the three-minute build, it touches your real brain repo, and it works offline. Pick **Path 3** if you'd rather build the endpoint once and never touch a paid app — but that's not a today build, it's a Saturday build. **Path 2** is the wrong tradeoff for most: the Mac dependency negates the "capture while out" use case.
