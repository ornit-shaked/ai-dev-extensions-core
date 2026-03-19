# Observability

## Logging

### Framework
- **Library**: SLF4J with Logback
- **Format**: JSON (production), Console (development)
- **Output**: STDOUT (captured by K8s)

### Log Levels by Environment

**Development**:
- Application: DEBUG
- Spring: INFO
- Hibernate: DEBUG

**Production**:
- Application: INFO
- Spring: WARN
- Hibernate: WARN

### Structured Logging

**JSON Format**:
```json
{
  "timestamp": "2026-03-19T14:30:00.123Z",
  "level": "INFO",
  "logger": "com.example.userservice.controller.UserController",
  "thread": "http-nio-8080-exec-1",
  "traceId": "abc-123-def-456",
  "spanId": "xyz-789",
  "message": "User created successfully",
  "userId": "550e8400-e29b-41d4-a716-446655440000",
  "email": "user@example.com",
  "duration": 45,
  "method": "POST",
  "path": "/api/v1/users"
}
```

### Log Correlation

**Trace IDs**:
- Generated for each request
- Propagated to all services
- Included in responses (X-Trace-ID header)
- Used for distributed tracing

**MDC (Mapped Diagnostic Context)**:
- userId
- traceId
- requestId
- sessionId

### Log Retention

- **Development**: 7 days
- **Staging**: 30 days
- **Production**: 90 days
- **Archive**: 1 year (compliance)

## Metrics

### Metrics Framework
- **Spring Boot Actuator** + **Micrometer**
- **Export**: Prometheus format
- **Endpoint**: `/actuator/prometheus`

### Application Metrics

**Business Metrics**:
```
user_service_users_created_total{status}
user_service_users_deleted_total
user_service_email_verifications_sent_total
user_service_email_verifications_completed_total
user_service_login_attempts_total{result}
```

**Technical Metrics**:
```
http_server_requests_seconds{method, uri, status}
jvm_memory_used_bytes{area, id}
jvm_gc_pause_seconds{action, cause}
hikaricp_connections_active
hikaricp_connections_pending
```

**Custom Metrics**:
```java
@Timed(value = "user_service_create_user", 
       description = "Time taken to create user")
public UserDTO createUser(CreateUserRequest request) {
    meterRegistry.counter("user_service_users_created_total",
        "status", user.getStatus()).increment();
    // ... business logic
}
```

### Metric Collection

**Scrape Interval**: 15 seconds (Prometheus)
**Retention**: 15 days (Prometheus), 1 year (long-term storage)

## Health Checks

### Endpoints

**Overall Health**: `/actuator/health`
```json
{
  "status": "UP",
  "components": {
    "db": {"status": "UP"},
    "diskSpace": {"status": "UP"},
    "ping": {"status": "UP"},
    "rabbit": {"status": "UP"}
  }
}
```

**Liveness**: `/actuator/health/liveness`
- Indicates if application is running
- K8s restarts pod if DOWN

**Readiness**: `/actuator/health/readiness`
- Indicates if application can serve traffic
- K8s removes from load balancer if DOWN

### Health Indicators

**Database**:
```java
@Component
public class DatabaseHealthIndicator implements HealthIndicator {
    public Health health() {
        try {
            userRepository.count(); // Simple query
            return Health.up().build();
        } catch (Exception e) {
            return Health.down(e).build();
        }
    }
}
```

**RabbitMQ**:
- Connection status
- Channel availability

**Disk Space**:
- Threshold: 10% free space
- Status DOWN if below threshold

## Dashboards

⚠️ **Dashboard links require manual setup**

### Grafana Dashboards

**User Service Overview**:
- **URL**: https://grafana.example.com/d/user-service-overview
- **Panels**:
  - Request rate (req/s)
  - Error rate (%)
  - P50, P95, P99 latencies
  - Active users
  - Database connection pool

**JVM Metrics**:
- **URL**: https://grafana.example.com/d/jvm-metrics
- **Panels**:
  - Heap memory usage
  - GC pause times
  - Thread count
  - CPU usage

**Business Metrics**:
- **URL**: https://grafana.example.com/d/user-service-business
- **Panels**:
  - User registrations (daily)
  - Email verification rate
  - Active users count
  - User status distribution

### Kibana Logs

**Log Search**:
- **URL**: https://kibana.example.com/app/discover
- **Index**: `user-service-*`
- **Filters**: Pre-configured for error tracking

## Alerting

### Prometheus Alerts

**High Error Rate**:
```yaml
alert: UserServiceHighErrorRate
expr: rate(http_server_requests_seconds_count{status=~"5..", job="user-service"}[5m]) > 0.05
for: 5m
labels:
  severity: critical
annotations:
  summary: "User Service error rate above 5%"
```

**Database Connection Pool Exhausted**:
```yaml
alert: DatabasePoolExhausted
expr: hikaricp_connections_pending{job="user-service"} > 5
for: 2m
labels:
  severity: warning
```

**High Response Time**:
```yaml
alert: UserServiceSlowResponses
expr: histogram_quantile(0.95, http_server_requests_seconds_bucket{job="user-service"}) > 1
for: 10m
labels:
  severity: warning
```

### Alert Channels

- **Critical**: PagerDuty → On-call engineer
- **Warning**: Slack #user-service-alerts
- **Info**: Email to team

## Distributed Tracing

### Framework
- **Spring Cloud Sleuth** (trace propagation)
- **Zipkin** (trace collection)

### Trace Endpoints

**Zipkin UI**: https://zipkin.example.com
**Query**: Search by traceId, service name, span name

### Trace Sampling

- **Development**: 100% (all requests)
- **Production**: 10% (sampled for performance)
- **Errors**: 100% (always traced)

### Example Trace

```
User Registration Flow (traceId: abc-123)
├─ user-service: POST /api/v1/users (200ms)
│  ├─ user-service: check_email_exists (10ms)
│  ├─ user-service: create_user_db (50ms)
│  ├─ user-service: create_verification_token (5ms)
│  └─ notification-service: send_email (135ms)
└─ Total: 200ms
```

## Runbooks

### High CPU Usage

1. Check Grafana for CPU metrics
2. Review thread dump: `jstack <pid>`
3. Check for GC thrashing
4. Scale horizontally if sustained

### Database Connection Issues

1. Check database health: `/actuator/health`
2. Review connection pool metrics
3. Check PostgreSQL logs
4. Restart pod if connections leaked

### Email Verification Failures

1. Check notification service health
2. Review RabbitMQ queue depth
3. Check retry queue for pending messages
4. Manual retry if needed

### Service Not Starting

1. Check pod logs: `kubectl logs <pod-name>`
2. Verify database connectivity
3. Check environment variables
4. Verify database migrations applied

## Performance Monitoring

### Key Performance Indicators

**Response Time**:
- Target P95: < 200ms
- Target P99: < 500ms

**Throughput**:
- Target: 1000 req/s per instance
- Current: ~300 req/s per instance

**Error Rate**:
- Target: < 0.1%
- Alert: > 1%

### Profiling

**Tools**:
- JProfiler (local development)
- Async-profiler (production)

**Flame Graphs**: Generated weekly for performance analysis

---

## Metadata

```yaml
source: SEMI
completeness: PARTIAL
needs-human: true
risk: MEDIUM
last-updated: 2026-03-19
notes: "Dashboard URLs and alert configurations need manual verification"
```
