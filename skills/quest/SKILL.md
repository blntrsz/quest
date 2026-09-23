---
name: quest
description: Create and execute a Quest.
disable-model-invocation: true
---

A **Quest** is one objective, filed as a ticket on this repo's issue tracker. Its **quest type** selects a **runbook**, a procedure in this skill's `quests/` folder. Executing the quest means following that runbook in order.

The ticket records the objective for this repo. The runbook defines how quests of that type run. The skill covers two tasks: **run** a quest from its ticket or **file** a new quest.

## Quest type and runbook

A runbook is `quests/<type>-quest.md`; the quest type is the filename and frontmatter name without the `-quest` suffix. Type names use letters, digits, periods, underscores, and hyphens; they cannot be `.` or `..`, or end in `-quest`. The loader reserves that suffix for runbook names. For example, `quests/decision-quest.md` has type `decision`, so its ticket label is `quest:decision`.

Load one or more runbooks with `skills/quest/scripts/load.sh <name> [<name>...]` from the repo root. Use either the bare quest type (`decision`) or the suffixed runbook name (`decision-quest`). List types with `skills/quest/scripts/list.sh`. Loading a runbook does not run the quest.

Runbooks can declare the abilities their workflow needs in a top-level `abilities` frontmatter list:

```yaml
abilities:
  - enrich
  - code-review
```

The loader validates those names and includes each ability's content in its output after the runbook. Use one ability name per indented list item; each name must match a regular file in `skills/ability/abilities/`.

**How a ticket is created, fetched, and completed is tracker-specific.** The issue tracker should have been provided to you in `docs/agents/issue-tracker.md`. If it hasn't, stop and tell the user to run `/setup-adventure`. Read that doc before touching the tracker. Follow its **Quest operations** section for this repo's tracker procedures.

## Run a quest

Invoked with a ticket link (or number/path).

1. **Fetch the ticket**, per the tracker doc.
2. **Resolve its runbook.** Read the `quest:<name>` label. If the ticket has none, stop and report that. Otherwise, run `skills/quest/scripts/load.sh <name>` from the repo root. The script prints the runbook in a `<quest name="...">` element, followed by an `<ability name="...">` element for each declared ability. If the quest name is unknown, the loader reports it and lists the available quest names. If an ability declaration is malformed or refers to an unknown ability, the loader reports the error and exits non-zero. Stop on either error. Never improvise a runbook.
3. **Follow the runbook.** Work its steps in order and call whatever skills it names. A quest is one session's work, start to finish: if the runbook outgrows the session, stop and say so rather than carrying state forward.
4. **Record and hand back.** The quest is done only when the runbook's completion criterion is met. Record the outcome on the ticket as the tracker doc directs. Prepare the runbook's output, such as a PR, a document, or a decision. Then stop. **The human closes the ticket** once the output has landed. The agent may close it only after the human explicitly approves.

## Create a quest

Use this section when the user asks to file a quest, such as "create a decision quest to ...".

1. **Settle the type.** Use the type the user names. If no existing type fits, run `skills/quest/scripts/list.sh` from the repo root and ask whether to add one. It prints an `<quests>` element containing each type and its description. If the user wants a new type, ask them to run `/create-quest-type` first.
2. **Settle the objective.** The ticket's title and body state what this quest is for; agree them with the user before filing.
3. **File the ticket**, labelled `quest:<type>` (without the runbook's `-quest` suffix), per the tracker doc.
4. **Report the ticket link** so the user can run the quest.
