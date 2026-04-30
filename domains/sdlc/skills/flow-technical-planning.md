---
flow: "Technical Planning"
goal: "Translate decisions into an implementation plan and task breakdown."
expected_outcome: "A plan with ordered work units, dependencies, and estimates."
entry_command: "/technical-planning"
recommended_steps:
  - "Context Assembly"
  - "Plan & Decomposition"
  - "Specification / Contract Definition"
optional_steps:
  - "Constraints & Assumptions Identification"
  - "Readiness Assessment"
---

# Technical Planning

## User Guidance

Use this Flow when you need to translate high-level decisions (from a PRD or architecture) into an actionable implementation plan. This Flow produces a task breakdown with dependencies and estimates.

**When to use:**
- After a PRD or architecture decisions are in place
- During sprint planning or development kickoff
- When breaking down an Epic into implementable units
- Before starting implementation work

**What this Flow produces:**
- Work breakdown structure (tasks, stories, milestones)
- Dependencies between work units
- Implementation specifications with acceptance criteria
- Rough effort estimates (if appropriate)

**Prerequisites:**
- Existing decisions (PRD, architecture, or chosen solution approach)
- Sufficient context about the system being modified
- Understanding of team capacity and constraints

## Recommended Steps (Set — No Fixed Order)

This Flow typically involves these Steps. They provide **guidance**, not a mandatory sequence.

- **Context Assembly** — Gather existing PRD, architecture decisions, specs, and codebase context
- **Plan & Decomposition** — Break the solution into logical work units with dependencies
- **Specification / Contract Definition** — Define detailed specs and acceptance criteria for each work unit

**Optional Steps** (may be included based on context):
- **Constraints & Assumptions Identification** — If new constraints emerge during planning
- **Readiness Assessment** — To verify that planning prerequisites are sufficient

**Common patterns:**
- Context Assembly runs first to surface missing information
- Plan & Decomposition identifies high-level work structure
- Specification adds detail to each work unit
- May iterate between planning and specification as details emerge

## What This Flow Does NOT Do

- **NOT a pipeline** — Steps are guidance, not a mandatory sequence
- **NOT task assignment** — produces work breakdown, doesn't assign owners
- **NOT an implementation guide** — defines work structure, not how to code
- **NOT tool-specific orchestration** — conceptual Flow, not execution engine
- **NOT governance** — doesn't enforce timelines or resource allocation
