# SDLC Tests

This directory contains automated test definitions for validating SDLC Flows and Steps.

## Purpose

Test definitions enable automated validation of:
- Flow completeness and clarity
- Step prompts and execution intent
- User journey simulations
- Friction point identification

## Structure

```
tests/
├── README.md                    # This file
├── test-runner.md              # Instructions for LLM to run tests
├── feedback-template.md        # Structured output format
├── flows/                      # Flow-level tests
│   ├── test-create-prd.md
│   ├── test-technical-planning.md
│   └── ...
└── results/                    # Generated feedback files
    ├── create-prd-results.md
    └── ...
```

## How to Run a Test

1. Read `test-runner.md` for execution instructions
2. Select a test definition from `flows/`
3. Follow test runner process
4. Generate feedback using `feedback-template.md`
5. Save results to `results/`

## Test Philosophy

- **Declarative:** Tests define scenarios, LLM executes
- **Auto-discovery:** Tests read Flow/Step definitions automatically
- **Consistent:** All tests use same evaluation criteria
- **Extensible:** Framework works for Flows, Steps, and future artifacts
