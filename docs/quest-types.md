# Creating quest types

The agreed design introduces a `new-type` quest for agent-led, end-to-end creation of additional quest types.

## Entry point

Start from a GitHub issue labelled `quest:new-type`. The runbook is `skills/quest/quests/new-type-quest.md`, with frontmatter name `new-type`.

## Workflow

The issue is the source of truth. The agent asks focused questions only for blocking gaps, then presents the proposed design and waits for user confirmation before editing files.

After confirmation, the agent:

1. Adds the new runbook under `skills/quest/quests/`.
2. Documents the type in `skills/quest/SKILL.md` and updates the authorship guidance to allow agent-led type creation.
3. Ensures the runbook loader accepts both a bare type name (such as `decision`) and a suffixed runbook name (such as `decision-quest`), documents both forms, and tests compatibility.
4. Updates the quest-list and loaded-runbook snapshots and runs the focused tests.
5. Records the outcome on the issue; the human closes the quest.

## Design rationale

The workflow uses the ticket as its input rather than requiring a complete specification upfront. It still pauses for confirmation before changes, and it can own the supporting documentation, loader, and test updates as part of the same implementation.

The loader currently mismatches the documented convention: quest labels use the bare type name, while the loader accepts suffixed runbook names. Both forms should remain supported, with regression coverage.

A human-only checklist, human-only runbook authorship, requiring a complete specification before starting, and a documentation-only loader fix were not selected.

## Source

[Quest #7 reference](raw/quest-7-new-type.md)
