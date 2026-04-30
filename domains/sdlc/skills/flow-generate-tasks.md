---
flow: "Generate Tasks"
goal: "Produce a structured, actionable task list from existing definitions."
expected_outcome: "A set of implementable tasks with acceptance criteria, dependencies, and estimates."
entry_command: "/generate-tasks"
recommended_steps:
  - "Context Assembly"
  - "Plan & Decomposition"
  - "Specification / Contract Definition"
optional_steps:
  - "Readiness Assessment"
---

# Generate Tasks

## User Guidance

Use this Flow when you need to produce detailed, actionable tasks from existing specifications or plans. This Flow is more granular than Technical Planning — it focuses on task-level detail.

**When to use:**
- For story creation and backlog refinement
- When breaking down planned work into sprint-sized tasks
- After Technical Planning produces a high-level plan
- Before task assignment or sprint planning

**What this Flow produces:**
- Detailed task list with clear scope per task
- Acceptance criteria for each task
- Dependencies between tasks
- Effort estimates (if appropriate)

**Prerequisites:**
- Existing specifications or plans (from PRD, Technical Planning, or Epic definition)
- Sufficient context about the system and requirements
- Understanding of what "task-sized" means for your team

## Recommended Steps (Set — No Fixed Order)

This Flow is similar to Technical Planning but focuses on finer-grained task breakdown.

- **Context Assembly** — Gather existing specs, plans, PRD, and architecture context
- **Plan & Decomposition** — Break work into task-level chunks with dependencies
- **Specification / Contract Definition** — Define acceptance criteria and scope per task

**Optional Steps** (may be included based on context):
- **Readiness Assessment** — Verify task completeness before submission to backlog

**Common patterns:**
- Context Assembly reads high-level plans and specs
- Plan & Decomposition produces task-level granularity
- Specification adds acceptance criteria per task
- Tasks should be small enough to complete in a short time (hours or days, not weeks)

## What This Flow Does NOT Do

- **NOT a pipeline** — Steps are guidance, not a mandatory sequence
- **NOT task assignment** — produces tasks, doesn't assign owners
- **NOT implementation** — defines tasks, doesn't execute them
- **NOT tool-specific orchestration** — conceptual Flow, not execution engine
- **NOT governance** — doesn't enforce sprint boundaries or velocity
