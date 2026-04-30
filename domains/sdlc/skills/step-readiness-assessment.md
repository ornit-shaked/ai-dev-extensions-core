---
name: "Readiness Assessment"
tag: "Validation"
execution_intent: "agent-assisted"
semantic_responsibility: "Assesses whether the current state is ready to progress, highlighting gaps and risks."
input:
  conceptual: "Current state of artifacts, specifications, and context; criteria for progression."
output:
  conceptual: "Readiness report: ready / not-ready, with gaps, risks, and recommendations."
status:
  complete: "Assessment performed"
  needs_human: "Readiness decision requires human judgment"
prompt: |
  You are assessing whether the current state is ready to progress to the next phase.
  
  **Input:** Current state of artifacts (code, docs, specs, tests), specifications, context, progression criteria (what "ready" means).
  
  **Task:**
  1. Evaluate readiness against criteria:
     - **Completeness**: Are required artifacts present and complete?
     - **Quality**: Do artifacts meet specifications and standards?
     - **Dependencies**: Are prerequisites resolved?
     - **Risks**: Are there known blockers or concerns?
  2. Identify gaps:
     - What is missing
     - What is incomplete
     - What is unclear or uncertain
  3. Assess risks:
     - Technical risks (untested code, unclear requirements)
     - Process risks (missing approvals, unresolved conflicts)
     - Resource risks (dependencies on unavailable systems/people)
  4. Provide recommendation: Ready / Not Ready / Ready with Risks
  5. Document what should be done if not ready
  
  **Output format:**
  - **Readiness Status**: Ready / Not Ready / Ready with Risks
  - **Gaps**: What is missing or incomplete
  - **Risks**: Known concerns or blockers
  - **Recommendations**: What should be done before progressing (if not ready)
  
  **Note:** Provide assessment and recommendation, but human makes the final go/no-go decision.
---

# Readiness Assessment

## What This Step Does

Readiness Assessment evaluates whether the current state is sufficient to progress to the next phase. It surfaces gaps, risks, and missing prerequisites before committing to the next step.

This Step is **agent-assisted** because it assembles evidence, but humans make the final go/no-go decision.

**When this Step is needed:**
- Before implementation begins (Prepare for Implementation)
- Before PR merge (PR Review)
- Before release (Release Preparation)
- At milestone checkpoints

## What This Step Is NOT

- **NOT a gate** — provides assessment, doesn't enforce gates
- **NOT dependent on execution order** — can run independently
- **NOT approval** — reports readiness, doesn't approve work
- **NOT orchestration logic** — doesn't manage other Steps
- **NOT risk acceptance** — identifies risks, doesn't accept them

## Conceptual Guidance

### Typical Inputs
- Current state of artifacts (code, docs, specs, tests)
- Specifications and acceptance criteria
- Context (dependencies, prerequisites, constraints)
- Progression criteria (what "ready" means for next phase)

### Typical Outputs
- **Readiness status**: Ready / not ready / ready with risks
- **Gaps**: What is missing or incomplete
- **Risks**: Known issues or concerns
- **Recommendations**: What should be done before progressing

### Relationship to Other Steps
- **Follows:** Artifact Validation (validation informs readiness)
- **Used by:** Prepare for Implementation, PR Review (readiness drives go/no-go)
- **May trigger:** Additional work (if gaps identified)

### Common Patterns
- **Pre-implementation readiness**: Specs complete, dependencies resolved, environment ready
- **Pre-merge readiness**: Tests pass, reviews complete, conflicts resolved
- **Pre-release readiness**: Docs complete, deployment tested, rollback plan ready
