---
name: ability
description: Load an ability, which describes how to do something. Only call it when a user asks to load an ability.
---

An **ability** is a written capability: a procedure for doing one kind of thing, filed in this skill's `abilities/` folder as `abilities/<name>.md`.

**Loading and running are separate acts.** Loading brings an ability into context so the agent knows what it can do — it never performs it. An ability runs only when the user says so explicitly: "run the babysit-pr ability". Never run an ability because it was loaded, because it looks relevant, or because the task merely resembles it.

## Load an ability

Invoked with an ability name — "load the babysit-pr ability".

1. **Resolve it.** From the repo root, run `scripts/load.sh ability <name> [<name>...]`. The script prints one `<ability name="...">` element per name, in the order given. The element text is that file. The script escapes `&`, `<`, and `>`. If any name does not resolve, the script prints no elements, exits non-zero, names each miss, and lists the names that exist. Stop there and never improvise an ability.
2. **Report it.** Say what the ability does and what it needs in order to run. Then stop — offer to run it and wait for the explicit instruction.

Loading is not a commitment to run. Several abilities can be loaded in one call. None of them runs until asked.

## Run an ability

Only on an explicit run instruction — "run the babysit-pr ability", "run it".

1. **Be sure it's loaded.** If the ability is not already in context, run `scripts/load.sh ability <name>` from the repo root first.
2. **Follow it.** Work its steps in order, calling whatever skills, tools, or sub-agents it names.
3. **Finish it.** An ability is one session's work: if it outgrows the session, stop and say so rather than carrying state forward. Report what it produced and stop at its last step.

## List abilities

When asked what abilities exist, run `scripts/load.sh list ability` from the repo root. It prints the YAML frontmatter of every ability, one block per file, in filename order. It does not print the body.
