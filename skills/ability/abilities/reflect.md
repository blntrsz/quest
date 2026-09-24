---
name: reflect
description: Read a finished piece of work, the current chat, a PR, a ticket, or a decision-quest chat, and turn it into what lasts: guards the next run obeys without being told, such as a format, lint, ast-grep, or architecture rule, plus the domain concepts and business rules for docs/concepts.md and any ADR the decisions earn. Proposes every guard and document, and waits for approval before creating it. Use after finishing work, for a retrospective, or when the user asks to reflect on a chat, a PR, a ticket, or a decision-quest.
---

Reflection reads a finished piece of work and writes down what it settled: guards that make repeat problems impossible, and the domain knowledge the next run inherits. It points backward at a chat, a PR, a ticket, or a decision-quest chat. It writes the rules and the docs, and it never rewrites the past work.

The first unit is the **guard**: a rule that fails before a human notices the problem. The second is the **concept**: a domain term and the business rules that constrain it. A guard earns its place when the problem can recur and a machine can catch it. A concept earns its place when the work settled it and a newcomer would misread it. A reflection ends with the guards and docs it created, or a plain report that none was warranted.

## Operating rules

- **Stay in the session.** The approval gate needs the user here, and the current chat is only visible here. Do not hand this to a background agent.
- **Propose, then wait.** Every guard and every document is a proposal the user approves before it exists. Present them, and wait for the answer. Create nothing the user did not approve.
- **Only settled knowledge.** Write a concept or a rule only when the work settled it. An open question goes back to the user, never into `docs/concepts.md`.
- **Prefer the guard that fails the build.** A linter that exits non-zero beats a document the next agent may not read.
- **Prove the guard fires.** Run each new guard against the code from the reflected work. A guard that does not fail on the original problem is not a guard yet.
- **The past work is read-only.** Do not fix the code you reflect on. Reflection fixes the rules and records the knowledge the work left behind.

## 1. Take the target

Ask what to reflect on when the user did not say. The target is one of four:

- **The current chat.** The conversation is already in context.
- **A PR.** Fetch it.
- **A ticket.** Fetch it.
- **A decision-quest chat.** The grilling conversation from the **decision-quest** quest. The ticket carries the agreed design and the chat carries the reasoning. Fetch both.

Resolve a PR, a ticket, or a quest through `docs/agents/issue-tracker.md` when the repo has one, or through the tracker's own tooling, such as `gh` or `glab`. Stop and say so when the target does not resolve.

## 2. Gather the work and its evidence

The target names the work. Its evidence is where the guards and the concepts come from. Pull every source the target reaches:

- **The change.** The diff, the commits, and the files they touch.
- **The intent.** The ticket body, the spec, or the plan, so a mistake stays distinct from a deliberate choice.
- **Human feedback.** PR review comments, ticket comments, and every place in the chat where the user corrected the agent or the work was redone.
- **Machine feedback.** Failed CI checks, test failures, and the fixes that followed.
- **Settled decisions.** From a decision-quest, the agreed design, the rejected alternatives, the assumptions, and the remaining risks that its final step recorded on the ticket.

For a chat, the evidence sits in the conversation and in the artifacts it produced. Search the tracker for the PR and the ticket the chat created, then pull their comments too. When the user points at a PR, look for the ticket behind it, and the reverse. When the user points at a decision-quest, follow it to its ticket and to the PR that implemented the design.

## 3. Name every preventable problem

Scan the gathered material and list the problems it exposes. A problem is preventable when the same shape can recur in another run and a machine can catch it.

For each candidate, record:

- What happened, with the evidence: quote the review comment, the CI failure, or the correction.
- Why it can recur.
- How often it already happened. One occurrence is a candidate. Two is a pattern.

Set aside a problem that cannot recur, and one no machine can catch. A bug is fixed by the work, and reflection guards the class the bug belongs to, such as "an unguarded timezone conversion", not the single instance.

Check what already exists. A rule the repo already has but the work ignored is not a missing guard. It is a guard that did not run: not wired into CI, not installed, or not loaded. Wire it instead of writing it again.

## 4. Pick the guard for each problem

Take the first mechanism that can express the rule, in this order:

1. **Formatter.** Layout, whitespace, import order, line length. The repo's formatter, such as Prettier, gofmt, or black.
2. **Linter.** A pattern the repo's linter can state, such as ESLint or Ruff, either an existing rule or a small custom one.
3. **ast-grep.** A code shape the linter cannot express, as a rule in `sgconfig.yml`.
4. **Architecture rule.** Import boundaries, layering, and dependency direction, through a tool such as dependency-cruiser, ArchUnit, or eslint-plugin-boundaries.
5. **Coding standard.** A judgment call no mechanical rule expresses, written under `docs/agents/coding-standards/`.

Prefer a mechanism the repo already runs. Adding a tool costs more than adding a rule to a tool already in CI. Read the existing configs and the standards directory first, and match their naming and structure.

## 5. Extract the domain knowledge

The work settled things about the domain, not only about the code. Read the material for concepts, rules, and decisions:

- **Concepts.** Terms the work used with a meaning a newcomer would misread: an entity, a state, a role, a status, an event. Record the term and its meaning in one line, in the words the work used.
- **Business rules.** Constraints the work stated or enforces, such as "an order cannot ship before payment" or "only the owner can cancel". Record the rule and where it came from.
- **Decisions.** From a decision-quest or any design discussion, the choices that were made. Offer an ADR for a choice only when it passes all three tests: hard to reverse, surprising without context, and the result of a real trade-off. Load the **domain-modeling** skill for its ADR format and its glossary rules.

Cross-check each concept and rule against the code. When the code contradicts a stated rule, surface it and ask, rather than writing the doc.

A rule the code can violate silently needs a guard as well as an entry: a test that locks the rule. Add it to the guard list from step 3, and pick its mechanism as in step 4. A rule nothing can check stays a doc entry alone.

## 6. Propose everything, and wait

Present the guards in one table:

| Problem | Evidence | Guard | Where it goes |
|---------|----------|-------|---------------|

Then the domain knowledge in another:

| Concept or decision | What the work settled | Proposal | Where it goes |
|---------------------|-----------------------|----------|---------------|

Under each table, give the exact form: the config diff, the ast-grep pattern, the doc's title and first line, or the ADR's decision. A reviewer who asks for the same rename twice becomes a naming rule in the linter. State which mechanism could not express a problem you set aside, and why.

Then wait. Take the user's yes or no on each guard and each document before you create anything.

## 7. Create the approved guards

For each approved guard:

1. Write the rule where its mechanism lives: the formatter or linter config, `sgconfig.yml`, the architecture config, or a file under `docs/agents/coding-standards/`.
2. Run it against the code from step 2. It must fail on the original problem. A rule that passes is wrong, or the problem needs a stronger mechanism. Fix it or report it.
3. Confirm the guard runs on a normal change: in CI, in a pre-commit hook, or in the check the next agent already runs. A rule nobody runs is not a guard.
4. For a coding standard, confirm `AGENTS.md` or the agents doc points at the file. A standard nothing reaches is not a guard either.

## 8. Write the approved concepts and ADRs

1. Write each approved concept and rule into `docs/concepts.md`. Give the term, its one-line meaning, and the rules under it. Keep implementation detail out, and match the file's shape when it already exists.
2. Give each entry its source: the PR, the ticket, or the decision-quest. A reader can trace why the term exists.
3. Write each approved ADR under `docs/adr/`, using the **domain-modeling** skill's format.
4. Confirm each term comes from the work and the code. A term you invented is not the project's language.

## 9. Report

Report what you created, what you rejected and why, and what was already in place. Name each guard, its mechanism, and its path. Name each concept, rule, and ADR. Name any problem or open question left for the user.

Done when every gathered source has been read, every preventable problem is either an approved guard that fires on the original code or a stated reason it stays unguarded, every settled concept and rule is in `docs/concepts.md` or is a named open question, and the user has seen the result.
