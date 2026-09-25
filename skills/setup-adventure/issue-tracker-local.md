# Issue tracker: Local Markdown

Store quest files under `.scratch/quests/` and adventure files under `.scratch/adventures/`.

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
- **Close**: the **human** flips `Status: done`, typically once the output has landed. The agent records the outcome and leaves the file open for human closure.

## Adventure operations

Used by `/adventure`. Store adventure files under `.scratch/adventures/` and keep quests under `.scratch/quests/`.

- **Create an adventure**: write `.scratch/adventures/<slug>.md` with `Kind: adventure` and `Status: open` near the top. Put the agreed high-level problem, outcome, constraints, and direction in the heading and body.
- **Fetch an adventure or quest**: read the referenced file.
- **Link a quest to an adventure**: add an `Adventure: .scratch/adventures/<slug>.md` line to the quest file. This line identifies the parent adventure. Find an adventure's children by scanning quest files for that exact path.
- **Set priority**: add an `Adventure priority: <number>` line to the quest file. Lower numbers run first when multiple quests are ready.
- **Record dependencies**: add one `Blocked by: .scratch/quests/<slug>.md` line per blocking quest. A blocker is satisfied only when its quest file has `Status: done`.
- **Claim a quest**: add `Adventure claim: in progress` to the quest file before running it, then remove the line at handoff. If a claim remains after an interrupted run, ask the human before clearing it.
- **Record a handoff or replan**: append it under the adventure file's `## Comments` heading. Begin each child handoff with `Adventure handoff: .scratch/quests/<slug>.md` so later runs can identify the quest.
- **Verify handoff author**: local files do not record authenticated comment authors. Ask the user to confirm a stored handoff marker before using it to skip an open quest.
- **Close**: the **human** changes an adventure or quest's `Status` to `done`. The agent records the outcome and leaves the file open for human closure.
