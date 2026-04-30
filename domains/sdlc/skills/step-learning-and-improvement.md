---
name: "Learning & Improvement"
tag: "Learning"
execution_intent: "human-led"
semantic_responsibility: "Distills insights and updates knowledge, assumptions, contracts, or future Steps."
input:
  conceptual: "Analysis results, observations, historical patterns."
output:
  conceptual: "Actionable improvements: updated assumptions, revised contracts, process changes, knowledge base updates."
status:
  complete: "Improvements documented"
  needs_human: "Proposed changes require review before adoption"
prompt: |
  You are distilling insights from analysis and observations into actionable improvements.
  
  **Input:** Analysis results (from Incident / Deviation Analysis), observations (from Observation & Monitoring), historical patterns, stakeholder feedback.
  
  **Task:**
  1. Identify improvement opportunities:
     - **Updated assumptions**: Beliefs that proved incorrect and need revision
     - **Revised contracts**: Specifications or interfaces that need adjustment
     - **Process changes**: Workflow or practice improvements
     - **Knowledge base updates**: Documentation of new patterns or anti-patterns
  2. Propose specific, actionable improvements
  3. Document rationale for each proposed change
  4. Prioritize by impact and effort (human decides what to adopt)
  5. Avoid over-correction or premature optimization
  
  **Output format:**
  - **Updated Assumptions**: Beliefs that need revision based on evidence
  - **Revised Contracts**: Specifications or interfaces that need adjustment (with rationale)
  - **Process Changes**: Workflow improvements with expected benefits
  - **Knowledge Updates**: Patterns, anti-patterns, or lessons to document
  - **Recommendations**: Prioritized list of proposed improvements (human decides adoption)
  
  **Improvement principles:**
  - Evidence-based - ground in observations, not speculation
  - Actionable - specific enough to implement
  - Prioritized - not all improvements are equal
  - Avoid over-correction - balance learning with stability
  
  **Note:** This is human-led - propose improvements with rationale, but human makes final decisions on adoption.
---

# Learning & Improvement

## What This Step Does

Learning & Improvement distills insights from analysis and observations into actionable improvements. It updates knowledge, revises assumptions, refines contracts, and proposes process changes based on what was learned.

This Step is **human-led** because deciding which improvements to adopt requires judgment about cost, priority, and strategic alignment.

**When this Step is needed:**
- After incident analysis (to prevent recurrence)
- During post-implementation review (to capture lessons)
- For continuous improvement (to optimize processes)
- When patterns emerge from multiple observations

## What This Step Is NOT

- **NOT a gate** — proposes improvements, doesn't enforce them
- **NOT dependent on execution order** — can run independently
- **NOT automatic adoption** — requires human review before changes
- **NOT orchestration logic** — doesn't manage other Steps
- **NOT retrospective facilitation** — focuses on improvement proposals, not team dynamics

## Conceptual Guidance

### Typical Inputs
- Analysis results (from Incident / Deviation Analysis)
- Observations (from Observation & Monitoring)
- Historical patterns (from previous improvements)
- Stakeholder feedback

### Typical Outputs
- **Updated assumptions**: Beliefs that proved incorrect and need revision
- **Revised contracts**: Specifications or interfaces that need adjustment
- **Process changes**: Workflow or practice improvements
- **Knowledge base updates**: Documentation of new patterns or anti-patterns
- **Proposed improvements**: Changes requiring human review before adoption

### Relationship to Other Steps
- **Follows:** Incident / Deviation Analysis, Observation & Monitoring
- **May update:** Specifications, assumptions, constraints
- **Informs:** Future iterations of the same Flows

### Common Patterns
- **Assumption validation**: Update beliefs based on evidence
- **Anti-pattern documentation**: Record what didn't work and why
- **Process refinement**: Adjust workflows based on friction points
- **Knowledge capture**: Document lessons for future reference
