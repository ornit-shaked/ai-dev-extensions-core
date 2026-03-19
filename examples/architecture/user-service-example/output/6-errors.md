# Error Handling

## Exception Hierarchy

### Custom Exceptions

```
RuntimeException
└── UserServiceException (base)
    ├── UserNotFoundException
    ├── EmailAlreadyExistsException
    ├── InvalidVerificationTokenException
    ├── TokenExpiredException
    └── UnauthorizedOperationException
```

**Base Exception**: `UserServiceException`
- All custom exceptions extend this base
- Provides common fields: message, errorCode, timestamp

## Error Codes

| Code | Exception | HTTP Status | Description |
|------|-----------|-------------|-------------|
| USER_001 | UserNotFoundException | 404 | User not found by ID or email |
| USER_002 | EmailAlreadyExistsException | 409 | Email already registered |
| USER_003 | InvalidVerificationTokenException | 400 | Token not found or invalid |
| USER_004 | TokenExpiredException | 400 | Verification token expired |
| USER_005 | UnauthorizedOperationException | 403 | User not authorized for operation |
| USER_006 | InvalidStatusTransitionException | 400 | Invalid user status change |
| USER_007 | ValidationException | 400 | Input validation failed |
| USER_008 | DatabaseException | 500 | Database operation failed |
| USER_009 | ExternalServiceException | 503 | External service unavailable |

## HTTP Status Mappings

### Success Responses
- **200 OK**: Successful GET, PUT
- **201 Created**: Successful POST (user created)
- **204 No Content**: Successful DELETE
- **202 Accepted**: Async operation accepted

### Client Error Responses (4xx)
- **400 Bad Request**: Validation errors, business rule violations
- **401 Unauthorized**: Missing or invalid authentication
- **403 Forbidden**: Insufficient permissions
- **404 Not Found**: Resource not found
- **409 Conflict**: Resource conflict (email exists, status conflict)
- **422 Unprocessable Entity**: Semantic errors

### Server Error Responses (5xx)
- **500 Internal Server Error**: Unhandled exceptions
- **503 Service Unavailable**: Dependent service unavailable
- **504 Gateway Timeout**: Dependent service timeout

## Global Exception Handler

**Class**: `GlobalExceptionHandler`
**Annotation**: `@RestControllerAdvice`

### Handled Exceptions

```java
@ExceptionHandler(UserNotFoundException.class)
ResponseEntity<ErrorResponse> handleUserNotFound(UserNotFoundException ex) {
    return ResponseEntity
        .status(HttpStatus.NOT_FOUND)
        .body(new ErrorResponse("USER_001", ex.getMessage()));
}

@ExceptionHandler(EmailAlreadyExistsException.class)
ResponseEntity<ErrorResponse> handleEmailExists(EmailAlreadyExistsException ex) {
    return ResponseEntity
        .status(HttpStatus.CONFLICT)
        .body(new ErrorResponse("USER_002", ex.getMessage()));
}

@ExceptionHandler(MethodArgumentNotValidException.class)
ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
    List<FieldError> errors = ex.getBindingResult().getFieldErrors();
    return ResponseEntity
        .status(HttpStatus.BAD_REQUEST)
        .body(new ValidationErrorResponse("USER_007", "Validation failed", errors));
}
```

## Error Response Format

### Standard Error Response

```json
{
  "timestamp": "2026-03-19T14:30:00Z",
  "status": 404,
  "error": "Not Found",
  "code": "USER_001",
  "message": "User not found with id: 12345",
  "path": "/api/v1/users/12345",
  "traceId": "abc-123-def-456"
}
```

### Validation Error Response

```json
{
  "timestamp": "2026-03-19T14:30:00Z",
  "status": 400,
  "error": "Bad Request",
  "code": "USER_007",
  "message": "Validation failed",
  "path": "/api/v1/users",
  "traceId": "abc-123-def-456",
  "errors": [
    {
      "field": "email",
      "rejectedValue": "invalid-email",
      "message": "must be a valid email address"
    },
    {
      "field": "firstName",
      "rejectedValue": "",
      "message": "must not be blank"
    }
  ]
}
```

## Recovery Strategies

### Retry Logic

**Transient Failures** (network issues, timeouts):
- External service calls: 3 retries with exponential backoff
- Database deadlocks: Automatic retry via Spring transaction management

**Implementation**:
```java
@Retryable(
    value = {ExternalServiceException.class},
    maxAttempts = 3,
    backoff = @Backoff(delay = 1000, multiplier = 2)
)
public void callExternalService() { ... }
```

### Circuit Breaker

**External Dependencies**:
- Auth Service: Circuit opens after 5 consecutive failures
- Notification Service: Circuit opens after 5 consecutive failures
- Reset timeout: 30 seconds

### Fallback Behavior

**Email Verification**: 
- If notification service fails → Store in retry queue
- Background job retries every 5 minutes

**User Search**:
- If database slow → Return cached results (if available)
- Timeout after 5 seconds

### Compensation

**User Creation Failure**:
- Rollback database transaction automatically
- No event published if save fails
- Clean up any created verification tokens

## Logging Patterns

### Error Logging Levels

**ERROR**: 
- Unhandled exceptions
- Database failures
- External service failures (after retries exhausted)

**WARN**:
- Business rule violations
- Validation failures
- Retry attempts

**INFO**:
- Successful operations
- Status changes
- External API calls

### Log Format

```json
{
  "timestamp": "2026-03-19T14:30:00Z",
  "level": "ERROR",
  "logger": "com.example.userservice.service.UserService",
  "thread": "http-nio-8080-exec-1",
  "message": "Failed to create user",
  "exception": "EmailAlreadyExistsException",
  "errorCode": "USER_002",
  "userId": "12345",
  "email": "user@example.com",
  "traceId": "abc-123-def-456",
  "stackTrace": "..."
}
```

### Correlation IDs

- Generated for each request
- Propagated to all log statements
- Included in error responses
- Sent to downstream services

## Monitoring & Alerts

### Error Metrics

**Prometheus Metrics**:
- `user_service_errors_total{code, status}`: Total errors by code and HTTP status
- `user_service_request_duration_seconds{endpoint, status}`: Request duration

**Alert Rules**:
- Error rate > 5% → Page on-call
- Database errors > 10/min → Page on-call
- External service errors > 50% → Notify team

### Health Checks

**Endpoint**: `/actuator/health`

**Checks**:
- Database connectivity
- External service availability (Auth, Notification)
- Disk space
- Memory usage

**Response**:
```json
{
  "status": "UP",
  "components": {
    "db": {"status": "UP"},
    "authService": {"status": "UP"},
    "diskSpace": {"status": "UP"}
  }
}
```

---

## Metadata

```yaml
source: AUTO
completeness: COMPLETE
needs-human: false
risk: LOW
last-updated: 2026-03-19
notes: "Extracted from exception classes and GlobalExceptionHandler"
```
