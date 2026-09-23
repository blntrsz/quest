# Creating quest types

Use the standalone `/create-type` skill to add a quest type. The skill lives at `skills/create-type/SKILL.md`; it is not a quest or runbook.

## Entry point

The user invokes `/create-type` with a direct request or an issue. When the user supplies an issue, the skill reads it and its comments to determine what to build. It asks only about missing details that block the work, then waits for user approval before editing files.

## Workflow

After the user approves, the agent:

1. Add `skills/quest/quests/<type>-quest.md`, with the bare type in frontmatter.
2. Keep the general instruction to use `/create-type` in `skills/quest/SKILL.md`. `list.sh` reads each type's name and description from runbook frontmatter, so individual types do not need duplicate registry entries.
3. Verify that `skills/quest/scripts/load.sh` accepts both the bare type name and suffixed runbook name.
4. Update the snapshots for quest listing and runbook loading, then run the focused tests.
5. Record the result on the source issue when there is one, or hand the result back in chat.

## Loader names

The loader accepts both `decision` and `decision-quest`. Type names use letters, digits, periods, underscores, and hyphens; they cannot be `.` or `..`, or end in `-quest`. The suffix is reserved for runbook names.

## History

Issue #9 replaced [quest #7's proposed `new-type` quest](raw/quest-7-new-type.md) with the standalone `/create-type` skill.

## Sources

- [Issue #9 clarification](raw/quest-9-create-type.md)
- [Original quest #7 design](raw/quest-7-new-type.md)
