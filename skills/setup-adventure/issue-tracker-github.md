# Issue tracker: GitHub

Quests for this repo live as GitHub issues. Use the `gh` CLI for all operations.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --comments`.
- **List issues**: `gh issue list --state open --json number,title,body,labels --jq '[.[] | {number, title, body, labels: [.labels[].name]}]'` with appropriate `--label` and `--state` filters.
- **Comment on an issue**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

Infer the repo from `git remote -v`; `gh` does this automatically when run inside a clone.

## Quest operations

Used by `/quest`. A **quest** is one issue labelled `quest:<type>`. The type is the runbook name without its `-quest` suffix; for example, `quests/task-quest.md` uses `quest:task`.

- **Create a quest**: `gh issue create --title "<objective>" --body "<context>" --label "quest:<type>"`. The title states the objective; the body carries whatever the runbook will need.
- **Fetch a quest**: `gh issue view <number> --comments`.
- **List open quests**: `gh issue list --state open --json number,title,labels --jq '[.[] | select(any(.labels[]; .name | startswith("quest:")))]'`, or filter by an exact type with `--label "quest:<type>"`.
- **Record the outcome**: `gh issue comment <number> --body "<outcome>"`.
- **Close**: the **human** closes quests, typically once the output has landed. The agent records the outcome and hands back; it does not run `gh issue close` on a quest.
