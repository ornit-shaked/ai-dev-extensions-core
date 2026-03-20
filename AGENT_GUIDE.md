# Agent Guide - Package Structure

**How AI agents should understand and navigate this package**

This guide explains the **package structure**, **file organization**, and **deployment system** - not how to execute specific workflows.

---

## 🎯 Purpose

This is **ai-dev-extensions-core** - a structured package containing:
- **Workflows** (`.md` files with step-by-step instructions)
- **Rules** (`.md` files with behavioral constraints)
- **Skills** (`.skill.yaml` files with capability definitions)

Each workflow/rule/skill has its own documentation. This guide is about the **package itself**.

---

## 📚 Key Files for Agents

- **[manifest.yaml](./manifest.yaml)** - Package metadata, domains, IDE compatibility
- **[config/ide-mapping.yaml](./config/ide-mapping.yaml)** - How files deploy to different IDEs
- **[domains/agent.md](./domains/agent.md)** - Creating new domains

**Human docs:**
- **[README.md](./README.md)** - User-facing Quick Start
- **[CHANGELOG.md](./CHANGELOG.md)** - Version history

---

## � Package Directory Structure

**Source (this repository):**
```
ai-dev-extensions-core/
├── domains/
│   ├── _core/
│   │   ├── .domain-metadata.yaml
│   │   ├── workflows/
│   │   ├── rules/
│   │   └── skills/
│   └── architecture/
│       ├── .domain-metadata.yaml
│       ├── workflows/
│       │   ├── workflow1
│       │   ├── workflow2
│       │   └── assets/
│       │       ├── templates/
│       │       └── schemas/
│       ├── rules/
│       ├── skills/
│       └── README.md
├── manifest.yaml
└── config/
    └── ide-mapping.yaml
```

**Target (after deployment to a project):**
```
your-project/
├── .dev-extensions/          # Submodule pointing to this repo
└── .{ide}/                  # Path depends on IDE (see config/ide-mapping.yaml)
    ├── {workflows-dir}/     # e.g., workflows/ (Windsurf) or prompts/ (Cursor)
    │   ├── workflow1        # Symlink to source
    │   ├── workflow2        # Symlink to source
    │   └── .assets-architecture/  # Symlink to workflows/assets/
    ├── {rules-dir}/
    │   └── rule1
    └── {skills-dir}/
        └── skill1
```

**Note:** Actual paths depend on IDE. See table below or `config/ide-mapping.yaml`.

---

## 🔄 How Files Are Copied/Deployed

### Flatten Mode (Default)

**All content types (workflows/rules/skills):**
- Individual files are symlinked directly
- If `assets/` subdirectory exists, it's symlinked as `.assets-{domain}/`

**Example (Windsurf):**
```
Source: domains/architecture/workflows/intake
Target: .windsurf/workflows/intake

Source: domains/architecture/workflows/assets/
Target: .windsurf/workflows/.assets-architecture/
```

**Note:** rules/skills may have also assets/ directories

**Why flatten?**
- IDEs need to discover all workflow files at top level
- Assets remain accessible via relative paths

### Naming Conventions

**Files:** Lowercase with hyphens (extension determined by type)
- ✅ `architecture-intake-create` (workflow)
- ✅ `no-fabrication` (rule)
- ❌ `Architecture_Intake`

**Domains:** Lowercase, underscore for core
- ✅ `_core`
- ✅ `architecture`
- ✅ `code-review`

**Assets directories:** `.assets-{domain}`
- ✅ `.assets-architecture`
- ✅ `.assets-security`

---

## 🎨 Multi-IDE Support

### Supported IDEs

| IDE | Workflows Directory | Rules Directory | Skills Directory | Status |
|-----|---------------------|-----------------|------------------|--------|
| Windsurf | `.windsurf/workflows/` | `.windsurf/rules/` | `.windsurf/skills/` | ✅ Full |
| Cursor | `.cursor/prompts/` | `.cursor/rules/` | - | ✅ Partial |
| VS Code | `.vscode/` | - | - | 🚧 Planned |

**See `config/ide-mapping.yaml` for complete mapping and configuration.**

### How IDE Detection Works

1. **Auto-detect:** Check for `.windsurf/`, `.cursor/`, `.vscode/`
2. **Fallback:** User specifies via `-IDE` parameter
3. **Map content:** Read `config/ide-mapping.yaml` for IDE-specific paths
4. **Create symlinks:** To correct directories per IDE

**Important:**
- Paths shown in examples use Windsurf (`.windsurf/workflows/`)
- Other IDEs use different paths (e.g., Cursor uses `.cursor/prompts/`)
- Check `config/ide-mapping.yaml` for your IDE's configuration
- Windsurf is prioritized over VS Code (Windsurf extends VS Code)

---

## �️ Domain Structure

Each domain is a self-contained unit:

```
domains/{domain-name}/
├── .domain-metadata.yaml    # Domain configuration
├── workflows/               # Workflow files
│   ├── workflow1
│   └── assets/             # Optional: for workflow-specific files
│       ├── templates/
│       └── schemas/
├── rules/                   # Optional: may have assets/ too
├── skills/                  # Optional: may have assets/ too
└── README.md               # Domain documentation
```

### Domain Metadata

Each domain has `.domain-metadata.yaml` with:
- Domain name and description
- Dependencies (e.g., `_core` loaded first)
- Workflows/rules/skills provided
- IDE compatibility

**See individual domain docs for workflow/rule/skill details.**

---

## 📝 File Types

### Workflows
- Markdown files with YAML frontmatter
- Step-by-step instructions
- May have `assets/` subdirectory (templates, schemas, etc.)

### Rules
- Markdown files
- Behavioral constraints
- Applied globally or per-domain
- May have `assets/` subdirectory if needed

### Skills
- YAML files (`.skill.yaml` extension)
- Capability definitions
- May have `assets/` subdirectory if needed

**Assets deployment:** If any content type has an `assets/` subdirectory, it's deployed as `.assets-{domain}/` in the target IDE.

**Each file type has its own documentation within the file.**

---

## � Finding Content

**To use a workflow:**
1. Check `domains/{domain}/workflows/`
2. Read the workflow file itself for instructions

**To understand a domain:**
1. Read `domains/{domain}/README.md`
2. Check `.domain-metadata.yaml` for structure

**To create new domains:**
1. Read `domains/agent.md`
2. Follow the template structure

---

## ✅ Package Maintenance

**When updating files:**
- Follow naming conventions (lowercase-with-hyphens)
- Update `.domain-metadata.yaml` when adding workflows/rules/skills
- Update `CHANGELOG.md` with changes
- Keep `manifest.yaml` version current

**When creating examples:**
- Read `examples/agent.md`
- Place in `examples/{domain}/{example-name}/output/`

---

**For workflow execution details, read the workflow files themselves. This guide is only about package structure.**
