# Error Catalog: {{SERVICE_NAME}}

## Metadata
```yaml
source: AUTO
completeness: {{COMPLETE|PARTIAL|MISSING}}
needs-human: {{false}}
risk: {{LOW|MEDIUM|HIGH}}
last-updated: {{TIMESTAMP}}
```

## Error Handling Strategy

### Approach
{{DESCRIBE_OVERALL_ERROR_HANDLING_APPROACH}}
- **Framework**: {{Spring @ExceptionHandler|Custom error handling}}
- **Global Handler**: {{@ControllerAdvice class}}
- **Error Response Format**: {{Standardized JSON|Custom}}

### Error Response Structure
```json
{
  "timestamp": "2024-02-10T12:30:00Z",
  "status": 400,
  "error": "Bad Request",
  "message": "Detailed error message",
  "path": "/api/endpoint",
  "errorCode": "ERR_001",
  "details": []
}
```

---

## Exception Hierarchy

### Custom Exceptions
{{AUTO_DETECT_FROM_CUSTOM_EXCEPTION_CLASSES}}

```
BaseException (extends RuntimeException)
├── ValidationException
│   ├── InvalidToscaSyntaxException
│   ├── InvalidVersionFormatException
│   └── DuplicateTemplateException
├── NotFoundException
│   ├── TemplateNotFoundException
│   └── PluginNotFoundException
├── BusinessException
│   ├── InvalidStateTransitionException
│   └── TemplateInUseException
└── InfrastructureException
    ├── DatabaseException
    └── MessageBrokerException
```

---

## Error Catalog

### Validation Errors (4xx)

#### ERR_001: Invalid TOSCA Syntax
- **Exception**: `InvalidToscaSyntaxException`
- **HTTP Status**: `400 Bad Request`
- **Trigger**: TOSCA parser validation fails
- **Message Format**: `"Invalid TOSCA syntax: {details}"`
- **Source Layer**: Service
- **Recovery**: User must fix YAML syntax
- **Example**:
  ```json
  {
    "errorCode": "ERR_001",
    "message": "Invalid TOSCA syntax: unknown node type 'Custom.Node'",
    "details": ["Line 15: node type not found in imports"]
  }
  ```

#### ERR_002: Duplicate Template
- **Exception**: `DuplicateTemplateException`
- **HTTP Status**: `409 Conflict`
- **Trigger**: Template with same name+version exists
- **Message Format**: `"Template {name} version {version} already exists"`
- **Source Layer**: Service
- **Recovery**: Use different name or version
- **Example**:
  ```json
  {
    "errorCode": "ERR_002",
    "message": "Template 'my-template' version '1.0.0' already exists"
  }
  ```

#### ERR_003: Template Not Found
- **Exception**: `TemplateNotFoundException`
- **HTTP Status**: `404 Not Found`
- **Trigger**: Requested template ID doesn't exist
- **Message Format**: `"Template with ID {id} not found"`
- **Source Layer**: Service
- **Recovery**: Verify template ID
- **Example**:
  ```json
  {
    "errorCode": "ERR_003",
    "message": "Template with ID '123e4567-e89b-12d3-a456-426614174000' not found"
  }
  ```

#### ERR_004: Invalid State Transition
- **Exception**: `InvalidStateTransitionException`
- **HTTP Status**: `400 Bad Request`
- **Trigger**: Attempt invalid state change (e.g., ARCHIVED → DRAFT)
- **Message Format**: `"Cannot transition from {current} to {target}"`
- **Source Layer**: Service
- **Recovery**: Follow valid state transitions
- **Example**:
  ```json
  {
    "errorCode": "ERR_004",
    "message": "Cannot transition from ARCHIVED to DRAFT",
    "details": ["Valid transitions from ARCHIVED: none"]
  }
  ```

#### ERR_005: Template In Use
- **Exception**: `TemplateInUseException`
- **HTTP Status**: `409 Conflict`
- **Trigger**: Attempt to delete template that has active instances
- **Message Format**: `"Template is in use by {count} instances"`
- **Source Layer**: Service
- **Recovery**: Delete instances first or archive template
- **Example**:
  ```json
  {
    "errorCode": "ERR_005",
    "message": "Template is in use by 5 instances",
    "details": ["Instance IDs: inst-001, inst-002, ..."]
  }
  ```

### Server Errors (5xx)

#### ERR_500: Database Connection Failed
- **Exception**: `DatabaseException`
- **HTTP Status**: `500 Internal Server Error`
- **Trigger**: MongoDB connection lost
- **Message Format**: `"Database operation failed"`
- **Source Layer**: Infrastructure
- **Recovery**: Retry, check database health
- **Diagnostics**: Check MongoDB logs, network connectivity
- **Remediation**: Restart service, verify DB credentials

#### ERR_501: Message Broker Error
- **Exception**: `MessageBrokerException`
- **HTTP Status**: `500 Internal Server Error`
- **Trigger**: RabbitMQ publish fails
- **Message Format**: `"Failed to publish event"`
- **Source Layer**: Infrastructure
- **Recovery**: Event will be retried
- **Diagnostics**: Check RabbitMQ health, queue status
- **Remediation**: Verify RabbitMQ connection, check credentials

#### ERR_502: External Service Unavailable
- **Exception**: `ExternalServiceException`
- **HTTP Status**: `503 Service Unavailable`
- **Trigger**: Downstream service (e.g., instance-manager) is down
- **Message Format**: `"External service {service} is unavailable"`
- **Source Layer**: Integration
- **Recovery**: Retry with backoff
- **Diagnostics**: Check downstream service health
- **Remediation**: Wait for service recovery, check network

---

## Error Handling by Layer

### Controller Layer
{{@ExceptionHandler_METHODS}}

```java
@ExceptionHandler(TemplateNotFoundException.class)
public ResponseEntity<ErrorResponse> handleNotFound(TemplateNotFoundException ex) {
    return ResponseEntity.status(404).body(
        new ErrorResponse("ERR_003", ex.getMessage())
    );
}
```

### Service Layer
{{BUSINESS_LOGIC_ERROR_HANDLING}}

```java
public Template createTemplate(TemplateDTO dto) {
    if (repository.existsByNameAndVersion(dto.getName(), dto.getVersion())) {
        throw new DuplicateTemplateException(dto.getName(), dto.getVersion());
    }
    // ... rest of logic
}
```

### Repository Layer
{{DATA_ACCESS_ERROR_HANDLING}}

```java
try {
    return mongoTemplate.save(template);
} catch (MongoException ex) {
    throw new DatabaseException("Failed to save template", ex);
}
```

---

## Logging & Monitoring

### Error Logging
{{HOW_ERRORS_ARE_LOGGED}}

```java
log.error("Failed to create template: name={}, version={}, error={}", 
    dto.getName(), dto.getVersion(), ex.getMessage(), ex);
```

### Error Metrics
{{IF_METRICS_ARE_COLLECTED}}

- **Counter**: `errors.total` (tagged by error code)
- **Counter**: `errors.by.type` (tagged by exception class)
- **Gauge**: `errors.rate` (errors per minute)

### Alerting
{{IF_ALERTS_ARE_CONFIGURED}}

- **Critical**: Database connection failures (ERR_500)
- **Warning**: High rate of validation errors (ERR_001)
- **Info**: Template not found errors (ERR_003)

---

## Error Recovery Patterns

### Retry Logic
{{OPERATIONS_THAT_ARE_RETRIED}}

- **External API calls**: 3 retries with exponential backoff
- **Message publishing**: 5 retries with 1s delay
- **Database operations**: No automatic retry (fail fast)

### Circuit Breaker
{{IF_CIRCUIT_BREAKER_IS_USED}}

- **Protected Operations**: {{EXTERNAL_SERVICE_CALLS}}
- **Failure Threshold**: {{5_FAILURES_IN_10_SECONDS}}
- **Open Duration**: {{30_SECONDS}}

### Fallback Strategies
{{GRACEFUL_DEGRADATION}}

- **Cache**: Return cached data if database unavailable
- **Default Values**: Use defaults if config service down
- **Async Processing**: Queue for later if sync fails

---

## Troubleshooting Guide

### Common Issues

#### Issue: High rate of ERR_001 (Invalid TOSCA)
**Symptoms**: Many 400 errors from validation
**Diagnosis**: Check client TOSCA templates
**Resolution**: Improve client-side validation, update documentation

#### Issue: ERR_500 (Database errors)
**Symptoms**: 500 errors, slow response times
**Diagnosis**: Check MongoDB health, connection pool
**Resolution**: Restart MongoDB, increase connection pool size

#### Issue: ERR_005 (Template in use)
**Symptoms**: Cannot delete templates
**Diagnosis**: Check instance-manager for active instances
**Resolution**: Archive instead of delete, or clean up instances

---
*Auto-generated by /architecture-intake workflow*
