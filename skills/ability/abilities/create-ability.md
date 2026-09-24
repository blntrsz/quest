---
name: create-ability
description: Explain how to shape an ability's Markdown body around its job, using the repository template as a starting point. Use when drafting ability content.
---

This ability guides authors in shaping an ability's Markdown body around its task, producing clear, useful instructions. It covers body structure and writing choices; repository-wide conventions live in `skills/ability/SKILL.md`, and the authoring workflow is in `skills/create-ability/SKILL.md`.

Start from `skills/ability/TEMPLATE.md`, but do not treat it as a fixed outline. It includes YAML frontmatter and a Markdown body. Replace the metadata placeholders with the ability's kebab-case name and a single-line description, following `skills/ability/SKILL.md`.

Existing abilities include step-by-step workflows, operating rules, reference material, and combinations of those forms. Keep the body shape that makes each ability easiest to follow. Use an H1 when it helps readers navigate; omit it when it only repeats a clear opening sentence.

## Shape the body around the work

- **Open with the capability.** State the purpose, result, and scope. Add the mental model or relationship to another ability only when it helps the reader apply this one.
- **Use a procedure for ordered work.** Number actions that depend on one another. Give a prerequisite, a decision, or a stop condition where it changes what the reader does next.
- **Use grouped sections for rules and reference.** A catalog of rules, a set of techniques, and a lookup guide do not need to pretend to be a sequence of steps.
- **Make boundaries explicit when they matter.** Say what the ability may read or change, whether it reports or edits, and when it needs user approval. Name consequential commands, external access, publication, or deletion before those actions.
- **Describe the expected output when it has a required shape.** Give the report sections, artifact location, or handoff information only when the task depends on them.
- **Define completion in observable terms.** For a multi-step or consequential task, name the evidence that shows it is done. Use a `Done when` section when that makes the condition easier to find.

## Keep instructions useful

- Write actions so an agent can tell what to do and what result to look for. Use real paths, symbols, commands, and examples when the repository provides them.
- Include branches for decisions that materially change the procedure. Tell the agent when to continue, ask, stop, or report a blocker.
- Refer to another ability by name when it owns a distinct part of the work. Explain when to use it, and do not copy its full procedure.
- Attribute outside material when the ability depends on it. Include a source and retrieval date when freshness matters.
- Keep general ability conventions in `skills/ability/SKILL.md`; keep this ability's task-specific directions in its own file.

Do not copy every optional section into every ability. The common contract is clear metadata, a clear capability, and instructions shaped to that capability. Headings, examples, approval gates, output formats, and completion sections are tools to use when the work calls for them.
