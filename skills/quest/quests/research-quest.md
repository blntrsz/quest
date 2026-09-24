---
name: research
description: Research a ticket question from high-trust primary sources, starting with the wiki; prepare cited findings for human approval, post and ingest the approved findings, then hand the ticket back. Use when the user wants a topic researched or docs and API facts gathered.
abilities:
  - wiki
  - writing
  - unslop
---

Research the ticket's question against primary sources, starting with the wiki's existing content. Deliver approved, cited findings on the ticket and in the wiki, then hand the ticket back to the human.

## Operating rules

- Treat the wiki as the starting point and continuity record; verify findings against the primary sources that own the claims.
- Never post research to the ticket until the human explicitly approves the final draft.

1. **Query the wiki first.** Load the **wiki** ability and run its **Query** operation with the ticket's question. Report the pages consulted and what the wiki already contains. Reuse settled claims and identify gaps that need research. Done when you have read the relevant wiki content or confirmed there is none.
2. **Investigate primary sources.** Use official documentation, source code, specifications, and first-party APIs—not secondary write-ups as evidence. Follow each finding to the source that owns it and collect citations. Done when every finding is supported by a primary source.
3. **Draft and review the findings.** Prepare the findings as a Markdown ticket comment, citing the source for each claim. Run the **writing** ability over the draft so it selects the right mode and reads well on the first pass. Print the draft for the human. Done when the cited draft has been shared.
4. **Refine the prose.** Spawn a background sub-agent to run the **unslop** ability over the draft; it reports each pattern it finds and its rewrite. Apply the refinements and print the final draft for the human. Done when the sub-agent has reported and the refined draft has been shared.
5. **Get approval.** Wait for the human to approve the final draft. Revise and share it again until they approve. Done when the human has explicitly approved the version to post.
6. **Post the approved findings.** Add them as a comment on the ticket, not as loose files in the repository. Done when the approved findings are posted.
7. **Ingest the findings into the wiki.** Load the **wiki** ability and run its **Ingest** operation with the ticket as the source. Add or update the ticket reference in `docs/raw/`; update every page the findings extend or correct; add a new page to its directory index when needed. Commit the wiki changes. Done when the wiki contains the findings, every affected page links to the ticket reference, and the changes are committed.
8. **Record the outcome and hand back.** Comment on the ticket per the issue-tracker instructions, including the research comment and wiki commit. Hand the ticket back; the human closes it. Done when the ticket records the outcome and is ready for the human to close.
