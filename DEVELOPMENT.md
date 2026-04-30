# Development Guide

**Technical documentation for developers working on ai-dev-extensions-core**

---

## 📑 Table of Contents

- [Overview](#overview)
- [Technical Architecture](#technical-architecture)
- [Dependencies](#dependencies)
- [Development Setup](#development-setup)
- [Testing Strategy](#testing-strategy)
- [Security Considerations](#security-considerations)
- [Performance Guidelines](#performance-guidelines)
- [IDE Integration](#ide-integration)
- [Contributing](#contributing)

---

## Overview

AI Dev Extensions Core is a **content-only package** that provides structured workflows, rules, and skills for AI-powered development tools. It contains no runtime code - only static content files (Markdown, YAML) that AI agents consume.

**Key Principles**:
- Language-agnostic design
- Content only (no code execution)
- Git-based distribution
- Multi-IDE support through configuration
- Domain-based organization

---

## Technical Architecture

### Package Structure

See [README.md - File Structure](./README.md#file-structure) for complete package structure.

**Key technical points:**
- **Domain priority order:** `_core` (0) → `architecture` (1) → `sdlc` (2)
- **Content types:** workflows, rules, skills (all `.md` format)
- **IDE integration:** Symlinks via `config/ide-mapping.yaml`

### Integration Architecture

**Deployment Model**: Flatten Mode (Individual File Symlinks)

```
Microservice Project:
├── .dev-extensions/         # Git submodule (this package)
└── .windsurf/              # IDE directory
    ├── workflows/          # Individual workflow files (symlinks)
    │   ├── architecture-intake-create.md  → .dev-extensions/domains/architecture/workflows/...
    │   ├── architecture-intake-resolve.md → .dev-extensions/domains/architecture/workflows/...
    │   └── .assets-architecture/         → .dev-extensions/domains/architecture/workflows/assets/
    │       ├── intake-create/            # Assets for architecture-intake-create
    │       └── intake-resolve/           # Assets for architecture-intake-resolve (future)
    ├── rules/              # Individual rule files (symlinks)
    └── skills/             # Individual skill files (symlinks)
```

**Why Flatten Mode?**
- Windsurf IDE requires workflows directly under `.windsurf/workflows/`
- Directory symlinks (`.windsurf/workflows-architecture/`) don't work - IDE doesn't discover subdirectories
- Individual file symlinks ensure IDE discovery
- Assets are symlinked to `.assets-{domain}/` directories

### Configuration System

**Three-Layer Configuration**:

1. **manifest.yaml** - Package metadata and file references
   - Version information
   - Repository URLs
   - References to configuration files

2. **config/domain-mapping.yaml** - Domain definitions
   - Domain priorities (0=first, 1,2,3...=later)
   - Enabled by default flags
   - Content types per domain
   - Domain descriptions

3. **config/ide-mapping.yaml** - IDE-specific mappings
   - Target directories per IDE
   - Content type mappings
   - Supported features
   - Setup instructions

---

## Dependencies

### Required

- **Git**: Required for submodule management
- **PowerShell 5.1+**: Windows setup script
- **Bash 4.0+**: Linux/Mac setup script

### Optional

- **Administrator rights** (Windows): For symlink creation
  - Alternative: Developer Mode in Windows 10+
  - Fallback: Copy mode (automatic if no admin rights)

### No Runtime Dependencies

This is a **content package** - it has no code dependencies, build steps, or runtime requirements.

---

## Development Setup

### Local Development

1. **Clone the repository**:
   ```bash
   git clone <repo-url>
   cd ai-dev-extensions-core
   ```

2. **Test setup scripts**:
   ```powershell
   # Windows - Test in dry-run mode
   .\scripts\setup-microservice.ps1 -DryRun
   
   # Linux/Mac
   bash scripts/setup-microservice.sh
   ```

3. **Validate YAML files**:
   ```bash
   # Check YAML syntax
   yamllint config/domain-mapping.yaml
   yamllint config/ide-mapping.yaml
   yamllint manifest.yaml
   ```

4. **Test in a microservice**:
   - Create a test microservice project
   - Add this package as submodule
   - Run setup script
   - Verify symlinks and IDE discovery

### Creating New Domains

See [domains/agent.md](./domains/agent.md) for step-by-step guide.

**Quick Steps**:
1. Create `domains/{name}/` directory
2. Add `workflows/`, `rules/`, or `skills/` subdirectories
3. Create `.domain-metadata.yaml`
4. Update `config/domain-mapping.yaml`
5. Test with setup script

---

## Testing Strategy

### Manual Testing

**Integration Tests** (Required before release):
- [ ] Setup script execution on Windows (PowerShell)
- [ ] Setup script execution on Linux (Bash)
- [ ] Setup script execution on Mac (Bash)
- [ ] Symlink creation and validation
- [ ] Copy mode fallback (non-admin Windows)
- [ ] IDE workflow discovery in Windsurf
- [ ] IDE workflow discovery in Cursor
- [ ] Submodule update flow
- [ ] Domain selection logic

**Workflow Execution Tests**:
- [ ] Architecture intake create workflow
- [ ] Architecture intake resolve workflow
- [ ] PRD creation workflow
- [ ] All workflows execute without errors
- [ ] Templates are accessible via relative paths

**Configuration Tests**:
- [ ] YAML files are valid
- [ ] Domain priorities are respected
- [ ] IDE mappings are correct
- [ ] Manifest references are accurate

### Security Testing

**Symlink Security**:
- [ ] Symlink creation with non-admin user (expect clear error message)
- [ ] Path traversal attempts in workflow references (should fail)
- [ ] Malicious YAML in configuration files (should be rejected)

**Access Control**:
- Repository access controlled by Git permissions
- No sensitive data stored in package
- No code execution (content only)

### Performance Testing

**Baseline Metrics**:
- Setup script execution: < 5 seconds (typical project)
- Symlink creation: < 1 second per file
- Submodule update: Depends on network speed
- No runtime performance impact (content only)

**Large Scale Tests**:
- [ ] Setup with 10+ domains
- [ ] 100+ workflow files
- [ ] Large example files (>1MB)

---

## Security Considerations

### Symlink Permissions

**Windows Challenges**:
- Symlinks require Administrator rights by default
- **Mitigation**: Document requirement, provide Developer Mode instructions
- **Fallback**: Automatic copy mode if symlinks fail

**Security Warning**:
```powershell
# Documented in README
# Admin rights required for symlinks on Windows
# Alternative: Enable Developer Mode (Windows 10+)
# Fallback: Script uses copy mode automatically
```

### Content Security

- **No code execution**: Package contains only static content
- **No sensitive data**: No credentials, tokens, or secrets
- **Git permissions**: Access controlled at repository level
- **Read-only package**: Users should not modify .dev-extensions/

### Path Traversal Protection

Setup scripts should validate paths to prevent:
- Symlinks outside project directory
- Accessing system files
- Malicious path references in workflows

---

## Performance Guidelines

### Setup Script Performance

**Target Metrics**:
- Script execution: < 5 seconds for typical project
- Symlink creation: < 1 second for all domains
- Dry-run mode: < 2 seconds

**Optimization Tips**:
- Minimize file system operations
- Use batch operations where possible
- Cache domain configurations
- Parallel symlink creation (if supported)

### Submodule Updates

**Considerations**:
- Manual updates only (no automatic polling)
- Network speed dependent
- Version pinning recommended for production

---

## IDE Integration

### Supported IDEs

| IDE | Status | Implementation Notes |
|-----|--------|---------------------|
| **Windsurf** | ✅ Full Support | Auto-detection via `.windsurf/` directory |
| **Cursor** | ✅ Supported | Auto-detection via `.cursor/` directory, no skills support |
| **VS Code** | 🚧 Planned | Requires AI extension detection |
| **IntelliJ** | ⚠️ Manual Setup | Cannot auto-detect AI plugins |

### Adding New IDE Support

1. **Update config/ide-mapping.yaml**:
   ```yaml
   new-ide:
     display_name: "New IDE"
     target_directory: ".new-ide"
     supported: true
     mappings:
       workflows:
         target: "workflows"
         description: "Workflow definitions"
   ```

2. **Update setup scripts**:
   - Add IDE detection logic
   - Add directory creation logic
   - Add symlink creation logic

3. **Test**:
   - Test auto-detection
   - Verify workflow discovery
   - Document any limitations

4. **Update documentation**:
   - README.md
   - AGENT_GUIDE.md
   - This file

---

## Contributing

### Code Review Checklist

Before submitting changes:

- [ ] YAML files are valid (run yamllint)
- [ ] Setup scripts tested on Windows and Linux
- [ ] Documentation updated (README, AGENT_GUIDE, DEVELOPMENT)
- [ ] Examples provided for new features
- [ ] Breaking changes documented
- [ ] Version bumped appropriately (semantic versioning)

### Breaking Changes

**Definition**: Changes that require users to re-run setup or modify existing workflows

**Process**:
1. Document in pull request
2. Update version (major bump)
3. Create migration guide
4. Update all affected documentation
5. Add to CHANGELOG.md (when created)

### Version Guidelines

**Semantic Versioning**:
- **Major** (x.0.0): Breaking changes (flatten mode, structure changes)
- **Minor** (0.x.0): New domains, new workflows, new IDEs
- **Patch** (0.0.x): Bug fixes, documentation updates

---

## Troubleshooting Development Issues

### Setup Script Fails

**Symptoms**: Script errors, symlinks not created

**Debug Steps**:
1. Run in dry-run mode: `-DryRun`
2. Check permissions (admin/Developer Mode on Windows)
3. Verify Git submodule is initialized
4. Check YAML syntax
5. Review script output for specific errors

### IDE Not Discovering Workflows

**Symptoms**: Workflows don't appear in IDE

**Debug Steps**:
1. Check symlinks exist: `ls -la .windsurf/workflows`
2. Verify workflow frontmatter (YAML header)
3. Restart IDE
4. Check IDE version compatibility
5. Verify flatten mode (individual files, not directories)

### Configuration Issues

**Symptoms**: Wrong domains loaded, incorrect paths

**Debug Steps**:
1. Validate YAML: `yamllint config/*.yaml`
2. Check manifest.yaml references
3. Verify domain priorities
4. Review setup script output
5. Check .gitignore isn't excluding files

---

**For Questions**:
- Review [AGENT_GUIDE.md](./AGENT_GUIDE.md) for AI agent details
- Review [README.md](./README.md) for user documentation
- Open an issue on GitHub

---

**Version**: 0.1.0  
**Last Updated**: March 22, 2026
