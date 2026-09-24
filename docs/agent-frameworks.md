# Agent frameworks: four standout ideas

This comparison distills the approved research snapshots for [pstack](raw/quest-13-pstack.md), [Matt Pocock's skills](raw/quest-15-matt-pocock-skills.md), [Compound Engineering](raw/quest-14-compound-engineering.md), and [Superpowers](raw/quest-12-superpowers.md). “Standout” means distinctive within this comparison, not exclusive across the whole field.

## pstack

1. **Route from a goal to a complete playbook.** `poteto-mode` takes a goal and finish condition, then selects and sequences a playbook instead of asking the user to pick individual skills. That makes the workflow easier to start while keeping its steps, gates, and completion criteria explicit.
2. **Use different forms of parallel work for different jobs.** `arena` compares candidate implementations in isolated workspaces, `swarm` divides independent slices, and `interrogate` gathers multi-model reviews. The separation lets pstack get parallel coverage without having workers overwrite each other’s work.
3. **Make real behavior the evidence for completion.** pstack verifies the changed application behavior, uses independent checks, and only ships a contiguous verified pull-request stack. Its verification records and decision logs make long-running work auditable beyond the chat.

## Matt Pocock's skills framework

1. **Build the process from small, readable Markdown procedures.** Each `SKILL.md` has a bounded job, and skills compose through their instructions rather than a central execution engine. People can inspect, edit, and reuse the procedures directly.
2. **Make invocation policy an explicit design choice.** Model-invoked skills improve automatic discovery; user-invoked orchestration skills preserve user control and avoid keeping every description in the model's context. The split makes the discovery-versus-context tradeoff visible and configurable.
3. **Persist a team's shared language and decisions in the repository.** Skills such as `grill-with-docs` build a glossary in `CONTEXT.md` and capture selected decisions as ADRs, then carry that context into specs, vertical-slice tickets, TDD, and review. Later work can start from the terms and decisions the team already established.

## Compound Engineering

1. **Treat each change as one turn of a learning loop.** The core sequence is brainstorm, plan, work, simplify, review, and compound. Clear stage contracts separate deciding what to build from planning how to build it and implementing it; `lfg` can run the pipeline autonomously when desired.
2. **Write useful discoveries where future work can retrieve them.** `ce-compound` captures durable solutions in repository documents that later planning and ideation can use. Optional Compound Packs extend reusable guidance across repositories while treating pack content as citeable evidence, not executable workflow instructions.
3. **Adapt review to the actual change.** Reviewers and depth are selected based on the diff and its likely consequences, rather than always running the same fixed panel. Parallel perspectives can broaden coverage while a report-only default keeps findings separate from applying fixes.

## Superpowers

1. **Bootstrap a shared skill workflow across agent hosts.** A session-start integration injects `using-superpowers`, which prompts the agent to check for a relevant skill before acting. Shared skills use host-neutral action language, while each harness adapter maps those actions to its own tools.
2. **Gate implementation on an approved design, then execute from concrete plans.** The workflow has human approval points for design and planning, followed by exact tasks that can run inline or through fresh subagents. This helps prevent premature implementation without requiring routine check-ins during approved execution.
3. **Test the instructions themselves like software.** Superpowers uses pressure scenarios to expose ways an agent can skip or misread a skill, then revises the skill against those failures. Treating Markdown procedures as testable artifacts helps make the framework's process rules more robust.

## Sources

- [pstack research findings](https://github.com/blntrsz/quest/issues/13#issuecomment-5803403780), based on the [pstack snapshot at `12d587d`](https://github.com/cursor/plugins/tree/12d587dfb20741cafc376c42c696c5f6e2a64487/pstack).
- [Matt Pocock skills research findings](https://github.com/blntrsz/quest/issues/15#issuecomment-5803416854), based on [`mattpocock/skills` at `c55ee46`](https://github.com/mattpocock/skills/tree/c55ee46073ed923f86ce59a5eb3b6d895095d1b7).
- [Compound Engineering research findings](https://github.com/blntrsz/quest/issues/14#issuecomment-5803408042), based on the [plugin snapshot at `4fbabcd`](https://github.com/EveryInc/compound-engineering-plugin/tree/4fbabcd32b6ca7d8ebb82f15840fe34ef7562a64).
- [Superpowers research findings](https://github.com/blntrsz/quest/issues/12#issuecomment-5803403813), based on [Superpowers `v6.4.1`](https://github.com/obra/superpowers/tree/5bf4e78011075bcfc0dc295f0724994cd123ee71).
