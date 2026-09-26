# quest

Reusable agent skills for creating and running quests and adventures.

## Install the skills

Use the [skills CLI](https://www.skills.sh/) from the project where you want to use the skills. Preview this repository's available skills with:

```sh
npx skills add blntrsz/quest --list
```

To install all Quest skills for OpenCode in the current project:

```sh
npx skills add blntrsz/quest --skill '*' --agent opencode
```

The CLI installs the skills into the current project by default. Add `--global` to install them for your user instead:

```sh
npx skills add blntrsz/quest --skill '*' --agent opencode --global
```

To install every skill for all supported agents without prompting, use `--all`:

```sh
npx skills add blntrsz/quest --all
```

You can install selected skills by repeating `--skill`, for example:

```sh
npx skills add blntrsz/quest --skill quest --skill adventure --agent opencode
```

Start a new agent session after installation. To update installed skills later, run `npx skills update`.

## Skills in this repository

- `quest` — create and execute a quest.
- `adventure` — create an adventure issue, coordinate linked quests, and run a ready quest.
- `setup-adventure` — configure the issue tracker for quests and adventures.
- `ability` — load or run an ability.
- `create-ability` — create or revise an ability.
- `create-quest-type` — add a quest type to this repository.
