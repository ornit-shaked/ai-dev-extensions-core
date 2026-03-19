# AI Dev Extensions Core

**Reusable AI development workflows, templates, and rules for multiple IDEs**

A language-agnostic package providing structured workflows, templates, and rules that can be integrated into any microservice or project, regardless of programming language. Works with Windsurf, Cursor, and other AI-powered IDEs.

---

## 🎯 What is This?

This is a **content package** (not a code library) containing:

- 📋 **Workflows**: Step-by-step guides for AI agents (architecture intake, code review, etc.)
- 📄 **Templates**: Reusable document templates
- 📏 **Rules**: Best practices and constraints for AI assistants
- 🛠️ **Skills**: Task-specific capabilities (future)

Think of it as a **"plugin pack"** for AI development tools.

---

## 🚀 Quick Start

### Installation

**Option 1: Git Submodule (Recommended)**
```bash
cd your-microservice
git submodule add https://github.com/ornit-shaked/ai-dev-extensions-core .dev-extensions
git submodule update --init --recursive
```

**Option 2: npm Package** (when available)
```bash
npm install -D @your-org/ai-dev-extensions-core
```

**Option 3: Manual Download**
```bash
curl -L https://github.com/ornit-shaked/ai-dev-extensions-core/archive/v0.1.0.tar.gz | tar xz
mv ai-dev-extensions-core-0.1.0 .dev-extensions
```

### Integration with Windsurf

See **[MICROSERVICE_INTEGRATION.md](./MICROSERVICE_INTEGRATION.md)** for detailed steps.

**Quick setup:**
```bash
# Create symlinks (Windsurf auto-discovers from .windsurf/)
ln -s ../.dev-extensions/domains/architecture/workflows .windsurf/workflows
ln -s ../.dev-extensions/domains/architecture/templates .windsurf/templates
ln -s ../.dev-extensions/rules .windsurf/rules
```

---

## 📦 What's Inside?

### Domains

#### 🏗️ Architecture Domain
- **Workflows**: Architecture intake (create & resolve)
- **Templates**: Identity, contracts, data models, flows, config, observability
- **Use case**: Document microservice architecture for AI agents
- **Example**: See `examples/architecture/user-service-example/`

#### 🧩 Core Domain (_core)
- **Rules**: Shared behavioral constraints (no-fabrication, minimal-changes)
- **Skills**: Reusable capabilities (future)
- **Priority**: Loaded first, used by all other domains

**Future domains** (planned):
- Code Review - code review workflows
- Security - security audit workflows

---

## 📖 Documentation

- **[MICROSERVICE_INTEGRATION.md](./MICROSERVICE_INTEGRATION.md)** - Step-by-step integration guide
- **[AGENT_GUIDE.md](./AGENT_GUIDE.md)** - AI agent consumption guide
- **[CHANGELOG.md](./CHANGELOG.md)** - Version history

---

## 🎨 Features

### ✅ Phase 1 (Current)
- ✅ Architecture domain with intake workflows
- ✅ Core domain with shared rules
- ✅ Windsurf workflow integration
- ✅ Template system
- ✅ Language-agnostic design
- ✅ Complete example output
- ✅ Git-based distribution

### 🚧 Phase 2 (Planned)
- 🚧 Skills framework
- 🚧 Dynamic domain loading
- 🚧 User-configurable enable/disable per domain
- 🚧 npm package distribution
- 🚧 Cursor IDE support

### 🔮 Phase 3 (Future)
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
# .windsurf/extensions.yaml
extensions:
  ai-dev-extensions-core/
  ├── manifest.yaml              # Package metadata and IDE mappings
  ├── domains/                   # Domain-specific content
  │   ├── _core/                # Shared rules, skills (priority 0)
  │   │   ├── rules/           # Behavioral constraints
  │   │   └── skills/          # Reusable capabilities
  │   └── architecture/         # Architecture documentation domain
  │       ├── workflows/       # Architecture intake workflows
  │       └── templates/       # Architecture templates
  ├── examples/                  # Example workflow outputs
  └── docs/                      # Additional documentation
```

---

## 🤝 Contributing

**Note**: Contributing guidelines will be added when project becomes open source.

### Adding a New Domain

```bash
# 1. Create domain structure
mkdir -p domains/my-domain/{workflows,templates}

# 2. Add metadata
cat > domains/my-domain/.domain-metadata.yaml << EOF
domain:
  name: "my-domain"
  description: "My awesome domain"
  enabled_by_default: false
EOF

# 3. Update manifest.yaml
# (Add entry under 'domains:' section)
```

---

## 📋 Best Practices

1. **Keep workflows atomic**: One workflow = one clear task
2. **Templates stay generic**: Avoid project-specific hardcoding
3. **Document everything**: Every workflow needs frontmatter metadata
4. **Test before commit**: Verify workflows work in target IDE
5. **Version carefully**: Use semantic versioning for releases

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
