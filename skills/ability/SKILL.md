---
name: ability
description: Load or run an ability when a user asks to load, run, or use one to accomplish a task.
---

An **ability** is a written capability: a procedure for doing one kind of thing, filed in this skill's `abilities/` folder as `abilities/<name>.md`.

## Ability conventions

Use a lowercase kebab-case filename and the same value for the YAML `name`. Include a single-line YAML `description`. Choose headings and steps to fit the ability's procedure.

Use `skills/create-ability/SKILL.md` for the authoring workflow. `TEMPLATE.md` provides an adaptable ability-file template with frontmatter and Markdown body, and `abilities/create-ability.md` explains how to shape the body. Keep repository-wide conventions here and task-specific instructions in each ability.

**Loading and running are separate acts, but the user's wording does not have to use the word "run".** Read the whole request, not just the word "load" or the ability name. If the user only asks to load or explain an ability, load it and stop. If the user also asks for work that clearly requires following that ability or producing its stated output, run it as part of the request. Do not ask whether to run it when that intent is clear.

Do not run an ability just because it looks relevant or the task resembles it. A mention of an ability is not enough on its own; the requested task must clearly call for its procedure or output.

For example, "load the writing ability" is load-only. "Load create-verification and update the story quest to use the verification skill it creates" asks for the ability's output and the follow-up edit, so run the ability and continue with the edit.

## Load an ability

Invoked with an ability name — "load the babysit-pr ability".

1. **Resolve it.** From the repo root, run `skills/ability/scripts/load.sh <name> [<name>...]`. The script prints one `<ability name="...">` element per name, in the order given. The element text is that file. The script escapes `&`, `<`, and `>`. If any name does not resolve, the script prints no elements, exits non-zero, names each miss, and lists the names that exist. Stop there and never improvise an ability.
2. **Follow the user's intent.** If the user only asked to load the ability, say what it does and what it needs in order to run, then stop. You may offer to run it. If the user also asked for a task that clearly requires the ability, continue with **Run an ability**; do not stop to ask whether to run it.

Loading alone is not a commitment to run. Several abilities can be loaded in one call. Run an ability only when the user's full request explicitly asks for its procedure or clearly asks for work that depends on that procedure or its output.

## Run an ability

Run on an explicit instruction — "run the babysit-pr ability", "run it" — or when the user's full request clearly asks for work that depends on the ability's procedure or output. The user does not need to say "run" or "execute". Do not infer intent from relevance alone. If intent is genuinely unclear, ask a focused question; otherwise proceed without confirmation.

1. **Be sure it's loaded.** If the ability is not already in context, run `skills/ability/scripts/load.sh <name>` from the repo root first.
2. **Follow it.** Work its steps in order, calling whatever skills, tools, or sub-agents it names.
3. **Finish it.** An ability is one session's work: if it outgrows the session, stop and say so rather than carrying state forward. Report what it produced and stop at its last step.

## List abilities

When asked what abilities exist, run `skills/ability/scripts/list.sh` from the repo root. It prints an `<abilities>` element containing each ability's filename and description in filename order. It does not print the body.
