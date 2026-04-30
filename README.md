# AI Dev Extensions Core

**Reusable AI development workflows, skills, and rules for multiple IDEs - Language-agnostic**

---

## 📑 Table of Contents

- [Introduction](#section-1-introduction)
- [Prerequisites](#-prerequisites)
- [How To Use](#section-2-how-to-use)
- [What's Included](#-whats-included)
- [What's NOT Included (Non-Goals)](#-whats-not-included-non-goals)
- [Documentation Navigation](#-documentation-navigation)
- [Features](#-features)
  - [Multi-IDE Support](#️-multi-ide-support)
  - [Multi-Domains Support](#️-multi-domains-support)
- [Troubleshooting](#-troubleshooting)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)

---

## Section 1: Introduction

**What**: A language-agnostic content package providing structured workflows, rules, and skills for AI-powered development tools (Windsurf, Cursor, VS Code). The package is distributed as a Git submodule and integrates into projects via symlinks, enabling AI agents to follow standardized processes such as architecture documentation, PRD creation, code review and etc.
Think of it as a **"plugin pack"** for AI development tools.

**Why**: Development teams lack standardized, reusable workflows for AI agents working on microservices. Each project creates ad-hoc documentation approaches, leading to inconsistent quality, repeated work, and poor AI agent guidance. This package solves the problem by providing battle-tested workflows that AI agents can consume directly from their IDE.

**Goal**: Enable AI agents across multiple IDEs to produce consistent, high-quality documentation and follow best practices through standardized workflows, skills, and rules that are maintained centrally and distributed to all projects.

---

## 📋 Prerequisites

Before you begin, ensure you have:

- **Git** installed and configured
- **PowerShell 5.1+** (Windows) or **Bash 4.0+** (Linux/Mac)
- **Administrator rights** or **Developer Mode enabled** (Windows only, for symlinks)
  - *Alternative*: Script automatically uses copy mode if symlinks aren't available
  - *Copy mode*: Works without admin, but requires re-running setup after package updates
  - *Symlink mode*: Recommended, updates automatically with package

---

## Section 2: How To Use

### 🚀 Super Simple (Recommended)

**One line in your build.gradle:**

```gradle
apply from: 'https://raw.githubusercontent.com/ornit-shaked/ai-dev-extensions-core/main/gradle/setup-ai-extensions.gradle'
```

**Then run:**
```bash
./gradlew setupAiExtensions
```

**That's it!** The task will:
- ✅ Download latest version from GitHub
- ✅ Copy workflows to `.windsurf/workflows/`  
- ✅ Copy domains to `.ai-extensions/domains/`
- ✅ Update `.gitignore`
- ✅ Clean up temporary files

---

### 🔧 Advanced: Git Submodule (If you need version control)

**Step 1: Add as Git Submodule**

```bash
cd your-microservice
git submodule add https://github.com/ornit-shaked/ai-dev-extensions-core.git .dev-extensions
```

**Step 2: Run Setup Script**

**Windows:**
```powershell
.\.dev-extensions\scripts\setup-microservice.ps1
```

**Linux/Mac:**
```bash
bash .dev-extensions/scripts/setup-microservice.sh
```

---

### Options

```powershell
# Use specific IDE
.\.dev-extensions\scripts\setup-microservice.ps1 -IDE cursor

# Preview changes without modifying anything
.\.dev-extensions\scripts\setup-microservice.ps1 -DryRun
```

### Bitbucket Users

Use Bitbucket URL in Step 1:
```bash
git submodule add https://ilptltvbbp01.ecitele.com:8443/scm/~oshaked/ai-dev-extensions-core.git .dev-extensions
```

---

## 📦 What's Included

This package provides:

- **📋 Workflows**: Step-by-step guides for AI agents (architecture intake, PRD creation, code review)
- **📏 Rules**: Best practices and behavioral constraints for AI assistants
- **🛠️ Skills**: Task-specific capabilities (YAML-based)
- **📁 Domains**: Organized content modules (`_core`, `architecture`, and extensible)
- **⚙️ Setup Scripts**: Automated integration for Windows/Linux/Mac
- **📝 Examples**: Sample outputs demonstrating correct workflow execution

### File Structure

**Domain Structure Pattern:**

Each domain can contain:
```
domain-name/
├── workflows/           # Workflow definitions (*.md)
│   └── assets/         # Optional: workflow assets (templates, schemas)
│       ├── workflow-a/ # Assets specific to workflow-a
│       └── workflow-b/ # Assets specific to workflow-b
├── rules/              # Behavioral rules (*.md)
│   └── assets/         # Optional: rule assets
├── skills/             # Skill definitions (*.md)
│   └── assets/         # Optional: skill assets
├── .domain-metadata.yaml    # Domain registration and asset inventory
└── README.md               # Human-readable documentation and usage guide
```

**File Purposes:**
- **`.domain-metadata.yaml`**: Technical registration (name, priority, dependencies, asset list with IDs/paths)
- **`README.md`**: User documentation (overview, usage examples, available workflows/skills descriptions)

**Asset Organization:**
- Assets are organized per-workflow/rule/skill for clear ownership
- Referenced in workflows as `.assets-{domain}/{workflow-name}/file.md`

**Package Structure:**

```
ai-dev-extensions-core/
├── domains/
│   ├── _core/          # Shared rules and skills (priority 0)
│   ├── architecture/   # Architecture workflows (priority 1)
│   └── sdlc/          # SDLC flows and steps (priority 2)
├── config/
│   ├── domain-mapping.yaml
│   └── ide-mapping.yaml
├── scripts/
│   ├── setup-microservice.ps1
│   └── setup-microservice.sh
├── manifest.yaml
├── AGENT_GUIDE.md
└── README.md
```

---

## ❌ What's NOT Included (Non-Goals)

This package is a **content-only package**. It does NOT:

- ❌ **Generate code automatically** - Workflows guide documentation only, not code implementation
- ❌ **Act as an IDE plugin** - Works with existing AI IDE capabilities (Windsurf, Cursor, etc.)
- ❌ **Execute code or run linting** - Static content package only, no runtime execution
- ❌ **Provide authentication or access control** - Relies on Git repository permissions
- ❌ **Offer cloud-hosted SaaS service** - Git-based distribution only
- ❌ **Create PRs or integrate with CI/CD** - Manual workflow execution
- ❌ **Support multi-language translations** - English only in v1.0
- ❌ **Include visual workflow editors or GUI tools** - Markdown-based workflows

Think of it as a **"recipe book" for AI agents**, not a code generator or automation tool.

---

## 📖 Documentation Navigation

### For Developers
- **[README.md](./README.md)** - This file (overview, quick start and setup guide)

### For AI Agents
- **[AGENT_GUIDE.md](./AGENT_GUIDE.md)** - Complete guide for AI consumption and domain creation

### Configuration & Technical
- **[manifest.yaml](./manifest.yaml)** - Package metadata and reference configuration
- **[config/ide-mapping.yaml](./config/ide-mapping.yaml)** - IDE-specific mappings (you can add/edit support for new IDEs here)
- **[config/domain-mapping.yaml](./config/domain-mapping.yaml)** - Domain-specific mappings (you can add/edit support for new domains here)
- **[scripts/setup-microservice.ps1](./scripts/setup-microservice.ps1)** - Setup automation for Windows
- **[scripts/setup-microservice.sh](./scripts/setup-microservice.sh)** - Setup automation for bash
- **[domains/](./domains/)** - Domain-specific content (_core, architecture)

---


## 🎨 Features

### Key Features

- Multi-IDE support
- Multi-domains support
- Language-agnostic design
- Content only (no code dependencies, no build required)

---

### Supported and Future Planning

✅ Phase 1 (Current)
- ✅ User-configurable enable/disable per domain
- ✅ Architecture domain with intake workflows
- ✅ Core domain
- ✅ Windsurf workflow integration
- ✅ Git-based distribution

🚧 Phase 2 (Planned)
- 🚧 Extending Core domain with shared rules
- 🚧 Cursor IDE support

🔮 Phase 3 (Future)
- 🔮 npm package distribution
- 🔮 JFrog/Artifactory support
- 🔮 Auto-update mechanism
- 🔮 MCP (Model Context Protocol) integration
- 🔮 Multi-IDE auto-discovery

---

### Features Explanation

#### 🖥️ Multi-IDE Support

This package works with multiple AI-powered IDEs:

| IDE | Status | Workflows | Rules | Skills |
|-----|--------|-----------|-------|--------|
| **Windsurf** | ✅ Full Support | ✅ | ✅ | ✅ |
| **Cursor** | ✅ Supported | ✅ | ✅ | ❌ |
| **VS Code** | 🚧 Planned | - | - | - |
| **IntelliJ** | ⚠️ Manual Setup | ✅ | ✅ | ❌ |

**Note**: Each type may contain a `assets/` subdirectory with type-specific assets (templates, config files, etc.).

IDE-Specific Notes

**Windsurf**: Full support for all content types. Auto-detection works seamlessly.

**Cursor**: Supports workflows (as prompts) and rules. Skills not supported.

**VS Code**: Planned for future releases. Will require AI extension (Copilot, Continue.dev, etc.).

---

### 🖥️ Multi-Domains Support

This package supports multiple domains:

| Domain | Status | Description |
|--------|--------|-------------|
| **_core** | ✅ Active | Shared basic workflows and utilities |
| **architecture** | ✅ Active | Architecture intake workflows |
| **[new-domain]** | 🚧 Planned | Add your own domains |

**Note**: You can add new domains by creating a new directory in the `domains/` folder and updating `config/domain-mapping.yaml`.
You can control which domains are enabled/disabled in the `config/domain-mapping.yaml` file.
You can control the loading order of domains in the `config/domain-mapping.yaml` file.

#### Adding a New Domain

**Quick reference**:
- Create `domains/{name}/{workflows,rules,skills}/`
- Add `.domain-metadata.yaml` (see architecture domain as example)
- Update `config/domain-mapping.yaml` to register the new domain
- Create domain README
- See [AGENT_GUIDE.md](./AGENT_GUIDE.md) for detailed instructions

**Key metadata fields**:
- `priority`: Loading order (0=first, 1,2,3... = later)
- `enabled_by_default`: true/false
- `content_types`: List of content types (workflows, rules, skills)
- `description`: Brief description of the domain

---

## 🐛 Troubleshooting

**Workflows not appearing in Windsurf?**
- Check symlinks: `ls -la .windsurf/workflows`
- Verify frontmatter in workflow files
- Restart Windsurf

**Wrong content showing up?**
- Update submodule: `git submodule update --remote`
- Check you're on correct version/tag

**Need help?**
- Review [AGENT_GUIDE.md](./AGENT_GUIDE.md) for domain creation
- Open an issue on GitHub

### Removing/Reinstalling Submodule

If you get `fatal: '.dev-extensions' already exists in the index` after manually deleting `.dev-extensions`, you need to clean up git's submodule tracking:

**Windows (PowerShell):**
```powershell
# Clean removal
git submodule deinit -f .dev-extensions
git rm -f .dev-extensions
Remove-Item -Recurse -Force .git\modules\.dev-extensions

# Then add again
git submodule add <repo-url> .dev-extensions
```

**Linux/Mac (Bash):**
```bash
# Clean removal
git submodule deinit -f .dev-extensions
git rm -f .dev-extensions
rm -rf .git/modules/.dev-extensions

# Then add again
git submodule add <repo-url> .dev-extensions
```

**Why?** Git tracks submodules in 3 places: `.gitmodules`, git index, and `.git/modules/`. Manual deletion only removes files, not tracking info.

---

## 📝 License

MIT License - see [LICENSE](./LICENSE) file

---

## 🙏 Acknowledgments

Built for AI-powered development with:
- [Windsurf](https://codeium.com/windsurf) - AI IDE
- [Cursor](https://cursor.sh/) - AI Code Editor
- Inspired by modern extension ecosystems

---

**Version**: 0.1.0  
**Status**: Active Development (Phase 1)  
**Last Updated**: March 22, 2026
