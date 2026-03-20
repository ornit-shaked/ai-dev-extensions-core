# Configuration: {{SERVICE_NAME}}

## Metadata
```yaml
source: AUTO
completeness: {{COMPLETE|PARTIAL|MISSING}}
needs-human: {{false}}
risk: {{LOW|MEDIUM|HIGH}}
last-updated: {{TIMESTAMP}}
```

## Configuration Files

### Main Configuration
{{LIST_APPLICATION_CONFIG_FILES}}

- **application.yaml** / **application.properties**: Base configuration
- **application-dev.yaml**: Development profile
- **application-k8s.properties**: Kubernetes profile
- **application-secured.properties**: Security configuration
- **bootstrap.yml**: Bootstrap configuration (if using Spring Cloud Config)

### External Configuration
- **ms-config/application.env**: Environment-specific variables
- **ms-config/secrets/passwords.txt**: Encrypted secrets
- **ms-config/ServiceDescriptor/*.yaml**: Service metadata

---

## Configuration Keys

### Server Configuration

| Key | Default | Required | Description | Profiles |
|-----|---------|----------|-------------|----------|
| `server.port` | {{8080}} | Yes | HTTP port | all |
| `server.servlet.context-path` | {{/}} | No | Base path | all |
| `spring.application.name` | {{tosca-engine-ms}} | Yes | Service name | all |

### Database Configuration

#### MongoDB
{{IF_MONGODB_IS_USED}}

| Key | Default | Required | Description | Profiles |
|-----|---------|----------|-------------|----------|
| `mongodb.host` | {{localhost}} | Yes | MongoDB host | all |
| `mongodb.port` | {{27017}} | Yes | MongoDB port | all |
| `mongodb.database` | {{toscaenginedb}} | Yes | Database name | all |
| `mongodb.user` | {{toscascore}} | Yes | Username | all |
| `mongodb.password` | {{***}} | Yes | Password (from secrets) | all |
| `mongodb.credentials.enable` | {{true}} | Yes | Enable auth | prod, k8s |

**Example Configuration**:
```yaml
mongodb:
  credentials:
    enable: true
  user: "toscascore"
  password: "${MONGODB_PASSWORD}"
  database: toscaenginedb
  host: ${dev.host}
  port: 27017
```

### Message Broker Configuration

#### RabbitMQ
{{IF_RABBITMQ_IS_USED}}

| Key | Default | Required | Description | Profiles |
|-----|---------|----------|-------------|----------|
| `rabbitmq.host` | {{localhost}} | Yes | RabbitMQ host | all |
| `rabbitmq.port` | {{5672}} | Yes | RabbitMQ port | all |
| `rabbitmq.user` | {{admin}} | Yes | Username | all |
| `rabbitmq.password` | {{***}} | Yes | Password | all |
| `rabbitmq.vhost` | {{/}} | No | Virtual host | all |

**Example Configuration**:
```yaml
rabbitmq:
  credentials:
    enable: true
  user: admin
  password: "${RABBITMQ_PASSWORD}"
  host: ${dev.host}
  port: 5672
```

### Service-Specific Configuration

#### TOSCA Engine
{{SERVICE_SPECIFIC_CONFIG}}

| Key | Default | Required | Description |
|-----|---------|----------|-------------|
| `tosca-engine.pluginsDirectory` | {{config/tosca-plugins}} | Yes | Plugin location |
| `tosca-engine.bootstrap.skipProject` | {{[]}} | No | Projects to skip on startup |

**Example Configuration**:
```yaml
tosca-engine:
  pluginsDirectory: config/tosca-plugins
  bootstrap:
    skipProject:
      - muse_sdn_node_designer_capability_util
      - muse_sdn_card_designer
```

### External Service URLs

| Key | Default | Required | Description |
|-----|---------|----------|-------------|
| `instance-manager.url` | {{http://localhost:8081}} | Yes | Instance manager service |
| `ui-muse.url` | {{http://localhost:8082}} | No | UI service |

### Feature Flags

{{IF_FEATURE_FLAGS_EXIST}}

| Key | Default | Description |
|-----|---------|-------------|
| `features.template-validation.enabled` | {{true}} | Enable TOSCA validation |
| `features.async-processing.enabled` | {{false}} | Enable async template processing |

---

## Environment Variables

### Required Environment Variables
{{VARS_THAT_MUST_BE_SET}}

| Variable | Purpose | Example |
|----------|---------|---------|
| `MONGODB_PASSWORD` | MongoDB password | `secretpass123` |
| `RABBITMQ_PASSWORD` | RabbitMQ password | `adminpass456` |
| `SPRING_PROFILES_ACTIVE` | Active profile | `dev` or `k8s` |

### Optional Environment Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `LOG_LEVEL` | Logging level | `INFO` |
| `JVM_OPTS` | JVM options | `-Xmx512m` |

---

## Configuration Profiles

### Development Profile (`dev`)
{{CONFIGURATION_FOR_LOCAL_DEVELOPMENT}}

**Activation**: `--spring.profiles.active=dev`

**Characteristics**:
- Local infrastructure (MongoDB, RabbitMQ on localhost)
- Debug logging enabled
- Hot reload enabled
- No authentication (optional)

**Configuration**:
```yaml
mongodb:
  credentials:
    enable: false
  host: localhost
  port: 27017

rabbitmq:
  credentials:
    enable: false
  host: localhost
  port: 5672

logging:
  level:
    com.sdn.tosca: DEBUG
```

### Kubernetes Profile (`k8s`)
{{CONFIGURATION_FOR_KUBERNETES_DEPLOYMENT}}

**Activation**: Automatically activated in K8s

**Characteristics**:
- Service discovery via K8s DNS
- Secrets from K8s secrets
- Production logging
- Health checks enabled

**Configuration**:
```yaml
mongodb:
  credentials:
    enable: true
  host: mongodb-service
  port: 27017

rabbitmq:
  credentials:
    enable: true
  host: rabbitmq-service
  port: 5672

management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus
```

---

## Local Development Setup

### Prerequisites
{{WHAT_IS_NEEDED_TO_RUN_LOCALLY}}

1. **Java**: Version 17 or higher
2. **Gradle**: 7.x or use wrapper (`./gradlew`)
3. **MongoDB**: Running on localhost:27017
4. **RabbitMQ**: Running on localhost:5672 (optional for basic testing)

### Setup Steps

#### 1. Start Infrastructure Services

**MongoDB**:
```bash
docker run -d -p 27017:27017 --name mongodb \
  -e MONGO_INITDB_ROOT_USERNAME=toscascore \
  -e MONGO_INITDB_ROOT_PASSWORD=toscascore \
  mongo:latest
```

**RabbitMQ** (optional):
```bash
docker run -d -p 5672:5672 -p 15672:15672 --name rabbitmq \
  -e RABBITMQ_DEFAULT_USER=admin \
  -e RABBITMQ_DEFAULT_PASS=admin \
  rabbitmq:3-management
```

#### 2. Configure Application

Edit `src/main/resources/application-dev.yaml`:
```yaml
mongodb:
  credentials:
    enable: false
  user: "toscascore"
  password: "toscascore"
  database: toscaenginedb
  host: localhost
  port: 27017

rabbitmq:
  credentials:
    enable: false
  user: admin
  password: admin
  host: localhost
  port: 5672
```

#### 3. Run Application

**Using Gradle**:
```bash
./gradlew bootRun --args='--spring.profiles.active=dev'
```

**Using IDE**:
- Main class: `com.sdn.tosca.engine.ToscaEngineApplication`
- VM options: `-Dspring.profiles.active=dev`
- Program arguments: None

#### 4. Verify Running

```bash
# Check health
curl http://localhost:8080/actuator/health

# Check application
curl http://localhost:8080/api/templates
```

### Troubleshooting Local Setup

**Issue**: MongoDB connection refused
- **Solution**: Ensure MongoDB is running: `docker ps | grep mongodb`

**Issue**: Port 8080 already in use
- **Solution**: Change port in application.yaml: `server.port=8081`

**Issue**: Template loading fails
- **Solution**: Check `tosca-engine.pluginsDirectory` path is correct

---

## Testing Configuration

### Unit Tests
{{CONFIGURATION_FOR_UNIT_TESTS}}

- **Profile**: `test` (auto-activated)
- **Database**: Embedded MongoDB (Flapdoodle)
- **Message Broker**: Mock/embedded

### Integration Tests
{{CONFIGURATION_FOR_INTEGRATION_TESTS}}

- **Profile**: `integration-test`
- **Database**: Testcontainers MongoDB
- **Message Broker**: Testcontainers RabbitMQ

**Run Tests**:
```bash
# Unit tests
./gradlew test

# Integration tests
./gradlew integrationTest
```

---

## Configuration Management Best Practices

### Secrets Management
{{HOW_SECRETS_ARE_HANDLED}}

- **Development**: Plain text in application-dev.yaml (not committed)
- **Production**: Kubernetes secrets, injected as environment variables
- **Never**: Commit passwords to Git

### Configuration Validation
{{IF_VALIDATION_EXISTS}}

```java
@ConfigurationProperties(prefix = "mongodb")
@Validated
public class MongoConfig {
    @NotNull
    private String host;
    
    @Min(1)
    @Max(65535)
    private int port;
}
```

### Configuration Documentation
- Keep this file updated when adding new config keys
- Document required vs optional
- Provide examples for complex configurations

---
*Auto-generated by /architecture-intake workflow*
