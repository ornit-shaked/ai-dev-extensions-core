---
name: "Option Evaluation & Decision"
tag: "Thinking"
execution_intent: "human-led"
semantic_responsibility: "Compares alternatives and arrives at a reasoned decision."
input:
  conceptual: "Solution alternatives, evaluation criteria (from goals/constraints)."
output:
  conceptual: "Reasoned decision with trade-off analysis and rationale."
status:
  complete: "Decision made with documented rationale"
  needs_human: "Trade-offs require human judgment"
prompt: |
  You are helping compare solution alternatives and document the decision rationale.
  
  **Input:** Solution alternatives (from Option Generation), evaluation criteria (from Goal & Success Definition), constraints.
  
  **Task:**
  1. Create a trade-off matrix comparing options on key criteria:
     - Cost (time, money, resources)
     - Risk (technical, business)
     - Time to value (quick win vs. long-term)
     - Flexibility (future changes)
     - Complexity (maintenance burden)
  2. Highlight differences and trade-offs between options
  3. Provide recommendation with rationale (but human makes final decision)
  4. Document what is being traded off and why
  5. Identify risks and mitigation strategies for the chosen approach
  
  **Output format:**
  - **Trade-off Matrix**: Table comparing options on key criteria
  - **Recommendation**: Suggested option with rationale
  - **Trade-offs**: What is being gained/sacrificed with this choice
  - **Risks Acknowledged**: Known limitations or concerns
  - **Decision Rationale** (after human decision): Why this option was chosen
  
  **Note:** This is human-led - provide analysis and recommendation, but the human makes the final decision.
---

# Option Evaluation & Decision

## What This Step Does

Option Evaluation & Decision compares solution alternatives against evaluation criteria and makes a reasoned choice. It makes trade-offs explicit and documents the rationale for the chosen approach.

This Step is **human-led** because it involves judgment, risk tolerance, and strategic alignment that machines cannot reliably make.

**When this Step is needed:**
- After Option Generation (to choose an approach)
- During PRD creation or technical planning
- When stakeholders need alignment on direction
- Before committing significant resources

## What This Step Is NOT

- **NOT a gate** — makes a decision, doesn't approve work
- **NOT dependent on execution order** — can run independently
- **NOT automated** — requires human judgment
- **NOT orchestration logic** — does not manage other Steps
- **NOT risk acceptance** — evaluates options, doesn't accept risk formally

## Conceptual Guidance

### Typical Inputs
- Solution alternatives (from Option Generation)
- Evaluation criteria (from Goal & Success Definition)
- Constraints (from Constraints & Assumptions Identification)
- Context (from Context Assembly)

### Typical Outputs
- **Chosen option**: The selected solution approach
- **Trade-off analysis**: How options compare on key criteria
- **Rationale**: Why this option was chosen over alternatives
- **Risks acknowledged**: Known trade-offs or limitations

### Relationship to Other Steps
- **Follows:** Option Generation (evaluates generated options)
- **Informs:** Plan & Decomposition, Specification (decision guides planning)
- **Uses:** Goal & Success Definition (goals are evaluation criteria)

### Common Patterns
- **Weighted criteria**: Evaluate options against prioritized criteria
- **Trade-off matrix**: Compare options across multiple dimensions
- **Risk vs. reward**: Balance potential benefits against implementation cost
- **Strategic alignment**: Choose options that align with long-term direction
