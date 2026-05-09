# Your First Agent — End-to-End Walkthrough

You have a brain. You have agents wired to it. The last step is wiring an agent to do real work in your business — not just read context, but actually run a workflow you'd otherwise do by hand.

This walkthrough builds one agent end-to-end. Pick a workflow you do every week. The agent handles it from now on. You stay in the review seat.

By the end of this walkthrough you will have:

1. A documented workflow in your brain.
2. An agent skill that runs the workflow.
3. A clear human-review point so you stay in control.
4. Logs in the brain so the agent's work is visible and auditable.

Time-on-task: 60–90 minutes the first time. 15 minutes for every agent after that.

---

## Step 1 — Pick the right first workflow

The right first workflow has these properties:

- **You do it at least weekly.** Frequency justifies the build.
- **It has a clear input and a clear output.** Not "use judgment" — actual inputs (a transcript, an email, a CSV) producing actual outputs (a draft email, a summary, a logged entry).
- **You can describe it in 5–10 steps.** If it takes 30 steps, the workflow has hidden complexity that needs to come out before automation.
- **The downside of an error is bounded.** A bad draft you review before sending is fine. A direct money transfer is not.

Examples that fit:

- Discovery call → followup email + a logged decision in the brain.
- Loom from a client → action plan written into the brain, awaiting your greenlight.
- Daily standup summary across three repos → one paragraph in the brain.
- A new lead in your CRM → enrichment + an outreach draft in your drafts folder.

Examples that do not fit (yet):

- "Help me think strategically" — too vague.
- "Run my marketing" — too broad.
- "Send the followup email automatically" — no human-review point. Agent drafts, you send.

Pick one. Write it at the top of `memory-types/project.md` for the project this agent serves. Submit.

---

## Step 2 — Document the workflow in plain English

Open a new file in your brain at `workflows/<workflow-name>.md`. Write the workflow as 5–10 numbered steps. Each step has:

- **A name** — verb-noun, short.
- **An input** — what arrives at this step.
- **An output** — what leaves this step.
- **A check** — how you know the step worked.

Example, for a Loom-to-action-plan workflow:

```
# Workflow — Loom → Action Plan

## 1. Pull the transcript
- Input: a Loom URL or local file
- Output: a plain-text transcript
- Check: transcript is non-empty and readable

## 2. Identify magic lines
- Input: the transcript
- Output: a list of 3–8 verbatim quotes worth surfacing later
- Check: every quote is a real line from the transcript, not a paraphrase

## 3. Bucket feedback
- Input: the transcript
- Output: a list of items split into 5 buckets — workflow polish / data-model work / new features / deferred / verification items
- Check: every item is one short sentence and clearly belongs to its bucket

## 4. Draft an action plan
- Input: the bucketed feedback + the project's current state
- Output: a markdown action plan with priority order and lane numbers
- Check: every item has a lane number, a priority, and an owner suggestion

## 5. Log the plan
- Input: the action plan
- Output: a file at `BOS/Products/<slug>/<slug>_Loom_Walkthrough_<date>_Action_Plan.md` with status "Awaiting greenlight on fire order"
- Check: file exists at the expected path; daily-log entry appended

## 6. Surface the punch list
- Input: the action plan
- Output: a 1-paragraph summary in chat
- Check: the summary fits in a single phone screen
```

Write yours for your workflow. Submit it to the brain.

---

## Step 3 — Build the skill

A "skill" is a named instruction file the agent loads on demand. Drop a file at `.claude/agents/<workflow-name>.md` in your project repo.

The structure:

```markdown
---
name: <workflow-name>
description: <one-sentence trigger description so the agent knows when to invoke this skill>
---

# <Workflow Name>

<one-paragraph summary of what this skill does>

## Brain reads on invocation
1. workflows/<workflow-name>.md — the workflow doc you just wrote
2. memory-types/project.md — project scope
3. memory-types/feedback.md — tone and voice rules

Confirm by replying first with "<workflow-name> skill loaded — running step 1."

## Steps
1. <Step 1 from your workflow doc, in agent-actionable phrasing>
2. <Step 2>
3. <Step 3>
...

## Output format
<exactly what the agent should produce — markdown structure, file path, etc.>

## Stop conditions
- After step <N>, wait for human review before continuing.
- If any check fails, stop and surface the failure with details.
- If a brain read returns 404, stop and ask whether to write the missing file or abort.

## Logging
After completion, append:
- Daily_Log.md — one paragraph summarizing what ran
- Change_Log.md — if a file was created, the path and a one-line description
- Feature_Inventory.md — if status changed, update the row
```

Save it. The agent will load this skill on demand when you invoke it (e.g., `/loom-to-action-plan` in Claude Code or by name in another agent).

---

## Step 4 — Run it once with a real input

Pick a real input. Not a fake one. The fake inputs always make the workflow look easier than it is.

Invoke the skill. Watch the agent run through the steps. Watch where it slows down, where it goes off-script, where it asks a clarifying question you didn't expect.

When it finishes (or stops at the human-review point), open the brain. Verify:

- The expected file was created at the expected path.
- The Daily Log entry was appended.
- The Change Log entry was appended.
- The Feature Inventory wasn't silently broken.

If any of those didn't happen, the skill needs a fix. Edit the skill file, re-run, repeat until the four checks pass cleanly.

---

## Step 5 — Capture lessons learned

The first run will surface five to ten things the workflow doc didn't anticipate. Write them down. Two places:

- **`memory-types/feedback.md`** — for things the agent did wrong that you don't want it to do again ("don't paraphrase quotes — use verbatim only").
- **`workflows/<workflow-name>.md`** — for clarifications on the workflow itself ("step 3 needs to handle the case where there are zero items in a bucket").

Submit both. Re-run the skill on the same input. The output should now be cleaner. Re-run on a different input. Note any new lessons.

After 3–5 runs, the workflow stabilizes. The agent runs it the same way every time. You stay in the review seat. The brain has logs of every run.

---

## Step 6 — Promote to the standard workflow

Once the skill is stable, document it as the standard. Three actions:

1. **Update `CLAUDE.md`** — add a one-line entry to the "How we ship" section: "We use the `<workflow-name>` skill for <workflow input> → <workflow output>."
2. **Add the workflow doc to the dashboard quick-links.** It should be one click away from anyone reading the brain.
3. **Tell anyone else who works in this project.** A team member, a co-founder, a contractor. The workflow is now a shared asset.

The agent isn't doing the work alone. The agent is running the workflow you documented, with a clear human-review point, logged in the brain. You can hand the same instructions to another human and it would work the same way. The agent is the implementation, not the magic.

---

## What this builds toward

After 3–5 agents like this, you have a real operating system. Each agent runs a narrow workflow. Each workflow has a documented input and output. Each run is logged. The brain is the substrate; the agents are the muscles.

The mistake people make is starting with a single "do everything" agent. That agent can never be reviewed, can never be debugged, and can never be handed off to a teammate. The right pattern is many narrow agents over a shared brain — each one solving one problem, all of them logging through the same conventions.

You started with one. After three, the pattern is yours.

---

## Common stuck points

- **"My workflow has 20 steps."** Compress. If a workflow has more than 10 steps, two of them are hidden — find them and split. If it still has more than 10, the workflow is two workflows. Split it into two skills.
- **"The agent goes off-script."** The skill file is too vague. Tighten step phrasing. Add explicit stop conditions. Add a "Confirm by saying" check after the first read.
- **"The brain reads are slow."** Cache. The skill should fetch each file once, not every step.
- **"I don't trust the output to skip review."** Don't skip review. The point is not to skip review — it's to make the work visible and consistent so review takes 30 seconds instead of 30 minutes.

---

## Where to go from here

- **Build a second agent.** Pick another workflow. Repeat steps 1–6.
- **Layer agents.** Once two agents exist, you can chain them — output of A is input to B. Hand off via the brain (write the output to a file, pass the path to B).
- **Share the pattern.** Document your top three workflows publicly. Members in the community pattern off real examples, not theory.

The brain compounds. Each workflow added makes the next one easier to add. Three months in, you have an operations system someone could buy from you.
