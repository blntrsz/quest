---
name: quest
description: Create and execute a Quest.
disable-model-invocation: true
---

A **Quest** is one objective, filed as a ticket on this repo's issue tracker. Its **quest type** selects a **runbook** — a procedure shipped in this skill's `quests/` folder — and executing the quest means following that runbook in order.

The ticket is the instance (this objective, this repo). The runbook is the method (how every quest of that type runs). One skill, two acts: **run** a quest from its ticket, or **create** one.

## Quest type and runbook

A runbook is `quests/<name>.md`, and `<name>` is the quest type: `quests/decision-quest.md` is type `decision-quest`. A ticket declares its type with the label `quest:<name>`.

Load one or more runbooks with `skills/quest/scripts/load.sh <name> [<name>...]` from the repo root. List them with `skills/quest/scripts/list.sh`. Loading a runbook does not run the quest.

**How a ticket is created, fetched, and completed is tracker-specific.** The issue tracker should have been provided to you in `docs/agents/issue-tracker.md`. If it hasn't, stop and tell the user to run `/setup-adventure`. Read that doc before touching the tracker; its **Quest operations** section is the authority on this repo's mechanics.

## Run a quest

Invoked with a ticket link (or number/path).

1. **Fetch the ticket**, per the tracker doc.
2. **Resolve its runbook.** Read the `quest:<name>` label. If the ticket carries no quest label, stop and say so. Otherwise run `skills/quest/scripts/load.sh <name>` from the repo root. The script prints one `<quest name="...">` element whose text is that runbook. If the script exits non-zero, it names the miss and lists the quest names that exist. Stop and say so. Never improvise a runbook.
3. **Follow the runbook.** Work its steps in order and call whatever skills it names. A quest is one session's work, start to finish: if the runbook outgrows the session, stop and say so rather than carrying state forward.
4. **Record and hand back.** The quest is done when the runbook's completion criterion is met — not before. Record the outcome on the ticket (the tracker doc says where) and prepare whatever the runbook produces — a PR, a doc, a decision. Then stop. **The human closes the ticket** once the output has landed, and the agent may close it too — but only after the human has explicitly approved closing it.

## Create a quest

Invoked to file a new quest — "create a decision quest to ...".

1. **Settle the type.** It comes from the user. If none fits, run `skills/quest/scripts/list.sh` from the repo root and ask. A missing type means a missing runbook, which the human writes. You file tickets, not runbooks.
2. **Settle the objective.** The ticket's title and body state what this quest is for; agree them with the user before filing.
3. **File the ticket**, labelled `quest:<type>`, per the tracker doc.
4. **Report the ticket link** so the user can run the quest.
