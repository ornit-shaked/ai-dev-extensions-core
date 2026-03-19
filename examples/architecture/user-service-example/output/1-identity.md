# Identity & Boundaries

## Service Purpose

User Service manages user accounts, authentication, and profile information for the platform. It provides CRUD operations for user data and serves as the central authority for user identity within the system.

## Responsibilities

- User account creation and management
- User profile data storage and retrieval
- Email verification workflows
- Password reset functionality
- User search and filtering
- Integration with authentication service
- User activity tracking

## Non-Goals

⚠️ **Requires human review**

- Authentication/authorization logic (handled by Auth Service)
- Payment processing (handled by Payment Service)
- Email delivery (uses external Email Service)
- User analytics and reporting (separate Analytics Service)

## Team & Ownership

- **Team**: Identity & Access Management
- **Tech Lead**: Sarah Chen (sarah.chen@example.com)
- **Product Owner**: Mike Rodriguez
- **On-call**: #iam-oncall Slack channel

## Documentation Links

- Wiki: https://wiki.example.com/services/user-service
- Architecture Decision Records: docs/adr/
- API Documentation: https://api.example.com/docs/user-service
- Runbook: https://runbook.example.com/user-service

## Integration Points

### Upstream Dependencies (Services this service calls)
- **auth-service**: Token validation, permissions
- **notification-service**: Email/SMS notifications
- **audit-service**: User action logging

### Downstream Consumers (Services that call this service)
- **order-service**: User profile lookups
- **content-service**: User preferences
- **admin-portal**: User management UI
- **mobile-app**: User profile operations

## Service Boundaries

**Owns:**
- User profile data (name, email, preferences)
- Email verification state
- User metadata and tags

**Does NOT own:**
- Authentication credentials (auth-service)
- User permissions and roles (auth-service)
- User payment methods (payment-service)

---

## Metadata

```yaml
source: SEMI
completeness: PARTIAL
needs-human: true
risk: MEDIUM
last-updated: 2026-03-19
notes: "Non-goals section requires product owner validation"
```
