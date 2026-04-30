# Flows Directory — Agent Contract

## Purpose

This directory contains **Phase 1 Flow skills** derived from the SDLC ontology.

Flows are goal-oriented, user-facing composite skills that guide users toward concrete outcomes by orchestrating multiple Step skills. They are **descriptive, not prescriptive** — they provide guidance, not execution pipelines.

## Source of Truth

- **Flow definitions:** `tasks/ai-dev-extensions-core/sdlc-domain-design.md` (Canonical Flow Catalog §D)
- **Phase 1 scope:** `tasks/ai-dev-extensions-core/sdlc-execution-mapping-windsurf.md` (Phase 1 Flow Overview §B)
- **File format:** `tasks/ai-dev-extensions-core/sdlc-content-scaffolding-phase2-decisions.md`

## Scope

**Phase 1 only** — exactly 5 Flows:
1. Create PRD
2. Technical Planning
3. Prepare for Implementation
4. Generate Tasks
5. PR Review

Additional Flows from the canonical catalog (8 more) will be added in Phase 2+.

## File Naming Convention

**Rule:** Lowercase + hyphenated, derived from canonical Flow name

Examples:
- "Create PRD" → `create-prd.md`
- "Technical Planning" → `technical-planning.md`
- "PR Review" → `pr-review.md`

## Required Structure

Every Flow file must use this structure:

```yaml
---
flow: "<Canonical Flow Name>"
goal: "<What the user is trying to achieve>"
expected_outcome: "<Concrete result produced by completing the Flow>"
entry_command: "<Windsurf command (metadata hint only)>"
recommended_steps:
  - "<Step Name 1>"
  - "<Step Name 2>"
  # ... unordered set, not a sequence
optional_steps:
  - "<Step Name (if applicable)>"
---

# <Flow Name>

## User Guidance

[When to use this Flow, what it produces, prerequisites, typical scenarios]

## Recommended Steps (Set — No Fixed Order)

[Natural language explanation of which Steps are typically needed and why — emphasize they are guidance, not mandatory sequence]

## Optional Steps

[Steps that may be skipped, repeated, or included based on context]

## What This Flow Does NOT Do

- NOT a pipeline or mandatory sequence
- NOT an approval or governance mechanism
- NOT an implementation guide
- NOT tool-specific orchestration
```

## Field Definitions

| Field | Type | Valid Values | Required | Description |
|-------|------|--------------|----------|-------------|
| `flow` | string | One of 5 Phase 1 Flow names | ✅ Yes | Canonical Flow name from Domain Design §D |
| `goal` | string | Exact from Domain Design §D | ✅ Yes | What the user is trying to achieve |
| `expected_outcome` | string | Exact from Domain Design §D | ✅ Yes | Concrete result produced by completing the Flow |
| `entry_command` | string | Windsurf command (e.g., `/create-prd`) | ⚠️ Metadata | Tool hint — not part of ontology; from Execution Mapping §B |
| `recommended_steps` | array | List of canonical Step names | ✅ Yes | **Unordered set** — guidance, not mandatory; from Domain Design §D |
| `optional_steps` | array | List of canonical Step names | ⚠️ Optional | Steps that may be skipped/repeated; from Domain Design §D |

### Phase 1 Flow Names (All 5)

From Execution Mapping §B:
1. **Create PRD** — Produce a clear, pre-implementation Product Requirements Document
2. **Technical Planning** — Translate decisions into an implementation plan and task breakdown
3. **Prepare for Implementation** — Ensure all prerequisites for implementation are in place
4. **Generate Tasks** — Produce a structured, actionable task list from existing definitions
5. **PR Review** — Assess and improve a proposed change before merge

## Core Rule: Flows Are NOT Pipelines

**CRITICAL:** Flows are goal-oriented guidance, not execution pipelines.

### What This Means

- **Recommended Steps are a SET, not a sequence** — they can be executed in any order, skipped, or repeated
- **No mandatory ordering** — users/agents decide execution order based on context
- **No orchestration semantics** — Flows do not manage state, retries, or branching logic
- **Not executable** — Flows are conceptual; execution is handled separately

### How to Prevent Pipeline Drift

1. **In YAML:** The `recommended_steps` array is a list of names, not a numbered sequence
2. **In prose:** Always use "Set — No Fixed Order" label when describing Steps
3. **In guidance:** Emphasize "typically needed" or "commonly useful", not "must run in order"
4. **In validation:** Check for ordering language ("Step 1/2/3", "first/then/next", "→")

## Allowed Content

✅ Flow files **may** include:
- Ontology-level metadata (from Domain Design)
- Goal-oriented guidance (when to use, what to expect)
- Recommended Steps **as a set** (no ordering)
- Conceptual relationships between Steps
- Entry command **as metadata hint** (not execution requirement)
- Prerequisites or typical scenarios

## Forbidden Content

❌ Flow files **must NOT** include:
- Ordering language ("Step 1/2/3", "first/then/next", "→", "before/after")
- Branching logic or orchestration semantics ("if X then Y")
- Prompts or prompt text (prompts belong in Step files, not Flow files)
- Workflow sequences or implementation details
- Governance/approval mechanics
- Tool-specific execution instructions
- Any implication that Steps must run in sequence
- State management or retry logic

**Note:** Prompts are tool-agnostic and belong in Step files. Flows only reference Steps and provide conceptual guidance.

## Quality Rules

### 1. Identity Preservation
- Flow `flow` name must match Domain Design §D exactly
- `goal` and `expected_outcome` must be exact quotes from Domain Design
- No renaming or redefining Flows

### 2. Set Semantics (Not Sequence)
- Always label Steps as "Set — No Fixed Order" in prose
- No numbered lists or ordering words
- Emphasize guidance, not mandatory execution

### 3. Anti-Pipeline Protection
- Always include "What This Flow Does NOT Do" section
- Explicitly state: "NOT a pipeline or mandatory sequence"
- Prevent common misconceptions about Flow behavior

### 4. Consistency
- All `recommended_steps` must be canonical Step names from Domain Design §C
- `entry_command` matches Execution Mapping §B (Windsurf-specific, Phase 1 only)

## How to Add a New Flow (Phase 2+)

**Important:** You cannot add new Flows without checking the Domain Design and Execution Mapping first.

If you need to add a Flow from the canonical catalog:
1. Verify the Flow exists in Domain Design §D (all 13 Flows are canonical)
2. Check if the Flow is already in Phase 1 scope (Execution Mapping §B)
3. If it's a new Phase (Phase 2+), update Execution Mapping first
4. Extract metadata from Domain Design §D (goal, outcome, Steps)
5. Use the structure template exactly
6. Validate against checklist before committing

**Do NOT invent new Flows.** All Flow names come from the canonical catalog in Domain Design §D.

## How to Modify an Existing Flow

**Important:** Flow semantics cannot change. Only these modifications are allowed:

**Allowed:**
- Clarify user guidance (if ambiguous)
- Add examples of typical scenarios
- Expand "What This Flow Does NOT Do" to prevent drift

**Forbidden:**
- Change `flow` name, `goal`, or `expected_outcome`
- Change `recommended_steps` list (this is defined in Domain Design §D)
- Add ordering or sequencing language
- Add execution details or tool-specific logic

If you need semantic changes, update the Domain Design first.

## Validation Checklist

Before committing a Flow file:
- [ ] `flow` name matches one of 5 Phase 1 Flows from Execution Mapping §B
- [ ] `goal` and `expected_outcome` match Domain Design §D exactly
- [ ] All `recommended_steps` are canonical Step names (from Domain Design §C)
- [ ] No ordering language in prose sections (no "Step 1/2/3", "first/then/next", "→")
- [ ] "What This Flow Does NOT Do" section present with "not a pipeline" explicit
- [ ] `entry_command` is metadata only (not execution requirement)
- [ ] No prompts, workflows, or implementation logic
- [ ] "Set — No Fixed Order" label present when describing Steps

## Relationship to Execution Layer

**Flows are ontology, not execution.**

The execution realization of Flows (workflows, orchestration) is defined separately in the execution layer. See:
- `tasks/ai-dev-extensions-core/sdlc-execution-mapping-windsurf.md` for Phase 1 mapping
- Future: `domains/sdlc/workflows/` (not yet created)

**This directory contains scaffolds only** — conceptual definitions that execution artifacts will implement.

## Common Mistakes to Avoid

### ❌ Mistake: Treating YAML array as ordered sequence

**Wrong:**
```markdown
## Steps
1. First, run Problem Framing
2. Then, run Context Assembly
3. Finally, run Specification
```

**Correct:**
```markdown
## Recommended Steps (Set — No Fixed Order)

This Flow typically involves:
- Problem Framing
- Context Assembly
- Specification / Contract Definition

These Steps provide guidance. The actual order depends on context.
```

### ❌ Mistake: Adding execution logic

**Wrong:**
```yaml
recommended_steps:
  - "Problem Framing"
  - "if user provides PRD, skip to Context Assembly"
  - "Context Assembly"
```

**Correct:**
```yaml
recommended_steps:
  - "Problem Framing"
  - "Context Assembly"
optional_steps:
  - "Problem Framing"  # May be skipped if PRD already exists
```

### ❌ Mistake: Assuming tool-specific behavior

**Wrong:**
```markdown
Run `/create-prd` to execute this Flow in Windsurf.
```

**Correct:**
```yaml
---
entry_command: "/create-prd"  # Windsurf metadata hint only
---

Use this Flow when you need to produce a PRD. The Flow guides thinking, not execution.
```
