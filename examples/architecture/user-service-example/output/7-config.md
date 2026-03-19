# Configuration

## Configuration Files

### Location
- **Main Config**: `src/main/resources/application.yaml`
- **Profile-Specific**: 
  - `application-dev.yaml` (development)
  - `application-k8s.yaml` (Kubernetes)
  - `application-prod.yaml` (production)

### Active Profile Selection
```bash
# Via environment variable
export SPRING_PROFILES_ACTIVE=k8s

# Via JVM argument
java -jar user-service.jar --spring.profiles.active=prod
```

## Key Configuration Parameters

### Server Configuration

```yaml
server:
  port: 8080
  servlet:
    context-path: /
  compression:
    enabled: true
  shutdown: graceful
  
spring:
  application:
    name: user-service
```

### Database Configuration

```yaml
spring:
  datasource:
    url: jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME:userdb}
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:changeme}
    driver-class-name: org.postgresql.Driver
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
  
  jpa:
    hibernate:
      ddl-auto: validate  # Never 'update' in production
    show-sql: false
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
        format_sql: true
        use_sql_comments: true
```

### Flyway Configuration

```yaml
spring:
  flyway:
    enabled: true
    baseline-on-migrate: true
    locations: classpath:db/migration
    schemas: public
```

### RabbitMQ Configuration

```yaml
spring:
  rabbitmq:
    host: ${RABBITMQ_HOST:localhost}
    port: ${RABBITMQ_PORT:5672}
    username: ${RABBITMQ_USERNAME:guest}
    password: ${RABBITMQ_PASSWORD:guest}
    virtual-host: /
    listener:
      simple:
        acknowledge-mode: auto
        prefetch: 10
        retry:
          enabled: true
          max-attempts: 3
          initial-interval: 1000
```

### Logging Configuration

```yaml
logging:
  level:
    root: INFO
    com.example.userservice: DEBUG
    org.springframework.web: INFO
    org.hibernate.SQL: DEBUG
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} - %msg%n"
  file:
    name: /var/log/user-service/application.log
    max-size: 10MB
    max-history: 30
```

### Actuator Configuration

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
      base-path: /actuator
  endpoint:
    health:
      show-details: when-authorized
  metrics:
    export:
      prometheus:
        enabled: true
```

## Environment Variables

### Required Variables

| Variable | Description | Example | Default |
|----------|-------------|---------|---------|
| DB_HOST | Database hostname | postgres.example.com | localhost |
| DB_PORT | Database port | 5432 | 5432 |
| DB_NAME | Database name | userdb | userdb |
| DB_USERNAME | Database username | app_user | postgres |
| DB_PASSWORD | Database password | <secret> | changeme |
| RABBITMQ_HOST | RabbitMQ hostname | rabbitmq.example.com | localhost |
| AUTH_SERVICE_URL | Auth service base URL | http://auth-service:8081 | http://localhost:8081 |
| NOTIFICATION_SERVICE_URL | Notification service URL | http://notification-service:8082 | http://localhost:8082 |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| SERVER_PORT | HTTP port | 8080 |
| LOG_LEVEL | Root log level | INFO |
| POOL_SIZE_MAX | Max DB connections | 20 |
| SPRING_PROFILES_ACTIVE | Active profile | dev |

## Profiles

### Development Profile (`dev`)

**Characteristics**:
- H2 in-memory database (optional)
- Debug logging enabled
- Actuator fully exposed
- CORS enabled for local development
- Auto-migration enabled

**Usage**:
```bash
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

### Kubernetes Profile (`k8s`)

**Characteristics**:
- Database via environment variables
- External configuration via ConfigMap/Secrets
- Health checks optimized for K8s
- Graceful shutdown enabled
- Production logging format

**ConfigMap Example**:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: user-service-config
data:
  application-k8s.yaml: |
    server:
      port: 8080
    spring:
      datasource:
        url: jdbc:postgresql://postgres:5432/userdb
```

**Secret Example**:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: user-service-secrets
type: Opaque
stringData:
  DB_PASSWORD: <base64-encoded>
  RABBITMQ_PASSWORD: <base64-encoded>
```

### Production Profile (`prod`)

**Characteristics**:
- Strict validation
- Minimal logging
- Security headers enabled
- Read-only actuator endpoints
- Connection pooling optimized

## Local Development Setup

### Prerequisites
- Java 17
- Maven 3.9+
- Docker & Docker Compose
- PostgreSQL client (optional)

### Quick Start

1. **Start dependencies**:
```bash
docker-compose up -d postgres rabbitmq
```

2. **Configure environment**:
```bash
export SPRING_PROFILES_ACTIVE=dev
export DB_HOST=localhost
export DB_PASSWORD=localdev
```

3. **Run migrations**:
```bash
./mvnw flyway:migrate
```

4. **Start application**:
```bash
./mvnw spring-boot:run
```

5. **Verify**:
```bash
curl http://localhost:8080/actuator/health
```

### Docker Compose for Local Dev

**File**: `docker-compose.yml`

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15.4
    environment:
      POSTGRES_DB: userdb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: localdev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
  
  rabbitmq:
    image: rabbitmq:3.12-management
    ports:
      - "5672:5672"
      - "15672:15672"
    environment:
      RABBITMQ_DEFAULT_USER: guest
      RABBITMQ_DEFAULT_PASS: guest

volumes:
  postgres_data:
```

### IDE Configuration (IntelliJ IDEA)

**Run Configuration**:
- Main class: `com.example.userservice.UserServiceApplication`
- VM options: `-Dspring.profiles.active=dev`
- Environment variables: `DB_PASSWORD=localdev`
- Working directory: `$MODULE_WORKING_DIR$`

## Configuration Validation

### Startup Validation

Application validates configuration on startup:
- Database connectivity
- Required environment variables
- RabbitMQ connectivity
- External service availability

**Fail-fast behavior**: Application exits if critical config missing

### Health Checks

**Liveness**: `/actuator/health/liveness`
**Readiness**: `/actuator/health/readiness`

Kubernetes uses these for pod lifecycle management.

---

## Metadata

```yaml
source: AUTO
completeness: COMPLETE
needs-human: false
risk: LOW
last-updated: 2026-03-19
notes: "Extracted from application.yaml and Spring Boot configuration"
```
