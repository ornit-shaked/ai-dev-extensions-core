# Architecture Domain

Workflows and templates for extracting and documenting microservice and library architecture.

---

## 🎯 Overview

The Architecture domain provides workflows that systematically extract architectural knowledge from codebases and generate structured documentation. This enables:

- **AI Agents** to safely understand service boundaries and contracts
- **Engineers** to quickly onboard to new services
- **SRE/DevOps** to access operational details
- **Tech Leads** to maintain architectural consistency

**Key Benefits:**
- ✅ 60-70% automated extraction from code
- ✅ Standardized structure across all services
- ✅ Fact-based, no speculation
- ✅ Flags gaps requiring human review
- ✅ Agent-ready output format

---

## 🚀 Quick Start

### Available Workflows

| Workflow | Command | Purpose |
|----------|---------|---------|
| **Create** | `/architecture-intake-create` | Extract and document architecture automatically |
| **Resolve** | `/architecture-intake-resolve` | Interactively close open issues flagged during create |

### Running Create Workflow

```bash
1. Open Windsurf in your service directory
2. Type: /architecture-intake-create
3. Enter service name when prompted (e.g., tosca-engine-ms)
4. Wait 2-5 minutes for completion
5. Review output in docs/architecture/
```

### Running Resolve Workflow

```bash
1. Type: /architecture-intake-resolve
2. Enter service name (e.g., tosca-engine-ms)
3. Select which issues to resolve (or resolve all)
4. Answer questions interactively — skip anything for later
```

---

## 📁 Output Structure

Workflows generate documentation in `docs/architecture/`:

```
docs/architecture/
├── 1-identity.md          # Service identity & boundaries
├── 2-architecture.md      # Tech stack & C4 views
├── 3-contracts.md         # APIs, events, integrations
├── 5-flows.md             # Key operational flows
├── _metadata.yaml         # Collection summary
└── _open-issues.md        # Items needing review
```

### Section Overview

| File | Priority | Source | Content |
|------|----------|--------|---------|
| 1-identity.md | ESSENTIAL | SEMI | Purpose, responsibilities, ownership |
| 2-architecture.md | ESSENTIAL | AUTO | Tech stack, components, patterns |
| 3-contracts.md | ESSENTIAL | SEMI | REST APIs, events, integrations |
| 5-flows.md | ESSENTIAL | SEMI | Critical operational sequences |
| _metadata.yaml | META | AUTO | Collection summary |
| _open-issues.md | META | AUTO | Items needing review |

---

## 📖 File Descriptions

### 1-identity.md
**Purpose, responsibilities, and boundaries**

Contains:
- Service purpose (1-2 sentences)
- Responsibilities (what it does)
- Non-goals (what it doesn't do) ⚠️ needs human input
- Team/contacts
- Wiki/doc links
- Integration points

**When to use:** Understanding service scope before making changes

---

### 2-architecture.md
**Technology stack and component structure**

Contains:
- Language, framework, versions
- Dependencies (Spring Boot, MongoDB, etc.)
- C4 Context and Container views
- Design patterns
- Deployment info

**When to use:** Understanding technical constraints and patterns

---

### 3-contracts.md
**APIs, events, and integrations**

Contains:
- REST endpoints (from @RestController)
- OpenAPI spec location (or flag if missing)
- Async events (RabbitMQ/Kafka)
- External service calls
- Error response formats

**When to use:** Critical for safe integration changes

---

### 5-flows.md
**3-5 critical operational sequences**

Contains:
- Flow triggers (endpoints/events)
- Step-by-step sequences
- Decision points
- Error scenarios
- External calls

**When to use:** Understanding business logic flow

---

### _metadata.yaml
**Summary of collection completeness**

Contains:
- Per-section metadata (source, completeness, risk)
- Overall statistics
- Security assessment
- ADR status
- Agent readiness

**When to use:** Assess reliability of information

---

### _open-issues.md
**Aggregated list of items needing human review**

Contains:
- High/medium/low priority issues
- Missing information (OpenAPI, dashboards)
- Items requiring business context
- Review checklist

**When to use:** Action items to complete intake

---

## 🏷️ Understanding Metadata

Every section includes a metadata block:

```yaml
source: AUTO|SEMI|MANUAL        # How info was collected
completeness: COMPLETE|PARTIAL|MISSING
needs-human: true|false         # Requires human review?
risk: LOW|MEDIUM|HIGH          # Change risk level
```

### Source Types

- **AUTO**: Extracted directly from code/config (high confidence)
- **SEMI**: Extracted but needs validation (medium confidence)
- **MANUAL**: Requires human input (low confidence)

### Completeness Levels

- **COMPLETE**: All expected information found
- **PARTIAL**: Some information found, gaps exist
- **MISSING**: Section not applicable or no data found

### Risk Levels

- **LOW**: Changes unlikely to break things
- **MEDIUM**: Changes need careful review
- **HIGH**: Critical section, changes risky without full understanding

---

## 🎓 For Different Users

### Engineers
- **Onboarding**: Read 1-identity.md → 2-architecture.md → 3-contracts.md
- **Understanding Flows**: Review 5-flows.md for business logic
- **Implementation**: Follow patterns in 2-architecture.md

### AI Agents
- **Before Changes**: Read _metadata.yaml for completeness
- **Completeness**: Review _open-issues.md for uncertain areas
- **Context Building**: Start with 1-identity.md and 3-contracts.md
- **Implementation**: Use 2-architecture.md patterns and 5-flows.md logic
- **Safety**: Respect `needs-human: true` flags

### Tech Leads
- **Architecture Review**: Compare 2-architecture.md across services
- **Standards**: Use 3-contracts.md to ensure API consistency
- **Flow Analysis**: Review 5-flows.md for business logic patterns
- **Maintenance**: Update after major changes

---

## 🤖 For AI Agents

### How to Use This Documentation

1. **Start with _metadata.yaml**: Check overall completeness
2. **Read 1-identity.md**: Understand service scope
3. **Check 3-contracts.md**: Verify API contracts
4. **Review 5-flows.md**: Understand business logic
5. **Consult _open-issues.md**: Note uncertain areas

### Safety Guidelines

- ⚠️ Treat `needs-human: true` items as uncertain
- ⚠️ Don't assume missing information
- ⚠️ Verify contracts against actual code
- ⚠️ Flag discrepancies for human review
- ⚠️ When in doubt, ask

### Agent-Ready Criteria

**READY**: All essential sections (1-7) complete
- Agents can safely make bug fixes and features
- Contracts and flows documented
- Configuration understood

**PARTIAL**: Some sections need review
- Agents can work with caution
- Flag uncertain areas
- Verify assumptions

**NOT READY**: Critical sections missing
- Human review required first
- Don't make architectural changes

---

## ✅ Key Features

### Automated Extraction (60-70%)
- Scans source code for classes, annotations
- Parses configuration files (YAML, properties)
- Analyzes build files (Gradle, Maven)
- Extracts from README and documentation
- Auto-resolves RabbitMQ/Kafka event constants from Gradle cache JARs via `javap -constants`

### Standardized Templates
- Same structure for all services
- Predictable information location
- Easy agent parsing
- Diff-friendly comparisons
- Always present headings with consistent fallback text when empty

### Fact-Based Collection
- No speculation or assumptions
- Marks uncertain items for review
- Documents what exists, not what should exist
- Flags missing information explicitly

### Interactive Issue Resolution
- Open issues generated automatically during create
- `/architecture-intake-resolve` lets you close issues interactively at your own pace
- OpenAPI spec fetched automatically from a running server (with version warning)
- Dashboard links remain manual — prompted during resolve

---

## 🔧 Maintenance

### When to Re-run

- After major architectural changes
- When adding new APIs or events
- After significant refactoring
- Quarterly for active services
- When onboarding new team members

### Updating Manually

You can manually update individual files:
1. Edit the file in `docs/architecture/`
2. Update metadata block (change timestamp, completeness)
3. Update `_metadata.yaml` if needed
4. Commit changes to git

### Validation Checklist

Before marking intake as complete:
- [ ] Review all HIGH priority items in `_open-issues.md`
- [ ] Verify non-goals with product owner
- [ ] Confirm API documentation (OpenAPI or manual)
- [ ] Validate key flows with tech lead
- [ ] Add dashboard links
- [ ] Update ownership information

---

## ⚠️ Important Notes

### What This Workflow Does
✅ Extracts facts from codebase  
✅ Documents current state  
✅ Flags gaps for human review  
✅ Creates agent-ready documentation  

### What This Workflow Does NOT Do
❌ Make assumptions about missing info  
❌ Invent API endpoints or configs  
❌ Modify your code  
❌ Replace human architectural decisions  

---

## 🐛 Troubleshooting

### Workflow Fails to Start

- Verify you're in a valid service directory
- Check service name is correct
- Ensure workflows are properly integrated

### Incomplete Output

- Check `_metadata.yaml` for section status
- Review `_open-issues.md` for missing items
- Some sections may be legitimately empty (e.g., no async events)

### Information Seems Wrong

- Workflow extracts facts from code as-is
- If code/config is outdated, output will reflect that
- Update code first, then re-run workflow

---

## 📦 Package Structure

This domain is part of **ai-dev-extensions-core** package.

**Location in package:**
```
domains/architecture/
├── workflows/
│   ├── architecture-intake-create.md
│   ├── architecture-intake-resolve.md
│   └── assets/
│       └── intake-create/           # Assets for architecture-intake-create
│           ├── 1-identity.md
│           ├── 2-architecture.md
│           ├── 3-contracts.md
│           ├── 5-flows.md
│           ├── _metadata-template.yaml
│           └── _open-issues-template.md
├── .domain-metadata.yaml
└── README.md (this file)
```

**Integration:** See [MICROSERVICE_INTEGRATION.md](../../MICROSERVICE_INTEGRATION.md) for setup instructions.

## 🔮 Future Sections (Ideas for Later)

The architecture intake was simplified to focus on 4 critical sections. These additional sections were removed but could be valuable for mature services:

- **Data Layer** (`4-data.md`) - Database schema, entities, migrations, data access patterns
- **Error Catalog** (`6-errors.md`) - Exception hierarchy, error codes, recovery strategies  
- **Configuration** (`7-config.md`) - Environment variables, feature flags, external config
- **Observability** (`8-observability.md`) - Logging, metrics, tracing, health checks

These sections can be added back when:
- The core 4-section process is working smoothly
- Teams request more detailed documentation
- Services reach maturity requiring operational depth

---

## 📞 Support

**Domain Metadata:** `.domain-metadata.yaml` (machine-readable structure for agents)  
**Main Documentation:** [Project README](../../README.md)  
**Integration Guide:** [MICROSERVICE_INTEGRATION.md](../../MICROSERVICE_INTEGRATION.md)

---

**Version**: 1.0.0  
**Last Updated**: March 2026  
**Status**: Ready to use ✅
