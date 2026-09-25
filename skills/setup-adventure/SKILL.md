---
name: setup-adventure
description: Configure this repo's issue tracker for quests and adventures. Run once before first use of /quest or /adventure.
disable-model-invocation: true
---

# Setup Adventure

Scaffold the per-repo configuration the Adventure skills assume:

- **Issue tracker**: where quests and adventures are tracked (GitHub by default; local markdown is also supported out of the box)

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config`: is this a GitHub repo? GitLab? Which one?
- `AGENTS.md` and `CLAUDE.md` at the repo root: does either exist? Is there already an `## Adventure` section in either?
- `docs/agents/issue-tracker.md`: has this skill's prior output already been written?
- `.scratch/`: a sign that a local-markdown issue tracker convention is already in use

### 2. Present findings and ask

Summarise what's present and what's missing. Then take the section in order.

Lead the section with the recommended answer so the user can accept it in a word. Give a one-line explainer only when the choice genuinely branches; skip the section entirely when exploration already settled it.

**Section A: Issue tracker.**

> Explainer: The "issue tracker" records quests and adventures for this repo. `/quest` reads quest tickets to find their runbooks, and `/adventure` creates and coordinates linked quest tickets. These skills need to know whether to call `gh issue create`, write markdown files under `.scratch/`, or follow some other workflow you describe. Pick the place you actually track work for this repo.

Default posture: GitHub if a `git remote` points at GitHub; GitLab (`gitlab.com` or a self-hosted host) if it points at GitLab. Otherwise (or if the user prefers), offer:

- **GitHub**: track quests in this repo's GitHub Issues (uses the `gh` CLI)
- **GitLab**: track quests in this repo's GitLab Issues (uses the [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- **Local markdown**: track quests in `.scratch/quests/` (good for solo projects or repos without a remote)
- **Other** (Jira, Linear, etc.): ask how the tracker creates, reads, links, orders, claims, comments on, and closes quests and adventures. Record Quest and Adventure operations as freeform prose, including how it represents parentage, dependencies, and trusted handoffs.

Record the choice in `docs/agents/issue-tracker.md`, using the seed template for the chosen tracker.

### 3. Confirm and edit

Show the user a draft of:

- The `## Adventure` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 4 for selection rules)
- The contents of `docs/agents/issue-tracker.md`

Let them edit before writing.

### 4. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask the user which one to create; don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa); always edit the one that's already there.

If an `## Adventure` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Adventure

### Issue tracker

[one-line summary of where quests and adventures are tracked]. See `docs/agents/issue-tracker.md`.
```

Then write `docs/agents/issue-tracker.md` using the seed template in this skill folder:

- [issue-tracker-github.md](./issue-tracker-github.md): GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md): GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md): local-markdown issue tracker

For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description. Include both Quest operations and Adventure operations so `/quest` and `/adventure` can follow the same tracker contract.

### 5. Done

Tell the user setup is complete, and that `/quest` and `/adventure` will now read and write tracker items via `docs/agents/issue-tracker.md`. Mention they can edit that file directly later; re-running this skill is only necessary to switch trackers.
