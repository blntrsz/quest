---
name: task
description: Deliver a task ticket end to end with wiki-informed implementation, review, and tracker handoff. Use for a direct change with a clear done, including bug fixes.
abilities:
  - enrich
  - code-review
  - security-review
  - unslop
---

Implement the ticket's clearly bounded change using relevant wiki guidance, then return a reviewed result with findings addressed.

1. **Enrich from the wiki.** Run the **enrich** ability over the ticket. Report every wiki page that affects the task and use relevant guidance in the implementation. Done when you have read and reported every relevant page, or enrich reports that the wiki holds nothing relevant.
2. **Implement the task.** Make the change described by the ticket and check it against the acceptance criteria. Done when the criteria are met and the suite is green.
3. **Review the change in parallel.** Spawn one sub-agent per ability below, all at once. Each reports findings without changing anything; you apply fixes in step 4.
   - **code-review:** review the diff since the commit the task started from, using the four axes defined by the ability.
   - **security-review:** review the changed code and the entry points that reach it.
   - **unslop:** review prose added by the change, including docs, comments, the commit message, and any PR body. Report each pattern with its rewrite.
   Done when all three sub-agents have reported.
4. **Address findings and verify.** Work through every finding: fix it, or record on the ticket why it is wrong or out of scope. Rerun the full suite after making fixes. Done when the suite is green and every finding is addressed.
5. **Commit and hand back.** Commit the implementation and fixes. Record the outcome on the ticket according to the tracker doc, then hand the ticket back for the human to close. Done when the commit and outcome are recorded and the ticket is handed back.
