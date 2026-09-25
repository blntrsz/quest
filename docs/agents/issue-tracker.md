# Issue tracker: GitHub

This repo tracks quests and adventures as GitHub issues. Use the `gh` CLI for all operations.

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
- **Close**: the **human** closes quests, typically once the output has landed. The agent records the outcome and leaves the issue open for human closure.

## Adventure operations

Used by `/adventure`. An **adventure** is one issue labeled `adventure`. Its children are ordinary quest issues labeled `quest:<type>`.

- **Create an adventure**: `gh issue create --title "<problem or outcome>" --body "<high-level brief>" --label "adventure"`.
- **Fetch an adventure or quest**: `gh issue view <number> --comments`.
- **Get a quest's parent**: `gh api "repos/{owner}/{repo}/issues/$QUEST_NUMBER/parent"`.
- **List child quests**: `gh api "repos/{owner}/{repo}/issues/$ADVENTURE_NUMBER/sub_issues" --paginate`. The response includes each child's issue number, ID, title, labels, and open/closed state. Preserve the response order as roadmap priority; use the priority operation below to change it.
- **Link a quest to an adventure**: get the child's numeric issue ID with `gh api "repos/{owner}/{repo}/issues/$QUEST_NUMBER" --jq .id`, then run `gh api "repos/{owner}/{repo}/issues/$ADVENTURE_NUMBER/sub_issues" -F sub_issue_id="$CHILD_ID"`. GitHub requires the child issue to belong to the same repository owner as the adventure.
- **Set child priority**: to place a child after another child, run `gh api "repos/{owner}/{repo}/issues/$ADVENTURE_NUMBER/sub_issues/priority" -X PATCH -F sub_issue_id="$CHILD_ID" -F after_id="$PREVIOUS_CHILD_ID"`. To place it first, use `-F before_id="$FIRST_CHILD_ID"` instead of `after_id`.
- **List blockers for a quest**: `gh api "repos/{owner}/{repo}/issues/$QUEST_NUMBER/dependencies/blocked_by" --paginate`.
- **Add a blocker**: get the blocking issue's numeric ID with `gh api "repos/{owner}/{repo}/issues/$BLOCKING_NUMBER" --jq .id`, then run `gh api "repos/{owner}/{repo}/issues/$QUEST_NUMBER/dependencies/blocked_by" -F issue_id="$BLOCKER_ID"`.
- **Claim a quest**: add the `adventure:claimed` label with `gh issue edit "$QUEST_NUMBER" --add-label "adventure:claimed"`. Remove it at handoff with `gh issue edit "$QUEST_NUMBER" --remove-label "adventure:claimed"`.
- **Record a handoff or replan**: comment on the adventure with `gh issue comment "$ADVENTURE_NUMBER" --body "$UPDATE"`. Begin each child handoff comment with `Adventure handoff: <quest link>`.
- **Verify handoff author**: compare the comment author's login with `gh api user --jq .login`. If the author cannot be verified, ask the user before treating the marker as a handoff.
- **Close**: the **human** closes adventures and quests. The agent records outcomes and leaves both issues open for human closure.

The repository needs the `adventure` and `adventure:claimed` labels. If either is missing, create it with `gh label create "$LABEL_NAME" --color "$SIX_DIGIT_HEX" --description "$DESCRIPTION"` before using it. GitHub's `gh issue` commands do not expose sub-issue or dependency operations; use `gh api` as shown above.
