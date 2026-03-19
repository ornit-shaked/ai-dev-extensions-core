# Skills Directory

This directory will contain reusable skill definitions for AI agents (Phase 2 feature).

## What are Skills?

**Skills** are declarative definitions of capabilities that AI agents can use to perform specific tasks. Think of them as reusable functions or tools.

## Status

⚠️ **Phase 2 Feature** - Skills framework is planned but not yet implemented.

## Planned Structure

```
skills/
├── code-analyzer.skill.yaml    # Analyze code patterns
├── test-runner.skill.yaml      # Execute tests
├── doc-generator.skill.yaml    # Generate documentation
└── README.md                   # This file
```

## Skill Schema (Draft)

```yaml
skill:
  name: "code-analyzer"
  version: "1.0.0"
  description: "Analyze code for patterns, issues, and metrics"
  
  # What this skill provides
  capabilities:
    - analyze_complexity
    - detect_patterns
    - find_unused_code
  
  # Inputs this skill needs
  inputs:
    - name: "file_path"
      type: "string"
      required: true
    - name: "language"
      type: "string"
      required: false
  
  # Outputs this skill produces
  outputs:
    - name: "analysis_report"
      type: "object"
      schema: "..."
  
  # How to use this skill
  usage:
    example: "Analyze src/main.py for complexity"
    context: "Use when workflow requires code analysis"
```

## Future Capabilities

Skills will enable:
- Reusable task definitions across workflows
- Consistent behavior across different AI agents
- Composable workflow building blocks
- Clear input/output contracts

## Development

Skills framework is tracked in:
- **TODO-038**: Define skill schema specification
- **TODO-039**: Create skill discovery mechanism
- **TODO-040**: Implement code-analyzer skill (example)

See [TODO.md](../TODO.md) for full list.

## Contributing

Skills framework is not yet ready for contributions. Please wait for Phase 2 release.

For questions or suggestions, open an issue on GitHub.
