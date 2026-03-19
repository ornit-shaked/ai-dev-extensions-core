# Architecture

## Technology Stack

### Language & Framework
- **Language**: Java 17
- **Framework**: Spring Boot 3.1.5
- **Build Tool**: Maven 3.9.4

### Key Dependencies
- **Spring Boot Starter Web** (3.1.5): REST API endpoints
- **Spring Boot Starter Data JPA** (3.1.5): Database access
- **Spring Boot Starter Validation** (3.1.5): Input validation
- **PostgreSQL Driver** (42.6.0): Database connectivity
- **Flyway** (9.22.0): Database migrations
- **Lombok** (1.18.30): Code generation
- **MapStruct** (1.5.5): DTO mapping
- **SpringDoc OpenAPI** (2.2.0): API documentation

### Testing
- JUnit 5 (5.10.0)
- Mockito (5.5.0)
- Testcontainers (1.19.1)

## Component Architecture

### Layered Architecture

```
┌─────────────────────────────────────┐
│         REST Controllers            │  → API Layer
├─────────────────────────────────────┤
│         Service Layer               │  → Business Logic
├─────────────────────────────────────┤
│       Repository Layer              │  → Data Access
├─────────────────────────────────────┤
│         PostgreSQL DB               │  → Persistence
└─────────────────────────────────────┘
```

### Key Components

**Controllers**:
- `UserController`: User CRUD operations
- `UserSearchController`: Search and filtering
- `UserVerificationController`: Email verification

**Services**:
- `UserService`: Core user management logic
- `UserVerificationService`: Email verification workflows
- `UserSearchService`: Search and filtering logic

**Repositories**:
- `UserRepository`: JPA repository for User entity
- `VerificationTokenRepository`: Email verification tokens

**Entities**:
- `User`: Main user entity
- `VerificationToken`: Email verification tokens
- `UserPreferences`: User settings and preferences

## C4 Model Views

### Context Diagram (Level 1)

```
┌──────────────┐
│  Mobile App  │─────┐
└──────────────┘     │
                     ↓
┌──────────────┐   ┌────────────────┐   ┌─────────────────┐
│  Admin Portal│──→│  User Service  │──→│  Auth Service   │
└──────────────┘   └────────────────┘   └─────────────────┘
                          │
                          ↓
                   ┌──────────────┐
                   │ Notification │
                   │   Service    │
                   └──────────────┘
```

### Container Diagram (Level 2)

```
User Service Container:
┌────────────────────────────────────────┐
│  Spring Boot Application               │
│  ┌──────────────────────────────────┐  │
│  │  REST API (Port 8080)            │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │  Business Logic Layer            │  │
│  └──────────────────────────────────┘  │
│  ┌──────────────────────────────────┐  │
│  │  PostgreSQL Database             │  │
│  │  (Port 5432)                     │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
```

## Design Patterns

- **Repository Pattern**: Data access abstraction
- **DTO Pattern**: Request/Response object mapping
- **Service Layer Pattern**: Business logic encapsulation
- **Builder Pattern**: Complex object construction (User, DTOs)
- **Strategy Pattern**: Different user search strategies

## Cross-Cutting Concerns

### Logging
- SLF4J with Logback
- Structured JSON logging
- Correlation IDs for request tracing

### Monitoring
- Spring Boot Actuator endpoints
- Prometheus metrics exposure
- Custom metrics for business events

### Security
- Input validation on all endpoints
- SQL injection prevention (JPA/Hibernate)
- XSS protection (Content-Type headers)

## Deployment

- **Platform**: Kubernetes
- **Container**: Docker image
- **Registry**: Harbor
- **Base Image**: eclipse-temurin:17-jre-alpine
- **Replicas**: 3 (production), 2 (staging)
- **Resources**: 
  - CPU: 500m request, 1000m limit
  - Memory: 512Mi request, 1Gi limit

---

## Metadata

```yaml
source: AUTO
completeness: COMPLETE
needs-human: false
risk: LOW
last-updated: 2026-03-19
notes: "Extracted from pom.xml and source code"
```
