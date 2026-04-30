---
name: "Incident / Deviation Analysis"
tag: "Learning"
execution_intent: "agent-assisted"
semantic_responsibility: "Analyzes failures, deviations, or mismatches between expectation and reality."
input:
  conceptual: "Observed deviation or incident; expected behavior; relevant context."
output:
  conceptual: "Root cause analysis, contributing factors, impact assessment."
status:
  complete: "Analysis performed with findings"
  needs_human: "Root cause ambiguous or requires domain expertise"
prompt: |
  You are analyzing an incident or deviation to understand why it happened.
  
  **Input:** Observed deviation or incident (what went wrong), expected behavior (what should have happened), observations (from Observation & Monitoring), context.
  
  **Task:**
  1. Reconstruct the timeline of events leading to the incident
  2. Identify the **root cause** (primary reason for the deviation)
  3. Identify **contributing factors** (secondary factors that enabled or worsened the issue)
  4. Assess **impact** (what was affected, severity, duration)
  5. Use "5 Whys" technique to reach root cause (ask "why" iteratively)
  6. Avoid blame assignment - focus on system factors, not individuals
  
  **Output format:**
  - **Timeline**: Sequence of events leading to the incident
  - **Root Cause**: Primary reason for the deviation
  - **Contributing Factors**: Secondary factors that enabled the issue
  - **Impact Assessment**: What was affected, severity, duration
  - **Analysis Method**: How root cause was determined (e.g., "5 Whys")
  
  **Analysis principles:**
  - Blameless approach - focus on system factors, not people
  - Multiple causes - identify both root cause and contributors
  - Evidence-based - ground analysis in observations, not speculation
  - Iterative questioning - use "5 Whys" to go deeper
---

# Incident / Deviation Analysis

## What This Step Does

Incident / Deviation Analysis investigates failures, unexpected behavior, or mismatches between what was expected and what actually happened. It seeks to understand **why** something went wrong and what factors contributed.

This Step is **agent-assisted** because it requires evidence assembly (agent) and root cause validation (human expertise).

**When this Step is needed:**
- After production incidents or outages
- When test failures occur
- When actual results deviate from expected
- During post-implementation review (if issues occurred)

## What This Step Is NOT

- **NOT a gate** — analyzes incidents, doesn't block work
- **NOT dependent on execution order** — can run independently
- **NOT blame assignment** — focuses on understanding, not accountability
- **NOT orchestration logic** — doesn't manage other Steps
- **NOT prevention** — analyzes past events, doesn't implement fixes

## Conceptual Guidance

### Typical Inputs
- Observed deviation or incident (what went wrong)
- Expected behavior (what should have happened)
- Observations (from Observation & Monitoring)
- Context (system state, recent changes, environment)

### Typical Outputs
- **Root cause**: Primary reason for the deviation
- **Contributing factors**: Secondary factors that enabled or worsened the issue
- **Impact assessment**: What was affected, severity, duration
- **Timeline**: Sequence of events leading to the incident

### Relationship to Other Steps
- **Follows:** Observation & Monitoring (observations feed analysis)
- **Precedes:** Learning & Improvement (analysis informs improvements)
- **May trigger:** Specification updates (if specs were incorrect)

### Common Patterns
- **5 Whys**: Iteratively ask "why" to reach root cause
- **Timeline reconstruction**: Map events to understand sequence
- **Contributing factors**: Identify multiple causes, not just one
- **Blameless analysis**: Focus on system factors, not individual errors
