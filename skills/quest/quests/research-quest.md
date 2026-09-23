---
name: research
description: Investigate a question against high-trust primary sources, keeping what the wiki already holds, write the findings up with the writing ability, refine them with unslop, post them as a comment on the ticket for the human to review, then ingest them into the wiki. Use when the user wants a topic researched or docs and API facts gathered.
abilities:
  - wiki
  - writing
  - unslop
---

Research the ticket's question against **primary sources**, write it up, refine the prose, then post the approved findings as a comment on the ticket and ingest them into the wiki.

1. **Query the wiki first.** Run the **wiki** ability's **Query** operation over the ticket's question. Report what the wiki already holds, and build on it rather than researching it again. Done when you have read the wiki's answer or the query finds no relevant wiki pages.
2. **Investigate against primary sources:** official docs, source code, specs, and first-party APIs, not a secondary write-up of them. Follow every claim back to the source that owns it. Done when every claim traces to the source that owns it.
3. **Draft the findings as a Markdown comment on the ticket**, citing each claim's source. Run the **writing** ability over the draft, so it picks the right mode and reads on the first pass.
4. **Print the research result to the human.**
5. **Refine the prose.** Spawn a background sub-agent running the **unslop** ability over the draft. It reports each pattern it finds with its rewrite. Done when the sub-agent has reported.
6. **Apply the refinements and print the final research for the human.** Post nothing until they approve; revise until they do.
7. **Post the approved findings as a comment on the ticket**, only after human approval, and as a ticket comment rather than loose files in the repository.
8. **Ingest the findings into the wiki.** Run the **wiki** ability's **Ingest** operation, so the findings become wiki pages that cite the ticket as their reference. Done when the wiki holds them and the change is committed.
