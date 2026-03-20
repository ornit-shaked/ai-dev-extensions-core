# AI Dev Extensions Core

**Reusable AI development workflows and rules for multiple IDEs**

A language-agnostic package providing structured workflows and rules that can be integrated into any microservice or project, regardless of programming language. Works with Windsurf, Cursor, and other AI-powered IDEs.

---

## 📑 Table of Contents

- [What is This?](#-what-is-this)
- [Quick Start](#-quick-start)
- [What's Inside?](#-whats-inside)
- [Documentation](#-documentation)
- [Multi-IDE Support](#-multi-ide-support)
- [Features](#-features)
- [Configuration](#-configuration)
- [Contributing](#-contributing)
- [Troubleshooting](#-troubleshooting)
- [License](#-license)

---

## 🎯 What is This?

This is a **content package** (not a code library) containing:

- 📋 **Workflows**: Step-by-step guides for AI agents (architecture intake, code review, etc.).
- 📏 **Rules**: Best practices and constraints for AI assistants
- 🛠️ **Skills**: Task-specific capabilities (future)

Think of it as a **"plugin pack"** for AI development tools.

---

## 🚀 Quick Start

### Two Simple Steps

**Step 1: Add as Git Submodule**

Choose ONE repository URL:

```bash
cd your-microservice
# Option 1: Bitbucket (internal)
git submodule add https://ilptltvbbp01.ecitele.com:8443/scm/~oshaked/ai-dev-extensions-core.git .dev-extensions

# Option 2: GitHub (public)
# git submodule add https://github.com/ornit-shaked/ai-dev-extensions-core.git .dev-extensions
```

> **Note:** `git submodule add` automatically downloads all files. No separate initialization needed.

**Step 2: Run Setup Script**

**Windows:**
```powershell
# Run as Administrator, OR enable Developer Mode first
.\.dev-extensions\scripts\setup-microservice.ps1
```

> **Windows Note:** Creating symlinks requires either:
> - Running PowerShell as Administrator, OR
> - Enabling Developer Mode: Settings → Update & Security → For developers → Developer Mode

**Linux/Mac:**
```bash
bash .dev-extensions/scripts/setup-microservice.sh
```

**That's it!** The script will:
- ✅ Detect your IDE (Windsurf/Cursor/VS Code)
- ✅ Create symlinks for workflows and rules
- ✅ Update `.gitignore`
- ✅ Load default domains (`_core` + `architecture`)

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

## � Troubleshooting

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

## �� What's Inside?

### Domains

#### 🧩 Core Domain (_core)
- **Rules**: Shared behavioral constraints (no-fabrication, minimal-changes)
- **Skills**: Reusable capabilities (future)
- **Priority**: Loaded first, used by all other domains

#### 🏗️ Architecture Domain
- **Workflows**: Architecture intake (create & resolve) with embedded templates
- **Use case**: Document microservice architecture for AI agents
- **Example**: See `examples/architecture/user-service-example/`

---

## 📖 Documentation

### For Developers
- **[SETUP.md](./SETUP.md)** - Integration guide
- **[CHANGELOG.md](./CHANGELOG.md)** - Version history and breaking changes

### For AI Agents
- **[AGENT_GUIDE.md](./AGENT_GUIDE.md)** - Complete guide for AI consumption and domain creation

### Configuration & Technical
- **[manifest.yaml](./manifest.yaml)** - Package metadata and domain configuration
- **[config/ide-mapping.yaml](./config/ide-mapping.yaml)** - IDE-specific mappings
- **[scripts/setup-microservice.ps1](./scripts/setup-microservice.ps1)** - Setup automation
- **[domains/](./domains/)** - Domain-specific content (_core, architecture)

---

## 🖥️ Multi-IDE Support

This package works with multiple AI-powered IDEs:

| IDE | Status | Workflows | Rules | Skills |
|-----|--------|-----------|-------|--------|
| **Windsurf** | ✅ Full Support | ✅ | ✅ | ✅ |
| **Cursor** | ✅ Supported | ✅ | ✅ | ❌ |
| **VS Code** | 🚧 Planned | - | - | - |
| **IntelliJ** | ⚠️ Manual Setup | ✅ | ✅ | ❌ |

**Note**: Workflows may contain a `templates/` subdirectory with workflow-specific assets (document templates, config files, etc.).

### IDE-Specific Notes

**Windsurf**: Full support for all content types. Auto-detection works seamlessly.

**Cursor**: Supports workflows (as prompts) and rules. Skills not supported.

**VS Code**: Planned for future releases. Will require AI extension (Copilot, Continue.dev, etc.).

**IntelliJ/JetBrains IDEs**: Requires manual setup as the script cannot auto-detect AI plugins. See `config/ide-mapping.yaml` for instructions.

### Configuration

IDE mappings are defined in [`config/ide-mapping.yaml`](./config/ide-mapping.yaml). To add support for a new IDE:
1. Update `config/ide-mapping.yaml` with target directories and mappings
2. Setup script will automatically handle the new IDE
3. Test and submit a PR!

---

## 🎨 Features

### ✅ Phase 1 (Current)
- ✅ Architecture domain with intake workflows
- ✅ Core domain with shared rules
- ✅ Windsurf workflow integration
- ✅ Language-agnostic design
- ✅ Complete example output
- ✅ Git-based distribution

### 🚧 Phase 2 (Planned)
- 🚧 User-configurable enable/disable per domain
- 🚧 Cursor IDE support

### 🔮 Phase 3 (Future)
- 🚧 npm package distribution
- 🔮 JFrog/Artifactory support
- 🔮 Auto-update mechanism
- 🔮 MCP (Model Context Protocol) integration
- 🔮 Multi-IDE auto-discovery

---

## 🔧 Configuration

### Enabling/Disabling Domains

**Manual approach** (Phase 1):
```bash
# Only use architecture domain
ln -s ../.dev-extensions/domains/architecture/workflows .windsurf/workflows
# Don't link security domain
```

**Future approach** (Phase 2):
```yaml
# Package structure
ai-dev-extensions-core/
  ├── manifest.yaml              # Package metadata and IDE mappings
  ├── domains/                   # Domain-specific content
  │   ├── _core/                # Shared rules, skills (priority 0)
  │   │   ├── rules/           # Behavioral constraints
  │   │   └── skills/          # Reusable capabilities
  │   └── architecture/         # Architecture documentation domain
  │       └── workflows/       # Architecture intake workflows
  │           └── assets/      # Workflow assets
  │               └── templates/
  ├── examples/                  # Example workflow outputs
  └── docs/                      # Additional documentation

# After integration (flatten mode)
.windsurf/
  └── workflows/
      ├── architecture-intake-create.md    # Individual workflow files
      ├── architecture-intake-resolve.md
      └── .assets-architecture/            # Symlinked from source assets/
          └── templates/                   # Workflow assets
```

---

## 🤝 Contributing

**Note**: Contributing guidelines will be added when project becomes open source.

### Adding a New Domain

**Quick reference**:
- Create `domains/{name}/{workflows,skills}/`
- Add `.domain-metadata.yaml` (see architecture domain as example)
- Update root `manifest.yaml`
- Create domain README

**Key metadata fields**:
- `priority`: Loading order (0=first, higher=later)
- `dependencies`: Always include `_core`
- `enabled_by_default`: true/false


## 🐛 Troubleshooting

**Workflows not appearing in Windsurf?**
- Check symlinks: `ls -la .windsurf/workflows`
- Verify frontmatter in workflow files
- Restart Windsurf

**Wrong content showing up?**
- Update submodule: `git submodule update --remote`
- Check you're on correct version/tag

**Need help?**
- Check [MICROSERVICE_INTEGRATION.md](./MICROSERVICE_INTEGRATION.md)
- Review examples in `examples/` directory
- Open an issue on GitHub

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
**Last Updated**: March 19, 2026
