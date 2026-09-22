---
name: research-quest
description: Investigate a question against high-trust primary sources, write the findings up with the writing ability, refine them with unslop, and post them as a comment on the ticket for the human to review. Use when the user wants a topic researched or docs and API facts gathered.
---

Research the ticket's question against **primary sources**, write it up, refine the prose, then post the approved findings as a comment on the ticket.

1. **Investigate against primary sources:** official docs, source code, specs, and first-party APIs, not a secondary write-up of them. Follow every claim back to the source that owns it. Done when every claim traces to the source that owns it.
2. **Draft the findings as a Markdown comment on the ticket**, citing each claim's source. Load and run the **writing** ability over the draft, so it picks the right mode and reads on the first pass.
3. **Print the research result to the human.**
4. **Refine the prose.** Spawn a background sub-agent running the **unslop** ability over the draft. It reports each pattern it finds with its rewrite. Done when the sub-agent has reported.
5. **Apply the refinements and print the final research for the human.** Post nothing until they approve; revise until they do.
6. **Post the approved findings as a comment on the ticket**, only after human approval, and never in the repository.
