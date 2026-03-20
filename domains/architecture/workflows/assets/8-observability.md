# Observability & Operations: {{SERVICE_NAME}}

## Metadata
```yaml
source: SEMI
completeness: {{COMPLETE|PARTIAL|MISSING}}
needs-human: {{true|false}}
risk: {{MEDIUM|LOW|HIGH}}
last-updated: {{TIMESTAMP}}
```

## Logging

### Logging Framework
- **Framework**: {{Log4j2|Logback|SLF4J}}
- **Configuration**: {{src/main/resources/log4j2.xml}}
- **Format**: {{JSON|Plain text}}

### Log Levels
{{AUTO_DETECT_FROM_APPLICATION_YAML}}

| Logger | Level | Purpose |
|--------|-------|---------|
| `com.sdn.tosca.engine` | {{DEBUG|INFO}} | Application logs |
| `org.springframework` | {{INFO|WARN}} | Framework logs |
| `org.mongodb` | {{WARN}} | Database logs |
| `org.springframework.amqp` | {{INFO}} | Message broker logs |

**Configuration**:
```yaml
logging:
  level:
    com.sdn.tosca.engine: INFO
    org.springframework: WARN
    org.mongodb: WARN
```

### Key Log Statements
{{IMPORTANT_LOG_POINTS}}

**Service Operations**:
```java
log.info("Creating template: name={}, version={}", dto.getName(), dto.getVersion());
log.debug("Validating TOSCA syntax for template: {}", templateId);
log.error("Failed to save template: {}", templateId, exception);
```

**Request Logging**:
```java
log.info("Received request: method={}, path={}, user={}", 
    request.getMethod(), request.getPath(), user);
```

**Performance Logging**:
```java
log.info("Template creation completed: duration={}ms, templateId={}", 
    duration, templateId);
```

### Log Aggregation
{{IF_CENTRALIZED_LOGGING_EXISTS}}

- **System**: {{ELK Stack|Splunk|CloudWatch}}
- **Endpoint**: {{LOGGING_ENDPOINT}}
- **Retention**: {{30_DAYS|90_DAYS}}

> ⚠️ **Needs Review**: Verify log aggregation configuration and dashboard links.

---

## Metrics

### Metrics Framework
- **Framework**: {{Micrometer|Prometheus|Custom}}
- **Endpoint**: {{/actuator/prometheus}}
- **Scrape Interval**: {{15s|30s}}

### Application Metrics
{{AUTO_DETECT_FROM_@Timed_@Counted_ANNOTATIONS}}

#### Business Metrics

| Metric | Type | Description | Labels |
|--------|------|-------------|--------|
| `templates.created.total` | Counter | Total templates created | `state`, `version` |
| `templates.validation.duration` | Histogram | TOSCA validation time | `result` |
| `templates.active.count` | Gauge | Active templates | `state` |

#### Technical Metrics

| Metric | Type | Description | Labels |
|--------|------|-------------|--------|
| `http.server.requests` | Timer | HTTP request duration | `method`, `uri`, `status` |
| `mongodb.queries.duration` | Timer | Database query time | `collection`, `operation` |
| `rabbitmq.messages.published` | Counter | Messages published | `exchange`, `routing_key` |

### System Metrics
{{JVM_AND_SYSTEM_METRICS}}

- **JVM**: Heap usage, GC pauses, thread count
- **System**: CPU usage, memory usage, disk I/O
- **Connection Pools**: MongoDB connections, HTTP connections

**Example Queries**:
```promql
# Request rate
rate(http_server_requests_total[5m])

# 95th percentile response time
histogram_quantile(0.95, http_server_requests_seconds_bucket)

# Error rate
rate(http_server_requests_total{status=~"5.."}[5m])
```

---

## Health Checks

### Health Endpoints
{{SPRING_BOOT_ACTUATOR_ENDPOINTS}}

| Endpoint | Purpose | Used By |
|----------|---------|---------|
| `/actuator/health` | Overall health | Load balancer |
| `/actuator/health/readiness` | Ready to serve traffic | Kubernetes readiness probe |
| `/actuator/health/liveness` | Application is alive | Kubernetes liveness probe |
| `/actuator/info` | Application info | Monitoring |

### Health Indicators
{{AUTO_DETECT_HEALTH_CHECKS}}

| Indicator | Checks | Failure Impact |
|-----------|--------|----------------|
| `mongodb` | Database connectivity | Service unhealthy |
| `rabbitmq` | Message broker connectivity | Service degraded |
| `diskSpace` | Available disk space | Service unhealthy if < 10MB |

**Health Response Example**:
```json
{
  "status": "UP",
  "components": {
    "mongodb": {
      "status": "UP",
      "details": {
        "version": "5.0.0"
      }
    },
    "rabbitmq": {
      "status": "UP",
      "details": {
        "version": "3.9.0"
      }
    }
  }
}
```

### Probe Configuration
{{KUBERNETES_PROBE_SETTINGS}}

**Readiness Probe**:
```yaml
readinessProbe:
  httpGet:
    path: /actuator/health/readiness
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3
```

**Liveness Probe**:
```yaml
livenessProbe:
  httpGet:
    path: /actuator/health/liveness
    port: 8080
  initialDelaySeconds: 60
  periodSeconds: 30
  timeoutSeconds: 5
  failureThreshold: 3
```

---

## Tracing

### Distributed Tracing
{{IF_TRACING_IS_ENABLED}}

- **Framework**: {{Spring Cloud Sleuth|OpenTelemetry|Jaeger}}
- **Trace ID Propagation**: {{HTTP headers, message headers}}
- **Sampling Rate**: {{10%|100%}}

**Trace Context**:
```
X-B3-TraceId: 80f198ee56343ba864fe8b2a57d3eff7
X-B3-SpanId: e457b5a2e4d86bd1
X-B3-ParentSpanId: 05e3ac9a4f6e3b90
```

### Trace Collection
- **Backend**: {{Jaeger|Zipkin|AWS X-Ray}}
- **Endpoint**: {{TRACING_ENDPOINT}}
- **Retention**: {{7_DAYS|30_DAYS}}

> ⚠️ **Needs Review**: Verify tracing configuration and backend details.

---

## Dashboards

### Monitoring Dashboards
{{LINKS_TO_GRAFANA_KIBANA_DASHBOARDS}}

> ⚠️ **Needs Review**: Dashboard links need to be added manually.

**Suggested Dashboards**:
1. **Service Overview**: Request rate, error rate, latency
2. **Database Performance**: Query time, connection pool usage
3. **Message Broker**: Message throughput, queue depth
4. **JVM Metrics**: Heap usage, GC activity, thread count
5. **Business Metrics**: Templates created, validation failures

### Dashboard Queries
{{EXAMPLE_QUERIES_FOR_KEY_METRICS}}

**Request Rate**:
```promql
sum(rate(http_server_requests_total{application="tosca-engine-ms"}[5m])) by (uri)
```

**Error Rate**:
```promql
sum(rate(http_server_requests_total{application="tosca-engine-ms",status=~"5.."}[5m]))
```

**Response Time (p95)**:
```promql
histogram_quantile(0.95, 
  sum(rate(http_server_requests_seconds_bucket{application="tosca-engine-ms"}[5m])) by (le)
)
```

---

## Alerting

### Alert Rules
{{IF_ALERTS_ARE_CONFIGURED}}

> ⚠️ **Needs Review**: Alert configuration needs verification.

**Critical Alerts**:

| Alert | Condition | Severity | Action |
|-------|-----------|----------|--------|
| Service Down | Health check fails for 2 minutes | Critical | Page on-call |
| High Error Rate | Error rate > 5% for 5 minutes | Critical | Page on-call |
| Database Unavailable | MongoDB health DOWN | Critical | Page on-call |

**Warning Alerts**:

| Alert | Condition | Severity | Action |
|-------|-----------|----------|--------|
| High Latency | p95 latency > 1s for 10 minutes | Warning | Notify team |
| High Memory Usage | JVM heap > 85% for 15 minutes | Warning | Notify team |
| Queue Backlog | RabbitMQ queue depth > 1000 | Warning | Notify team |

### Alert Channels
- **Critical**: {{PagerDuty|Slack #alerts|Email}}
- **Warning**: {{Slack #monitoring|Email}}
- **Info**: {{Slack #monitoring}}

---

## Operational Runbooks

### Common Operations

#### Restart Service
```bash
# Kubernetes
kubectl rollout restart deployment/tosca-engine-ms -n muse

# Docker
docker restart tosca-engine-ms
```

#### Check Logs
```bash
# Kubernetes
kubectl logs -f deployment/tosca-engine-ms -n muse

# Docker
docker logs -f tosca-engine-ms

# Tail specific logger
kubectl logs -f deployment/tosca-engine-ms -n muse | grep "com.sdn.tosca.engine"
```

#### Check Health
```bash
# Health endpoint
curl http://tosca-engine-ms:8080/actuator/health

# Readiness
curl http://tosca-engine-ms:8080/actuator/health/readiness

# Metrics
curl http://tosca-engine-ms:8080/actuator/prometheus
```

### Troubleshooting

#### High Memory Usage
**Symptoms**: JVM heap usage > 85%, frequent GC
**Diagnosis**:
```bash
# Check heap usage
kubectl exec -it deployment/tosca-engine-ms -- jstat -gc 1

# Heap dump
kubectl exec -it deployment/tosca-engine-ms -- jmap -dump:live,format=b,file=/tmp/heap.hprof 1
```
**Resolution**: Increase memory limits, investigate memory leaks

#### Slow Response Times
**Symptoms**: p95 latency > 1s
**Diagnosis**:
- Check database query times in logs
- Check external service latency
- Review thread pool metrics
**Resolution**: Optimize queries, increase connection pools, scale horizontally

#### Database Connection Errors
**Symptoms**: MongoDB health DOWN, connection refused errors
**Diagnosis**:
```bash
# Check MongoDB pod
kubectl get pods -n muse | grep mongodb

# Check MongoDB logs
kubectl logs -f deployment/mongodb -n muse
```
**Resolution**: Restart MongoDB, verify network connectivity, check credentials

---

## Performance Baselines

### Expected Performance
{{DOCUMENT_NORMAL_OPERATING_RANGES}}

| Metric | Normal Range | Warning Threshold | Critical Threshold |
|--------|--------------|-------------------|-------------------|
| Request Rate | 10-100 req/s | > 200 req/s | > 500 req/s |
| Response Time (p95) | 100-500ms | > 1s | > 3s |
| Error Rate | < 0.1% | > 1% | > 5% |
| CPU Usage | 20-50% | > 70% | > 90% |
| Memory Usage | 40-70% | > 85% | > 95% |
| Database Query Time | 10-50ms | > 200ms | > 500ms |

### Capacity Planning
- **Current Capacity**: {{REQUESTS_PER_SECOND}}
- **Max Capacity**: {{REQUESTS_PER_SECOND}}
- **Scaling Trigger**: {{CPU_OR_MEMORY_THRESHOLD}}

---

## Maintenance Windows

### Scheduled Maintenance
{{IF_MAINTENANCE_WINDOWS_EXIST}}

- **Frequency**: {{MONTHLY|QUARTERLY}}
- **Duration**: {{2_HOURS}}
- **Notification**: {{48_HOURS_ADVANCE}}

### Deployment Process
{{DEPLOYMENT_PROCEDURE}}

1. **Pre-deployment**: Run health checks, backup database
2. **Deployment**: Rolling update (zero downtime)
3. **Post-deployment**: Verify health, check metrics, smoke tests
4. **Rollback**: Automatic if health checks fail

---
*Auto-generated by /architecture-intake workflow*
