---
name: "Option Generation"
tag: "Thinking"
execution_intent: "agent-assisted"
semantic_responsibility: "Produces possible solution alternatives."
input:
  conceptual: "Problem statement, goals, constraints, assembled context."
output:
  conceptual: "A set of distinct solution alternatives with brief descriptions."
status:
  complete: "Meaningful alternatives generated"
  needs_human: "Domain expertise needed for viable options"
prompt: |
  You are generating distinct solution alternatives that address the problem.
  
  **Input:** Problem statement, goals, constraints, assembled context (existing systems, technologies, patterns).
  
  **Task:**
  1. Generate 2-5 distinct solution approaches
  2. Ensure alternatives have different trade-offs (not just minor variations)
  3. Consider multiple dimensions:
     - Build vs. buy vs. integrate
     - Incremental vs. big-bang delivery
     - Technology alternatives (platforms, languages, frameworks)
     - Architecture patterns (monolith, microservices, serverless)
  4. For each option, provide brief description and key trade-offs
  5. Avoid premature convergence or bias toward one solution
  
  **Output format:**
  - **Option 1**: [Name] - Brief description, key trade-offs
  - **Option 2**: [Name] - Brief description, key trade-offs
  - **Option 3**: [Name] - Brief description, key trade-offs
  - **Key Differences**: What distinguishes these options from each other
  
  **Good alternatives explore:**
  - Different levels of investment (quick fix vs. comprehensive solution)
  - Different technology choices
  - Different delivery strategies
  - Different sourcing approaches (build/buy/partner)
---

# Option Generation

## What This Step Does

Option Generation produces a set of distinct solution alternatives that address the problem within given constraints. It explores the solution space creatively before committing to a single approach.

Good option generation considers different trade-offs (cost/speed, complexity/flexibility, build/buy) and avoids premature convergence on a single solution.

**When this Step is needed:**
- During PRD creation (to explore solution approaches)
- Before major technical decisions
- When stakeholders disagree on approach
- When existing solutions have failed

## What This Step Is NOT

- **NOT a gate** — generates options, doesn't decide
- **NOT dependent on execution order** — can run independently
- **NOT evaluation** — produces alternatives without comparing them
- **NOT orchestration logic** — does not manage other Steps
- **NOT implementation** — describes options conceptually, not in detail

## Conceptual Guidance

### Typical Inputs
- Problem statement (what needs to be solved)
- Goals and success criteria (what "good" looks like)
- Constraints (what limits the solution space)
- Assembled context (existing systems, technologies, patterns)

### Typical Outputs
- **Solution alternatives**: 2-5 distinct approaches with different trade-offs
- **Brief descriptions**: High-level explanation of each option
- **Key differences**: What distinguishes each option

### Relationship to Other Steps
- **Follows:** Problem Framing, Context Assembly (problem and context inform options)
- **Precedes:** Option Evaluation & Decision (options are evaluated)
- **Bounded by:** Constraints & Assumptions (constraints limit viable options)

### Common Patterns
- **Build vs. buy vs. integrate**: Explore different sourcing strategies
- **Incremental vs. big-bang**: Different delivery approaches
- **Technology alternatives**: Different platforms, languages, frameworks
- **Architecture patterns**: Monolith, microservices, serverless, etc.
