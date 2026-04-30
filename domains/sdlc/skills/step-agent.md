# Steps Directory — Agent Contract

## Purpose

This directory contains **canonical Step scaffolds** derived from the SDLC ontology.

Steps are atomic, runnable units of thinking or work. They are **ontology-level constructs**, not execution artifacts.

## Source of Truth

- **Step names and semantics:** `tasks/ai-dev-extensions-core/sdlc-domain-design.md` (Canonical Step Catalog §C)
- **File format:** `tasks/ai-dev-extensions-core/sdlc-content-scaffolding-phase2-decisions.md`
- **Execution mapping (Phase 1 only):** `tasks/ai-dev-extensions-core/sdlc-execution-mapping-windsurf.md`

## File Naming Convention

**Rule:** Lowercase + hyphenated, derived from canonical Step name

Examples:
- "Problem Framing" → `problem-framing.md`
- "Goal & Success Definition" → `goal-and-success-definition.md`
- "Context Assembly" → `context-assembly.md`

## Required Structure

Every Step file must use this structure:

```yaml
---
name: "<Canonical Step Name>"
tag: "<Thinking|Contracting|Validation|Learning>"
execution_intent: "<human-led|agent-assisted|agent-executed>"
semantic_responsibility: "<One sentence — invariant across all Flows>"
input:
  conceptual: "<What the Step needs to reason — concepts, not file paths>"
output:
  conceptual: "<What the Step produces — artifacts/decisions, not file formats>"
status:
  complete: "<When this Step is considered complete>"
  needs_human: "<When human intervention is required>"
---

# <Step Name>

## What This Step Does

[Conceptual explanation: purpose, reasoning approach, when it's needed]

## What This Step Is NOT

- NOT a gate or approval mechanism
- NOT dependent on execution order or time
- NOT a tool-specific operation
- NOT orchestration logic

## Conceptual Guidance

[Additional context: common patterns, typical inputs/outputs, relationship to other Steps]
```

## Field Definitions

| Field | Type | Valid Values | Required | Description |
|-------|------|--------------|----------|-------------|
| `name` | string | One of 13 canonical Step names from Domain Design §C | ✅ Yes | Immutable identifier — must match Domain Design exactly |
| `tag` | string | `Thinking`, `Contracting`, `Validation`, `Learning` | ✅ Yes | Step taxonomy classification |
| `execution_intent` | string | `human-led`, `agent-assisted`, `agent-executed` | ✅ Yes | Default automation posture (per Domain Design §E) |
| `semantic_responsibility` | string | Exact sentence from Domain Design | ✅ Yes | Single invariant responsibility — defines what the Step does |
| `input.conceptual` | string | Conceptual description (no file paths) | ✅ Yes | What the Step needs to reason |
| `output.conceptual` | string | Conceptual description (no file formats) | ✅ Yes | What the Step produces |
| `status.complete` | string | Description of completion criteria | ✅ Yes | When the Step is considered done |
| `status.needs_human` | string | Description of when human is needed | ✅ Yes | When human intervention is required |
| `prompt` | string (multiline) | Tool-agnostic LLM instructions with Input/Task/Output format | ✅ Yes | Instructions for LLM to execute this Step |

## Allowed Content

✅ Step files **may** include:
- Ontology-level metadata (from Domain Design)
- Conceptual guidance (what, why, when)
- Anti-patterns ("What This Step Is NOT")
- Relationships to other Steps (conceptual, not execution)
- Examples of conceptual inputs/outputs

## Prompt Text in Steps

✅ Step files **must** include a `prompt` field in YAML frontmatter with LLM instructions.

**Why prompts belong in Steps:**
- Prompt text is tool-agnostic (same text works in Windsurf, Cursor, or any LLM-based tool)
- Only orchestration wrappers (workflows/skills) are tool-specific
- The prompt defines HOW the Step talks to the LLM to achieve its semantic responsibility

**Prompt location:**
- **In YAML frontmatter** (structured data): `prompt: |` field

**Prompt structure:**
```yaml
---
prompt: |
  [Clear instructions for the LLM on how to execute this Step]
  
  **Input:** [What the LLM receives]
  **Task:** [What the LLM should do, step-by-step if needed]
  **Output format:** [Expected structure of the result]
---
```

**Note:** If a Step is invoked via Workflow (multi-turn) or Skill (wrapper), the prompt text still lives here in the Step file. The workflow/skill only handles orchestration.

---

## Forbidden Content

❌ Step files **must NOT** include:
- Workflow sequences or orchestration logic
- Skills implementation or code
- Tool-specific instructions (e.g., "run this command in Windsurf")
- File paths in input/output (use conceptual descriptions)
- Any change to Step identity or semantics from Domain Design
- Execution ordering or dependencies
- Governance or approval logic

## Quality Rules

### 1. Identity Preservation
- Step `name` must match Domain Design §C exactly
- `semantic_responsibility` must be exact quote from Domain Design
- No renaming, merging, splitting, or redefining Steps

### 2. Conceptual Purity
- Input/output descriptions are conceptual (not file-based)
- No execution details or tool assumptions
- Focus on "what" and "why", not "how"

### 3. Anti-Drift Protection
- Always include "What This Step Is NOT" section
- Explicitly state: NOT a gate, NOT a pipeline, NOT orchestration
- Prevent common misconceptions about Step behavior

### 4. Consistency
- `tag` and `execution_intent` must match Domain Design §E
- Status descriptions align with Domain Design definitions

## How to Add a New Step

**Important:** You cannot add new Steps without updating the Domain Design first.

If you believe a new Step is needed:
1. **Stop** — do not create the file yet
2. Propose the new Step in the Domain Design document
3. Follow the `/sdlc-domain-design` workflow to update the ontology
4. Only after the Domain Design is updated, create the Step file here

## How to Modify an Existing Step

**Important:** Step semantics cannot change. Only these modifications are allowed:

**Allowed:**
- Clarify conceptual guidance (if ambiguous)
- Add examples to illustrate input/output
- Expand "What This Step Is NOT" to prevent drift

**Forbidden:**
- Change `name`, `tag`, or `semantic_responsibility`
- Change `execution_intent` (this is defined in Domain Design §E)
- Add execution details or tool-specific logic
- Change conceptual input/output definitions

If you need semantic changes, update the Domain Design first.

## Validation Checklist

Before committing a Step file:
- [ ] `name` matches one of 13 canonical Steps from Domain Design §C
- [ ] `semantic_responsibility` is exact quote from Domain Design
- [ ] `tag` and `execution_intent` match Domain Design §E
- [ ] `input` and `output` are conceptual (no file paths, no tools)
- [ ] "What This Step Is NOT" section present
- [ ] No prompt text, workflow sequences, or implementation logic
- [ ] No deviation from canonical Step definition

## Relationship to Execution Layer

**Steps are ontology, not execution.**

The execution realization of Steps (prompts, workflows, skills) is defined separately in the execution layer. See:
- `tasks/ai-dev-extensions-core/sdlc-execution-mapping-windsurf.md` for Phase 1 mapping
- Future: `domains/sdlc/prompts/`, `domains/sdlc/workflows/`, `domains/sdlc/skills/` (not yet created)

**This directory contains scaffolds only** — conceptual definitions that execution artifacts will implement.
