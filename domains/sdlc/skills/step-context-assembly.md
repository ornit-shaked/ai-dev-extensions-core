---
name: "Context Assembly"
tag: "Thinking"
execution_intent: "agent-executed"
semantic_responsibility: "Collects and consolidates all relevant existing knowledge."
input:
  conceptual: "Problem scope, goals, constraints; pointers to existing artifacts (architecture docs, specs, codebase)."
output:
  conceptual: "Consolidated context summary: what is known, what is missing, what is uncertain."
status:
  complete: "Sufficient context assembled to proceed"
  needs_human: "Critical knowledge gaps identified"
prompt: |
  You are gathering and consolidating all relevant existing knowledge for this work.
  
  **Input:** Problem scope, goals, pointers to existing artifacts (architecture docs, specs, codebase, previous PRDs).
  
  **Task:**
  1. Read and summarize existing artifacts:
     - Architecture documentation (system design, decisions, constraints)
     - Existing specifications or PRDs
     - Codebase structure and relevant implementations
     - Previous decisions or related work
  2. Identify what is known vs. what is missing
  3. Surface gaps, inconsistencies, or uncertainties
  4. Consolidate information into a coherent summary
  5. Use configurable artifact paths (don't assume fixed locations)
  
  **Output format:**
  - **Known Information**: Summary of what exists (architecture decisions, specs, implementations)
  - **Missing Information**: Gaps in documentation, unclear requirements, undocumented decisions
  - **Uncertain Information**: Conflicting sources, assumptions that need validation
  - **Context Summary**: Consolidated view of current state
  
  **Graceful degradation:**
  - If artifacts are missing, note the gap (don't fail)
  - If multiple sources conflict, list all perspectives
  - If paths are invalid, report and continue
---

# Context Assembly

## What This Step Does

Context Assembly gathers and synthesizes all relevant existing knowledge before reasoning or decision-making begins. It reads architecture documentation, existing specifications, codebase, previous decisions, and any other artifacts that inform the current work.

The output is a consolidated view: what is known, what is missing, and what is uncertain. This prevents reinventing existing solutions and surfaces knowledge gaps early.

**When this Step is needed:**
- At the start of most Flows (Create PRD, Technical Planning, PR Review, etc.)
- Before generating options or making decisions
- When entering an existing codebase or system
- When stakeholders have incomplete information

## What This Step Is NOT

- **NOT a gate** — surfaces gaps, doesn't block progression
- **NOT dependent on execution order** — can run independently
- **NOT a tool-specific operation** — conceptually reads artifacts, not tied to specific tools
- **NOT orchestration logic** — does not manage other Steps
- **NOT implementation** — gathers knowledge, doesn't execute changes

## Conceptual Guidance

### Typical Inputs
- Problem scope and goals (what knowledge is relevant)
- Pointers to existing artifacts: architecture docs, specs, PRD, codebase
- Cross-domain artifacts (e.g., architecture domain outputs)
- Previous decisions or related work

### Typical Outputs
- **Known information**: Existing specs, architecture decisions, codebase structure
- **Missing information**: Gaps in documentation, unclear requirements, undocumented decisions
- **Uncertain information**: Assumptions that need validation, conflicting sources
- **Summary**: Consolidated view of the current state

### Relationship to Other Steps
- **Precedes:** Most other Steps (context informs reasoning)
- **Consumes:** Outputs from Architecture domain, previous SDLC Flows
- **May trigger:** Problem Framing (if context reveals problem is unclear)

### Common Patterns
- **Architecture consumption**: Read `_metadata.yaml` to assess architecture completeness
- **Graceful degradation**: Missing information is valid — surface gaps, don't fail
- **Cross-domain discovery**: Locate artifacts via configurable paths, not hardcoded
