# Issue tracker: GitLab

This repo tracks quests and adventures as GitLab issues. Use the [`glab`](https://gitlab.com/gitlab-org/cli) CLI for all operations.

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
- **Close**: the **human** closes quests, typically once the output has landed. The agent records the outcome and leaves the issue open for human closure.

## Adventure operations

Used by `/adventure`. An adventure is a GitLab issue with the `adventure` label. Its children remain quest issues with `quest:<type>` labels.

- **Create an adventure**: `glab issue create --title "<problem or outcome>" --description "<high-level brief>" --label "adventure"`.
- **Fetch an adventure or quest**: `glab issue view "$IID" --comments`. Use `-F json` when structured issue state is needed.
- **List related issues**: `glab api "projects/:id/issues/$ADVENTURE_IID/links"`. Keep linked quests with a `quest:<type>` label whose description names the adventure URL. The numbered child list in the adventure description is the priority order; update it when priorities change.
- **Link a quest to an adventure**: add `Adventure: <adventure URL>` to the quest description and create a GitLab issue link of type `relates_to`, for example: `glab api --method POST "projects/:id/issues/$ADVENTURE_IID/links" -F target_project_id="$PROJECT_ID" -F target_issue_iid="$CHILD_IID" -F link_type=relates_to`. This avoids requiring a GitLab plan that provides epic-style parentage.
- **Order child quests**: keep a numbered child list in the adventure description and update it when priority changes.
- **Record dependencies**: use a GitLab issue link of type `blocks` from the blocking issue to the blocked quest. The Issue links API is available through `glab api`; for example: `glab api --method POST "projects/:id/issues/$BLOCKING_IID/links" -F target_project_id="$PROJECT_ID" -F target_issue_iid="$BLOCKED_IID" -F link_type=blocks`. If the configured GitLab instance does not support this operation, record `Blocked by: <quest URL>` in the blocked quest description.
- **Claim a quest**: add the `adventure:claimed` label with `glab issue update "$IID" --label "adventure:claimed"`. Remove it at handoff with `glab issue update "$IID" --unlabel "adventure:claimed"`.
- **Record a handoff or replan**: add a note to the adventure with `glab issue note "$ADVENTURE_IID" --message "$UPDATE"`. Begin each child handoff note with `Adventure handoff: <quest URL>`.
- **Verify handoff author**: compare the note author's username with `glab api user --jq .username`. If the author cannot be verified, ask the user before treating the marker as a handoff.
- **Close**: the **human** closes adventures and quests. The agent records outcomes and leaves both issues open for human closure.

Create the `adventure` and `adventure:claimed` project labels if they are missing. Use `glab api --method POST "projects/:id/labels" -F name="$LABEL_NAME" -F color="$HEX_COLOR" -F description="$DESCRIPTION"`. GitLab issue links use `relates_to`, `blocks`, or `is_blocked_by`; they do not by themselves distinguish parentage, so keep the `Adventure:` field in each child description.
