---
name: "Specification / Contract Definition"
tag: "Contracting"
execution_intent: "agent-assisted"
semantic_responsibility: "Defines contracts, interfaces, boundaries, and required behaviors."
input:
  conceptual: "Decisions, plan, constraints, relevant domain context."
output:
  conceptual: "Formal or semi-formal specification: interfaces, boundaries, acceptance criteria, behavioral expectations."
status:
  complete: "Specification is reviewable and testable"
  needs_human: "Ambiguities in scope or interface"
prompt: |
  You are defining the contracts, interfaces, and requirements for implementation.
  
  **Input:** Decisions (from Option Evaluation), plan (from Plan & Decomposition), constraints, context, success criteria.
  
  **Task:**
  1. Define **interfaces** (API signatures, function contracts, data structures)
  2. Define **boundaries** (what is in/out of scope for this component)
  3. Define **acceptance criteria** (testable conditions for "done")
  4. Define **behavioral expectations** (how the system should behave in different scenarios)
  5. Define **non-functional requirements** (performance, security, reliability)
  6. Use Given/When/Then format for acceptance criteria where appropriate
  
  **Output format:**
  - **Interfaces**: API definitions, function signatures, data contracts
  - **Boundaries**: What this component/feature does vs. doesn't do
  - **Acceptance Criteria**: Given/When/Then testable conditions
  - **Behavioral Expectations**: Normal flow, edge cases, error handling
  - **Non-Functional Requirements**: Performance targets, security requirements, reliability SLAs
  
  **Specification principles:**
  - Be specific enough to implement and test
  - Define "what" not "how" (implementation details)
  - Make acceptance criteria testable
  - Cover edge cases and error scenarios
---

# Specification / Contract Definition

## What This Step Does

Specification / Contract Definition produces formal or semi-formal documentation that defines **what** must be built: interfaces, boundaries, acceptance criteria, and behavioral expectations. It creates the contract between design and implementation.

This Step translates decisions and plans into concrete, testable requirements that implementation can follow and validation can verify.

**When this Step is needed:**
- During PRD creation (to define requirements)
- After Technical Planning (to specify implementation contracts)
- Before implementation begins (to clarify expectations)
- When defining APIs, interfaces, or system boundaries

## What This Step Is NOT

- **NOT a gate** — defines contracts, doesn't approve work
- **NOT dependent on execution order** — can run independently
- **NOT implementation** — defines what to build, not how
- **NOT orchestration logic** — doesn't manage other Steps
- **NOT detailed design** — specifies behavior, not internal structure

## Conceptual Guidance

### Typical Inputs
- Decisions (from Option Evaluation & Decision)
- Plan (from Plan & Decomposition)
- Constraints (from Constraints & Assumptions Identification)
- Context (from Context Assembly)
- Success criteria (from Goal & Success Definition)

### Typical Outputs
- **Interfaces**: API definitions, function signatures, data contracts
- **Boundaries**: What is in/out of scope for this component
- **Acceptance criteria**: Testable conditions for "done"
- **Behavioral expectations**: How the system should behave in different scenarios
- **Non-functional requirements**: Performance, security, reliability expectations

### Relationship to Other Steps
- **Follows:** Plan & Decomposition (plan informs specifications)
- **Precedes:** Artifact Validation (specs are validation criteria)
- **Informs:** Implementation work (specs guide coding)

### Common Patterns
- **Interface-first design**: Define contracts before implementation
- **Acceptance criteria**: Given/When/Then format for testable requirements
- **Boundary definition**: What this component does vs. what it doesn't
- **Error handling**: Expected behavior for edge cases and failures
