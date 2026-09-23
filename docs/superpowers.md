# Superpowers: how it works and what makes it distinctive

> Reference: [Research quest #12](raw/quest-12-superpowers.md)

**Scope.** I based this report on the Superpowers repository at version `v6.4.1`, commit [`5bf4e780`](https://github.com/obra/superpowers/tree/5bf4e78011075bcfc0dc295f0724994cd123ee71). I inspected it on 2026-09-23. The repository is the primary source for the architecture and workflow below.

## Short answer

Superpowers is a workflow layer for coding agents. It combines a shared library of Markdown skills with a small integration for each supported coding-agent harness. The skills describe actions such as "read a file" and "dispatch a subagent" without naming a vendor tool. The integration injects the `using-superpowers` bootstrap at session start, registers or exposes the skills, and maps those actions to the host's real tools. This split lets the same process documents run across Claude Code, Codex, Gemini, OpenCode, Pi, and other harnesses. [`docs/porting-to-a-new-harness.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/porting-to-a-new-harness.md#L31-L55)

The repository defines a development procedure rather than a prompt library. The bootstrap tells the agent to check for a relevant skill before any action. The skills then impose gates, tests, reviews, and evidence requirements on the development process. [`skills/using-superpowers/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/using-superpowers/SKILL.md#L10-L24)

## Core architecture

### 1. Shared skills define the workflow

Each skill lives in `skills/<name>/SKILL.md`. Its YAML frontmatter supplies a name and a trigger description. Its body contains the process. The porting guide says that the project shares this directory verbatim across harnesses and that skills must name actions, not tools. A skill therefore says "invoke a skill", "read a file", or "dispatch a subagent". The harness adapter supplies the translation. [`docs/porting-to-a-new-harness.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/porting-to-a-new-harness.md#L31-L63)

The repository has fifteen top-level skills covering startup, design, planning, worktrees, implementation, testing, debugging, review, delivery, parallel delegation, skill authoring, and session diagnosis. The README groups them as testing, debugging, collaboration, and meta skills. [`README.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/README.md#L339-L364)

### 2. The bootstrap activates the skills

The bootstrap activates the skills for each session. The porting guide says that, at every session start, the harness injects the full `using-superpowers` skill, wraps it in `<EXTREMELY_IMPORTANT>` tags, and appends the host's tool mapping. Without that injection, the skill files can sit on disk without the harness invoking them. [`docs/porting-to-a-new-harness.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/porting-to-a-new-harness.md#L49-L55)

Claude Code uses a `SessionStart` hook for `startup`, `clear`, and `compact`. The shell script reads `skills/using-superpowers/SKILL.md`, escapes it for JSON, and emits the platform-specific context field. It emits Claude's nested `hookSpecificOutput`, Cursor's `additional_context`, or the SDK-style `additionalContext` for other hosts. [`hooks/hooks.json`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/hooks/hooks.json#L1-L17) [`hooks/session-start`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/hooks/session-start#L1-L50)

OpenCode uses an in-process adapter. In V1, the named `SuperpowersPlugin` export adds the skills directory through the `config` hook and injects the bootstrap with `experimental.chat.messages.transform`. In V2, `setup()` registers each `SKILL.md` with `ctx.skill.transform()` and registers a `context` hook for bootstrap injection. The module exports both paths and has no external runtime dependency. [`.opencode/plugins/superpowers.js`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/.opencode/plugins/superpowers.js#L1-L16) [`.opencode/plugins/superpowers.js`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/.opencode/plugins/superpowers.js#L219-L265) [`.opencode/plugins/superpowers.js`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/.opencode/plugins/superpowers.js#L286-L369)

The adapter distinguishes controller sessions from delegated child sessions. It injects the controller bootstrap into top-level sessions, but skips it for sessions with a `parentID`. Child sessions still receive registered skills. This prevents a worker from restarting the parent's brainstorming and approval loop. The code caches the classification for each session and limits the cache to 512 entries. If a lookup fails, it injects the bootstrap and retries on a later request. [`.opencode/plugins/superpowers.js`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/.opencode/plugins/superpowers.js#L143-L209) [`docs/README.opencode.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/README.opencode.md#L120-L141)

### 3. Tool mapping lets one skill set run on different harnesses

Skills use a stable action vocabulary, while the bootstrap teaches the model each harness's concrete names. OpenCode V1 maps subagent dispatch to `task`, file changes to `apply_patch`, shell commands to `bash`, and progress tracking to `todowrite`. OpenCode V2 maps those actions to `subagent`, `patch`, `shell`, and a plan file because V2 has no todo tool. The V2 adapter also passes `sessionID` when a worker must be continued. [`.opencode/plugins/superpowers.js`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/.opencode/plugins/superpowers.js#L70-L107) [`docs/README.opencode.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/README.opencode.md#L143-L172)

Other harnesses use the same boundary. Pi registers `skills/` during resource discovery and injects a bootstrap on session start and after compaction. Its mapping directs the model to use Pi's native skill system. If no subagent tool exists, the model works inline. If no task-list tool exists, it uses a plan file. [`.pi/extensions/superpowers.ts`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/.pi/extensions/superpowers.ts#L16-L57) [`.pi/extensions/superpowers.ts`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/.pi/extensions/superpowers.ts#L88-L97)

## The intended development workflow

The README presents this default path:

1. **Brainstorming.** Before coding, the agent asks questions, explores alternatives, presents a design in readable sections, and saves the design document.
2. **Worktree isolation.** After design approval, it creates an isolated branch and verifies a clean test baseline.
3. **Planning.** It turns the approved design into short tasks with exact paths, complete code examples, and verification steps.
4. **Execution.** It chooses subagent-driven development or inline plan execution.
5. **Test-driven development.** During implementation, it follows RED-GREEN-REFACTOR.
6. **Code review.** It reviews work against the plan between tasks.
7. **Branch completion.** It verifies the suite and presents merge, pull-request, or keep-the-branch options.

The README lists these as the repository's named stages. [`README.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/README.md#L307-L323)

### Design is a gate, not a suggestion

`brainstorming` first classifies the request as a spike, bounded change, or architectural change. A spike ends in a recommendation. A bounded change gets a short in-chat design. An architectural change requires a sectioned design, a written spec, a spec review, and then a plan. The skill's hard gate forbids implementation work until the human approves the selected path. [`skills/brainstorming/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/brainstorming/SKILL.md#L38-L56) [`skills/brainstorming/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/brainstorming/SKILL.md#L58-L84)

This is the first point where a human must approve the work. The agent can explore and propose, but it cannot turn an unapproved design into code under the documented process. After approval, the architectural path writes and commits a spec before it invokes `writing-plans`. [`skills/brainstorming/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/brainstorming/SKILL.md#L129-L139) [`skills/brainstorming/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/brainstorming/SKILL.md#L237-L265)

### Plans make execution steps explicit

`writing-plans` requires a plan header with the goal, architecture, stack, spec path, global constraints, and review focus. Each task names the files, interfaces, tests, exact code, expected command output, and commit command. It rejects placeholders such as "handle edge cases" or "write tests for the above". [`skills/writing-plans/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/writing-plans/SKILL.md#L25-L52) [`skills/writing-plans/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/writing-plans/SKILL.md#L54-L89) [`skills/writing-plans/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/writing-plans/SKILL.md#L94-L165)

The plan transfers execution to the next stage. The human chooses between subagent-driven and inline execution unless an execution method was already supplied. [`skills/writing-plans/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/writing-plans/SKILL.md#L167-L192)

### Two execution modes

**Subagent-driven development** dispatches a fresh implementer for each task. The implementer tests and self-reviews. A task reviewer then checks specification compliance and task quality. Findings enter a fix loop, and a final reviewer checks the whole branch. The controller does not pause between tasks for routine confirmation. [`skills/subagent-driven-development/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/subagent-driven-development/SKILL.md#L1-L17) [`skills/subagent-driven-development/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/subagent-driven-development/SKILL.md#L59-L121)

**Inline plan execution** keeps implementation in one session. It keeps the per-task test gate and ledger, then uses one fresh whole-branch review at the end. The repository describes inline execution as cheaper and faster than assigning a fresh implementer and reviewer to every task. It gives up independent review during the task sequence. [`skills/executing-plans/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/executing-plans/SKILL.md#L1-L22)

### TDD, debugging, and verification are separate controls

The TDD skill states: "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST." The skill requires the agent to watch the test fail for the expected reason. The agent then writes the smallest passing code, runs the full suite, and refactors only while the suite is green. [`skills/test-driven-development/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/test-driven-development/SKILL.md#L7-L45) [`skills/test-driven-development/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/test-driven-development/SKILL.md#L47-L66) [`skills/test-driven-development/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/test-driven-development/SKILL.md#L113-L189)

`systematic-debugging` uses a separate four-phase rule: investigate the root cause, analyze patterns, test one hypothesis, then implement a tested fix. After three failed fixes, it tells the agent to question the architecture instead of trying a fourth patch. [`skills/systematic-debugging/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/systematic-debugging/SKILL.md#L8-L20) [`skills/systematic-debugging/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/systematic-debugging/SKILL.md#L44-L84) [`skills/systematic-debugging/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/systematic-debugging/SKILL.md#L168-L210)

`verification-before-completion` separates evidence from status claims. Before claiming that tests pass or work is complete, the agent must identify and run the full command. It must read the output and compare it with the claim. [`skills/verification-before-completion/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/verification-before-completion/SKILL.md#L8-L35)

## What makes the approach distinctive

### It tests process instructions like code

`writing-skills` applies TDD to skill authoring. A pressure scenario is the test, and the skill document is production code. Baseline agent behavior is RED; compliance is GREEN. New loopholes start another refactor cycle. [`skills/writing-skills/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/writing-skills/SKILL.md#L9-L18) [`skills/writing-skills/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/writing-skills/SKILL.md#L30-L45)

That idea shapes the skill format. The descriptions should state when a skill applies. They should not summarize the process, because tests found that agents may follow the short description and skip the body. The full workflow stays in the body, where the agent can load it when the trigger matches. [`skills/writing-skills/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/writing-skills/SKILL.md#L140-L180)

### It separates human approval from routine execution

Superpowers does not try to make every step autonomous. It inserts human approval at design, spec, and plan boundaries, then gives the controller a procedure for running approved work without repeated check-ins. That combination explains the README's claim that an agent can work for long periods without deviating from an approved plan. [`README.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/README.md#L36-L46) [`skills/subagent-driven-development/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/subagent-driven-development/SKILL.md#L14-L25)

### It separates controller policy from worker execution

The parent session owns design, approval, planning, and coordination. Worker sessions execute assigned tasks with the relevant skills but do not re-run the controller bootstrap. This is a concrete architectural decision, not a prompt convention. [`.opencode/plugins/superpowers.js`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/.opencode/plugins/superpowers.js#L143-L160) [`.opencode/plugins/superpowers.js`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/.opencode/plugins/superpowers.js#L337-L365)

### It requires every harness to provide the same core capabilities

The porting guide defines one non-negotiable capability: automatic session-start injection with no per-session opt-in. It also lists skill discovery, file access, shell execution, and tool-specific fallbacks. The project considers a harness integrated only when the clean-session message "Let's make a react todo list" triggers brainstorming before the agent writes code and the integration tests pass. [`docs/porting-to-a-new-harness.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/porting-to-a-new-harness.md#L81-L122) [`docs/porting-to-a-new-harness.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/porting-to-a-new-harness.md#L134-L163)

### It includes a process for explaining its own failures

`diagnosing-superpowers` treats a bad session as a problem that requires evidence. It requires a problem statement, transcript paths, and line-level citations for every finding. It also requires parallel analysis of skill timing, plan adherence, repeated work, stumbles, quality, request conflicts, and cost. It can produce a scrubbed bundle for a maintainer issue only after approval. [`skills/diagnosing-superpowers/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/diagnosing-superpowers/SKILL.md#L8-L18) [`skills/diagnosing-superpowers/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/diagnosing-superpowers/SKILL.md#L19-L63)

## Tradeoffs and limitations

### More review and context increase costs

The most thorough execution mode uses a new implementer and reviewer context for every task, plus a final review. Inline execution uses one implementation context and one final reviewer, but gives up fresh context and task-level independent review. The repository states this tradeoff directly. The choice is between fresh, independent review and lower cost and latency. [`skills/subagent-driven-development/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/subagent-driven-development/SKILL.md#L53-L57) [`skills/executing-plans/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/executing-plans/SKILL.md#L8-L18)

### Approval gates add interaction and make unstructured coding less suitable

By design, the process stops before implementation until the human approves the relevant artifact. That reduces the risk of building the wrong thing, but it also makes unstructured coding less suitable. The skill provides a lighter spike path for feasibility questions, but even that path asks for approval of the probe first. [`skills/brainstorming/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/brainstorming/SKILL.md#L38-L84) [`skills/brainstorming/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/brainstorming/SKILL.md#L115-L127)

### The host does not enforce the workflow rules

The plugin can inject the bootstrap, expose skills, map tools, and isolate worker sessions. The workflow rules live in Markdown, and the model follows them. This means the system's strongest controls are behavioral instructions and review artifacts, not a host-enforced transaction system. The repository recognizes this boundary by requiring real agent behavior tests, including tests that ask Claude Code to describe review ordering and a separate evaluation harness for skill behavior. [`docs/porting-to-a-new-harness.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/porting-to-a-new-harness.md#L49-L55) [`tests/claude-code/test-subagent-driven-development.sh`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/tests/claude-code/test-subagent-driven-development.sh#L1-L9) [`README.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/README.md#L375-L387)

### Harness compatibility remains a maintenance burden

Each harness needs its own installation path, bootstrap mechanism, and tool mapping. The porting guide says those mechanisms will keep changing and requires empirical validation. OpenCode V2 requires version 2.0.4 or later, uses a different `plugins` configuration key, and rejects a direct JavaScript-file path for local installs. Its V1 and V2 adapters also use different host APIs. [`docs/porting-to-a-new-harness.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/porting-to-a-new-harness.md#L14-L17) [`docs/README.opencode.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/README.opencode.md#L5-L35)

Two documented edge cases follow. Hermes has no post-compaction hook, so a long session that compacts over its first turn can lose the bootstrap and may need a fresh session. OpenCode can also keep a cached git dependency after an update, so a restart may not load the newest commit. [`README.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/README.md#L268-L278) [`docs/README.opencode.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/README.opencode.md#L102-L118)

### Skill names and host precedence can collide

OpenCode V2 gives project skills priority over personal skills and Superpowers skills. Tested V1 behavior gives bundled Superpowers skills precedence over same-named personal or project skills. The documentation recommends distinct names for personal and project skills, so installing custom skills requires attention to namespace and host version. [`docs/README.opencode.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/README.opencode.md#L93-L100)

### The full process adds work to small tasks

TDD is mandatory for features, fixes, refactors, and behavior changes. Exceptions apply only to throwaway prototypes and generated or configuration files, and only after the human partner agrees. The system supports a spike path, but teams that prioritize speed over repeatability may find the default process requires more work than a small experiment warrants. [`skills/test-driven-development/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/test-driven-development/SKILL.md#L22-L29) [`skills/brainstorming/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/brainstorming/SKILL.md#L65-L70)

## Assessment

Superpowers makes its workflow the central feature. The integration injects one startup skill, exposes the shared skills, and maps their action vocabulary to the host. The surrounding documents require approval gates before implementation, exact plans, TDD, root-cause debugging, independent review, and evidence before completion claims. [`docs/porting-to-a-new-harness.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/porting-to-a-new-harness.md#L31-L55) [`README.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/README.md#L307-L323)

The process fits software work where rework is costly. It records decisions and evidence, lets the controller run approved plans without routine prompts, and adds context, review, setup, and harness-maintenance costs. [`README.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/README.md#L36-L46) [`skills/subagent-driven-development/SKILL.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/skills/subagent-driven-development/SKILL.md#L14-L25) [`docs/porting-to-a-new-harness.md`](https://github.com/obra/superpowers/blob/5bf4e78011075bcfc0dc295f0724994cd123ee71/docs/porting-to-a-new-harness.md#L81-L122)
