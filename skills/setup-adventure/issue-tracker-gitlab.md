# Issue tracker: GitLab

Quests for this repo live as GitLab issues. Use the [`glab`](https://gitlab.com/gitlab-org/cli) CLI for all operations.

## Conventions

- **Create an issue**: `glab issue create --title "..." --description "..."`. Use a heredoc for multi-line descriptions. Pass `--description -` to open an editor.
- **Read an issue**: `glab issue view <number> --comments`. Use `-F json` for machine-readable output.
- **List issues**: `glab issue list -F json` with appropriate `--label` filters.
- **Comment on an issue**: `glab issue note <number> --message "..."`. GitLab calls comments "notes".
- **Apply / remove labels**: `glab issue update <number> --label "..."` / `--unlabel "..."`. Multiple labels can be comma-separated or by repeating the flag.
- **Close**: `glab issue close <number>`. `glab issue close` does not accept a closing comment, so post the explanation first with `glab issue note <number> --message "..."`, then close.

Infer the repo from `git remote -v`; `glab` does this automatically when run inside a clone.

## Quest operations

Used by `/quest`. A **quest** is one issue labelled `quest:<type>`. The type is the runbook name without its `-quest` suffix; for example, `quests/task-quest.md` uses `quest:task`.

- **Create a quest**: `glab issue create --title "<objective>" --description "<context>" --label "quest:<type>"`. The title states the objective; the description carries whatever the runbook will need.
- **Fetch a quest**: `glab issue view <number> --comments`.
- **List open quests**: `glab issue list -F json`, then keep issues carrying a `quest:<type>` label (or filter by `--label "quest:<type>"`).
- **Record the outcome**: `glab issue note <number> --message "<outcome>"`.
- **Close**: the **human** closes quests, typically once the output has landed. The agent records the outcome and hands back; it does not run `glab issue close` on a quest.
