# Rules Directory

This directory contains behavioral rules that AI agents should follow when executing workflows.

## What are Rules?

**Rules** are markdown documents that define constraints, best practices, and guidelines for AI assistants. They apply globally across all workflows and domains.

## Purpose

Rules help ensure:
- Consistent behavior across different AI agents
- Quality standards are maintained
- Common pitfalls are avoided
- Security best practices are followed

## Directory Structure

```
rules/
├── no-fabrication.md      # Never invent data not in codebase
├── minimal-changes.md     # Prefer focused, minimal edits
├── security-first.md      # Security considerations (planned)
└── README.md             # This file
```

## How Rules Work

1. **Discovery**: AI agents load rules from this directory
2. **Application**: Rules apply to all tasks, not just specific workflows
3. **Priority**: Rules take precedence over other instructions
4. **Enforcement**: Agents must follow rules or explicitly document violations

## Rule Format

Each rule should be a markdown file with:

```markdown
# Rule Name

## Directive
Clear statement of what to do or not do

## Rationale
Why this rule exists

## Examples
Good and bad examples

## When to Override
Rare exceptions (if any)

## Enforcement
How to verify compliance
```

## Creating New Rules

1. Create markdown file in `rules/` directory
2. Use clear, imperative language
3. Provide examples
4. Document in this README
5. Update manifest.yaml if needed

## Available Rules

### no-fabrication.md
**Status**: Planned  
**Applies to**: All workflows

Never invent or guess data that doesn't exist in the codebase:
- API endpoints
- Configuration values
- Error codes
- Database schemas

Mark uncertain items as `needs-human: true` instead.

### minimal-changes.md
**Status**: Planned  
**Applies to**: Code editing tasks

Prefer single-line changes over large refactors:
- Fix root cause, not symptoms
- Avoid over-engineering
- Keep changes focused
- Add tests, not workarounds

## Best Practices

1. **Keep rules atomic**: One rule = one clear directive
2. **Make rules testable**: Can you verify compliance?
3. **Provide examples**: Show good and bad patterns
4. **Document exceptions**: When can rules be overridden?
5. **Review regularly**: Are rules still relevant?

## Usage

Rules are automatically loaded by AI agents when workflows are executed. No explicit inclusion needed.

For Windsurf integration:
```bash
ln -s ../.dev-extensions/rules .windsurf/rules
```

See [MICROSERVICE_INTEGRATION.md](../MICROSERVICE_INTEGRATION.md) for details.
