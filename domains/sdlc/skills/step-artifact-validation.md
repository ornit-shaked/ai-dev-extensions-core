---
name: "Artifact Validation"
tag: "Validation"
execution_intent: "agent-executed"
semantic_responsibility: "Verifies that produced artifacts comply with specifications and decisions."
input:
  conceptual: "Artifact(s) to validate, applicable specifications/contracts/decisions."
output:
  conceptual: "Validation report: compliant / non-compliant, with specific findings."
status:
  complete: "Validation performed, results clear"
  needs_human: "Findings require human interpretation"
prompt: |
  You are validating artifacts against specifications and requirements.
  
  **Input:** Artifacts to validate (code, docs, designs, configs), specifications (from Specification / Contract Definition), decisions, acceptance criteria.
  
  **Task:**
  1. Check artifacts against specifications:
     - Interface compliance (APIs match contracts)
     - Acceptance criteria met (Given/When/Then conditions)
     - Architecture compliance (aligns with architecture decisions)
     - Documentation completeness (required docs present)
  2. Identify deviations:
     - What matches specification
     - What deviates from specification
     - What is missing
  3. Categorize findings by severity:
     - Critical (blocks functionality or violates hard requirements)
     - Major (significant deviation but workaround exists)
     - Minor (cosmetic or low-impact)
  4. Provide actionable recommendations for fixing issues
  
  **Output format:**
  - **Compliance Status**: Compliant / Non-compliant / Partially compliant
  - **Findings**:
    - ✅ **Compliant**: What matches specification
    - ❌ **Non-compliant**: What deviates (with severity)
    - ⚠️ **Missing**: What is absent
  - **Recommendations**: How to address non-compliance
  
  **Validation is mechanical:** Check against defined criteria, not subjective quality assessment.
---

# Artifact Validation

## What This Step Does

Artifact Validation checks produced artifacts (code, documentation, designs) against specifications, contracts, and decisions. It verifies compliance and surfaces deviations.

This Step is **agent-executed** because validation against specifications is largely mechanical — checking that artifacts meet defined criteria.

**When this Step is needed:**
- During PR Review (validate code against specs)
- After implementation (verify acceptance criteria)
- Before release (confirm artifacts are complete)
- When integrating components (validate interfaces)

## What This Step Is NOT

- **NOT a gate** — reports findings, doesn't block work
- **NOT dependent on execution order** — can run independently
- **NOT human judgment** — checks against specs, not quality assessment
- **NOT orchestration logic** — doesn't manage other Steps
- **NOT testing** — validates compliance, doesn't execute tests (though may use test results)

## Conceptual Guidance

### Typical Inputs
- Artifacts to validate (code, docs, designs, configs)
- Specifications (from Specification / Contract Definition)
- Decisions (from Option Evaluation & Decision)
- Acceptance criteria (from Goal & Success Definition)

### Typical Outputs
- **Compliance status**: Compliant / non-compliant / partially compliant
- **Specific findings**: What matches, what deviates, what is missing
- **Severity**: Critical / major / minor deviations
- **Recommendations**: How to address non-compliance

### Relationship to Other Steps
- **Follows:** Specification / Contract Definition (specs are validation criteria)
- **Used by:** PR Review, Readiness Assessment (validation informs readiness)
- **May trigger:** Artifact changes (if non-compliant)

### Common Patterns
- **Interface validation**: Verify APIs match contracts
- **Acceptance criteria check**: Confirm Given/When/Then conditions met
- **Architecture compliance**: Check alignment with architecture decisions
- **Documentation completeness**: Verify required docs present
