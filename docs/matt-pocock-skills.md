# Matt Pocock's skills framework
Source: [research quest #15](raw/quest-15-matt-pocock-skills.md).

**Source snapshot:** [`mattpocock/skills` commit `c55ee46073ed923f86ce59a5eb3b6d895095d1b7`](https://github.com/mattpocock/skills/tree/c55ee46073ed923f86ce59a5eb3b6d895095d1b7), fetched 2026-09-23. The repository is MIT-licensed and describes itself as a collection of agent skills for engineering work.

## Summary

The repository is a library of agent-readable Markdown procedures. It is not an execution engine. Each skill tells an agent how to do a bounded job. Host metadata decides whether an agent can discover a skill on its own, and distribution manifests decide which skills get installed.

The procedures combine into a repeatable process. That process can clarify intent, record shared terms and decisions, split work into vertical slices, implement test-first, and review against standards and the original spec.

The user chooses which process steps run. The agent still interprets prose, so the framework's limits come from the host system and the model.

## How a skill works

A skill is a directory whose main file is `SKILL.md`. The file begins with YAML front matter. It defines a `name`, a `description`, and, for skills intended only for human invocation, `disable-model-invocation: true`. The body is a procedure or reference document. A skill can include supporting Markdown files, scripts, and an `agents/openai.yaml` file containing display metadata and Codex policy.

The repository has 38 skill directories. All 38 contain both `SKILL.md` and `agents/openai.yaml` in this snapshot. [`tdd`](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/tdd/SKILL.md) is a reference skill with companion documents for tests and mocking. [`setup-matt-pocock-skills`](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/setup-matt-pocock-skills/SKILL.md) writes per-repository configuration.

The central design choice is how users invoke skills:

- **Model-invoked skills.** These omit `disable-model-invocation`. Their descriptions tell the model when to use them, so either the model or a user can reach them. Examples include `tdd`, `grilling`, `research`, and `code-review`.
- **User-invoked skills.** These set `disable-model-invocation: true` and set `policy.allow_implicit_invocation: false` in `agents/openai.yaml`. The user must type the skill name. These skills handle orchestration and decisions, including `grill-with-docs`, `to-spec`, `to-tickets`, and `implement`.

The repository's `SKILL-MECHANICS.md` describes the tradeoff. Model invocation improves discoverability and reuse across skills, but it keeps each description in permanent context. User invocation avoids that context cost but requires the user to remember the skill. `ask-matt` is a user-invoked router that maps user-reachable skills and their relationships. A user-invoked skill can call model-invoked reference skills, but it cannot call another user-invoked skill. [Invocation mechanics](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/productivity/writing-for-agents/SKILL-MECHANICS.md#L5-L22) and [the invocation rules](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/.agents/invocation.md#L1-L31) describe this split.

Skills define composition in their text. `grill-with-docs` tells the host to call both `grilling` and `domain-modeling`. `tdd` calls `codebase-design` when the test seam needs design. `code-review` runs its Standards and Spec checks in parallel sub-agents and keeps the reports separate. The dependencies appear in instructions rather than executable code. See [`grill-with-docs`](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/grill-with-docs/SKILL.md#L1-L7), [`tdd`](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/tdd/SKILL.md#L18-L38), and [`code-review`](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/code-review/SKILL.md#L6-L11).

## Repository structure and discovery

The `skills/` tree has five buckets:

- `engineering/` holds daily code-work skills.
- `productivity/` holds general workflow skills.
- `in-progress/` holds public beta skills that the plugin and main catalog exclude.
- `misc/` holds retained but unpromoted skills.
- `deprecated/` holds retired material.

The two promoted buckets contain 25 skills in this snapshot. `.claude-plugin/plugin.json` lists those 25 directories explicitly, so the Claude Code plugin ships a curated set rather than every directory under `skills/`. Each promoted skill has a human-facing page under `docs/<bucket>/`. Those pages explain when to use the skill and where it fits, while `SKILL.md` remains the agent-facing procedure. [Bucket rules](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/CLAUDE.md#L1-L23) and [the plugin manifest](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/.claude-plugin/plugin.json#L21-L47) show which directories the plugin includes.

There are two documented installation models:

1. The Claude Code plugin installs the promoted set as a managed, read-only bundle.
2. `npx skills@latest add mattpocock/skills` installs selected skill files into a project so the user owns and edits them.

Users choose one route because installing both creates duplicate skills.

The local maintainer script is separate from both user installation methods. It creates symlinks in `~/.claude/skills` and `~/.agents/skills` for every skill outside `misc` and `deprecated`, including `in-progress` skills. It supports local development. The documentation marks it as development-only. [Installation](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/README.md#L25-L82) and [local linking](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/scripts/link-skills.sh#L4-L31) document these methods.

The repository has no skill runtime. Its [`package.json`](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/package.json#L1-L20) contains changeset and versioning commands plus one plugin-version check. The skills themselves are Markdown. The host's plugin or skills installer must discover and load those files. A host that supports this format can load them without repository-specific runtime code. The repository cannot control how another host interprets every instruction.

## Intended workflow

The top-level `ask-matt` skill is the router. Its main process turns an idea into an implementation:

1. **Clarify the idea.** Run `grill-with-docs` in a working repository. It conducts a round-based interview, updates the project's `CONTEXT.md` glossary, and records hard-to-reverse decisions as ADRs. Without a working directory, use the stateless `grill-me` route.
2. **Answer questions that need an artifact.** When the design needs a runnable state model or visible UI, send work to a temporary `prototype`. Return its result to the main conversation.
3. **Choose the session size.** For a multi-session effort, `to-spec` turns the conversation into a spec, and `to-tickets` breaks it into end-to-end tickets with blocking dependencies. For a small effort, invoke `implement` directly.
4. **Implement with feedback.** `implement` applies TDD when the repository supports it. `tdd` requires a failing test before implementation, one vertical slice per cycle, and tests at agreed public seams, with private internals excluded.
5. **Review the result.** `code-review` checks the diff against repository standards and the originating spec in parallel sub-agents, then aggregates the reports.
6. **Commit.** The implementation skill ends by asking the agent to commit the work.

The framework also has separate entry points named `triage` for raw incoming issues and `diagnosing-bugs` for hard bugs. `wayfinder` handles efforts too large or unclear for one session. It creates a map issue and decision tickets, resolves one decision at a time, and returns the clarified result to the spec-and-implementation process. It is a planning tool; implementation happens later. [The router](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/ask-matt/SKILL.md#L13-L46), [`setup-matt-pocock-skills`](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/setup-matt-pocock-skills/SKILL.md#L7-L16), and [the wayfinder flow](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/wayfinder/SKILL.md#L103-L128) describe this process.

Before engineering skills run, `setup-matt-pocock-skills` configures the repository. It asks which issue tracker to use, records triage-label mappings, and establishes where `CONTEXT.md` and ADRs live. It supports GitHub, GitLab, local Markdown files, and a free-form description for another tracker. [Setup procedure](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/setup-matt-pocock-skills/SKILL.md#L17-L112).

## What is distinctive

### Small procedures instead of a large process owner

The README calls the skills small, adaptable, and composable. Each skill has a narrow job, and `ask-matt` describes how they connect without putting the entire process into one executable program. A user can run one skill, combine several skills, or edit the Markdown. The Markdown shows the framework's assumptions. [Repository rationale](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/README.md#L15-L19) and [router](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/ask-matt/SKILL.md#L11-L30).

### Process control is split between the human and the model

The repository treats the choice between user and model invocation as a central design choice. The user starts orchestration skills such as grilling, ticket creation, and implementation. The model can reach reusable disciplines such as TDD, domain modeling, research, and writing-for-agents when their descriptions match the task. Users do not need to make every skill discoverable at all times. Shared reference skills remain available automatically. The mechanics document describes this as a trade between human cognitive load and agent context load. [Skill mechanics](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/productivity/writing-for-agents/SKILL-MECHANICS.md#L7-L18).

### It treats project language as an engineering dependency

`grill-with-docs` does more than ask questions. It updates a glossary in `CONTEXT.md` and records selected decisions in ADRs. Other skills must read that material and use its terms. This reduces repeated explanation and keeps names consistent across issues, tests, and code. The files persist per repository and affect later tasks. [Domain modeling](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/domain-modeling/SKILL.md#L40-L64) and [the README's shared-language rationale](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/README.md#L105-L140).

### It encodes feedback and design checks around code generation

The repository puts alignment, testing, and design checks around code generation. TDD defines the red-green loop and public seams. `to-spec` asks users to make testing decisions and set module boundaries before publishing a spec. `to-tickets` prefers complete vertical slices and requires the user to approve granularity and blocking edges. `code-review` keeps standards and spec correctness as separate checks. Together, these instructions control how an agent works during code production. [TDD](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/tdd/SKILL.md#L12-L38), [to-spec](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/to-spec/SKILL.md#L11-L75), and [to-tickets](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/skills/engineering/to-tickets/SKILL.md#L25-L67).

### Packaging is part of the design

The repository maintains a curated stable set and a visible beta set. It offers editable and managed distribution choices. The Claude plugin manifest names the stable directories. The ADR explains why a native Codex plugin is deferred. The Codex manifest accepts one skills path rather than an array. Pointing it at the whole tree would include unpromoted buckets, while a symlink-based curated directory would not survive installation.

The repository uses broad editable distribution through `skills.sh` and a curated Claude plugin. It does not require both hosts to use one package format. [Packaging ADR](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/.agents/adr/0002-ship-as-a-claude-code-plugin.md#L3-L23).

## Tradeoffs and limitations

- **The model and host determine behavior.** There is no runtime that validates or executes a skill's prose. A compatible installer must discover `SKILL.md`, and the model must follow the procedure. The source package contains only Markdown, small maintenance scripts, and release tooling. Hosts can load these files without a repository-specific runtime, but behavior is less deterministic than that of a program with tests.
- **Invocation trades discovery for context.** Model-invoked descriptions improve automatic discovery but consume always-loaded context. User-invoked skills save that context but require the user to remember them. The router reduces that memory cost, but it is another document that must stay in sync.
- **The workflow expects human decisions.** Setup asks the user to choose a tracker, label vocabulary, and document layout. Grilling waits for answers. `to-spec` asks the user to confirm test seams, and `to-tickets` asks the user to approve the breakdown. This gives the user control but prevents unattended automation.
- **The installation routes differ.** The Claude route is managed and read-only, while the `skills.sh` route is editable and selective. Installing both routes installs the same skills twice. The repository does not document a native Codex plugin, so Codex users depend on the external installer.
- **Maintainers curate the stable plugin manually.** Adding a promoted skill requires maintainers to keep the skill file, bucket README, top-level README, docs page, and plugin manifest aligned. This keeps the plugin contents curated but creates maintenance work and lets files fall out of sync. The repository includes a version check for `package.json` and `plugin.json`, but the broader cross-file consistency rules are written as conventions rather than enforced by one comprehensive validator. [Maintenance rules](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/CLAUDE.md#L9-L23) and [version check](https://github.com/mattpocock/skills/blob/c55ee46073ed923f86ce59a5eb3b6d895095d1b7/scripts/sync-plugin-version.mjs#L1-L4).

## Assessment

The individual practices are not new. TDD, code review, domain language, and issue tracking all predate this repository. The contribution is to package those practices as small, composable, agent-readable procedures and make invocation, per-repository state, human checkpoints, and distribution boundaries explicit.

The repository gives teams a small set of procedures for agent-assisted engineering. It works best when a team wants repeatable habits while retaining control over the process. It provides less help for deterministic automation, unattended execution, or one installation model across all agent hosts.
