# Adding a New Domain - Agent Guide

**Purpose**: Guide for AI agents helping developers add new domains to this package.

---

## When to Use This Guide

User requests: "Add a new domain" or "Create [domain-name] domain"

---

## Prerequisites

Before starting, confirm with user:
1. **Domain name** (e.g., "security", "code-review")
2. **Domain purpose** (what workflows/templates will it contain)
3. **At least one workflow** ready or planned
4. **Priority level** (0-10, lower = loads first, higher = loads later)

---

## Step-by-Step Process

### Step 1: Determine Directory Structure

**Ask user which directories are needed** (avoid creating empty folders):

```
Which types of content will this domain include?
[ ] workflows  - Workflow definitions
[ ] templates  - Template files
[ ] rules      - Domain-specific rules
[ ] skills     - Domain-specific skills
```

**Domain structure reference**:
```
domains/{domain-name}/
├── workflows/              # Workflow definitions
├── templates/              # Template files (if workflows need them)
├── rules/                  # Domain-specific rules (optional)
├── skills/                 # Domain-specific skills (optional)
├── .domain-metadata.yaml   # Required
└── README.md              # Recommended
```

**Current domain examples**:
- `_core/` - Has rules/ and skills/ (no workflows/templates)
- `architecture/` - Has workflows/ and templates/ (no rules/skills)

**Windsurf IDE mapping**:
Domain content maps to `.windsurf/` in microservice projects:
- `workflows/*.md` → `.windsurf/workflows/`
- `templates/` → `.windsurf/templates/`
- `rules/*.md` → `.windsurf/rules/`
- `skills/*.skill.yaml` → `.windsurf/skills/`

**After user confirms, create only needed directories**:
```bash
# Example: User needs workflows and templates only
mkdir -p domains/{DOMAIN_NAME}/workflows
mkdir -p domains/{DOMAIN_NAME}/templates

# Example: User needs rules only (like _core)
mkdir -p domains/{DOMAIN_NAME}/rules
```

**Best practice**: Only create directories that will have content immediately or very soon.

---

### Step 2: Create Domain Metadata

**File**: `domains/{DOMAIN_NAME}/.domain-metadata.yaml`

**Template**:
```yaml
# {DOMAIN_NAME} Domain Metadata

domain:
  name: "{domain-name}"
  display_name: "{Display Name}"
  description: "{Brief description of domain purpose}"
  version: "1.0.0"
  
  # Default settings
  enabled_by_default: true  # or false for opt-in domains
  priority: {NUMBER}  # 0=highest, 10=lowest
  
  # Domain owner/maintainer
  owner:
    team: "{Team Name}"
    contact: "{email@example.com}"
  
  # What this domain provides
  provides:
    workflows:
      - id: "{workflow-id}"
        file: "workflows/{workflow-file}.md"
        description: "{Workflow description}"
    
    templates:
      - id: "{template-id}"
        path: "templates/{template-path}/"
        description: "{Template description}"
    
    rules:
      - id: "{rule-id}"
        file: "rules/{rule-file}.md"
        description: "{Rule description}"
    
    skills:
      - id: "{skill-id}"
        file: "skills/{skill-file}.skill.yaml"
        description: "{Skill description}"
  
  # Dependencies on other domains
  dependencies:
    - _core  # Always depend on _core for shared rules
  
  # Target IDEs
  compatible_with:
    - windsurf
  
  # Documentation
  documentation:
    guide: "../../docs/domains/{domain-name}.md"
    examples: "../../examples/{domain-name}/"
```

**Required fields**:
- `name`, `display_name`, `description`, `version`
- `enabled_by_default`, `priority`
- At least one workflow OR template in `provides`
- `dependencies` (include `_core`)

---

### Step 3: Create Domain README

**File**: `domains/{DOMAIN_NAME}/README.md`

**Template**:
```markdown
# {Domain Name}

**Purpose**: {Brief description}

---

## Overview

{Detailed explanation of what this domain provides}

## Available Workflows

### {Workflow Name}
- **File**: `workflows/{workflow-file}.md`
- **Purpose**: {What it does}
- **When to use**: {Usage scenarios}

## Available Templates

### {Template Name}
- **Location**: `templates/{template-path}/`
- **Purpose**: {What it's for}
- **Usage**: {How to use it}

## Dependencies

This domain depends on:
- `_core` - Shared rules and skills

## Examples

See `examples/{domain-name}/` for complete examples.

---

**Status**: {Active/Beta/Planned}  
**Version**: 1.0.0
```

---

### Step 4: Add Workflows

Create at least one workflow file: `domains/{DOMAIN_NAME}/workflows/{workflow-name}.md`

**Workflow Template**:
```markdown
---
description: {Brief description}
version: 1.0.0
priority: ESSENTIAL
---

# {Workflow Title}

## Purpose

{What this workflow accomplishes}

## Prerequisites

- {Requirement 1}
- {Requirement 2}

## Steps

### Step 1: {Step Name}

{Detailed instructions}

### Step 2: {Step Name}

{Detailed instructions}

## Output

{What gets generated}

## Validation

- [ ] {Check 1}
- [ ] {Check 2}
```

---

### Step 5: Update manifest.yaml

**File**: `manifest.yaml`

Add new domain entry under `domains:` section:

```yaml
domains:
  _core:
    enabled_by_default: true
    description: "Shared rules, skills, and utilities"
    priority: 0
    
  architecture:
    enabled_by_default: true
    description: "Architecture documentation and intake workflows"
    priority: 1
    
  {domain-name}:  # ← Add here
    enabled_by_default: true  # or false
    description: "{Domain description}"
    priority: {NUMBER}
```

**Priority guidelines**:
- 0: Core/foundation (reserved for `_core`)
- 1-3: Essential domains (architecture, etc.)
- 4-6: Standard domains
- 7-10: Optional/specialized domains

---

### Step 6: Create Templates (Optional)

If domain has templates:
```bash
mkdir -p domains/{DOMAIN_NAME}/templates/{template-name}
```

Add template files following existing patterns from `architecture` domain.

---

## Validation Checklist

Before considering the domain complete:

- [ ] Directory structure created (at minimum: workflows/ or rules/)
- [ ] `.domain-metadata.yaml` exists with all required fields
- [ ] Domain `README.md` created and complete
- [ ] At least one workflow OR rule file exists
- [ ] Workflow files have frontmatter (if applicable)
- [ ] `manifest.yaml` updated with new domain entry
- [ ] Priority number assigned (doesn't conflict with others)
- [ ] Dependencies listed (at minimum `_core`)
- [ ] Domain name is lowercase with hyphens (e.g., `code-review`, not `CodeReview`)
- [ ] Only created directories that will have content (don't create empty folders)

---

## Example: Adding "Security" Domain

```bash
# 1. Create structure
mkdir -p domains/security/{workflows,templates}

# 2. Create metadata
cat > domains/security/.domain-metadata.yaml << EOF
domain:
  name: "security"
  display_name: "Security Analysis"
  description: "Security audit and vulnerability workflows"
  version: "1.0.0"
  enabled_by_default: false  # Opt-in
  priority: 5
  dependencies:
    - _core
EOF

# 3. Create README
cat > domains/security/README.md << EOF
# Security Domain
**Purpose**: Security-focused analysis and auditing
...
EOF

# 4. Create workflow
cat > domains/security/workflows/security-audit.md << EOF
---
description: Comprehensive security audit
version: 1.0.0
---
# Security Audit
...
EOF

# 5. Update manifest.yaml
# (Add security domain entry)
```

---

## Common Pitfalls

❌ **Forgetting to add domain to manifest.yaml** - domain won't be recognized  
❌ **Missing frontmatter in workflows** - workflows won't load  
❌ **Conflicting priority numbers** - use unique numbers  
❌ **Not depending on `_core`** - missing shared rules  
❌ **Uppercase domain names** - use lowercase-with-hyphens  

---

## Next Steps After Creation

1. Test domain in a microservice project
2. Create example output in `examples/{domain-name}/`
3. Document in main `README.md` (optional)
4. Consider adding to IDE mappings if needed

---

**This guide is for AI agents assisting developers. Always confirm requirements with user before proceeding.**
