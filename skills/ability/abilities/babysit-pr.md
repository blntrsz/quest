---
name: babysit-pr
description: Drive a pull request to green — fix every review comment and CI failure, commit, push, and refresh the PR description. Run it with a background agent, and always print the PR link when the run ends.
---

Use this ability to drive a pull request to green: resolve its outstanding review comments and CI failures, push the resulting fixes, and refresh any inaccurate title, summary, or testing notes. Its scope is the PR's review threads, failing checks, branch updates, and description; it finishes by reporting the PR URL.

## Operating rules

**Run this with a background agent.** Hand the sub-agent the PR link and this procedure, and let it work in the background so the current session stays free. When it finishes, report back.

## Procedure

1. **Fix every review comment.** Work through each unresolved comment on the PR. Fix it, reply on the thread, and resolve it. If a comment is wrong or out of scope, say so on the thread rather than silently ignoring it.
2. **Fix every CI failure.** Pull the failing checks, reproduce the failure, and fix the cause — not the symptom. Re-run until the checks pass.
3. **Commit and push.** Stage the fixes, write commits that explain each change, and push to the PR's branch.
4. **Refresh the PR description.** If the title, summary, or testing notes no longer match the changes, update them so the description is accurate.

## Output

Always end a babysit run by printing the PR's URL, even when nothing needed changing.

## Done when

Done when the PR is green, the fixes are pushed, and its description matches the change.
