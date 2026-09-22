---
name: code-review
description: Review the changes since a fixed point on four axes — Standards (the repo's documented conventions), Spec (the originating issue), Correctness (bugs, regressions, and test gaps), and Design (structural quality and missed simplifications). Runs the axes as parallel sub-agents, reports them side by side, and changes nothing. Use to review a branch, a PR, work in progress, or "review since X".
---

# Code review

Review the diff between `HEAD` and a fixed point the user supplies, on four axes:

- **Standards.** Does the code follow this repo's documented conventions?
- **Spec.** Does it implement the originating issue or spec?
- **Correctness.** Are there bugs or regressions, and do the tests cover the behavior?
- **Design.** Is it structured to be maintained, or did it leave an obvious simplification on the table?

Run the four axes as parallel sub-agents, so each keeps its own context, then report them side by side. See *Why separate axes*.

## Operating principles

- **Report only.** The review finds; it does not fix. Apply the findings only when the user explicitly asks. Never push, open a PR, or file a ticket.
- **Review scope is not permission to mutate.** A PR number, URL, or branch name selects what to review. Never run `git checkout`, `git switch`, or `gh pr checkout`. Review uncommitted work from the checkout that holds it.
- **A finding earns its place by its consequence.** Report a defect or an improvement only when acting on it is worth the cost. An adequate change needs no findings. Judge the code against its intent and the repo's requirements, not against a rewrite you would prefer.
- **Evidence or it goes.** Every retained finding cites the file, line, and hunk. Drop what you cannot support.
- **Report the change, not the machinery.** The report is about the change and its findings. Leave the review's own bookkeeping and setup out of it.
- **State the coverage.** Say what was reviewed, and name any axis or part of the change that was not.

## 1. Pin the fixed point

Take the fixed point from the user: a commit, a branch, a tag, `main`, `HEAD~5`. When they named none, ask for one.

Capture the diff command once: `git diff <fixed-point>...HEAD`. The three dots compare against the merge base. Note the commits too: `git log <fixed-point>..HEAD --oneline`.

Confirm the fixed point resolves with `git rev-parse <fixed-point>`, and confirm the diff is non-empty. A bad ref or an empty diff fails here, not inside four parallel sub-agents.

## 2. Find the spec, and write the intent summary

Look for the originating spec, in this order:

1. Issue references in the commit messages (`#123`, `Closes #45`, GitLab `!67`), fetched through `docs/agents/issue-tracker.md` when the repo has one.
2. A path the user passed.
3. A spec file under `docs/`, `specs/`, or `.scratch/` whose name matches the branch or feature.
4. Ask the user where the spec is.

When the user says there is no spec, skip the Spec sub-agent and record "no spec available" in the report. When you need the tracker doc and it is missing, say so and ask the user for the spec directly.

Then write one short **intent summary** that every sub-agent receives: what the change is meant to do, the scope it covers, and the spec or plan it must satisfy. When there is no spec, the summary says so, and the Spec axis reports "no spec available".

## 3. Find the standards sources, and carry the two baselines

Find what the repo documents about writing code: `CODING_STANDARDS.md`, `CONTRIBUTING.md`, `docs/`, an ADR set, lint configs with prose.

Beyond the repo's own documents, every review carries two baselines. The **smell baseline** applies when a repo documents nothing, and a documented repo standard always overrides it. The **design bar** sets the strictness of the Design axis. Skip anything tooling already enforces. A formatter or a linter owns that.

### Smell baseline

A fixed set of Fowler smells (*Refactoring*, ch. 3). Each is a labelled heuristic, never a hard violation. Read *what it is* → *how to fix*, and match it against the diff:

- **Mysterious Name.** A function, variable, or type whose name does not reveal what it does or holds. → Rename it. When no honest name comes, the design is murky.
- **Duplicated Code.** The same logic shape appears in more than one hunk or file. → Extract the shared shape, and call it from both.
- **Feature Envy.** A method that reaches into another object's data more than its own. → Move the method onto the data it envies.
- **Data Clumps.** The same few fields or parameters keep travelling together. → Bundle them into one type, and pass that.
- **Primitive Obsession.** A primitive or string stands in for a domain concept that deserves its own type. → Give the concept its own small type.
- **Repeated Switches.** The same `switch` or `if` cascade on the same type recurs across the change. → Replace it with polymorphism, or with one map both sites share.
- **Shotgun Surgery.** One logical change forces scattered edits across many files. → Gather what changes together into one module.
- **Divergent Change.** One file is edited for several unrelated reasons. → Split it so each module changes for one reason.
- **Speculative Generality.** Abstraction, parameters, or hooks for needs the spec does not have. → Delete it, and inline back until a real need shows.
- **Message Chains.** Long `a.b().c().d()` navigation the caller should not depend on. → Hide the walk behind one method on the first object.
- **Middle Man.** A class or function that mostly delegates onward. → Cut it, and call the real target direct.
- **Refused Bequest.** A subclass or implementer that ignores or overrides most of what it inherits. → Drop the inheritance, and use composition.

### Design bar

The Design axis is deliberately harsh. Its job is not to tidy the diff but to find the restructuring that makes it simpler. Push for **code judo**: a move that keeps the behavior and deletes whole branches, helpers, modes, or layers. Prefer the version that feels inevitable in hindsight. A refactor that spreads the same complexity around has not earned its churn.

- **File size.** A file crossing 1000 lines because of this change is a smell. Decompose first. Waive it only for a compelling structural reason, and say why.
- **Spaghetti growth.** New ad-hoc conditionals, scattered special cases, one-off flags, or nullable modes bolted into unrelated flows are design problems, not style nits. Move the logic behind its own abstraction, helper, state model, or module.
- **Abstraction honesty.** A thin wrapper, identity abstraction, or pass-through helper that adds indirection without clarity should go. So should generic "magic" that hides a simple data shape.
- **Type and boundary honesty.** Unnecessary optionality, `any`, `unknown`, or cast-heavy code hides the real contract. Make the boundary explicit rather than falling back silently.
- **Canonical layer.** Feature logic belongs in its own module, not leaked into a shared path. Reuse the existing helper rather than a bespoke near-duplicate. Put logic in the package that owns the concept.
- **Orchestration.** Independent work serialized for no reason, or related updates that can leave state half-applied, is a design smell. Prefer parallel and atomic when that also makes the flow clearer.

**The bar to approve.** Approval needs correct behavior and clean structure. Treat each of these as a presumptive blocker unless the author justifies it:

- A visible code-judo move left on the table.
- A file pushed past 1000 lines.
- Ad-hoc branching that tangles an existing flow.
- Feature checks scattered across shared code.
- An unnecessary abstraction, wrapper, or cast-heavy contract.
- A duplicated canonical helper, or logic in the wrong layer.

The **codebase-design** skill owns the vocabulary of modules, interfaces, depth, seams, and leverage. Load it when a Design finding needs a sharper name.

## 4. Spawn the sub-agents

Spawn one sub-agent per axis, all at once, so no axis pollutes another's context. Give each the diff command, the commit list, and the intent summary. Read-only work only.

**Standards brief.** Give it the standards-source files you found, and paste the smell baseline in full (the sub-agent cannot see it otherwise). Then:

> Report, per file or hunk where relevant: (a) every place the diff violates a documented standard, citing the standard file and the rule; and (b) any baseline smell you spot, named, with the hunk quoted. Distinguish hard violations from judgement calls. A documented-standard breach can be hard. A baseline smell is always a judgement call, and a documented repo standard overrides the baseline. Skip anything tooling enforces. Under 400 words.

**Spec brief.** Give it the path or the fetched contents of the spec. Then:

> Report: (a) requirements the spec asked for that are missing or partial; (b) behavior in the diff that the spec did not ask for (scope creep); and (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Under 400 words.

**Correctness brief.**

> Report: (a) bugs and regressions in the diff, with the input, sequence, or state that triggers each; (b) behavior the change introduces that no test covers; and (c) tests that pass for the wrong reason, assert on implementation details, or would not fail if the behavior broke. Quote the hunk for each finding. Under 400 words.

**Design brief.** Paste the design bar in full. Then:

> Report the structural problems and the code-judo moves, worst first. For each, quote the hunk and name the remedy. Treat the presumptive blockers as blockers unless the author justifies them. Lead with structural regressions and missed simplifications. Keep the list short and high-conviction rather than flooding it with cosmetic notes. Under 400 words.

## 5. Verify and aggregate

Before you present, drop any finding the sub-agent did not support with a cited hunk.

Present the four reports under `## Standards`, `## Spec`, `## Correctness`, and `## Design`, verbatim or lightly cleaned. Keep the axes separate. Do not merge or rerank the findings.

Report the change and its findings, not the review's own bookkeeping.

End with one line: the findings per axis, the worst issue within each axis, and the coverage. Name what was reviewed and any axis or part of the change that was not. Rank within each axis only. A single winner across axes is exactly what the separation exists to prevent.

## Why separate axes

A change can pass one axis and fail another:

- Code that follows every convention but implements the wrong thing: Standards pass, Spec fail.
- Code that does exactly what the issue asked but breaks the project's conventions: Spec pass, Standards fail.
- Code that is correct and conventional but a tangled mess to maintain: Standards and Spec pass, Design fail.
- Code that meets the spec and follows every convention but crashes on an empty list: Standards and Spec pass, Correctness fail.

Reporting the axes separately stops one from masking another.

Sources: mattpocock/skills `skills/engineering/code-review/SKILL.md` (two-axis review and the smell baseline), the thermo-nuclear code-quality review, and EveryInc/compound-engineering-plugin `skills/ce-code-review/SKILL.md` (report-only, scope versus mutation, intent summary, evidence and coverage). Supplied 2026-09-22.
