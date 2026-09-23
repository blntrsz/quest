---
name: task
description: Deliver one task ticket end to end by implementing it directly. Read the wiki for what affects the ticket with the enrich ability, then implement the task. Review the result with the code-review, security-review, and unslop abilities, and fix every finding. Use for a direct change with a clear done, or a bug fix.
---

Deliver the task on the ticket. Work from the wiki, and finish with a reviewed implementation.

1. **Enrich from the wiki.** Load and run the **enrich** ability over the ticket. Report what the wiki holds that affects the task, and use it in the implementation. Done when you have read and reported every page that affects the task, or enrich reports that the wiki holds nothing relevant.
2. **Implement the task.** Make the change the ticket describes, and check it against the ticket's acceptance criteria. Done when the acceptance criteria are met and the suite is green.
3. **Review the change in parallel.** Spawn one sub-agent per ability, all at once. Each one reports findings and changes nothing; you apply the fixes in step 4.
   - **code-review**, over the diff since the commit the task started from. It reviews the change on the four axes it defines.
   - **security-review**, over the changed code and the entry points that reach it.
   - **unslop**, over the prose the change added: docs, comments, the commit message, and any PR body. Report each pattern with its rewrite.
   Done when all three sub-agents have reported.
4. **Fix every finding.** Work through each finding. Fix it, or record why it is wrong or out of scope on the ticket. Rerun the full suite after the fixes. Done when the suite is green and you have addressed every finding.
5. **Record the outcome and hand back.** Commit the implementation and the fixes. Record the outcome on the ticket, per the tracker doc. The human closes the ticket.
