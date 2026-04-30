---
name: sdlc-generate-execution-mapping
description: "Generate Phase 1 Execution Mapping (Windsurf) directly from the canonical SDLC Domain Design. Produces a tool-specific realization plan without altering ontology."
version: "1.0"
tags: ["sdlc", "execution-mapping", "windsurf", "phase-1"]
inputs:
  - id: domain_design
    description: "Attach: sdlc-domain-design.md (canonical SDLC Domain Design — source of truth)."
outputs:
  - id: execution_mapping
    description: "sdlc-execution-mapping-windsurf.md — Phase 1 execution mapping document."
---

# SDLC → Execution Mapping (Phase 1)

## 0) Guardrails (Non‑Negotiable)
- The attached **SDLC Domain Design** is the **single source of truth**.
- Do **not** rename, merge, split, or redefine Steps or Flows.
- Do **not** introduce new conceptual entities.
- Execution Mapping must:
  - Respect **Execution Intent** defaults
  - Be **Windsurf‑specific**, but **ontology‑agnostic**
- This workflow produces **a mapping document**, not runnable code.

If a conflict arises, prefer the Domain Design and record the conflict as a note.

---

## 1) Select Phase 1 Scope
### 1.1 Identify Phase 1 Flows
From the Flow Catalog, select the Phase 1 set (as defined in §OD‑5):
- Create PRD
- Technical Planning
- Prepare for Implementation
- Generate Tasks
- PR Review

Do not add or remove Flows.

---

## 2) Resolve Execution Realization per Step
For **each Step** referenced by Phase 1 Flows:

### 2.1 Read Default Execution Intent
Use the **Execution Intent Map** from the Domain Design.

### 2.2 Choose a Windsurf Realization Type
Map the Step to **one** realization type:

- **Prompt**  
  For reasoning, drafting, analysis, or decision‑support Steps.

- **Workflow**  
  For multi‑step guided interactions, orchestration of several prompts, or repeated patterns.

- **Skill**  
  For reusable, callable capabilities (e.g., reading artifacts, validating structure).

> Rules:
> - Prefer **Prompt** by default.
> - Use **Workflow** only if interaction spans multiple turns or assets.
> - Use **Skill** only for reusable, side‑effect‑free capabilities.

Record the rationale for each choice.

---

## 3) Map Each Phase 1 Flow
For each Flow:

### 3.1 Define User Entry Point
- Command or intent name (e.g., `/create-prd`, `/review-pr`).

### 3.2 Describe Execution Composition
- List the **Steps involved** (referencing canonical names).
- For each Step:
  - Realization type (Prompt / Workflow / Skill)
  - Execution intent alignment (human‑led / agent‑assisted / agent‑executed)

### 3.3 Human Gates
- Identify where `needs-human` gating applies.
- Describe gating conceptually (review, approval, confirmation).

Do **not** define file paths, engines, or scripts.

---

## 4) Produce the Execution Mapping Document
Create `sdlc-execution-mapping-windsurf.md` with this structure:

### A. Purpose & Scope
- Phase 1 only
- Windsurf‑specific
- Ontology‑preserving

### B. Phase 1 Flow Overview
- Table: Flow → Goal → Entry Command

### C. Step Realization Matrix
- Table: Step → Default Intent → Realization Type → Rationale

### D. Flow‑by‑Flow Execution Mapping
For each Phase 1 Flow:
- Entry command
- Steps involved
- Execution composition
- Human gates

### E. Non‑Goals
- Not runnable code
- Not final UX
- Not governance

---

## 5) Final Validation
Before emitting the document, verify:
- No Step or Flow definitions were altered
- All mappings trace back to Domain Design sections
- Execution details remain descriptive, not prescriptive

Add a closing statement:

> “This document maps SDLC ontology to Windsurf execution for Phase 1 only.  
> Changes to ontology must be made in the SDLC Domain Design.”

---

## 6) Emit Output
Output only:
- `sdlc-execution-mapping-windsurf.md`