# Workflow — SDLC Stage 2: Content Scaffolding (Refactored)

## Intent
Produce the **Content Scaffolding layer** for the SDLC package:
- A stable set of **Step files** (one per canonical Step)
- A stable set of **Flow files** (Phase 1 only)
- Folder-level **agent.md contracts** that teach any LLM how to generate/maintain content in `steps/` and `flows/`

This workflow is **ontology-preserving** and must not drift into implementation.

---

## Inputs (must be present in context)

### 1) sdlc-domain-design.md
Read these sections:
- A.4 Canonical Definition of a Step
- A.6 Canonical Definition of a Flow
- A.7 Conceptual Model vs. Execution Model
- B. Conceptual Contracts
- C. Canonical Step Catalog
- D. Canonical Flow Catalog
- I. Open Decisions

### 2) sdlc-execution-mapping-windsurf.md
Read these sections:
- B. Phase 1 Flow Overview
- C. Step Realization Matrix

---

## Global Constraints (non‑negotiable)
- Do NOT add/remove/rename/split/merge Steps.
- Do NOT add/remove/rename/redefine Flows.
- Do NOT write prompt text, workflow sequences, or skill implementations.
- Do NOT encode execution ordering (no step numbering, arrows, “then/next/first”).
- Do NOT silently resolve any Open Decision; if a decision is open, treat it as a constraint.

---

# Phase 2a — Format Decision (Human‑in‑the‑Loop)

## Goal
Explicitly decide the **file format** for Step files and Flow files.
This phase produces a **proposal** + requires **human selection**.
No scaffolding files are written in this phase.

## 2a.1 — Identify relevant Open Decisions
From `sdlc-domain-design.md` section "I. Open Decisions", extract only the items that impact:
- Step file/schema structure
- Flow file/schema structure
- Any other decision that would change how Steps/Flows should be represented as files

Summarize them as constraints (do not solve them).

## 2a.2 — Propose 2–3 Step file format options
Create 2–3 options that are valid given the constraints.
For each option, provide:
- **Structure** (small example showing metadata + body)
- **Pros**
- **Cons**
- **Best when** (what maturity/team/tooling it fits)

Recommended candidates to consider (do not assume these are chosen):
- Option S1: YAML frontmatter + Markdown body (human+LLM friendly)
- Option S2: Pure Markdown (minimal, very human friendly, less machine strict)
- Option S3: Structured YAML/JSON (machine strict, tooling friendly, less readable)

## 2a.3 — Propose 2–3 Flow file format options
Create 2–3 options that are valid given the constraints.
For each option, provide:
- **Structure**
- **Pros**
- **Cons**
- **Best when**
Ensure the format supports the core rule: **Flows are not pipelines** (sets, not sequences).

## HUMAN GATE (must stop here)
Do not proceed until the human explicitly provides:
- Selected Step file format: S1/S2/S3 (or a modified variant)
- Selected Flow file format: F1/F2/F3 (or a modified variant)

Record the chosen formats as:
- `CHOSEN_STEP_FORMAT`
- `CHOSEN_FLOW_FORMAT`

---

# Phase 2b — Content Scaffolding (Deterministic)

## Goal
Generate the scaffolding artifacts using the chosen formats.
This phase is deterministic: extract canonical data → project into files → validate.

---

## Output Spec (must be produced)

Create this tree:

steps/
- agent.md
- <13 step files>

flows/
- agent.md
- <5 phase‑1 flow files>

---

## 2b.1 — Generate steps/agent.md (folder contract)
Create `steps/agent.md` with these required contents:

- **Purpose**: This folder contains canonical Step scaffolds derived from the SDLC ontology.
- **Source of truth**: Step names and semantics come only from `sdlc-domain-design.md` (Canonical Step Catalog).
- **File naming rule**: lowercase + hyphenated derived from Step name.
- **Required structure**: Describe `CHOSEN_STEP_FORMAT` as the canonical format.
- **Allowed content**: ontology-level metadata + conceptual guidance.
- **Forbidden content** (must list explicitly):
  - prompts
  - workflow sequences
  - skills implementation
  - tool-specific instructions
  - file paths inside conceptual input/output
  - any change to step identity or semantics
- **Quality rules**:
  - include “What This Step Is NOT” to prevent drift (gate/pipeline/orchestration misconceptions)
  - keep content descriptive, not procedural

---

## 2b.2 — Generate flows/agent.md (folder contract)
Create `flows/agent.md` with these required contents:

- **Purpose**: This folder contains Phase 1 Flow scaffolds derived from the SDLC ontology.
- **Source of truth**: Flow definitions come only from `sdlc-domain-design.md` (Canonical Flow Catalog).
- **Scope**: Only Phase 1 flows listed in `sdlc-execution-mapping-windsurf.md` (Phase 1 Flow Overview).
- **Required structure**: Describe `CHOSEN_FLOW_FORMAT` as the canonical format.
- **Core rule**: Flows are **goal-oriented guidance**, not pipelines (Steps are a set, not an ordered sequence).
- **Forbidden content** (must list explicitly):
  - ordering (“Step 1/2/3”, “then/next/first”)
  - branching logic / orchestration semantics
  - prompts / implementation
  - governance/approval mechanics
- **Quality rules**:
  - include “What This Flow Does NOT Do” and explicitly mention “not a pipeline”

---

## 2b.3 — Generate Step files (exactly 13)
From `sdlc-domain-design.md` section "C. Canonical Step Catalog":
- Extract the complete list of canonical Steps (all 13)
- For each Step, extract:
  - name
  - tag
  - default execution intent
  - conceptual input
  - conceptual output
  - semantic responsibility sentence

From `sdlc-execution-mapping-windsurf.md` section "C. Step Realization Matrix":
- For each Step used in Phase 1, extract realization type (prompt/workflow/skill) as a **metadata hint only**
- Do not translate realization type into implementation content

Create `steps/<step-name>.md` for each of the 13 Steps using `CHOSEN_STEP_FORMAT`.
Each Step file MUST include:
- canonical name (exact)
- tag
- default execution intent
- conceptual input/output (no file paths, no tools)
- semantic responsibility
- short conceptual explanation
- explicit “What This Step Is NOT” (gate/pipeline/orchestration/tool behavior)

---

## 2b.4 — Generate Flow files (Phase 1 only, exactly 5)
From `sdlc-execution-mapping-windsurf.md` section "B. Phase 1 Flow Overview":
- Extract the Phase 1 Flow names (exactly 5)

For each Phase 1 Flow, from `sdlc-domain-design.md` section "D. Canonical Flow Catalog":
- Extract:
  - goal
  - expected outcome
  - recommended steps (as a set)
  - optional steps (as a set, if present)
  - user guidance constraints (especially “not a pipeline” behavior)

Also from `sdlc-execution-mapping-windsurf.md`:
- Extract the entry command for the flow as **metadata only**

Create `flows/<flow-name>.md` for each of the 5 Phase 1 Flows using `CHOSEN_FLOW_FORMAT`.
Each Flow file MUST include:
- goal + expected outcome
- recommended steps as a **set** (no ordering words, no numbering)
- optional steps only if explicitly listed
- “What This Flow Does NOT Do” including:
  - not a pipeline
  - not mandatory ordering
  - not implementation
