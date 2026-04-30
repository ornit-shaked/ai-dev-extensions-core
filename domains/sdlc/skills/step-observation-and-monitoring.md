---
name: "Observation & Monitoring"
tag: "Learning"
execution_intent: "agent-executed"
semantic_responsibility: "Collects real-world behavior and operational data."
input:
  conceptual: "System or process under observation; metrics or signals to collect."
output:
  conceptual: "Collected observations, measurements, or behavioral data."
status:
  complete: "Observations collected"
  needs_human: "Anomalies detected requiring interpretation"
prompt: |
  You are collecting real-world behavior and operational data from running systems.
  
  **Input:** System or process to observe, metrics/signals to collect, time period, context (expected behavior, baseline metrics).
  
  **Task:**
  1. Collect operational data:
     - **Performance metrics**: Latency, throughput, resource utilization
     - **Error data**: Exception rates, failure patterns, warnings
     - **Usage patterns**: User interactions, feature adoption, traffic patterns
     - **Business metrics**: Conversion rates, engagement, outcomes
  2. Compare actual vs. expected behavior (if baselines exist)
  3. Identify anomalies or deviations from normal patterns
  4. Organize data into coherent summary
  5. Flag significant findings for human review
  
  **Output format:**
  - **Measurements**: Quantitative data collected (metrics, counts, rates)
  - **Logs**: Relevant event sequences, errors, warnings
  - **Usage Patterns**: How users/systems interact with the feature
  - **Anomalies**: Deviations from expected behavior (flagged for review)
  - **Summary**: Consolidated view of system behavior
  
  **Data collection is mechanical:** Gather evidence, don't interpret or analyze (that's for Incident / Deviation Analysis).
---

# Observation & Monitoring

## What This Step Does

Observation & Monitoring collects real-world behavior and operational data from running systems or processes. It gathers evidence about actual performance, usage patterns, errors, and other measurable signals.

This Step is **agent-executed** because data collection is largely mechanical — gathering metrics, logs, and measurements.

**When this Step is needed:**
- Post-deployment (to monitor production behavior)
- During incident response (to collect diagnostic data)
- For post-implementation review (to assess actual vs. expected)
- For continuous improvement (to identify optimization opportunities)

## What This Step Is NOT

- **NOT a gate** — collects data, doesn't block work
- **NOT dependent on execution order** — can run independently
- **NOT analysis** — gathers data, doesn't interpret it
- **NOT orchestration logic** — doesn't manage other Steps
- **NOT alerting** — collects data, doesn't trigger responses

## Conceptual Guidance

### Typical Inputs
- System or process to observe (which component, feature, or workflow)
- Metrics or signals to collect (what to measure)
- Time period for observation
- Context (expected behavior, baseline metrics)

### Typical Outputs
- **Measurements**: Quantitative data (latency, throughput, error rates)
- **Logs**: Event sequences, errors, warnings
- **Usage patterns**: How users interact with the system
- **Anomalies**: Deviations from expected behavior (flagged for human review)

### Relationship to Other Steps
- **Precedes:** Incident / Deviation Analysis (observations feed analysis)
- **Used by:** Post-Implementation Review, Continuous Improvement
- **May trigger:** Incident / Deviation Analysis (if anomalies detected)

### Common Patterns
- **Performance monitoring**: Latency, throughput, resource utilization
- **Error tracking**: Exception rates, failure patterns
- **Usage analytics**: Feature adoption, user flows
- **Business metrics**: Conversion rates, engagement
