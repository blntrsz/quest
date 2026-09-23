# Issue tracker: Local Markdown

Quests for this repo live as markdown files under `.scratch/quests/`.

## Conventions

- One quest per file: `.scratch/quests/<slug>.md`
- A `Type:` line near the top records the quest type (the runbook name without `-quest`, e.g. `decision` for `decision-quest.md`)
- A `Status:` line records `open` / `done`
- Outcome and conversation history append to the bottom under a `## Comments` heading

## Quest operations

Used by `/quest`. A **quest** is one file with a `Type:` line naming its runbook type.

- **Create a quest**: write `.scratch/quests/<slug>.md` (creating the directory if needed) with `Type: <type>` and `Status: open` near the top. The heading states the objective; the body carries whatever the runbook will need.
- **Fetch a quest**: read the file at the referenced path.
- **List open quests**: scan `.scratch/quests/` for files with `Status: open`.
- **Record the outcome**: append it under `## Comments`.
- **Close**: the **human** flips `Status: done`, typically once the output has landed. The agent records the outcome and hands back; it does not mark a quest done.
