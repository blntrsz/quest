---
name: wiki
description: Curate docs/ as a Ryan Dahl style llm-wiki, a git-backed knowledge base whose index is docs/README.md, whose sources live in docs/raw/, and whose log is the commit history. Use to ingest a source, answer a question from the wiki, lint it for decay, or compact the pages that decayed.
---

# Wiki

An llm-wiki stores what a project learns in a git repository. An agent writes and maintains it, and a person reads it in an editor or on GitHub. The pattern is Andrej Karpathy's. Ryan Dahl adapted it to live inside a code repository, and this ability runs Dahl's adaptation.

The wiki is a directory of pages, and the sources sit beside them. The root index is `docs/README.md`. Sources live in `docs/raw/` inside the same tree, so one clone holds a source and the pages that cite it, and a relative link from a page into `raw/` always resolves. The commit history is the log: every change is one commit, and the commit message is the log entry. Wikilinks resolve only inside note-taking apps, so pages link with relative markdown paths.

The wiki holds design discussions, benchmark results, and feedback. The wiki drifts out of sync with the code, and that is expected. A page that turns into a run of dated updates is the failure mode.

Four operations maintain the wiki. Ingest brings a source in. Query answers a question from what the wiki holds. Lint finds the pages that have decayed. Compact repairs them.

## Operating rules

- The wiki lives in `docs/`, and its index is `docs/README.md`. Read the index before you open a page.
- A source lives in `docs/raw/`, and it is committed with the pages that cite it.
- A source that is a tracker ticket is a reference, not a download. Write a short reference that names the ticket, its quest type, its tracker link, and what it contributes. Copy no ticket body and no external page into `docs/raw/`.
- Link pages with relative markdown paths, as `[page-name](page-name.md)`.
- Make one change per commit. Write the commit message as the log entry: name what you ingested or changed, and what it touched. The repo keeps no `log.md`.
- Keep the tree flat until a cluster of pages forms around one topic. Then move the cluster into a subdirectory with its own `README.md`, and add that `README.md` to the root index.
- Every `README.md` lists every page in its own directory, and the root `README.md` also links each subdirectory's `README.md`.
- Add a dated update instead of rewriting the earlier entry. When a page becomes a run of dated updates, propose a compaction.

## 1. Ingest

Bring a source into the wiki, and make the pages that cite it stay true.

1. Read the source in full. A source is a document, a design discussion, a benchmark run, or a tracker ticket.
2. Write the source's reference in `docs/raw/`. For a ticket, write the short reference the operating rules describe. For any other source, save the file, or write the reference when the source lives elsewhere.
3. Find the pages the source bears on: the ones it extends, corrects, or contradicts. Update every one of them in the same pass, and link the source's reference from each page.
4. Write a new page when the source is a subject no page covers. Add it to the `README.md` of its directory with one line saying what it holds.
5. Commit the whole change with a message that records what you ingested and what it touched.

Done when the source has a reference in `docs/raw/`, every page it bears on links that reference, and you have committed the change.

## 2. Query

Answer a question from what the wiki holds, and keep what the answer teaches.

1. Read `docs/README.md`, then open the pages that answer the question. Follow their relative links.
2. Answer from the pages, and name the pages you used.
3. When the answer settles something the wiki did not hold, append a dated note to the page that covers it. When it settles something no page covers, write the page and add it to the `README.md` of its directory.
4. Commit the change with a message that records what the answer settled.

Done when the question is answered from the wiki, and either the wiki already held the answer or you have committed the change.

## 3. Lint

Find what has decayed. Change nothing.

1. Check every `README.md` against its directory: every page in the directory appears in its `README.md`, and every link in the `README.md` resolves.
2. Check that the root `README.md` links every subdirectory's `README.md`.
3. Check that every page's relative links resolve to a file that exists.
4. Read each page against the code and against its neighbours. Flag a page that contradicts the code, repeats another page, or has become a run of dated updates.
5. Report each finding as the page, the line, and the problem. Propose the repair, and leave the repair to Compact.

Done when every page has been read against the code and its neighbours, and every finding names a page, a line, and a problem.

## 4. Compact

Repair the wiki. Lint finds the problems. Compact repairs them.

1. Take the findings from Lint, and the pages you noticed were unrelated.
2. Rewrite a page that has decayed. Merge its dated updates into one account, and drop the dates that only mark their order.
3. Merge pages that turned out to be one subject. Delete pages that no longer matter, and fix every inbound link in the same pass.
4. Promote a cluster of related pages into a subdirectory with its own `README.md`, and add it to the root index.
5. Commit each repair as its own change with a message that records what it fixed.

Suggest a compaction when you notice a page whose parts no longer fit together, even when the human did not ask. The agent reads the wiki more often than the human does, so write for the agent first.

Done when every finding from Lint is repaired or refused with a reason, the inbound links to every moved, merged, or deleted page resolve, and you have committed each repair.
