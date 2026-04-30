---
name: sdlc-harvest-and-freeze
description: "Harvest relevant content from PRD drafts into a single canonical SDLC Domain Design doc, grounded in the source-of-truth ontology. Produces frozen artifacts + a harvest report."
version: "0.1"
tags: ["sdlc", "harvest", "canonicalize", "domain-design"]
inputs:
  - id: canonical_source
    description: "Attach: sdlc_thinking_stage_1.docx (canonical SDLC ontology)."
  - id: prd_draft
    description: "Attach: prd-ai-dev-extensions-core-sdlc.md (candidate PRD output)."
  - id: harvest_analysis
    description: "Attach: source_of_truth.md (extraction + anti-drift analysis + proposed structure)."
outputs:
  - id: domain_design_doc
    description: "Canonical SDLC Domain Design doc (single source for the SDLC domain)."
  - id: step_catalog
    description: "Canonical Step Catalog (13 steps) with IO schema and status."
  - id: flow_catalog
    description: "Canonical Flow Catalog (13 flows) as descriptive guidance."
  - id: open_decisions
    description: "Explicit list of open decisions + candidate options."
  - id: harvest_report
    description: "Traceability report: what was accepted/re-written/rejected from PRD and why."
---

# SDLC Harvest & Freeze (Ontology-First)

## 0) Non-negotiable Guardrails
1) The canonical source defines ontology. Do not change Step/Flow definitions.
2) The PRD draft is candidate material only.
3) No Step identity drift: if semantics differ, it is NOT the same step.
4) Flows are descriptive, not prescriptive; do not convert flows into executable pipelines.
5) This workflow outputs DESIGN ARTIFACTS (markdown docs), not implementation plans.

If conflicts exist, prefer the canonical source and document conflicts in the harvest report.

---

## 1) Build Canonical Baseline (from canonical_source + harvest_analysis)
### 1.1 Extract and freeze:
- Canonical Step list (13 steps) + step definition constraints
- Canonical Flow list (13 flows) + flow definition constraints
- Taxonomy tags
### 1.2 Output immediately:
- `step_catalog` (canonical)
- `flow_catalog` (canonical)

NOTE: Do not introduce new step names or flow names.

---

## 2) Harvest Candidate Material (from prd_draft using harvest_analysis rules)
### 2.1 Categorize every relevant PRD section into:
- ACCEPT (aligned as-is)
- ADAPT (idea aligned but wording/structure violates ontology; must rewrite)
- REJECT (conflicts with canonical ontology or introduces premature execution mapping)

### 2.2 Focus harvesting on ONLY these PRD topics:
- Configurable artifact paths (.dev-extensions.config.yaml concept)
- Cross-domain artifact discovery (architecture consumption)
- Graceful degradation when artifacts are missing
- Explicit non-goals / tool-agnostic principles

Explicitly do NOT harvest:
- Execution-level step lists (scan/read/apply steps)
- Flow-to-workflow file mappings presented as ontology
- Fixed step sequences

---

## 3) Produce the Domain Design Document (single canonical output)
Create `domain_design_doc` with these sections (in this order):

A. Vision & Definitions (from canonical_source; minimal additions)
B. Canonical Step Catalog (embed summary; reference step_catalog)
C. Canonical Flow Catalog (embed summary; reference flow_catalog)
D. Cross-Domain Artifact Contract (architecture ↔ sdlc)
E. Artifact Materialization & Configurability (OPEN DECISION)
   - Include PRD’s config pattern only as a candidate option
F. Non-goals / Boundaries
G. Open Decisions List (explicit)
H. Human Gate Checklist

Constraints:
- Keep flows conceptual (recommended/optional steps, not sequences)
- Keep execution mapping out of scope; list it only in open decisions

---

## 4) Emit Open Decisions (separate artifact)
Create `open_decisions` document containing:
- Artifact storage location/structure options (candidate patterns)
- Execution mapping strategy (Steps/Flows → prompts/workflows/skills) as open
- Step file/schema structure as open
- IDE deployment strategy considerations as open
- Phase 1 flow selection from canonical list (needs-human)

---

## 5) Emit Harvest Report (traceability)
Create `harvest_report` with:
- Accepted as-is (list PRD sections/ideas)
- Adapted (what changed + why)
- Rejected (what was rejected + why)
- Risks if rejected items were kept (short)
- Remaining questions for human review (needs-human)

---

## 6) Final "Freeze" Statement
At the end of `domain_design_doc`, add:
- "This document is the single source of truth for the SDLC domain design."
- "PRD drafts are inputs; they do not override this design."