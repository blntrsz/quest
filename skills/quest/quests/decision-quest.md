---
name: decision
description: Resolve an issue's decision through a guided interview, record the approved outcome, then hand it back or start implementation.
---

Guide the human through the issue's open decision, record the confirmed outcome, and either hand the issue back for closure or transition it into implementation.

Treat the discussion as one decision tree: each decision is a branch, and dependent decisions wait on their prerequisites. Track what is settled, what remains open, what each question depends on, and any assumptions that have not been checked.

## Operating rules

- Ask one question at a time, choosing the most important open question whose prerequisites are settled. Wait for the answer before asking another.
- Recommend an answer and explain why for every question. Present each in this shape:

  ❓ **<question title>**: <the question, with its options if there are any>

  ➡️ <your recommended answer, and the reason for it>

- When the question has a few mutually exclusive options, use a user-input tool if it fits; otherwise ask in plain text.
- Find environmental facts yourself. Dispatch a sub-agent when a question depends on a fact, and do not block the interview on a running search if other questions can proceed.
- As relevant, cover goals and non-goals, users and stakeholders, constraints, alternatives, APIs and interfaces, data model, error handling, security, observability, testing, migration and rollout, failure modes, operational ownership, and success criteria.
- Challenge vague, unsupported, or contradictory answers with a follow-up before moving on.

1. **Interview the decision tree.** Work through the open branches under the operating rules, preserving dependencies between questions. Each answer may settle a branch, reshape the tree, or reveal the next question. Done when no open branch or unchecked assumption remains, every needed fact has a source, and each relevant topic has been addressed or ruled out.

2. **Confirm the shared understanding.** Once the tree is settled, tell the human your understanding and ask them to confirm it. If they correct it, reopen the affected branch and continue the interview. Do not act on the design before they confirm. Done when the human confirms you share one understanding.

3. **Get approval of the written outcome.** Present the agreed design, remaining risks, assumptions, rejected alternatives, and next steps. Wait for the human to approve this summary; incorporate requested changes and seek approval before recording. Done when the human approves the summary.

4. **Record the approved outcome.** Follow `docs/agents/issue-tracker.md` and post the approved outcome as a comment on the same issue. Done when the issue carries the approved outcome.

5. **Choose the next step.** After recording the outcome, ask whether the human wants to finish with the decision or implement it. Recommend the path that best matches their stated goal and explain why. Done when the human has chosen a path.

   - **Finish with the decision:** hand the issue back for the human to close, following the tracker doc. The agent records and hands back; it does not close the quest. Done when the approved decision is recorded and handed back.
   - **Implement it:** use **task** for a direct, clearly bounded change or bug fix; use **story** when the behavior should be agreed through scenarios before building. If the scope does not clearly fit either type, ask one question at a time and recommend a type. On the same issue, remove `quest:decision` and add `quest:<type>`, where `<type>` is `task` or `story`. From the repo root, load the runbook with `skills/quest/scripts/load.sh <type>` and follow it in order, using the approved decision on the issue as context. Done when the selected runbook is loaded and its workflow is underway.
