---
name: "Goal & Success Definition"
tag: "Thinking"
execution_intent: "agent-assisted"
semantic_responsibility: "Defines measurable success criteria and 'done' boundaries for the problem."
input:
  conceptual: "Problem statement, stakeholder expectations, business objectives."
output:
  conceptual: "Specific, measurable success criteria and definition of done."
status:
  complete: "Success criteria are specific, measurable, and agreed upon"
  needs_human: "Stakeholders disagree on what 'success' means"
prompt: |
  You are helping define measurable success criteria for a problem or initiative.
  
  **Input:** Problem statement (what is wrong, who is affected, why it matters); stakeholder expectations if available.
  
  **Task:**
  1. Propose 3-5 specific, measurable success criteria
  2. Define "definition of done" (when is this work complete?)
  3. Identify explicit non-goals (what is out of scope)
  4. Ensure criteria are measurable (quantifiable or objectively verifiable)
  5. Align criteria with business objectives and user needs
  
  **Output format:**
  - **Success Criteria** (bullet list): Specific, measurable conditions that must be met
  - **Definition of Done** (1 paragraph): Clear boundary for completion
  - **Non-Goals** (bullet list): What is explicitly out of scope
  
  **Examples of good criteria:**
  - "Reduce page load time by 50% (from 4s to 2s)"
  - "Users can complete checkout in under 2 minutes"
  - "Zero critical bugs in production for 30 days"
  
  **Anti-patterns to avoid:**
  - Vague criteria ("make it faster", "improve UX")
  - Technical metrics without user impact
  - Criteria that can't be objectively verified
---

# Goal & Success Definition

## What This Step Does

Goal & Success Definition translates a problem statement into concrete, measurable outcomes. It answers: "How will we know we've solved this problem?" and "What does 'done' look like?"

This Step produces success criteria that are specific, measurable, and aligned with stakeholder expectations. It bridges the gap between understanding a problem and planning a solution.

**When this Step is needed:**
- After Problem Framing, to translate problem into actionable goals
- When writing a PRD or defining an Epic
- When stakeholders need alignment on what "success" means
- Before committing resources to implementation

## What This Step Is NOT

- **NOT a gate** — does not approve or block work
- **NOT dependent on execution order** — can run independently
- **NOT a tool-specific operation** — focuses on reasoning about outcomes
- **NOT orchestration logic** — does not manage other Steps
- **NOT a solution design** — defines outcomes, not implementation approach

## Conceptual Guidance

### Typical Inputs
- Problem statement (what is wrong, who is affected, why it matters)
- Stakeholder expectations or business objectives
- Existing metrics or KPIs (if available)
- Constraints that impact what "success" can realistically mean

### Typical Outputs
- **Success criteria**: Specific, measurable conditions that must be met
- **Measurable outcomes**: Quantifiable improvements or results
- **Definition of done**: Clear boundary for when the work is complete
- **Non-goals**: What is explicitly out of scope for this success definition

### Relationship to Other Steps
- **Follows:** Problem Framing (problems inform goals)
- **Precedes:** Constraints & Assumptions Identification (goals reveal constraints)
- **Informs:** Option Evaluation & Decision (goals are evaluation criteria)

### Common Patterns
- **Quantifiable metrics**: "Reduce load time by 50%" vs. "make it faster"
- **User-centric outcomes**: "Users can complete task X in Y seconds" vs. technical metrics
- **Business alignment**: Success criteria tied to business objectives, not just technical completeness
