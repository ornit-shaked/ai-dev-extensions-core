---
name: "Constraints & Assumptions Identification"
tag: "Thinking"
execution_intent: "agent-assisted"
semantic_responsibility: "Identifies constraints, assumptions, and operational boundaries."
input:
  conceptual: "Problem statement, goals, existing context (technical, organizational, regulatory)."
output:
  conceptual: "Explicit list of constraints (hard limits) and assumptions (beliefs to validate)."
status:
  complete: "Constraints and assumptions are documented"
  needs_human: "Assumptions need validation or constraints are unclear"
prompt: |
  You are helping identify constraints and assumptions that shape the solution space.
  
  **Input:** Problem statement, goals, existing context (technical, organizational, regulatory).
  
  **Task:**
  1. Identify **constraints** (hard limits that cannot be violated):
     - Technical constraints (platform limits, performance requirements, compatibility)
     - Business constraints (budget, timeline, resource availability)
     - Regulatory constraints (compliance, privacy, security requirements)
  2. Identify **assumptions** (beliefs that need validation):
     - User behavior assumptions
     - Technical capability assumptions
     - Business condition assumptions
  3. Distinguish between constraints (unchangeable) and assumptions (testable)
  4. Surface implicit beliefs that stakeholders may hold
  
  **Output format:**
  - **Constraints** (bullet list with categories): Hard boundaries that limit the solution space
  - **Assumptions** (bullet list): Beliefs that need validation, with indication of how to validate
  - **Boundary Implications**: What is in/out of scope based on these constraints
  
  **Examples:**
  - Constraint: "Must support IE11 (regulatory requirement)"
  - Assumption: "Users will have stable internet connection (needs validation via analytics)"
---

# Constraints & Assumptions Identification

## What This Step Does

This Step surfaces and documents the limits and beliefs that shape solution space. **Constraints** are hard boundaries that cannot be violated (technical limits, regulations, resource caps). **Assumptions** are beliefs that need validation (user behavior, technical capabilities, business conditions).

Making constraints and assumptions explicit prevents late-stage surprises and enables informed decision-making.

**When this Step is needed:**
- During PRD creation or technical planning
- Before option generation (to bound the solution space)
- When entering a new domain or technology
- When stakeholders have different implicit assumptions

## What This Step Is NOT

- **NOT a gate** — documents boundaries, doesn't enforce them
- **NOT dependent on execution order** — can run independently
- **NOT a tool-specific operation** — focuses on reasoning about limits
- **NOT orchestration logic** — does not manage other Steps
- **NOT risk management** — identifies boundaries, doesn't assess probability or impact

## Conceptual Guidance

### Typical Inputs
- Problem statement and goals
- Technical context (existing systems, platforms, languages)
- Organizational context (team size, timeline, budget)
- Regulatory or compliance requirements
- Stakeholder beliefs about what is possible

### Typical Outputs
- **Constraints**: Technical limits, regulatory requirements, resource caps, hard deadlines
- **Assumptions**: Beliefs about user behavior, system capabilities, external dependencies
- **Boundaries**: What is in/out of scope based on constraints

### Relationship to Other Steps
- **Follows:** Problem Framing, Goal & Success Definition (problems and goals reveal constraints)
- **Informs:** Option Generation (constraints bound the solution space)
- **May trigger:** Context Assembly (to validate assumptions)

### Common Patterns
- **Technical constraints**: Performance limits, platform restrictions, compatibility requirements
- **Business constraints**: Budget, timeline, resource availability
- **Regulatory constraints**: Compliance, privacy, security requirements
- **Assumptions to validate**: User needs, technical feasibility, external API behavior
