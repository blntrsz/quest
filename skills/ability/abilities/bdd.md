---
name: bdd
description: Turn a feature into concrete examples in the user's language — Given–When–Then scenarios that a person and a test runner both read. Use when the user mentions BDD, Gherkin, Given-When-Then, example mapping, or living documentation, or when the outside-in-tdd end-to-end test should read as a scenario.
---

Use this ability to turn a feature into concrete examples written in the user's own language, then check the system against them. The examples are a specification while you build, and documentation after you ship. The work runs as three practices, in order: **Discovery**, **Formulation**, **Automation**. Discovery pays for the other two. Skip it, and you automate examples nobody agreed to.

The outer loop of the **outside-in-tdd** ability is one of these examples made executable. Write the scenario first, watch it fail, then build inward with the **tdd** ability.

## Run the three practices

1. **Discovery: find the examples.** Sit with the people who know the domain, and talk through concrete cases from the user's point of view. Ask for the rules that govern the outcome, and the cases that bend them. Write each case as a real example with real values. Discovery also surfaces scope you can defer, which makes the change smaller.
2. **Formulation: write each example.** Put the examples in the shared language of the domain, in a form a person reads and a test runner executes. These are your scenarios.
3. **Automation: wire each example to the system.** One example at a time, connect the scenario to the code and watch it fail. Build the behavior with the **tdd** ability, then run the scenario again. When it passes, move to the next example.

## Formulate one scenario

A scenario has an initial context, one action, and an observable outcome:

```gherkin
Scenario: Withdraw within the balance
	Given my account has a balance of £100
	When I withdraw £30
	Then my account should have a balance of £70
```

- **Given** sets the known state before any action. Several Givens are fine.
- **When** is the one event that changes the state.
- **Then** is the outcome a user or an external system can observe. Check what comes out of the system, such as a screen, a message, or a report, rather than a row deep in a database.

Keep a scenario to three to five steps, and write it in the words your users say. The code behind each line, the step definition, hides the implementation.

## Rules that keep scenarios useful

- One example per scenario. A second When is a second scenario.
- Run one scenario across several values with a `Scenario Outline` and its `Examples` table, instead of copying the scenario.
- Move Givens that every scenario shares into a `Background`, and keep that background short and vivid with real names.
- Drop a step that only reaches a state the reader does not need to know.

## Keep examples honest

A scenario that no longer matches the system teaches the wrong behavior, so change the example in the same change that moves the behavior. When a scenario can pass only by looking at internals, the outward behavior is not yet observable. Fix that instead of weakening the Then.

Sources: cucumber.io/docs/bdd and cucumber.io/docs/gherkin/reference, fetched 2026-09-22.
