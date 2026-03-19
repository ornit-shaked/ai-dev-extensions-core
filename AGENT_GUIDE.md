# Agent Consumption Guide

**How AI agents should consume and use this extension package**

This guide is for **AI assistants** (like Claude, GPT-4, Windsurf AI, etc.) to understand how to properly consume workflows, templates, and rules from this package.

---

## 🤖 For AI Agents: What is This Package?

You are reading documentation for **ai-dev-extensions-core**, a structured collection of:
- Workflows (procedural guides)
- Templates (document skeletons)
- Rules (behavioral constraints)
- Skills (capability definitions)

This content helps you perform tasks more accurately and consistently across different projects.

---

## 📚 Package Structure

```
ai-dev-extensions-core/
├── manifest.yaml        # Package metadata and IDE mappings
├── domains/             # Task-specific content organized by domain
│   ├── _core/          # Shared rules, skills, utilities (priority 0)
│   │   ├── rules/     # Behavioral constraints for agents
│   │   └── skills/    # Reusable capabilities
│   └── architecture/   # Architecture documentation domain
│       ├── workflows/ # Architecture intake workflows
│       └── templates/ # Architecture templates
├── examples/           # Example workflow outputs
│   └── architecture/  # Architecture domain examples
└── docs/               # Additional documentation
```

---

## 🎯 How to Consume Workflows

### Workflow Format

All workflows are **Markdown files** with **frontmatter**:

```markdown
---
description: Extract and document service architectural knowledge
version: 2.0.0
priority: ESSENTIAL
---

# Workflow Title

## Step 1: Do something
...
```

### Reading Workflows

1. **Parse frontmatter** for metadata
2. **Follow steps sequentially** - don't skip unless instructed
3. **Respect constraints** (e.g., "NO FABRICATION", "needs-human: true")
4. **Use templates** referenced in workflow steps

### Example: Architecture Intake Workflow

When user triggers: `/architecture-intake-create`

**You should:**
1. Read: `domains/architecture/workflows/architecture-intake-create.md`
2. Follow each section (1-8) step by step
3. Use templates from: `domains/architecture/templates/`
4. Mark items `needs-human: true` when auto-detection fails
5. Generate output in `docs/architecture/` (in the target microservice repo)

**Key principles:**
- ✅ Only document what exists in codebase
- ✅ Mark uncertain items for human review
- ❌ Never fabricate endpoints, configs, or code
- ✅ Use "TBD" or "MISSING" for unavailable data

---

## 📋 How to Use Templates

### Template Format

Templates use **placeholders** in double curly braces:

```markdown
# {{SERVICE_NAME}} - Identity

## Purpose
{{PURPOSE_FROM_README}}

## Ownership
- Team: {{TEAM_NAME}}
- Repository: {{GIT_URL}}
```

### Filling Templates

1. **Read template** from `domains/*/templates/`
2. **Collect data** from codebase (as instructed in workflow)
3. **Replace placeholders** with actual values or "TBD"
4. **Never leave placeholders** in output - use "TBD" if data missing
5. **Preserve structure** - don't remove sections

### Example: Identity Template

```markdown
# Input Template
Team: {{TEAM_NAME}}

# ✅ Good Output
Team: Platform Engineering

# ✅ Also Good (if unknown)
Team: TBD - requires human input

# ❌ Bad Output (placeholder left)
Team: {{TEAM_NAME}}
```

---

## 📏 How to Apply Rules

### Rule Format

Rules are **Markdown files** with clear directives:

```markdown
# No Fabrication Rule

## Directive
Never invent or guess:
- API endpoints
- Configuration values
- Error codes
...

## When Uncertain
Mark as `needs-human: true`
```

### Applying Rules

1. **Load rules** from `domains/_core/rules/*.md` at session start
2. **Apply globally** - rules affect all tasks, not just workflows
3. **Prioritize rules** over other instructions if conflict
4. **Document violations** - if you must break a rule, explain why

### Common Rules

| Rule | Applies To | Key Constraint |
|------|-----------|----------------|
| `no-fabrication.md` | All workflows | Never invent data not in codebase |
| `minimal-changes.md` | Code edits | Prefer single-line fixes |
| *(more as added)* | ... | ... |

---

## 🔧 Domain-Specific Guidance

### Architecture Domain

**Purpose**: Document microservice/library architecture

**Workflows**:
- `architecture-intake-create.md` - Extract architecture knowledge
- `architecture-intake-resolve.md` - Complete flagged items

**Key behaviors**:
- Auto-detect technology stack (build files, configs)
- Mark business context as `needs-human: true`
- Generate C4 views from code structure
- Never guess non-goals or external integrations

**Output format**: Markdown files in `docs/architecture/` within the microservice repository

**Agent Navigation**:
- Read `domains/architecture/.domain-metadata.yaml` for structured section definitions
- Use `output_structure.sections[].use_when` to determine which files to read
- Check `_metadata.yaml` in output for completeness and agent_ready status

---

### Future Domains

**Planned but not yet implemented**:
- **Code Review**: Code review preparation and execution workflows
- **Security**: Security audit and threat modeling workflows (opt-in)

---

## �️ Navigating Domain Metadata

### Understanding .domain-metadata.yaml

Each domain has a `.domain-metadata.yaml` file with **structured information for agents**.

**Key sections for agents**:

```yaml
domain:
  name: "architecture"
  dependencies:
    - _core  # Load core rules/skills first

output_structure:
  location: "docs/architecture/"
  sections:
    - id: "3-contracts"
      file: "3-contracts.md"
      use_when:
        - "Modifying or adding APIs"
        - "Understanding event contracts"
      contains:
        - "REST endpoints"
        - "OpenAPI spec location"
```

### How to Use Domain Metadata

**When starting a task**:
1. Read `domains/{domain}/.domain-metadata.yaml`
2. Check `dependencies` - load those domains first
3. Review `output_structure.sections`
4. Use `use_when` to find relevant sections

**Example - API change task**:
```
Task: "Add new user search endpoint"

1. Read domains/architecture/.domain-metadata.yaml
2. Find sections with use_when containing "APIs"
   → 3-contracts.md: "Modifying or adding APIs"
3. Read docs/architecture/3-contracts.md
4. Follow existing patterns
5. Update documentation
```

**Metadata fields guide**:
- `typical_source: AUTO` → High confidence, machine-extracted
- `typical_source: SEMI` → Medium confidence, needs validation
- `typical_source: MANUAL` → Low confidence, requires human input
- `priority: ESSENTIAL` → Read before making changes
- `priority: OPERATIONAL` → Nice to have, optional

---

## � Error Handling

### When Data is Missing

```markdown
# ❌ Wrong
API Base URL: (not found)

# ✅ Correct
API Base URL: **MISSING** - requires human input
```

### When File Doesn't Exist

```markdown
# ❌ Wrong
(Skip section silently)

# ✅ Correct
**Note**: OpenAPI spec not found at expected locations:
- ✗ src/main/resources/openapi.yaml
- ✗ src/main/resources/swagger.json

Marked as `needs-human: true` in metadata.
```

### When Workflow Step Fails

1. **Document the failure** in output
2. **Continue with next step** (don't abort entire workflow)
3. **Add to open issues** (`_open-issues.md`)
4. **Mark section** as PARTIAL in metadata

---

## 📊 Metadata Management

### Section Metadata Format

Every workflow section should generate:

```yaml
source: AUTO|SEMI|MANUAL
completeness: COMPLETE|PARTIAL|MISSING
needs_human: true|false
risk: LOW|MEDIUM|HIGH
notes: "Additional context"
```

### Aggregating Metadata

After completing workflow:
1. Collect metadata from all sections
2. Generate `_metadata.yaml` summary
3. Count complete/partial/missing sections
4. Determine `agent_ready` status

---

## ✅ Validation Checklist

Before finishing any workflow:

- [ ] All template placeholders replaced (or "TBD")
- [ ] No fabricated data (only what exists in codebase)
- [ ] Metadata blocks present in all sections
- [ ] Open issues documented in `_open-issues.md`
- [ ] Output files in correct location (`docs/architecture/` for architecture domain)
- [ ] `_metadata.yaml` generated with completeness tracking
- [ ] Rules followed (no-fabrication, minimal-changes, etc.)
- [ ] Checked domain dependencies (e.g., _core loaded first)

---

## 🎓 Learning from Examples

Check `examples/` directory for complete workflow outputs:

**Architecture Domain Example**:
- Location: `examples/architecture/user-service-example/`
- Contains: All 8 sections + metadata + open issues
- Study: Output quality, metadata tracking, completeness levels

**What to learn**:
- Expected output format and structure
- How to mark items `needs-human: true`
- Metadata patterns (AUTO/SEMI/MANUAL)
- Open issues prioritization (HIGH/MEDIUM/LOW)
- Agent-ready assessment criteria

**Key observation**: ~60-70% can be auto-extracted, rest needs validation or human input.

---

## 🔄 Version Compatibility

### Checking Workflow Version

```markdown
---
version: 2.0.0
---
```

- **Major version change** (1.x → 2.x): Breaking changes, review carefully
- **Minor version change** (2.0 → 2.1): New features, backwards compatible
- **Patch version change** (2.0.0 → 2.0.1): Bug fixes only

### Handling Version Mismatches

If workflow version > your training data:
1. Read workflow carefully for new instructions
2. Follow latest version (workflows are authoritative)
3. Note version in output metadata

---

## 🤝 Multi-Agent Scenarios

### When Multiple Agents Use Same Package

- **Read-only access**: Never modify package content
- **Isolated outputs**: Write to project-specific locations (e.g., `docs/architecture/`)
- **No state sharing**: Each agent session is independent

### Consistency Across Projects

Using same package version ensures:
- Same workflow steps
- Same template structure
- Same quality standards

**Result**: Consistent documentation across all microservices

---

## 📞 When to Ask for Human Help

Flag for human input when:

1. **Business context needed** (non-goals, priorities)
2. **Ambiguous code** (multiple interpretations possible)
3. **External dependencies** (can't auto-detect integration)
4. **Security decisions** (risk assessment required)
5. **Incomplete information** (missing critical files)

**How to flag**:
```yaml
needs_human: true
notes: "OpenAPI spec not found - manual documentation required"
```

---

## 🎯 Success Criteria

You're using this package correctly when:

✅ Output matches template structure exactly  
✅ No fabricated data (all from codebase)  
✅ Metadata is accurate and complete  
✅ Human review items clearly flagged  
✅ Rules are consistently applied  

---

**This is a living document. Workflows and templates may evolve over time.**

**Always check workflow version and follow the latest instructions.**
