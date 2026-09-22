---
name: task-quest
description: Deliver one task ticket end to end: read the wiki for what bears on it with the enrich ability, agree the tests with the human, build them outside-in, then review the result with the code-review, security-review, and unslop abilities and fix every finding.
---

Deliver the task on the ticket, from what the wiki already knows to a reviewed implementation.

1. **Enrich from the wiki.** Load and run the **enrich** ability over the ticket. Report what the wiki holds that bears on the task, and carry it into the scenarios and the implementation. Done when every page that bears on the task is read and reported, or enrich has said plainly that the wiki holds nothing relevant.
2. **Agree the tests before any code.** Load and run the **bdd** ability over the ticket's task. Write the scenarios that say what done looks like, in the user's language, and print them to the human. Wait for approval, and revise until they give it. Done when the human has approved the test scenarios. Write no production code before this.
3. **Implement outside-in.** Load and run the **outside-in-tdd** ability. Write the first end-to-end test, then drive its inner red to green loop until the approved scenarios pass. Done when every approved scenario passes and the suite is green.
4. **Review the change in parallel.** Spawn one sub-agent per ability, all at once. Each one reports findings and changes nothing; you apply the fixes in step 5.
   - **code-review**, over the diff since the commit the task started from. It runs its own four axes.
   - **security-review**, over the changed code and the entry points that reach it.
   - **unslop**, over the prose the change added: docs, comments, the commit message, and any PR body. Report each pattern with its rewrite.
   Done when all three sub-agents have reported.
5. **Fix every finding.** Work through each finding in turn. Fix it, or record why it is wrong or out of scope on the ticket. Rerun the approved scenarios and the full suite after the fixes. Done when the suite is green and no finding is left unaddressed.
6. **Record the outcome and hand back.** Commit the implementation and the fixes. Record the outcome on the ticket, per the tracker doc. The human closes the ticket.
