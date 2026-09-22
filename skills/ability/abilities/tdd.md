---
name: tdd
description: The red → green loop, with the test standard that makes its tests worth keeping — where tests go, the anti-patterns, mocking at boundaries, and when to skip a test. Use for test-first work, a regression test, a red–green–refactor request, or from the outside-in-tdd ability.
---

# TDD

TDD is the red → green loop: write a failing test that states the behavior you want, then write only enough production code to pass it. The loop is easy. The discipline is in the tests it leaves behind, so read the sections below before and during a cycle, not after.

For a user-facing feature, the **outside-in-tdd** ability wraps this loop in an end-to-end test and calls it as the inner loop.

Before you write a test, read `CONTEXT.md` when the project has one, so names match the project's language. Respect the ADRs in the area you touch.

## The loop

1. **Red.** Write one failing test for one behavior, at a seam you confirmed. Run it. Watch it fail for the intended reason. A test that passes, or fails for something else, is not red yet.
2. **Green.** Write the least production code that passes the test. Run it. Add no speculative feature and no anticipation of the next test.
3. **Next slice.** One seam, one test, one minimal implementation per cycle. The next test responds to what this cycle taught you.

Refactoring is not part of the loop. It belongs to the review stage; load the **code-review** ability.

## What a good test is

A test states a behavior through a public interface, so the implementation can change entirely and the test still holds. Name it as a capability: "user can check out with a valid cart". A refactor with no behavior change that breaks the test means the test was wrong.

## Seams: where tests go

A **seam** is the public boundary where you observe behavior without reaching inside. Tests live at seams, never against internals.

Agree the seams first. Write down the public interfaces you will test, and confirm them with the user before writing any test. Testing effort is finite, so agreed seams are how it lands on the critical paths instead of every edge case.

When the shape of the interface is itself in question — how deep the module runs, where the seam belongs — load the **codebase-design** skill for the vocabulary. Consult it; do not run it.

## Anti-patterns

- **Implementation-coupled.** The test mocks an internal collaborator, calls a private method, or verifies through a side channel. The tell: it breaks on a refactor that kept the behavior.
- **Tautological.** The assertion recomputes the expected value the way the code does, so it passes by construction. Take the expected value from an independent source: a known-good literal, a worked example, or the spec.
- **Horizontal slicing.** All the tests first, then all the code. Bulk tests verify imagined behavior, so they pin the shape of things and go insensitive to real change. Slice vertically: one test, one implementation, repeat. Each test is a **tracer bullet** that responds to the last cycle.

## Mock at boundaries only

Mock an external system: a payment API, a database (prefer a test database), the clock, randomness, the file system. Keep your own modules, classes, and internal collaborators real.

Shape a boundary so a double is easy: pass the dependency in rather than constructing it inside, and give each external operation its own function with its own return type. One specific shape per function keeps test setup free of conditional logic.

Reach for a double when a collaborator does not exist yet, then build the collaborator to the interface the test used. The **outside-in-tdd** ability owns that move.

## When a test is not worth it

For a bug fix, make the broken behavior executable first. Prefer the narrowest test already used on that codepath: a unit, a component, or a regression test. Write it before the fix, watch it fail for the intended reason, make the smallest production fix, watch it pass, then run the nearby checks.

A bad test costs more than no test. When the only test needs broad harness setup, brittle mocks, slow end-to-end infrastructure, or production-only state, say so before you touch the fix. Then fall back to the closest executable check: a reproduction command, a scripted check, a browser drive, or a log assertion. A bad test mostly tests mocks, encodes the current implementation, depends on the clock or global state, or costs expensive infrastructure for a small fix.

## Guardrails

- Update a test when the behavior changes, and say why it changed. A failing test never licenses a wrong implementation.
- Weaken an assertion only for a real behavior change, and name the reason.
- Keep the test on the bug. Leave unrelated fixtures alone.
- For a flaky bug, make the test deterministic where you can, and write down the signal it locks down.
- Report evidence, not just the outcome: the test that failed before and the failure it produced, the run that passed after, and any nearby validation. When a failing test was impossible, say why and name the check you used instead.

Sources: mattpocock/skills `skills/engineering/tdd/SKILL.md`, `tests.md`, and `mocking.md`; cursor/plugins `pstack/skills/tdd/SKILL.md`. All fetched 2026-09-22.
