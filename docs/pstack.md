# pstack

## Source

This page records the findings from [quest #13](raw/quest-13-pstack.md). The primary source is the [`pstack` plugin](https://github.com/cursor/plugins/tree/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack) at commit [`12d587d`](https://github.com/cursor/plugins/commit/12d587dfb20741cafc376c42c696c5f6e2a64487), dated 2026-09-23.

## What it is

pstack is a workflow layer for Cursor. It is a plugin, not a standalone agent server. The plugin bundles skills, agents, playbooks, model-role configuration, and local tools ([`plugin.json`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/.cursor-plugin/plugin.json); [`README.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/README.md)).

Its stated goal is to produce less code with higher quality. It uses parallel agents, model-specific roles, review procedures, and verification on the changed application behavior ([`README.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/README.md)).

## Workflow

1. Install the plugin with `/add-plugin pstack`.
2. Run `/setup-pstack` to detect model slugs, select a reasoning budget, map roles to models, and write `~/.cursor/rules/pstack-models.mdc` ([setup guide](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/docs/guide/01-setup.md); [`setup-pstack/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/setup-pstack/SKILL.md)).
3. Give `/poteto-mode` a goal and a finish condition. It matches the request to one of 23 playbooks, copies the selected steps into a todo list, and calls other skills as needed ([`poteto-mode/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/SKILL.md)).
4. Run the selected playbook. Feature work uses `how`, `architect`, delegated implementation, application verification, ordered commits, and optional adversarial review. Bug fixes reproduce the issue first and verify the original reproduction after the fix ([`feature.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/playbooks/feature.md); [`bug-fix.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/playbooks/bug-fix.md)).
5. Verify the real behavior, open the pull request, and keep Babysit separate from Shipping. Shipping independently verifies each pull request and lands only a contiguous verified stack ([verification guide](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/docs/guide/06-verify-and-ship.md); [`shipping.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/playbooks/shipping.md)).

## Architecture

### Skills, playbooks, and principles

Skills define procedures. Playbooks sequence them for investigations, features, bug fixes, design, pull-request work, autonomous runs, and project-scale programs. `poteto-mode` owns routing rules, model roles, autonomy rules, and reply contracts ([`poteto-mode/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/SKILL.md); [playbooks](https://github.com/cursor/plugins/tree/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/playbooks)).

The 23 principle skills give recurring engineering judgments short names. They cover data modeling, shared-state isolation, root-cause debugging, real-artifact verification, and delegation. The mode asks the agent to name the principle and the decision it changed ([principles guide](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/docs/guide/08-principles.md)).

### Understanding and design

`how` builds a runtime and architectural explanation. Complex questions use two to four read-only explorers and an explainer. `why` searches code, history, and available evidence sources while separating direct evidence from inference ([`how/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/how/SKILL.md); [`why/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/why/SKILL.md)).

`architect` uses that evidence before design. It invokes `arena`, requires structurally different candidates, screens them, combines usage with types and module boundaries, and redesigns if implementation conflicts with the outline ([`architect/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/architect/SKILL.md)).

### Parallel work

`arena` gives candidates the same brief in separate worktrees or directories. A cross-model judge scores them. The parent chooses a base, copies useful ideas from rejected candidates, and verifies the result. `swarm` partitions independent slices or race arms and combines `PASS`, `ISSUES`, or `BLOCKED` reports. `interrogate` sends the same patch and rubric to reviewers from different model families and sorts findings into Act on, Consider, Noted, and Dismissed ([`arena/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/arena/SKILL.md); [`swarm/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/swarm/SKILL.md); [`interrogate/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/interrogate/SKILL.md)).

Workers use separate writable locations. Shared writes are serialized only when the shared state represents a real invariant ([`principle-separate-before-serializing-shared-state/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/principle-separate-before-serializing-shared-state/SKILL.md)).

### Long runs and delivery

Autonomous Run requires a checkable exit predicate, a Cursor `/loop` wake mechanism, one evidence-backed change per iteration, and one decision-log row per iteration. Orchestrate extends this to multi-day programs. Its `orch` command-line interface stores units, verification records, agent inbox pointers, human gates, and merge-frontier state in tab-separated-value and JSON files. The store uses locks and atomic writes ([`autonomous-run.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/playbooks/autonomous-run.md); [`orchestrate.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/playbooks/orchestrate.md); [`store.ts`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/scripts/orch/store.ts)).

The pull-request watcher reads GitHub pull-request facts, review threads, checks, and commit rollups. It classifies conflicts, review threads, failing checks, draft state, and requested changes for one pull request or a stack ([`watch-pr/cli.ts`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/scripts/watch-pr/cli.ts); [`watch-pr/policy.ts`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/poteto-mode/scripts/watch-pr/policy.ts)).

## Distinctive choices

- The workflow, rather than the prompt, is the main unit of design.
- Parallelism includes isolated workspaces, parent synthesis, model diversity, and independent verification.
- Principles provide reusable names for engineering judgments.
- Evidence from the real artifact determines completion instead of a green build alone.
- `/automate-me` and `/reflect` let users adapt the base mode to their own working style ([`automate-me/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/automate-me/SKILL.md); [`reflect/SKILL.md`](https://github.com/cursor/plugins/blob/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack/skills/reflect/SKILL.md)).

## Tradeoffs and limitations

- **Cursor dependence.** pstack requires Cursor skills, Task subagents, model slugs, `/loop`, and Model Context Protocol connections. It does not target another agent host. It also depends on companion tools for cleanup and live verification.
- **Instruction-driven routing.** Most routing and policy lives in Markdown. The repository has helper code for pull-request watching and orchestration, but no standalone natural-language task classifier. This means the host agent must follow much of the design. This point is an inference from the source layout.
- **Coordination cost.** Parallel work requires model calls, workspaces, coordination, and synthesis. Small tasks may need more coordination than the change requires.
- **Model configuration.** Results and cost vary with model access and configuration. A stale model rule can change the number of agents and the model that judges the work.
- **Asynchronous supervision.** Architect proceeds without a human checkpoint by default. An underspecified task may begin implementation before a human reviews the design.
- **Missing companion tools.** Users who need browser, Electron, or command-line planning tools must add host or companion tools. pstack coordinates them but does not replace them.

## Summary

pstack uses reusable procedures to make an agent follow an engineering workflow. `poteto-mode` routes each goal to a playbook. The playbook calls focused skills, isolates parallel work, uses different models when judgment requires it, and completes work only after checking the real artifact. This suits work that needs review, verification, and repeatable process. It costs Cursor dependence, model and tool setup, Markdown procedures, and coordination that one agent may not need.
