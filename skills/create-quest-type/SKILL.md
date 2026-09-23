---
name: create-quest-type
description: Guide an agent through adding a quest type to this repo.
disable-model-invocation: true
---

# Create a quest type

This standalone skill guides agents through adding a runbook for a user-requested quest type. The user can provide an issue or describe the type directly.

## Process

1. **Read the request.** If the user supplied an issue, read it and its comments using `docs/agents/issue-tracker.md`. Use the issue and comments to determine what to build. Otherwise, use the user's request. Identify the type name, purpose, runbook behavior, and acceptance criteria. Ask only about details needed to proceed. Check the name against `skills/quest/SKILL.md`. Done when the request and answers specify what to build.
2. **Confirm the design.** Summarize the type name, runbook steps, documentation changes, and tests. Wait for the user's confirmation before editing files. Done when the user approves the design.
3. **Add the runbook.** Create `skills/quest/quests/<type>-quest.md` with frontmatter `name` set to the bare type name, a description, ordered steps, and observable completion criteria. Keep the general instruction to use `/create-quest-type` in `skills/quest/SKILL.md`. `list.sh` reads each type's name and description from frontmatter, so avoid duplicating per-type registry details there. Done when the runbook is complete and the general instruction is correct.
4. **Check the loader.** Verify that `skills/quest/scripts/load.sh <type>` and `skills/quest/scripts/load.sh <type>-quest` both load the runbook. The loader accepts both names for every type. If either form fails, fix the shared loader and add a shared regression test. Done when both forms load the new runbook.
5. **Update and test.** Update the snapshots for quest listing and runbook loading. Keep tests for both loader names in `tests/list-scripts.test.js`, and add type-specific tests for behavior those tests do not cover. Run `bun test tests/list-scripts.test.js`, then `bun test`. Done when the snapshots are current and both commands pass.
6. **Record the result.** If the request came from an issue, comment there with the changed files and test results using `docs/agents/issue-tracker.md`. Otherwise, report the result in chat. Leave issue closure to the human. Done when the issue records the outcome or the user has the handoff.
