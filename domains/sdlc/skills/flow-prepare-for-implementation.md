---
flow: "Prepare for Implementation"
goal: "Ensure all prerequisites for implementation are in place."
expected_outcome: "Confirmation that specs, designs, tasks, and context are sufficient to begin coding."
entry_command: "/prepare-implementation"
recommended_steps:
  - "Context Assembly"
  - "Readiness Assessment"
optional_steps:
  - "Artifact Validation"
---

# Prepare for Implementation

## User Guidance

Use this Flow right before coding starts to verify that all prerequisites are in place. This Flow surfaces gaps early rather than discovering them mid-implementation.

**When to use:**
- Before starting implementation on a feature or task
- After planning and specification are complete
- When transitioning from design to development
- To verify readiness before a sprint or milestone

**What this Flow produces:**
- Readiness report (ready / not-ready)
- Identified gaps in specs, designs, or context
- Recommended actions if not ready
- Confirmation that implementation can begin safely

**Prerequisites:**
- Existing specifications or acceptance criteria
- Design decisions or architecture guidance
- Task breakdown (from Technical Planning or Generate Tasks)

## Recommended Steps (Set — No Fixed Order)

This Flow is lightweight — it focuses on assessment rather than production work.

- **Context Assembly** — Gather all available artifacts (PRD, architecture, tasks, specs)
- **Readiness Assessment** — Evaluate whether prerequisites are sufficient to begin coding

**Optional Steps** (may be included based on context):
- **Artifact Validation** — Validate existing artifacts against specs before starting

**Common patterns:**
- Context Assembly surfaces missing information (docs, decisions, dependencies)
- Readiness Assessment produces a go/no-go recommendation
- If not ready: identifies what needs to be clarified or completed first
- If ready: confirms implementation can proceed

## What This Flow Does NOT Do

- **NOT a pipeline** — Steps are guidance, not a mandatory sequence
- **NOT an approval mechanism** — produces readiness assessment, doesn't approve work
- **NOT implementation** — verifies prerequisites, doesn't write code
- **NOT tool-specific orchestration** — conceptual Flow, not execution engine
- **NOT governance** — doesn't enforce gates or sign-offs
