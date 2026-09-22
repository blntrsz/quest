---
name: reflect
description: Read a finished piece of work, the current chat, a PR, or a ticket, and turn each problem it exposed into a guard the next run obeys without being told: a format, lint, ast-grep, or architecture rule, or a standard under docs/agents/coding-standards. Proposes every guard and waits for approval before creating it. Use after finishing work, for a retrospective, or when the user asks to reflect on a chat, a PR, or a ticket.
---

# Reflect

Reflection reads a finished piece of work and makes the problems it exposed impossible in the next run. It points backward at a chat, a PR, or a ticket. It ends forward with rules that catch those problems automatically. It writes the rules and never rewrites the past work.

The unit is the **guard**: a rule that fails before a human has to notice the problem. A guard earns its place when the problem can recur and a machine can catch it. A reflection ends with the guards it created, or a plain report that none was warranted.

## Operating rules

- **Stay in the session.** The approval gate needs the user here, and the current chat is only visible here. Do not hand this to a background agent.
- **Propose, then wait.** Every guard is a proposal the user approves before it exists. Present each one, and wait for the answer. Never add a rule the user did not approve.
- **Prefer the guard that fails the build.** A linter that exits non-zero beats a document the next agent may not read.
- **Prove the guard fires.** Run each new guard against the code from the reflected work. A guard that does not fail on the original problem is not a guard yet.
- **The past work is read-only.** Do not fix the code you reflect on. Reflection fixes the rules that let the problem through.

## 1. Take the target

Ask what to reflect on when the user did not say. The target is one of three:

- **The current chat.** The conversation is already in context.
- **A PR.** Fetch it.
- **A ticket.** Fetch it.

Resolve a PR or a ticket through `docs/agents/issue-tracker.md` when the repo has one, or through the tracker's own tooling, such as `gh` or `glab`. Stop and say so when the target does not resolve.

## 2. Gather the work and its feedback

The target names the work. Its feedback is where preventable problems show up. Pull every source the target reaches:

- **The change.** The diff, the commits, and the files they touch.
- **The intent.** The ticket body, the spec, or the plan, so a mistake stays distinct from a deliberate choice.
- **Human feedback.** PR review comments, ticket comments, and every place in the chat where the user corrected the agent or the work was redone.
- **Machine feedback.** Failed CI checks, test failures, and the fixes that followed.

For a chat, the feedback sits in the conversation and in the artifacts it produced. Search the tracker for the PR and the ticket the chat created, then pull their comments too. When the user points at a PR, look for the ticket behind it, and the reverse.

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

## 5. Propose the guards, and wait

Present one row per guard:

| Problem | Evidence | Guard | Where it goes |
|---------|----------|-------|---------------|

Under the table, give the exact rule for each guard: the config diff, the ast-grep pattern, or the doc's title and first line. A reviewer who asks for the same rename twice becomes a naming rule in the linter. State which mechanism could not express a problem you set aside, and why.

Then wait. Take the user's yes or no on each guard before you create anything.

## 6. Create the approved guards

For each approved guard:

1. Write the rule where its mechanism lives: the formatter or linter config, `sgconfig.yml`, the architecture config, or a file under `docs/agents/coding-standards/`.
2. Run it against the code from step 2. It must fail on the original problem. A rule that passes is wrong, or the problem needs a stronger mechanism. Fix it or report it.
3. Confirm the guard runs on a normal change: in CI, in a pre-commit hook, or in the check the next agent already runs. A rule nobody runs is not a guard.
4. For a coding standard, confirm `AGENTS.md` or the agents doc points at the file. A standard nothing reaches is not a guard either.

## 7. Report

Report what you created, what you rejected and why, and what was already in place. Name each guard, its mechanism, and its path. Name any problem left unguarded.

Done when every gathered source has been read, every preventable problem is either an approved guard that fires on the original code or a stated reason it stays unguarded, and the user has seen the result.
