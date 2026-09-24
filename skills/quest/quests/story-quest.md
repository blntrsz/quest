---
name: story
description: Deliver one story ticket end to end, for work whose behaviour is worth agreeing before you build it. Read the wiki for what affects the ticket with the enrich ability, and agree the scenarios the human approves. Build them outside-in. Then review the result with the code-review, security-review, and unslop abilities, and fix every finding.
abilities:
  - enrich
  - bdd
  - outside-in-tdd
  - tdd
  - code-review
  - security-review
  - unslop
---

Deliver one story ticket end to end: agree the observable behavior with the human before coding, then hand back a reviewed implementation.

1. **Enrich from the wiki.** Run the **enrich** ability over the ticket. Report what the wiki holds that bears on the task, and carry it into the scenarios and the implementation. Done when you have read and reported every relevant page, or the enrich ability reports that the wiki has no relevant pages.
2. **Agree the tests before any code.** Run the **bdd** ability over the ticket's task. Write the scenarios that say what done looks like, in the user's language, and print them to the human. Wait for approval, and revise until they give it. Done when the human has approved the test scenarios. Write no production code before this.
3. **Implement outside-in.** Follow the **outside-in-tdd** ability. Write the first end-to-end test, then drive its inner red to green loop until the approved scenarios pass. Done when every approved scenario passes and the suite is green.
4. **Review the change in parallel.** Spawn four sub-agents at once. Each one reports findings and changes nothing; you apply the fixes in step 5.
   - **code-review**, over the diff since the commit the task started from. It runs its own four axes.
   - **security-review**, over the changed code and the entry points that reach it.
   - **unslop**, over the prose the change added: docs, comments, the commit message, and any PR body. Report each pattern with its rewrite.
   - **verify**. Ask a sub-agent to check whether a verify skill is available. If it is, have that sub-agent follow it to validate that the feature works as expected. If it is unavailable, have the sub-agent report that.
   Done when all four sub-agents have reported.
5. **Fix every finding.** Work through each finding in turn. Fix it, or record why it is wrong or out of scope on the ticket. Rerun the approved scenarios and the full suite after the fixes. Done when the suite is green and no finding is left unaddressed.
6. **Commit, record the outcome, and hand back.** Commit the implementation and fixes. Record the outcome on the ticket per the tracker doc, then hand it back for the human to close. Done when the work is committed, the ticket outcome is recorded, and the ticket is handed back for closure.
