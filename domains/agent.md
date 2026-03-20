# Creating a New Domain - Agent Guide

**Purpose**: Guide for AI agents helping developers add new domains to this package.

**Location**: This file is in `domains/` for locality - when working on domains, the guide is nearby.

---

## When to Use This Guide

User requests: "Add a new domain" or "Create [domain-name] domain"

---

## Prerequisites

Before starting, confirm with user:
1. **Domain name** (e.g., "security", "code-review")
2. **Domain purpose** (what workflows/rules will it contain)
3. **At least one workflow** ready or planned
4. **Priority level** (0-10, lower = loads first, higher = loads later)

---

## Step-by-Step Process

### Step 1: Determine Directory Structure

**Ask user which directories are needed** (avoid creating empty folders):

```
Which types of content will this domain include?
[ ] workflows  - Workflow definitions
[ ] rules      - Domain-specific rules
[ ] skills     - Domain-specific skills
```

**Domain structure reference**:
```
domains/{domain-name}/
├── workflows/              # Workflow definitions
│   └── assets/            # (Optional) Workflow assets (templates, schemas, etc.)
├── rules/                  # (Optional) Domain-specific rules
├── skills/                 # (Optional) Domain-specific skills
├── .domain-metadata.yaml   # Required
└── README.md              # Recommended
```

**Windsurf IDE mapping (flatten mode)**:
- `workflows/*.md` → `.windsurf/workflows/{filename}.md` (individual file symlinks)
- `workflows/assets/` → `.windsurf/workflows/.assets-{domain}/` (directory symlink)
- `rules/*.md` → `.windsurf/rules/{filename}.md` (individual file symlinks)
- `skills/*.skill.yaml` → `.windsurf/skills/{filename}.skill.yaml` (individual file symlinks)

**Important**: Workflows reference assets using `.assets-{domain}/` paths

---

### Step 2: Create Domain Metadata

**File**: `domains/{DOMAIN_NAME}/.domain-metadata.yaml`

**Template**:
```yaml
domain:
  name: "{domain-name}"
  display_name: "{Display Name}"
  description: "{Brief description}"
  version: "1.0.0"
  enabled_by_default: true
  priority: {NUMBER}
  
  owner:
    team: "{Team Name}"
    contact: "{email}"
  
  provides:
    workflows:
      - workflow-name
    rules:
      - id: "rule-id"
        file: "rules/{file}.md"
        description: "{description}"
  
  dependencies:
    - _core
  
  compatible_with:
    - windsurf
```

**Required fields**:
- `name`, `display_name`, `description`, `version`
- `enabled_by_default`, `priority`
- At least one workflow OR rule in `provides`
- `dependencies` (include `_core`)

---

### Step 3: Create Domain README

Create `domains/{DOMAIN_NAME}/README.md` documenting the domain purpose, workflows, and usage.

**Template structure**:
```markdown
# {Domain Name}

**Purpose**: {Brief description}

## Overview
## Available Workflows
## Available Rules
## Dependencies
## Examples
```

---

### Step 4: Add Workflows

Create workflow files in `domains/{DOMAIN_NAME}/workflows/{workflow-name}.md` with frontmatter:

```markdown
---
description: {Brief description}
version: 1.0.0
priority: ESSENTIAL
---

# {Workflow Title}

## Purpose
## Prerequisites
## Steps
## Output
## Validation
```

---

### Step 5: Update manifest.yaml

**File**: `manifest.yaml`

Add new domain entry:

```yaml
domains:
  {domain-name}:
    enabled_by_default: true
    description: "{Domain description}"
    priority: {NUMBER}
```

**Priority guidelines**:
- 0: Core/foundation (_core)
- 1-3: Essential domains
- 4-6: Standard domains
- 7-10: Optional domains

---

## Validation Checklist

Before considering the domain complete:

- [ ] Directory structure created (workflows/ or rules/)
- [ ] `.domain-metadata.yaml` exists with required fields
- [ ] Domain `README.md` created
- [ ] At least one workflow OR rule file exists
- [ ] Workflow files have frontmatter
- [ ] `manifest.yaml` updated
- [ ] Priority number assigned (unique)
- [ ] Dependencies listed (include `_core`)
- [ ] Domain name is lowercase with hyphens

---

## Common Pitfalls

❌ Forgetting to add domain to manifest.yaml  
❌ Missing frontmatter in workflows  
❌ Conflicting priority numbers  
❌ Not depending on `_core`  
❌ Uppercase domain names  
❌ Creating empty directories (only create what's needed)

---

## Example: Adding "Security" Domain

```bash
# 1. Create structure
mkdir -p domains/security/workflows

# 2. Create metadata
cat > domains/security/.domain-metadata.yaml << EOF
domain:
  name: "security"
  display_name: "Security Analysis"
  description: "Security audit and vulnerability workflows"
  version: "1.0.0"
  enabled_by_default: false
  priority: 5
  dependencies:
    - _core
EOF

# 3. Create README
cat > domains/security/README.md << EOF
# Security Domain
**Purpose**: Security-focused analysis and auditing
EOF

# 4. Create workflow
cat > domains/security/workflows/security-audit.md << EOF
---
description: Comprehensive security audit
version: 1.0.0
---
# Security Audit
EOF

# 5. Update manifest.yaml (add security entry)
```

---

## Next Steps After Creation

1. Test domain in a microservice project
2. Create example output in `examples/{domain-name}/`
3. Document in main `README.md` (optional)
4. Update `AGENT_GUIDE.md` navigation if needed

---

**This guide is for AI agents assisting developers. Always confirm requirements with user before proceeding.**
