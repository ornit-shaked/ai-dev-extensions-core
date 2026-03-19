# Contracts

## REST API Endpoints

### User Management

#### GET /api/v1/users/{id}
Get user by ID

**Response**: `UserDTO`
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "status": "ACTIVE",
  "createdAt": "2026-01-15T10:30:00Z"
}
```

#### POST /api/v1/users
Create new user

**Request**: `CreateUserRequest`
**Response**: `UserDTO`
**Status Codes**: 201 (Created), 400 (Validation Error), 409 (Email Exists)

#### PUT /api/v1/users/{id}
Update existing user

**Request**: `UpdateUserRequest`
**Response**: `UserDTO`
**Status Codes**: 200 (OK), 400 (Validation Error), 404 (Not Found)

#### DELETE /api/v1/users/{id}
Soft delete user

**Response**: 204 (No Content)
**Status Codes**: 204 (Deleted), 404 (Not Found)

### User Search

#### GET /api/v1/users/search
Search users with filters

**Query Parameters**:
- `email`: Email filter (optional)
- `status`: User status filter (optional)
- `page`: Page number (default: 0)
- `size`: Page size (default: 20)

**Response**: `Page<UserDTO>`

### Email Verification

#### POST /api/v1/users/{id}/verify-email
Request email verification

**Response**: 202 (Accepted)

#### GET /api/v1/users/verify
Verify email with token

**Query Parameters**:
- `token`: Verification token

**Response**: 200 (Success), 400 (Invalid Token)

## OpenAPI Specification

⚠️ **OpenAPI spec location**: `src/main/resources/openapi.yaml` (needs verification)

**Auto-generated documentation**: http://localhost:8080/swagger-ui.html

## Async Events

### Published Events

#### UserCreatedEvent
Published when a new user is created

**Exchange**: `user.events`
**Routing Key**: `user.created`
**Payload**:
```json
{
  "eventId": "uuid",
  "userId": "uuid",
  "email": "user@example.com",
  "timestamp": "2026-03-19T14:30:00Z"
}
```

#### UserUpdatedEvent
Published when user profile is updated

**Exchange**: `user.events`
**Routing Key**: `user.updated`
**Payload**: Similar to UserCreatedEvent with updated fields

#### UserDeletedEvent
Published when user is deleted

**Exchange**: `user.events`
**Routing Key**: `user.deleted`
**Payload**:
```json
{
  "eventId": "uuid",
  "userId": "uuid",
  "timestamp": "2026-03-19T14:30:00Z"
}
```

### Consumed Events

#### EmailVerifiedEvent
Consumed from notification-service when email is verified

**Exchange**: `notification.events`
**Routing Key**: `email.verified`

## External Dependencies

### Auth Service
- **Type**: REST API
- **Base URL**: http://auth-service:8081
- **Endpoints Used**:
  - `POST /api/v1/auth/validate-token`: Token validation
  - `GET /api/v1/auth/permissions/{userId}`: Get user permissions

### Notification Service
- **Type**: REST API
- **Base URL**: http://notification-service:8082
- **Endpoints Used**:
  - `POST /api/v1/notifications/email`: Send email notifications

### Audit Service
- **Type**: Async (RabbitMQ)
- **Exchange**: `audit.events`
- **Purpose**: Log user actions for compliance

## Error Response Format

Standard error response across all endpoints:

```json
{
  "timestamp": "2026-03-19T14:30:00Z",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed for field 'email'",
  "path": "/api/v1/users",
  "errors": [
    {
      "field": "email",
      "message": "must be a valid email address"
    }
  ]
}
```

## API Versioning

- **Strategy**: URL-based versioning (`/api/v1/`)
- **Current Version**: v1
- **Deprecation Policy**: 6 months notice before removing old versions

---

## Metadata

```yaml
source: SEMI
completeness: PARTIAL
needs-human: true
risk: HIGH
last-updated: 2026-03-19
notes: "OpenAPI spec location needs manual verification. External service URLs need confirmation."
```
