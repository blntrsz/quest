---
name: decision-quest
description: Grill the human about the ticket's plan or decision one question at a time until you share one understanding, then record the agreed design on the ticket. Use when a decision needs stress-testing before the work starts.
---

Grill the human about the ticket's decision until you share one understanding, then record the agreed design on the ticket.

Work one design tree. Every decision is a branch, and a decision hangs off the decisions it depends on. Hold the tree in your head: what is settled, what is open, what each open question waits on, and what you have assumed without asking.

1. **Ask one question at a time.** Ask the one open question that matters most, then wait for the answer. Never ask a question whose answer depends on one that is still open; save it for a later turn. Each answer settles a branch, reshapes the tree, and reveals the next question. Done when the human has answered the question you asked.

2. **Recommend an answer to every question.** Ask each question in this shape:

   ❓ **<question title>**: <the question, with its options if there are any>

   ➡️ <your recommended answer, and the reason for it>

   When a user-input tool fits the question and the options are few and mutually exclusive, use it. Otherwise ask in plain text. Done when every question carries a recommendation and a reason.

3. **Find the facts yourself.** When a question needs a fact from the environment, dispatch a sub-agent to find it. Never ask the human for anything you can look up. Do not block the interview on a running search; ask the questions that do not depend on it now. Done when every fact the tree needs has a source.

4. **Consider the usual topics.** As each one becomes relevant, ask about goals and non-goals, users and stakeholders, constraints, alternatives, APIs and interfaces, the data model, error handling, security, observability, testing, migration and rollout, failure modes, operational ownership, and success criteria. Done when every topic that bears on the decision has been asked about or ruled out.

5. **Challenge weak answers.** If an answer is vague, unsupported, or contradicts an earlier answer, ask a follow-up before you move on. Done when no branch rests on an unresolved assumption.

6. **Stop when the tree is settled.** The interview is done when no open question remains. Every branch has been visited and nothing is left silently assumed. Do not act on the design until the human confirms you share one understanding. Done when the human confirms it.

7. **Summarize and record.** Print the agreed design, the remaining risks, the assumptions, the rejected alternatives, and the next steps. Then record the outcome on the ticket, per the tracker doc. Done when the human has the summary and the ticket carries the outcome.
