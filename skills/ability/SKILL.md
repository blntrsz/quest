---
name: ability
description: Load an ability, which describes how to do something. Only call it when a user asks to load an ability.
---

An **ability** is a written capability: a procedure for doing one kind of thing, filed in this skill's `abilities/` folder as `abilities/<name>.md`.

**Loading and running are separate acts.** Loading brings an ability into context so the agent knows what it can do — it never performs it. An ability runs only when the user says so explicitly: "run the babysit-pr ability". Never run an ability because it was loaded, because it looks relevant, or because the task merely resembles it.

## Load an ability

Invoked with an ability name — "load the babysit-pr ability".

1. **Resolve it.** Read `abilities/<name>.md`. If no file matches, stop and list the abilities that do exist; never improvise one.
2. **Report it.** Say what the ability does and what it needs in order to run. Then stop — offer to run it and wait for the explicit instruction.

Loading is not a commitment to run. Several abilities can be loaded at once; none of them executes until asked.

## Run an ability

Only on an explicit run instruction — "run the babysit-pr ability", "run it".

1. **Be sure it's loaded.** If the ability is not already in context, read `abilities/<name>.md` first.
2. **Follow it.** Work its steps in order, calling whatever skills, tools, or sub-agents it names.
3. **Finish it.** An ability is one session's work: if it outgrows the session, stop and say so rather than carrying state forward. Report what it produced and stop at its last step.

## List abilities

When asked what abilities exist, or when a name doesn't resolve, list `abilities/*.md` with each one's description.
