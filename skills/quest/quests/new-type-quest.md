---
name: new-type
description: Add a quest type from an issue. Use when an issue requests a type that does not exist in this repo.
---

Add a quest type from its issue. Get the user's approval before editing.

1. **Read the issue.** Read the issue and its comments with the tracker instructions in `docs/agents/issue-tracker.md`. Record the requested type name, purpose, expected runbook behavior, and acceptance criteria. Check the type name against the naming rules in `skills/quest/SKILL.md`; ask for another name if it breaks them. Ask only about missing details that prevent the work. Done when the issue and the user's answers specify what to build.
2. **Confirm the design.** Summarize the type name, runbook behavior, documentation changes, and tests. Wait for the user's approval before editing files. Done when the user approves the design.
3. **Add the type.** Create `skills/quest/quests/<type>-quest.md` with frontmatter `name: <type>`, a concise description, ordered steps, and observable completion criteria. Document the type and how agents create it in `skills/quest/SKILL.md`. Check that `skills/quest/scripts/load.sh <type>` and `skills/quest/scripts/load.sh <type>-quest` both load the new runbook. Done when the runbook and skill guidance describe the type and both loader forms work.
4. **Update and run tests.** Update the quest-list and loaded-runbook snapshots. Keep tests for bare and suffixed names in `tests/list-scripts.test.js`. Add tests only for type-specific behavior those tests do not cover. Run `bun test tests/list-scripts.test.js`. Done when the snapshots include the new type and the focused suite passes.
5. **Record the result.** Comment on the issue with the files changed and test results, following `docs/agents/issue-tracker.md`. Leave the issue open for the human to close. Done when the issue comment lists the changes and results.
