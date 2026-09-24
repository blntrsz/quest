---
name: <bare-type-name>
description: <What this quest delivers and when to use it, in one line.>
# Include only when the workflow uses abilities:
# abilities:
#   - <ability-name>
---

[In one short paragraph, state the outcome this quest type delivers and its scope.]

[Optional: add a second paragraph for a mental model, scope boundary, or context that helps throughout the workflow.]

## Operating rules (optional)

- [Use for rules that apply across multiple steps, such as approval boundaries or source-of-truth requirements. Remove this section if there are none.]

1. **[First action-oriented stage].** [Describe what to do, the source of truth, and any decision or approval that affects the next step. Name the expected output.] Done when [observable condition for completing this stage].
2. **[Next stage].** [Describe the next dependent action and its relevant constraints or branches.] Done when [observable condition for completing this stage].
3. **[Further stage, if needed].** [Add, remove, or reorder steps to fit the workflow; use nested bullets for meaningful branches or parallel work. Delete this placeholder if it does not apply.] Done when [observable condition for completing this stage].

## Output (optional)

[Describe the required artifact, report shape, or handoff details not already clear from the steps. Keep actions such as recording, publishing, or seeking approval in the ordered workflow. Remove this section if it adds nothing.]

## Done when (optional)

[State the overall completion condition when it is not already clear from the final workflow step.]
