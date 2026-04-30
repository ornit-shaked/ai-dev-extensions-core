# SDLC Domain

Canonical Software Development Lifecycle processes as AI-executable skills.

## Overview

The SDLC domain provides structured, agent-compatible development workflows covering the full lifecycle from problem framing through implementation and review.

**Key Principles:**
- **Ontology-driven** - Steps and Flows are conceptual units, not rigid processes
- **Agent-compatible** - Designed for AI execution with human collaboration
- **Contextual completeness** - Sufficiency over exhaustiveness
- **Adaptive guidance** - Descriptive, not prescriptive

## Structure

```
domains/sdlc/
├── skills/
│   ├── flow-*.md          # Composite skills (Flows)
│   └── step-*.md          # Atomic skills (Steps)
├── .domain-metadata.yaml
└── README.md (this file)
```

## Available Flows

Flows are composite skills that orchestrate Steps to achieve a goal.

### flow-create-prd.md
**Produce pre-implementation Product Requirements Document**

Entry command: `/create-prd`

Orchestrates:
- Problem Framing
- Goal & Success Definition
- Constraints & Assumptions
- Context Assembly
- Option Generation
- Option Evaluation & Decision
- Specification / Contract Definition

### flow-technical-planning.md
**Translate decisions into implementation plan**

Entry command: `/technical-planning`

Orchestrates:
- Context Assembly
- Plan & Decomposition
- Specification / Contract Definition

### flow-prepare-for-implementation.md
**Ensure prerequisites for implementation are in place**

Entry command: `/prepare-implementation`

Orchestrates:
- Context Assembly
- Readiness Assessment

### flow-generate-tasks.md
**Produce structured, actionable task list**

Entry command: `/generate-tasks`

Orchestrates:
- Context Assembly
- Plan & Decomposition
- Specification / Contract Definition

---

## Available Steps

Steps are atomic skills that perform single units of work.

### Thinking Steps
- **step-problem-framing.md** - Frame problem with context and impact
- **step-goal-and-success-definition.md** - Define measurable success criteria
- **step-option-generation.md** - Generate solution alternatives
- **step-option-evaluation-and-decision.md** - Evaluate options and decide

### Contracting Steps
- **step-constraints-and-assumptions-identification.md** - Surface constraints, validate assumptions
- **step-specification-contract-definition.md** - Define specifications and contracts
- **step-plan-and-decomposition.md** - Break down work into tasks

### Validation Steps
- **step-context-assembly.md** - Gather and consolidate existing knowledge
- **step-readiness-assessment.md** - Assess readiness for next phase
- **step-artifact-validation.md** - Validate artifacts against specs

### Learning Steps
- **step-learning-and-improvement.md** - Extract learnings and improvements
- **step-incident-deviation-analysis.md** - Analyze incidents and deviations
- **step-observation-and-monitoring.md** - Monitor and observe outcomes

---

## Usage

### For AI Agents

Skills are automatically discovered by Windsurf when the domain is loaded.

**Invoking a Flow:**
```
User: /create-prd
Agent reads: domains/sdlc/skills/flow-create-prd.md
Agent executes: recommended_steps in sequence
```

**Invoking a Step:**
```yaml
# In Flow frontmatter:
recommended_steps:
  - "Problem Framing"  # Agent loads step-problem-framing.md
```

### For Humans

Each skill file contains:
- **YAML frontmatter** - Structured metadata (prompt, inputs, outputs)
- **Markdown body** - Human-readable documentation

---

## File Format

All skills use **Markdown with YAML frontmatter**:

**Atomic Skill (Step):**
```yaml
---
name: "Context Assembly"
tag: "Thinking"
execution_intent: "agent-executed"
prompt: |
  You are gathering and consolidating...
---

# Context Assembly

[Documentation here]
```

**Composite Skill (Flow):**
```yaml
---
flow: "Create PRD"
goal: "Produce pre-implementation PRD"
entry_command: "/create-prd"
recommended_steps:
  - "Problem Framing"
  - "Goal & Success Definition"
  # ...
---

# Create PRD

[Documentation here]
```

---

## Design Documents

- **Ontology Design:** `tasks/ai-dev-extensions-core/sdlc-domain-design.md`
- **Execution Mapping:** `tasks/ai-dev-extensions-core/sdlc-execution-mapping-windsurf.md`

---

## Adding New Skills

1. Create `skills/step-{name}.md` or `skills/flow-{name}.md`
2. Follow existing format (YAML frontmatter + markdown)
3. Update `.domain-metadata.yaml` with new skill entry
4. Add documentation to this README

---

## Dependencies

- **architecture domain** - SDLC Flows reference architecture artifacts

---

## Metadata

- **Priority:** 2 (loads after _core and architecture)
- **Created:** 2026-04-19
- **Version:** 1.0.0
