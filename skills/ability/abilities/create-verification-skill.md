---
name: create-verification-skill
description: Generate a project-local verification skill that drives every surface of a project — UI, API, MCP, CLI — the way a user does, and proves a change at the highest level that reaches it. Use for /create-verification-skill, "make a control skill for this repo", or when a project has no scripted way to prove UI, API, MCP, or CLI behavior.
---

# Create a verification skill

Every project needs a scripted way to drive its real surfaces and prove behavior: launch a surface, exercise a feature the way a user would, and capture evidence. This ability generates that as a project-local skill at `.agents/skills/verify-<project>/`. The next agent reads it cold, mid-task, and has never seen the project. Write for that agent, not for a human.

A project often exposes several surfaces at once — a UI, an API, and an MCP server. The generated skill maps each one and gives it its own drive recipe. A **level** ranks those surfaces by how close each sits to a real user, and verification runs at the highest level that reaches the change.

## 1. Interview the repo, not the user

Answer from the codebase. Ask the user only what you cannot observe.

- **Surfaces.** List every surface a user touches: web UI, CLI, TUI, desktop app, API, MCP server, mobile app, library. Name each one and its kind. A project can have several; none is the default.
- **Run.** How each surface starts locally. Prefer the project's own documented command — package scripts, Makefile, README quickstart — over one you invent. Record ports, env vars, seed data, and auth for each.
- **Drive.** How an agent reaches each surface programmatically. Prefer an existing harness — Playwright or Cypress specs, expect scripts, PTY helpers, curl-able endpoints, a debug port, an MCP client. Only then pick a generic recipe: browser or CDP for web and Electron, tmux or a PTY for CLI and TUI, plain HTTP for services, the MCP protocol for a tool server.
- **Observe.** The evidence each surface can give: screenshots, ARIA snapshots, terminal transcripts, response bodies, logs, exit codes, database rows.
- **Isolate.** Whether two instances run side by side — ports, data directories, profiles. When they cannot, the generated skill says so: refusing to double-drive a shared instance beats corrupting the user's session.
- **Level.** Rank the surfaces by closeness to a real user. Default, highest first: UI, CLI/TUI, MCP, API, in-process. Override the order when the project's users make another order true, and record the order in the skill.

If the checkout does not build or start as-is, fix that first, or report it precisely. A skill written against a broken base teaches wrong steps. When an unrelated missing asset blocks startup — a static directory the API never serves, a sample config — the generated skill may create it, marked as verification scaffolding, and remove it in cleanup.

## 2. Generate the skill

Write `.agents/skills/verify-<project>/SKILL.md`. The main file is the registry: it names the surfaces, states the level order, and points to one file per surface. Keep each surface's launch, drive, and cleanup in its own `apps/<surface>.md`, so a run loads only the surface it drives.

Frontmatter:

```markdown
---
name: verify-<project>
description: Drive and prove the real behavior of <project> across its <surface list>. Use to verify a change end to end, launch a surface for a manual proof, or answer "does this still work".
---
```

Keep the description. A quest run or another skill reaches the skill through it, which is what lets verification pick a level.

Main-file sections:

- **Surfaces.** A table: surface, kind, level, file, one-line purpose. The level column carries the order from the interview.
- **Level rule.** How to choose the level for a change: find the features the change touches in the map, then take the highest level among their surfaces that reaches the changed behavior. Drive that surface. Add a lower-level check only for a side effect the higher surface cannot show. When the highest level is unavailable, record the unmet precondition and the level you used; never present a lower level as equivalent.
- **Baseline.** Shared preconditions: how to isolate state, seed data, and authenticate. State that a run drives only instances it started.
- **Proof standards.** The rules every proof obeys:
  - Exercise the real user path, not internal setters or test-only endpoints.
  - Capture the action and the resulting state, not only the final screen.
  - Verify side effects — files written, rows inserted, messages sent — alongside what is visible.
  - Mock only where a production boundary already isolates the external system.
  - When the safe path is a dry-run or test mode, observe what it actually skips in files, network, and git refs. Some dry-runs still touch the network or open a browser.
  - Report an unreachable path with the attempted command and the unmet precondition. Never report a skipped entry point as verified through a different path.
- **Cleanup.** The shared rule: kill what this run started, never by process name, and let proof artifacts survive teardown.
- **Features.** A pointer to `features/README.md`.

Write one file per surface at `.agents/skills/verify-<project>/apps/<surface>.md`, each with these sections:

- **Launch.** The exact command that starts the surface for verification, and how to tell it is ready: a log line, a port answering, a prompt. Include teardown. A short-lived CLI or TUI has no server to keep alive: launch means build the binary once, then start each drive in its own isolated PTY or tmux session.
- **Doctor.** One read-only check that answers "is this instance worth driving?" — process up, right version or build, port owned by this run, auth valid. An agent runs it first whenever anything looks off.
- **Drive.** The harness recipe with real selectors, routes, tool names, and commands from this project, not examples. Prefer stable handles — ARIA labels, data attributes, prompt strings, route paths, tool names — over coordinates and tab order.
- **Evidence.** What to capture for this surface and where it goes.
- **Cleanup.** How to tear down the instance this run started. Proof artifacts stay.
- **Helpers.** Any script the surface ships. Make it executable and show its invocation here. A helper the reader has to reverse-engineer is not a helper.

## 3. Seed the feature map

Create `.agents/skills/verify-<project>/features/README.md` plus one file per user-facing feature. Start with the top three to five, drawn from routes, commands, menus, tool definitions, or docs. The map is the project's maintained verification source: a proof that drives one convenient entry point is incomplete when the map lists others.

Each feature file names the surface it lives on and the level to prove it at, then answers four questions in exactly these H2s, in this order:

- `Sub-features` — short IDs, one line each.
- `How to get to it (user POV)` — every entry point a user has.
- `Driving it with <harness>` — starts with `Preconditions:`, then labeled bullets pairing each user action with an exact command and an observable result.
- `Gotchas` — traps that waste or invalidate a run.

Shape to follow:

```markdown
# <Feature>

One paragraph on the user-visible behavior.

Surface: <surface>. Prove at level: <level>.

## Sub-features
- `<id>` <one line>

## How to get to it (user POV)
- <entry point>

## Driving it with <harness>

Preconditions:
- <state required>

- **<Action>.** <user step>. Run `<command>`. <observable result>.
- **Proof.** Run `<capture command>`. <what the artifact shows>.

## Gotchas
- <trap>
```

The README index carries the baseline, the driving conventions, the proof standards, and the feature entry contract. Keep implementation details out of the map: name only user paths, stable handles, required state, commands, and observable proof.

## 4. Prove the generated skill before handing it over

Run its own instructions end to end once:

1. Launch one surface, run its doctor, and confirm it reports healthy.
2. Drive ONE mapped feature at the highest level that reaches it. One is enough; the map exists so later runs cover the rest.
3. Capture evidence at the named location.
4. Clean up.
5. Confirm the evidence still exists where the skill says it does. A cleanup that eats the proof fails this step.

Fix what fails. After every failed iteration, run the generated cleanup too, so broken attempts do not strand processes and ports. A generated skill that was never executed is a draft, not a deliverable.

## 5. Hand over

Report the path to `.agents/skills/verify-<project>/`, the surfaces it covers with their levels, and the one feature you proved. Name the level rule so the user sees how quest verification will pick a surface. Point the user at `maintain-verification-skill` for keeping the map honest as the app changes; suggest a cadence only if the user asks.
