# SDLC Content Scaffolding — Phase 2 Decisions

> **Status:** Decided — format and structure frozen for Phase 2 scaffolding
> **Date:** 2026-03-26
> **Scope:** Step files and Flow files (Phase 1)

---

## Purpose of This Document

This document records **what was decided** and **where to find the details**. It avoids duplication with agent.md files by pointing to the authoritative sources.

**For details on how to work with Step/Flow files, read:**
- `domains/sdlc/skills/step-agent.md` — Complete guide for Step files
- `domains/sdlc/skills/flow-agent.md` — Complete guide for Flow files

---

## Decision Summary

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Step file format** | YAML frontmatter + Markdown body (S1) | Balance: machine-parseable metadata + human-readable prose |
| **Flow file format** | YAML frontmatter + Markdown body (F1) | Same pattern as Steps for consistency |
| **File location** | `domains/sdlc/skills/` (step-*.md and flow-*.md) | Unified skills directory |
| **Agent guidance** | `agent.md` in each directory | Folder-level contract teaches LLMs how to work with files |

---

## Format Choice: YAML Frontmatter + Markdown

### Why This Format?

**Balance of concerns:**
- **Machine-parseable:** YAML frontmatter enables tooling, validation, metadata extraction
- **Human-readable:** Markdown body is scannable, editable, natural prose
- **IDE-friendly:** Windsurf supports both syntaxes with highlighting
- **Extensible:** Can add metadata fields without breaking format
- **Consistency:** Same pattern for Steps and Flows reduces cognitive load

**Rejected alternatives:**
- **Pure Markdown (S2/F2):** Too loose — harder to validate, no schema enforcement
- **Pure YAML (S3/F3):** Too strict — less readable for prose content, YAML expertise barrier

### Why agent.md Files?

**Self-documenting scaffolding:**
- New LLMs can read the contract before modifying files
- Prevents "blind edits" that drift from ontology
- Makes format decisions explicit and findable
- Enables validation without external docs

**Precedent:** Architecture domain uses this pattern with `_metadata.yaml` and `_open-issues.md` templates.

---

## Where to Find Information

### For Step Files

**All details are in:** `domains/sdlc/skills/step-agent.md`

Including:
- Required structure and field definitions
- Valid values for each field (name, tag, execution_intent, etc.)
- Content rules (allowed/forbidden)
- Validation checklist
- How to add or modify Step files
- Canonical list of all 13 Step names

### For Flow Files

**All details are in:** `domains/sdlc/skills/flow-agent.md`

Including:
- Required structure and field definitions
- Valid values for each field (flow, goal, recommended_steps, etc.)
- Critical rule: "Flows are NOT pipelines"
- Content rules (allowed/forbidden)
- Validation checklist
- How to add or modify Flow files
- Phase 1 Flow names (5 flows)

### For Ontology Source of Truth

- **Step definitions:** `tasks/ai-dev-extensions-core/sdlc-domain-design.md` §C
- **Flow definitions:** `tasks/ai-dev-extensions-core/sdlc-domain-design.md` §D
- **Execution Intent Map:** `tasks/ai-dev-extensions-core/sdlc-domain-design.md` §E
- **Phase 1 Scope:** `tasks/ai-dev-extensions-core/sdlc-execution-mapping-windsurf.md` §B

---

## Key Design Principles

### 1. Ontology Purity

Steps and Flows are **conceptual constructs**, not execution artifacts.

- **Input/output are conceptual** (not file paths)
- **No tool-specific logic** (no prompts, workflows, skills)
- **No execution ordering** (Steps are guidance, not pipelines)

### 2. Anti-Drift Protection

Every file includes:
- "What This Is NOT" section
- Explicit warnings against pipeline/gate/orchestration interpretation
- Validation rules to prevent identity drift

### 3. Conceptual vs. Execution Separation

| Layer | Location | Contains |
|-------|----------|----------|
| **Ontology (scaffolding)** | `domains/sdlc/skills/` (step-*.md, flow-*.md) | Conceptual definitions only |
| **Execution (future)** | `domains/sdlc/workflows/`, `domains/sdlc/prompts/`, etc. | Tool-specific realization |

### 4. Single Source of Truth

No field definitions or validation rules are duplicated in this file. They live in `agent.md` files where agents will read them.

### 5. Prompts in Steps (Architecture Clarification)

**Initial scaffolding approach:** Steps contained only ontology (conceptual definitions), no prompts.

**Revised approach (based on source document):** Steps contain both ontology AND prompt text.

**Why prompts belong in Steps:**
- Prompt text is tool-agnostic (same text works in Windsurf, Cursor, or any LLM-based tool)
- Only orchestration changes between tools (workflow wrappers, skill invocation)
- The prompt defines the Step's "voice" when talking to the LLM

**What goes where:**
- **Step files** (`domains/sdlc/skills/step-*.md`) — Ontology + Prompt text (tool-agnostic)
- **Workflow files** (`domains/sdlc/workflows/*.md` - Phase 3) — Orchestration wrappers (tool-specific)
- **Flow files** (`domains/sdlc/skills/flow-*.md`) — Goal-oriented Step compositions (no prompts)

**From the source document** (`sdlc_thinking_stage_1.docx`):
> "A Step may contain: Prompts, Workflows, Skills, Local rules (execution logic)"

This confirms that prompts are part of Step definition, not separate execution artifacts.

---

## Implementation Status

| Artifact | Status | Location |
|----------|--------|----------|
| **Steps agent.md** | ✅ Created | `domains/sdlc/skills/step-agent.md` |
| **Flows agent.md** | ✅ Created | `domains/sdlc/skills/flow-agent.md` |
| **13 Step files** | ✅ Created | `domains/sdlc/skills/step-*.md` |
| **5 Flow files (Phase 1)** | ✅ Created | `domains/sdlc/skills/flow-*.md` |

---

## Reference Documents

- **Ontology authority:** `tasks/ai-dev-extensions-core/sdlc-domain-design.md`
- **Phase 1 scope:** `tasks/ai-dev-extensions-core/sdlc-execution-mapping-windsurf.md`
- **Step file guide:** `domains/sdlc/skills/step-agent.md` ← **Read this for Step details**
- **Flow file guide:** `domains/sdlc/skills/flow-agent.md` ← **Read this for Flow details**
