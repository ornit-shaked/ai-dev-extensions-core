---
flow: "Create PRD"
goal: "Produce a clear, pre-implementation Product Requirements Document."
expected_outcome: "A PRD defining scope, goals, requirements, non-goals, and success criteria."
entry_command: "/create-prd"
recommended_steps:
  - "Problem Framing"
  - "Goal & Success Definition"
  - "Constraints & Assumptions Identification"
  - "Context Assembly"
  - "Option Generation"
  - "Option Evaluation & Decision"
  - "Specification / Contract Definition"
optional_steps: []
---

# Create PRD

## User Guidance

Use this Flow when you need to produce a Product Requirements Document before architecture or implementation work begins. A PRD defines **what** to build — not **how** to build it.

**When to use:**
- At the start of a new feature or initiative
- When stakeholders need alignment on scope and goals
- Before committing resources to design or implementation
- When an existing idea needs formal definition

**What this Flow produces:**
- Problem statement and context
- Goals and success criteria
- Constraints and assumptions
- Solution approach (chosen from alternatives)
- Requirements and acceptance criteria
- Explicit non-goals and scope boundaries

**Prerequisites:**
- Stakeholder availability for problem clarification and decision-making
- Sufficient context about the problem domain (or willingness to assemble it)

## Recommended Steps (Set — No Fixed Order)

This Flow typically involves these Steps. They provide **guidance**, not a mandatory sequence. The actual order depends on what information you have and what you need to discover.

- **Problem Framing** — Clarify what problem you're solving before proposing solutions
- **Goal & Success Definition** — Define measurable success criteria
- **Constraints & Assumptions Identification** — Surface limits and beliefs that shape the solution space
- **Context Assembly** — Gather existing knowledge (architecture, specs, codebase)
- **Option Generation** — Explore solution alternatives before committing
- **Option Evaluation & Decision** — Choose an approach with documented rationale
- **Specification / Contract Definition** — Define requirements, interfaces, and acceptance criteria

**Common patterns:**
- Start with Problem Framing if the problem is unclear
- Start with Context Assembly if you're working in an existing system
- Option Generation may be skipped if the solution approach is already decided
- Specification may happen in multiple iterations (outline → detail)

## What This Flow Does NOT Do

- **NOT a pipeline** — Steps are guidance, not a mandatory sequence
- **NOT an approval mechanism** — produces a PRD, doesn't approve work
- **NOT an implementation guide** — defines what to build, not how to build it
- **NOT tool-specific orchestration** — conceptual Flow, not execution engine
- **NOT governance** — doesn't enforce gates or sign-offs
