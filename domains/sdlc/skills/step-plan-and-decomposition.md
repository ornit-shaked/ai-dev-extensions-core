---
name: "Plan & Decomposition"
tag: "Thinking"
execution_intent: "agent-assisted"
semantic_responsibility: "Breaks decisions into logical, actionable units of work."
input:
  conceptual: "Chosen solution, constraints, available context."
output:
  conceptual: "Ordered set of work units (tasks, milestones, or deliverables) with dependencies."
status:
  complete: "Plan is actionable and decomposed"
  needs_human: "Decomposition granularity or dependencies unclear"
prompt: |
  You are breaking down a solution into logical, actionable work units.
  
  **Input:** Chosen solution (from Option Evaluation & Decision), constraints (timeline, resources, dependencies), available context.
  
  **Task:**
  1. Break solution into logical work units (tasks, stories, milestones)
  2. Identify dependencies between work units (what must be done before what)
  3. Consider incremental delivery (can parts be released independently?)
  4. Identify critical path (sequential work vs. parallel work)
  5. Provide rough sizing (complexity or effort estimates if appropriate)
  6. Structure for iterative delivery (avoid all-or-nothing)
  
  **Output format:**
  - **Work Units**: List of logical chunks (tasks, stories, or milestones)
  - **Dependencies**: What depends on what ("Task B requires Task A complete")
  - **Milestones**: Key checkpoints or deliverables
  - **Estimated Effort** (if appropriate): Rough sizing (S/M/L or hours/days)
  - **Delivery Strategy**: Incremental vs. big-bang, risk mitigation
  
  **Decomposition principles:**
  - Aim for small, testable increments
  - Minimize blocking dependencies
  - Enable parallel work where possible
  - Tackle high-risk/uncertain work early
---

# Plan & Decomposition

## What This Step Does

Plan & Decomposition transforms a chosen solution into an actionable plan by breaking it into logical work units. It identifies tasks, milestones, or deliverables and establishes dependencies between them.

This Step produces a structure that can be implemented incrementally rather than requiring everything at once.

**When this Step is needed:**
- After a solution decision has been made
- During Technical Planning or Epic definition
- When creating a task breakdown for a sprint
- Before implementation begins

## What This Step Is NOT

- **NOT a gate** — produces a plan, doesn't approve execution
- **NOT dependent on execution order** — can run independently
- **NOT task assignment** — defines work, doesn't assign ownership
- **NOT orchestration logic** — doesn't manage execution
- **NOT detailed design** — produces work structure, not implementation details

## Conceptual Guidance

### Typical Inputs
- Chosen solution (from Option Evaluation & Decision)
- Constraints (timeline, resources, dependencies)
- Available context (existing systems, team capabilities)
- Success criteria (what "done" means)

### Typical Outputs
- **Work units**: Logical chunks of work (tasks, stories, milestones)
- **Dependencies**: What must be done before what
- **Milestones**: Key checkpoints or deliverables
- **Estimated effort**: Rough sizing (if appropriate)

### Relationship to Other Steps
- **Follows:** Option Evaluation & Decision (decision informs plan)
- **Precedes:** Specification / Contract Definition (plan guides spec detail)
- **Informs:** Generate Tasks (high-level plan → detailed tasks)

### Common Patterns
- **Incremental delivery**: Break into releasable chunks
- **Critical path**: Identify sequential vs. parallel work
- **Risk mitigation**: Tackle uncertain work early
- **Dependency management**: Minimize blocking dependencies
