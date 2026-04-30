---
name: sdlc-domain-design
description: "Stabilize the SDLC domain conceptual model (Steps/Flows ontology) before execution mapping. Produces canonical Step & Flow definitions + open decisions + cross-domain artifact contract."
version: "0.1"
tags: ["sdlc", "domain-design", "ontology-first", "architecture-aware"]
inputs:
  - id: source_spec
    description: "Attach the original SDLC conceptual document (source of truth)."
  - id: candidate_prd
    description: "Attach the latest PRD draft (optional). Use only as candidate material; do not treat as truth."
  - id: package_context
    description: "Optional: attach package docs/config (domain mapping, IDE mapping, architecture domain metadata)."
outputs:
  - id: domain_design_doc
    description: "A single 'SDLC Domain Design' document with canonical Steps/Flows, boundaries, open decisions, and cross-domain artifact contract."
  - id: step_catalog
    description: "Canonical Step Catalog (semantic responsibilities + IO + status)."
  - id: flow_catalog
    description: "Flow Catalog (goals + expected outcomes + recommended/optional steps; descriptive, not prescriptive)."
  - id: open_decisions
    description: "Explicit open decisions list (artifact storage, execution mapping, etc.)."
---

# SDLC Domain Design Workflow (Ontology-First)

## 0) Guardrails (Non-negotiable)
You MUST follow these rules throughout:
1) **Source of Truth**: The attached SDLC conceptual document is authoritative. The PRD is only a candidate draft.
2) **Step Identity**: A Step is a canonical semantic unit. If responsibility or outputs differ, it is NOT the same Step.
3) **Flow = Composite Skill**: A Flow is an executable composite skill orchestrating Step skills. It is NOT a rigid pipeline with mandatory sequencing.
4) **No Execution Lock-in**: Do NOT define runtime/orchestration, IDE-specific behavior, or file placement as "final".
5) **Contextual Completeness**: Do not optimize for “full completeness”; optimize for correct conceptual boundaries.

If any section in the draft violates these, you MUST flag it and propose a correction.

---

## 1) Ingest & Index Inputs
### 1.1 Read `source_spec` (mandatory)
- Extract the exact canonical definitions:
  - Vision statements
  - Step definition (Input/Output/Status; not a gate/policy/approval)
  - Step taxonomy (Thinking/Contracting/Validation/Learning)
  - Flow definition and "Flow is NOT" constraints
  - Canonical Step List (names + one-liners)
  - Suggested Flow List (names + goals)

### 1.2 Read `candidate_prd` (optional)
- Extract only potential reusable parts:
  - Config patterns (e.g., .dev-extensions.config.yaml concept)
  - Cross-domain discovery logic (architecture artifacts)
  - Artifact materialization options
- Mark each extracted part as one of:
  - ✅ aligns with source_spec
  - ⚠️ partially aligns (needs edits)
  - ❌ conflicts with source_spec (must not be adopted)

### 1.3 Read `package_context` (optional)
If provided, extract:
- How domains exist and are loaded (domain mapping)
- IDE mapping conventions
- Architecture domain output structure & metadata index concept

---

## 2) Canonical Step Catalog (Stabilize Ontology)
### 2.1 Start from the canonical Step List in `source_spec`
- Reproduce the Step list exactly as canonical names (do not invent new names unless strictly required).
- For each Step, define:
  - **Semantic Responsibility (single sentence)**
  - **Input schema (bulleted)**
  - **Output schema (bulleted)**
  - **Status**: complete | needs-human
  - **Tag(s)**: Thinking / Contracting / Validation / Learning

### 2.2 Anti-drift check (critical)
- Scan the PRD draft (if provided) for any Step name reuse with different semantics.
- If found:
  - Propose either:
    - a new Step name (if semantics differ), OR
    - a split into multiple Steps (if one draft step hides multiple responsibilities)
- Explicitly reject “mode-based” Steps that change identity across contexts.

**Deliverable:** `step_catalog`

---

## 3) Canonical Flow Catalog (Conceptual, Descriptive)
### 3.1 Start from `source_spec` suggested flows (if present)
For each Flow:
- **Flow goal**
- **Expected outcome**
- **Recommended Steps** (set, not mandatory sequence)
- **Optional/Conditional Steps**
- **User Guidance** (why these Steps matter)
- Explicitly include: "Flows are descriptive, not prescriptive"

### 3.2 Flow/Workflow separation check
- If any draft content turns flows into executable pipelines or fixed sequences:
  - Rewrite it into recommended/optional steps.
  - Move execution concerns into `open_decisions` (not into Flow definitions).

**Deliverable:** `flow_catalog`

---

## 4) Cross-Domain Artifact Contract (Architecture ↔ SDLC)
### 4.1 Define artifact consumption rules (conceptual)
- The SDLC domain MAY consume artifacts from the Architecture domain if they exist.
- Missing artifacts are a valid state; do not treat as error.
- When missing, the SDLC Steps must explicitly surface gaps and gather required info from:
  - user input
  - code/context inspection
  - or suggest running architecture intake

### 4.2 Use metadata-first reading pattern (if available)
If architecture metadata index exists, prefer reading metadata first, then only needed sections.

**Deliverable:** a section inside `domain_design_doc` titled “Cross-Domain Artifact Contract”.

---

## 5) Artifact Materialization (Open Decision + Configurable)
### 5.1 State the open decision explicitly
- The target directory structure in the host project for SDLC artifacts is NOT finalized.
- The design MUST support configurability.

### 5.2 Propose options (without choosing)
Provide 2–3 candidate patterns, e.g.:
- artifacts/{domain}/{identifier}/...
- docs/{domain}/...
- configurable base_path + per-domain override

### 5.3 Config contract (conceptual, not implementation)
Define what config must express (conceptually):
- base path
- per-domain override
- identifier pattern
- how other domains discover it

**Deliverable:** `open_decisions` + section inside `domain_design_doc`.

---

## 6) Human Gate: Design Review Checkpoint (needs-human)
Produce a short checklist that the human (you) must approve:
- Step Catalog has no identity drift
- Flows remain conceptual (not executable)
- Cross-domain contract is consistent
- Open decisions are explicit (not assumed)

Mark unresolved items as `needs-human` with concrete questions.

---

## 7) Final Output Assembly
Create the following artifacts (as markdown text outputs):
1) `domain_design_doc` with sections:
   - Vision (add only what is missing; do not rewrite unnecessarily)
   - Definitions: Step / Flow / Tags
   - Canonical Step Catalog (summary + reference)
   - Canonical Flow Catalog
   - Cross-Domain Artifact Contract
   - Artifact Materialization & Configurability (Open Decisions)
   - Non-goals / Boundaries
   - Human Gate Checklist
2) `step_catalog`
3) `flow_catalog`
4) `open_decisions`

IMPORTANT: Keep this as a domain design document, not an execution plan.
