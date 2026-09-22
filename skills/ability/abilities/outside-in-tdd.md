---
name: outside-in-tdd
description: Drive a feature from the outside in — one failing end-to-end test, then the tdd ability's red → green loop inward until it passes. Use for a new user-facing feature, a defect a user can see, or when the user asks for outside-in TDD or the two-level loop.
---

# Outside-in TDD

Outside-in TDD moves from the user's door inward. The **outer loop** is one end-to-end test that states a user-visible feature and fails. The **inner loop** is the red → green cycle of the **tdd** ability, which builds only what that failure asks for. The end-to-end test steers. The inner loop builds. You are done when the end-to-end test passes.

Load the **tdd** ability before the first inner cycle. It owns the test standard, the seams, the anti-patterns, and the loop rules.

The outer loop needs a way to run the app as a user would: a browser harness, a real request against a real server, a CLI run. When the project has no end-to-end harness, say so and stop. Building that harness is its own quest.

## The loop

1. **State the feature as an end-to-end test, and watch it fail.** Pick one user-facing feature. Drive it the way a user does, and assert on what the user sees. Run it. Confirm it fails because the feature is missing, not because the setup is wrong. This failure is the outer loop's work item.
2. **Step inward to the first unit.** Ask what production code the test needs to get one step further. Write a unit test for that piece at a seam you confirmed, following the **tdd** ability. When the piece does not exist yet, use the move below. Run it red, then green.
3. **Step back out, and rerun the end-to-end test.** It passes? The feature is done. It still fails? That failure names the next piece. Return to step 2.

When the end-to-end test passes, refactoring is the next stage, under the whole green suite. Load the **code-review** ability; the **tdd** ability keeps refactoring out of the loop.

## Write the code you wish you had

An inner unit often needs a collaborator that does not exist yet. Pause there. Call the collaborator the way you want to call it, and stand a test double in for its answer. The unit test now proves the caller's own logic. When the caller passes, build the collaborator to that exact interface, and test-drive it the same way. Build only what the current feature needs.

A double that needs a double that needs a double says the caller is coupled too deep. Fix the production interface so the caller reaches only the dependencies passed to it. Then rerun.

## What each test covers

- The end-to-end test proves **external quality**: a user can reach the feature, and the parts work together in the running app. It survives a rewrite of any inner layer, and it is the only test that proves the feature exists at all.
- The unit tests prove **internal quality**: the pieces are easy to call and cheap to change. They run fast, so they cover the edge cases the end-to-end test is too slow to carry, and a failure points at one unit.

Each type covers what the other cannot see. Write both, and count neither as duplicate effort.

Source: outsidein.dev/concepts/outside-in-tdd, fetched 2026-09-22.
