---
description: Extract and document service/library architectural knowledge for AI agents and engineers
---

# Architecture Intake Workflow

## Overview

This workflow systematically extracts architectural knowledge from a service or library codebase and generates structured documentation. The output enables AI agents to safely understand boundaries, contracts, and architecture for bug fixes and feature implementation.

## Execution

When user runs `/architecture-intake-create`, follow these steps:

### Step 1: Initialize Collection

Ask user for the service name:
```
Service/library name (e.g., tosca-engine-ms): 
```

Set variables:
- `SERVICE_NAME` = user input
- `TIMESTAMP` = current timestamp
- `OUTPUT_DIR` = `docs/architecture/`

Create output directory if it doesn't exist.

### Step 2: Collect Section Data

For each section (1-8), execute collection logic and fill the corresponding template from `templates/`.

---

## Section 1: Identity & Boundaries

**Template**: `1-identity-template.md`  
**Source**: SEMI  
**Priority**: ESSENTIAL

### Collection Steps

1. **Purpose & Description**
   - Read `README.md` - extract description/overview
   - Read `package-info.json` or `build.gradle` - extract metadata
   - Search for `@SpringBootApplication` class javadoc

2. **Responsibilities**
   - Extract from README "Features" or "Main features" section
   - List key capabilities from main package structure
   - Check `ms-config/ServiceDescriptor/*.yaml` for service description

3. **Non-Goals**
   - **Cannot auto-detect** - mark as `needs-human: true`
   - Add placeholder: "Requires business context"

4. **Ownership**
   - Extract team name from `package-info.json` or README
   - Find contacts/maintainers in README
   - Get git remote URL: `git config --get remote.origin.url`

5. **Documentation Links**
   - Search README for wiki links (e.g., `wiki.rbbn.com`)
   - Find HLD/design doc references

6. **Integration Points**
   - Search for `@FeignClient`, `RestTemplate`, `WebClient` - upstream dependencies
   - Search for `@RestController` - downstream consumers
   - Check `application.yaml` for external service URLs

### Output Metadata
```yaml
source: SEMI
completeness: PARTIAL
needs-human: true  # Non-goals require human input
risk: LOW
```

---

## Section 2: Architecture

**Template**: `2-architecture-template.md`  
**Source**: AUTO  
**Priority**: ESSENTIAL

### Collection Steps

1. **Technology Stack**
   - Read `build.gradle` or `pom.xml` - extract Java version, Spring Boot version
   - List major dependencies (Spring, MongoDB driver, RabbitMQ, etc.)
   - Identify build tool (Gradle/Maven)

2. **Infrastructure**
   - Search `application.yaml` for:
     - `mongodb.*` → MongoDB
     - `spring.datasource.*` → PostgreSQL/MySQL
     - `rabbitmq.*` → RabbitMQ
     - `spring.kafka.*` → Kafka
     - `spring.redis.*` → Redis

3. **C4 Views**
   - **Context**: Combine purpose from README + integration points
   - **Container**: List main packages under `src/main/java/`
   - Create component table from `@Controller`, `@Service`, `@Repository` classes

4. **Design Patterns**
   - Detect: Microservice (if REST API exists)
   - Detect: Repository pattern (if `@Repository` exists)
   - Detect: Event-driven (if message broker configured)
   - Detect: Layered (if controller/service/repository structure)

5. **Deployment**
   - Check for `Dockerfile` → Docker
   - Check for `chart/` directory → Kubernetes/Helm
   - Find `ms-config/ServiceDescriptor/*.yaml`

### Output Metadata
```yaml
source: AUTO
completeness: COMPLETE
needs-human: false
risk: LOW
```

---

## Section 3: Contracts & APIs

**Template**: `3-contracts-template.md`  
**Source**: SEMI  
**Priority**: ESSENTIAL

### Collection Steps

1. **REST API**
   - Search for `openapi.yaml`, `swagger.yaml`, `openapi.json` in `src/main/resources/`
   - If not found AND `DEV_SERVER_URL` is set:
     - Fetch spec: `Invoke-WebRequest -Uri "{DEV_SERVER_URL}/v3/api-docs" -OutFile "src/main/resources/openapi.json"`
     - If successful: mark spec as fetched from dev server, do NOT add to open issues
     - If failed: mark `needs-human: true`, add to open issues
   - If not found AND `DEV_SERVER_URL` is empty: mark `needs-human: true`, add to open issues
   - Find all `@RestController` classes
   - Extract `@RequestMapping`, `@GetMapping`, `@PostMapping`, etc.
   - Build endpoint table: method, path, controller, description

2. **Request/Response Models**
   - Find DTO classes (classes ending with `DTO`, `Request`, `Response`)
   - List key fields for main DTOs

3. **Async/Event Contracts**
   - Search for `@RabbitListener`, `@KafkaListener` → consumed events
   - Search for `RabbitTemplate`, `KafkaTemplate` usages → published events
   - Extract exchange/topic names and routing key constant references (e.g., `SomeInterface.EXCHANGE_NAME`)
   - **Auto-resolve constant values from Gradle cache**: For each unresolved constant interface:
     1. Identify the library from the import statement (e.g., `com.sdn.tosca.engine.client.dtos.notficition.ToscaEngineNotificationQIf`)
     2. Derive group and artifact from the package (e.g., group=`com.sdn.tosca`, artifact=`tosca-engine-api`)
     3. Find the latest JAR: `Get-ChildItem "$env:USERPROFILE\.gradle\caches\modules-2\files-2.1\{group}\{artifact}" -Recurse -Filter "*.jar" | Where-Object { $_.Name -notlike "*sources*" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1`
     4. Run: `javap -classpath {jar-path} -constants {fully.qualified.InterfaceName}`
     5. Replace all symbolic constant references in the output with actual extracted string values
     6. If JAR not found in cache: mark as `needs-human: true` and add to open issues
   - **Output format**: Always include both sections with fixed headings:
     - `### Consumed Events` — table if found, otherwise: `**No consumed events detected** — This service does not listen to any RabbitMQ/Kafka topics.`
     - `### Published Events` — table if found, otherwise: `**No published events detected** — This service does not send any RabbitMQ/Kafka messages.`
   - Document event schemas if found

4. **External Integrations**
   - Find `@FeignClient` annotations → HTTP clients
   - Search for `RestTemplate`, `WebClient` usage
   - Check `application.yaml` for external service URLs
   - List third-party APIs

5. **Error Responses**
   - Find `@ExceptionHandler` methods
   - Map exceptions to HTTP status codes
   - Document error response format

### Output Metadata
```yaml
source: SEMI
completeness: PARTIAL  # If OpenAPI missing
needs-human: true      # If OpenAPI missing
risk: HIGH             # Contracts are critical
```

---

## Section 4: Data & Migrations

**Template**: `4-data-template.md`  
**Source**: AUTO  
**Priority**: ESSENTIAL

### Collection Steps

1. **Database Configuration**
   - Extract from `application.yaml`:
     - Database type (MongoDB/PostgreSQL/MySQL)
     - Database name
     - Host/port
   - Check for Redis, Elasticsearch configs

2. **Domain Entities**
   - Find `@Entity` (JPA), `@Document` (MongoDB), or domain model classes
   - List entity names, collection/table names
   - Extract key fields from main entities
   - Document indexes (`@Indexed`, `@Index`)

3. **Migrations**
   - Check for:
     - `config/migration/*.yaml` → Custom MongoDB migrations
     - `src/main/resources/db/migration/` → Flyway
     - `src/main/resources/db/changelog/` → Liquibase
   - List recent migration files
   - Document migration execution strategy

4. **Data Invariants**
   - Find validation annotations: `@NotNull`, `@Size`, `@Pattern`, `@Valid`
   - Document unique constraints
   - Extract business rules from comments/javadoc

5. **Repository Layer**
   - Find `@Repository` interfaces
   - List key query methods

### Output Metadata
```yaml
source: AUTO
completeness: COMPLETE
needs-human: false
risk: LOW
```

---

## Section 5: Key Flows

**Template**: `5-flows-template.md`  
**Source**: SEMI  
**Priority**: ESSENTIAL

### Collection Steps

1. **Identify Critical Flows**
   - CRUD operations on main entities (Create, Read, Update, Delete)
   - Complex workflows (multi-step processes)
   - Cross-service interactions
   - Limit to 3-5 most important flows

2. **For Each Flow**
   - **Trigger**: Endpoint or event that starts the flow
   - **Actors**: User, services, external systems
   - **Steps**: Trace through controller → service → repository
   - **Decision Points**: If/else branches, state transitions
   - **Error Scenarios**: Exception handling, rollback logic
   - **External Calls**: HTTP clients, message publishing

3. **Generate Sequence**
   - Create step-by-step description
   - Include method calls and class names
   - Document error handling at each step

4. **Mark for Review**
   - Set `needs-human: true` - flows need business context validation
   - Flag if only partial flow detected

### Output Metadata
```yaml
source: SEMI
completeness: PARTIAL  # Technical steps complete, business context needed
needs-human: true      # Requires validation
risk: MEDIUM
```

---

## Section 6: Error Catalog

**Template**: `6-errors-template.md`  
**Source**: AUTO  
**Priority**: OPERATIONAL

### Collection Steps

1. **Custom Exceptions**
   - Find all classes extending `Exception` or `RuntimeException`
   - Build exception hierarchy tree
   - Group by category (Validation, NotFound, Business, Infrastructure)

2. **Error Codes**
   - Search for error code constants or enums
   - Map error codes to exception classes

3. **Exception Handlers**
   - Find `@ControllerAdvice` or `@ExceptionHandler` classes
   - Extract exception → HTTP status mappings
   - Document error response format

4. **Error Catalog Table**
   - For each exception:
     - Error code
     - Exception class
     - HTTP status
     - Trigger condition
     - Message format
     - Recovery action

### Output Metadata
```yaml
source: AUTO
completeness: COMPLETE
needs-human: false
risk: LOW
```

---

## Section 7: Configuration

**Template**: `7-config-template.md`  
**Source**: AUTO  
**Priority**: ESSENTIAL

### Collection Steps

1. **Configuration Files**
   - List all `application*.yaml` and `application*.properties` files
   - Check `ms-config/application.env`
   - Find `bootstrap.yml` if exists

2. **Configuration Keys**
   - Parse `application.yaml` and extract all keys
   - Categorize: Server, Database, Message Broker, Service-specific
   - Document default values, required status
   - Note profile-specific overrides

3. **Environment Variables**
   - Find references to `${VAR_NAME}` in config files
   - List required vs optional variables

4. **Profiles**
   - Document `dev`, `k8s`, `prod` profiles
   - Explain differences between profiles

5. **Local Development Setup**
   - Document prerequisites (Java version, databases)
   - Provide Docker commands for infrastructure
   - Show how to run the application locally
   - Include test execution commands

### Output Metadata
```yaml
source: AUTO
completeness: COMPLETE
needs-human: false
risk: LOW
```

---

## Section 8: Observability

**Template**: `8-observability-template.md`  
**Source**: SEMI  
**Priority**: OPERATIONAL

### Collection Steps

1. **Logging**
   - Find logging config: `log4j2.xml`, `logback.xml`
   - Extract log levels from `application.yaml`
   - Search for key log statements in code

2. **Metrics**
   - Check for `/actuator/prometheus` or `/actuator/metrics`
   - Find `@Timed`, `@Counted` annotations
   - Document custom metrics if found

3. **Health Checks**
   - Document `/actuator/health` endpoints
   - List health indicators (database, message broker, disk)
   - Extract Kubernetes probe configuration from `chart/`

4. **Tracing**
   - Check for Spring Cloud Sleuth or OpenTelemetry dependencies
   - Document if tracing is enabled

5. **Dashboards**
   - Search README for Grafana/Kibana links
   - Mark as `needs-human: true` if not found

6. **Alerting**
   - Document if alert configuration found
   - Mark as `needs-human: true` for verification

7. **Runbooks**
   - Provide common operations (restart, check logs, check health)
   - Document troubleshooting steps

### Output Metadata
```yaml
source: SEMI
completeness: PARTIAL  # Dashboard links need human input
needs-human: true
risk: MEDIUM
```

---

## Step 3: Auto-Detect Optional Sections

### Security Section (9-security.md)

**Auto-detect logic**:
```
IF (Spring Security dependency in build.gradle)
   OR (@PreAuthorize/@Secured annotations found)
   OR (OAuth2/JWT configuration in application.yaml)
THEN
   Include security section in _metadata.yaml
   Note: "Security features detected - consider full documentation"
ELSE
   Skip security section
   Note in _metadata.yaml: "Not applicable - backend service"
```

### ADRs Section (10-adrs.md)

**Auto-detect logic**:
```
Search for: docs/adr/, docs/decisions/, architecture/
IF found:
   Note location in _metadata.yaml
   List ADR files
ELSE:
   Note in _metadata.yaml: "MISSING - suggest creating docs/adr/"
   Provide template link
```

---

## Step 4: Generate Metadata Summary

**Template**: `_metadata-template.yaml`

### Aggregate Data

1. **Section Completeness**
   - For each section, copy metadata tags
   - Count: complete, partial, missing sections
   - Count: sections needing human review

2. **Security Assessment**
   - Document if security features detected
   - Note if section skipped

3. **ADR Status**
   - Document if ADRs found
   - Provide recommendation if missing

4. **Overall Statistics**
   - Total sections: 8
   - Complete: X
   - Partial: Y
   - Missing: Z
   - Needs human review: N

5. **Agent Consumption Notes**
   - Determine if intake is agent-ready
   - Provide guidance for agent usage

---

## Step 5: Generate Open Issues

**Template**: `_open-issues-template.md`

### Aggregate Issues

1. **Collect All `needs-human: true` Items**
   - Scan all section metadata
   - Extract items flagged for human review

2. **Categorize by Priority**
   - **HIGH**: Non-goals, OpenAPI spec, flow validation
   - **MEDIUM**: Dashboard links, alert verification, tracing config
   - **LOW**: ADRs, component diagrams, wiki link verification

3. **Create Action Items**
   - For each issue:
     - Section reference
     - Issue description
     - Action required
     - Impact
     - Suggested assignee

4. **Add Review Checklist**
   - List items to verify before marking intake complete

---

## Step 6: Write Output Files

For each section:
1. Read template from `templates/`
2. Replace `{{PLACEHOLDERS}}` with collected data
3. Write to `{OUTPUT_DIR}/[section-file].md`

Write metadata and open issues files to `{OUTPUT_DIR}/`.

---

## Step 7: Final Summary

Display to user:

```
✅ Architecture Intake Complete: {SERVICE_NAME}

📁 Output Location: {OUTPUT_DIR}

📄 Files Generated:
  ✓ 1-identity.md          [{SECTION_1_STATUS}]
  ✓ 2-architecture.md      [{SECTION_2_STATUS}]
  ✓ 3-contracts.md         [{SECTION_3_STATUS}]
  ✓ 4-data.md              [{SECTION_4_STATUS}]
  ✓ 5-flows.md             [{SECTION_5_STATUS}]
  ✓ 6-errors.md            [{SECTION_6_STATUS}]
  ✓ 7-config.md            [{SECTION_7_STATUS}]
  ✓ 8-observability.md     [{SECTION_8_STATUS}]
  ✓ _metadata.yaml         [Summary]
  ✓ _open-issues.md        [{OPEN_ISSUES_COUNT} items need attention]

📊 Completeness: {COMPLETE_COUNT}/8 sections complete, {PARTIAL_COUNT} partial

🤖 Agent Ready: {AGENT_READY_STATUS}
   Essential sections complete. Agents can use with caution.
   Review flagged items before full agent consumption.
```

Then, if `OPEN_ISSUES_COUNT > 0`, display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔧 {OPEN_ISSUES_COUNT} open issues need your input to complete this intake.

  High priority:    {HIGH_COUNT} items
  Medium priority:  {MEDIUM_COUNT} items
  Low priority:     {LOW_COUNT} items

Would you like to resolve them now?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Ask the user: **"Would you like to resolve the open issues now? (yes/no)"**

- If **yes**: Immediately continue with the `/architecture-intake-resolve` workflow steps below (do NOT ask for service name again — use `SERVICE_NAME` already set).
- If **no**: Display:
  ```
  ✓ Intake saved. Run /architecture-intake-resolve later to address open issues.
  📖 See: {OUTPUT_DIR}/_open-issues.md
  ```
  Then stop.

---

## Resolve Open Issues (inline continuation)

> This section runs automatically when the user confirms "yes" above, OR when the user runs `/architecture-intake-resolve` as a standalone workflow.
> See workflow: `.windsurf/workflows/architecture-intake-resolve.md`

If continuing inline, proceed directly to **Step 1** of the resolve workflow using the current `SERVICE_NAME`.

---

## Important Constraints

### NO FABRICATION
- Only document what exists in the codebase
- Mark uncertain items as `needs-human: true`
- Use "TBD" or "MISSING" for unavailable information
- Never invent API endpoints, error codes, or configurations

### Size Management
- Keep each output file focused and concise
- Use tables for structured data
- Avoid redundancy across sections
- Total output should be readable and navigable

### Metadata Discipline
- Every section MUST have metadata block
- Always set: source, completeness, needs-human, risk
- Aggregate metadata accurately in _metadata.yaml

### Template Adherence
- Always use templates from `templates/`
- Preserve template structure
- Fill placeholders with actual data or "TBD"
- Maintain consistent formatting

---

## Error Handling

### If Service Name Invalid
- Verify directory exists
- Ask user to confirm service name
- Suggest available services from workspace

### If Critical Files Missing
- Document in output: "File not found: {filename}"
- Mark section as PARTIAL or MISSING
- Add to open issues

### If Collection Fails
- Continue with other sections
- Document failure in metadata
- Add to open issues with HIGH priority

---

## Validation Checklist

Before completing workflow:
- [ ] All 8 section files created
- [ ] _metadata.yaml generated
- [ ] _open-issues.md generated
- [ ] All files have metadata blocks
- [ ] No fabricated information
- [ ] Placeholders filled or marked TBD
- [ ] Output directory structure correct

---

*Workflow Version: 2.0.0*
