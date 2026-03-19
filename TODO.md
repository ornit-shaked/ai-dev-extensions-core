# TODO List

**Prioritized tasks for ai-dev-extensions-core development**

---

## 🔴 High Priority (Phase 1 - Must Have)

### Documentation
- [ ] **TODO-001**: Add usage examples to README with screenshots
- [ ] **TODO-002**: Create video walkthrough of architecture-intake workflow
- [ ] **TODO-003**: Write troubleshooting guide for common symlink issues on Windows

### Content
- [ ] **TODO-004**: Copy architecture-intake workflows from auto-prompt-hub
- [ ] **TODO-005**: Copy architecture-intake templates from auto-prompt-hub
- [ ] **TODO-006**: Create `no-fabrication.md` rule
- [ ] **TODO-007**: Create `minimal-changes.md` rule
- [ ] **TODO-008**: Add domain metadata files (`.domain-metadata.yaml`)

### Testing
- [ ] **TODO-009**: Test submodule integration in real microservice (Java)
- [ ] **TODO-010**: Test submodule integration in real microservice (Node.js)
- [ ] **TODO-011**: Verify workflows execute correctly in Windsurf
- [ ] **TODO-012**: Test Windows symlink creation (developer mode)

### Repository
- [ ] **TODO-013**: Initialize Git repository
- [ ] **TODO-014**: Create initial commit with structure
- [ ] **TODO-015**: Push to GitHub/GitLab
- [ ] **TODO-016**: Create v0.1.0 release tag
- [ ] **TODO-017**: Write release notes for v0.1.0

---

## 🟡 Medium Priority (Phase 1 - Should Have)

### Content
- [ ] **TODO-018**: Create code-review workflow (basic)
- [ ] **TODO-019**: Create code-review templates
- [ ] **TODO-020**: Add example outputs to `examples/` directory
- [ ] **TODO-021**: Create security domain placeholder (minimal)

### Documentation
- [ ] **TODO-022**: Add FAQ section to README
- [ ] **TODO-023**: Document manifest.yaml schema in detail
- [ ] **TODO-024**: Create CONTRIBUTING.md guide
- [ ] **TODO-025**: Add badges to README (version, license, build status)

### Configuration
- [ ] **TODO-026**: Add example `.windsurf/extensions.yaml` config (for future)
- [ ] **TODO-027**: Create setup script for symlink automation
- [ ] **TODO-028**: Test manual copy method and document differences

---

## 🟢 Low Priority (Phase 1 - Nice to Have)

### Content
- [ ] **TODO-029**: Add more rules (security-first.md, test-driven.md)
- [ ] **TODO-030**: Create template validation checklist
- [ ] **TODO-031**: Add workflow versioning strategy documentation

### Tooling
- [ ] **TODO-032**: Create validation script for manifest.yaml
- [ ] **TODO-033**: Add pre-commit hooks for formatting
- [ ] **TODO-034**: Create workflow linter (check frontmatter, structure)

### Community
- [ ] **TODO-035**: Add CODE_OF_CONDUCT.md
- [ ] **TODO-036**: Create issue templates (bug, feature request, new domain)
- [ ] **TODO-037**: Set up GitHub Actions for basic CI (validate manifest)

---

## 🔵 Phase 2 Items (Future)

### Skills Framework
- [ ] **TODO-038**: Define skill schema specification
- [ ] **TODO-039**: Create skill discovery mechanism
- [ ] **TODO-040**: Implement code-analyzer skill (example)
- [ ] **TODO-041**: Document skill development guide

### Dynamic Loading
- [ ] **TODO-042**: Design `.windsurf/extensions.yaml` config format
- [ ] **TODO-043**: Implement domain enable/disable logic (if Windsurf supports)
- [ ] **TODO-044**: Create domain dependency resolver
- [ ] **TODO-045**: Test multi-domain configurations

### npm Distribution
- [ ] **TODO-046**: Finalize package.json for npm
- [ ] **TODO-047**: Test npm install in sample project
- [ ] **TODO-048**: Publish to npm registry (public or private)
- [ ] **TODO-049**: Create npm-specific integration docs
- [ ] **TODO-050**: Add npm badge to README

### Cursor Support
- [ ] **TODO-051**: Test rules in Cursor IDE
- [ ] **TODO-052**: Verify workflow compatibility (if applicable)
- [ ] **TODO-053**: Create Cursor-specific integration guide
- [ ] **TODO-054**: Document Cursor vs Windsurf differences

---

## 🟣 Phase 3 Items (Future)

### Enterprise Features
- [ ] **TODO-055**: JFrog publish configuration
- [ ] **TODO-056**: Create enterprise deployment guide
- [ ] **TODO-057**: Implement version checking mechanism
- [ ] **TODO-058**: Design rollback strategy
- [ ] **TODO-059**: Add update notifications (if possible)

### MCP Integration
- [ ] **TODO-060**: Research MCP protocol integration
- [ ] **TODO-061**: Create Jira workflow integration
- [ ] **TODO-062**: Create Confluence workflow integration
- [ ] **TODO-063**: Document MCP setup and usage

### Advanced Features
- [ ] **TODO-064**: Workflow composition (workflows calling workflows)
- [ ] **TODO-065**: Template inheritance system
- [ ] **TODO-066**: Conditional domain loading
- [ ] **TODO-067**: Performance optimization for large projects

---

## ⚪ Backlog (Ideas / Under Consideration)

### Content
- [ ] **TODO-068**: Refactoring workflow
- [ ] **TODO-069**: Performance optimization workflow
- [ ] **TODO-070**: Database migration workflow
- [ ] **TODO-071**: API documentation workflow
- [ ] **TODO-072**: Onboarding new developer workflow

### Features
- [ ] **TODO-073**: Multi-language template support (i18n)
- [ ] **TODO-074**: Workflow analytics and usage tracking
- [ ] **TODO-075**: Community marketplace for domains
- [ ] **TODO-076**: Extension certification/quality badges
- [ ] **TODO-077**: VS Code extension compatibility

### Tooling
- [ ] **TODO-078**: Web-based workflow builder/editor
- [ ] **TODO-079**: Visual workflow execution debugger
- [ ] **TODO-080**: Template playground/preview tool
- [ ] **TODO-081**: Automated testing framework for workflows

---

## 🔄 In Progress

Currently no items in progress. Update this section when work begins.

---

## ✅ Completed

### March 19, 2026
- [x] **TODO-082**: Create manifest.yaml structure
- [x] **TODO-083**: Write README.md
- [x] **TODO-084**: Write AGENT_GUIDE.md
- [x] **TODO-085**: Write MICROSERVICE_INTEGRATION.md
- [x] **TODO-086**: Write PLAN.md
- [x] **TODO-087**: Create project directory structure
- [x] **TODO-088**: Create TODO.md (this file)

---

## 📝 Notes on TODO Management

### Conventions
- **TODO-XXX**: Unique ID for tracking
- **Priority**: 🔴 High, 🟡 Medium, 🟢 Low
- **Phase**: Group by development phase
- **Status**: Update when starting/completing

### Adding New TODOs
1. Assign next sequential TODO-XXX ID
2. Place in appropriate priority/phase section
3. Use clear, actionable description
4. Link to related issues if applicable

### Completing TODOs
1. Move to "Completed" section with date
2. Update related documentation if needed
3. Close related GitHub issues
4. Update PLAN.md if milestone reached

---

**Last Updated**: March 19, 2026  
**Total TODOs**: 88 (6 completed, 82 pending)  
**Current Focus**: Phase 1 High Priority items
