# Data Layer

## Database Technology

- **Type**: PostgreSQL 15.4
- **Driver**: org.postgresql.Driver (version 42.6.0)
- **Connection Pool**: HikariCP (default with Spring Boot)
- **ORM**: Hibernate 6.2.7 (via Spring Data JPA)

## Configuration

**Database Name**: `userdb`
**Connection String**: `jdbc:postgresql://postgres:5432/userdb`
**Pool Size**: 
- Min: 5
- Max: 20

## Entities

### User
Primary entity representing a user account

**Table**: `users`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Unique identifier |
| email | VARCHAR(255) | UNIQUE, NOT NULL | User email |
| first_name | VARCHAR(100) | NOT NULL | First name |
| last_name | VARCHAR(100) | NOT NULL | Last name |
| phone_number | VARCHAR(20) | | Phone number |
| status | VARCHAR(20) | NOT NULL | ACTIVE, INACTIVE, SUSPENDED |
| email_verified | BOOLEAN | NOT NULL, DEFAULT false | Email verification status |
| created_at | TIMESTAMP | NOT NULL | Creation timestamp |
| updated_at | TIMESTAMP | NOT NULL | Last update timestamp |
| deleted_at | TIMESTAMP | | Soft delete timestamp |

**Indexes**:
- `idx_users_email` on `email`
- `idx_users_status` on `status`
- `idx_users_created_at` on `created_at`

### VerificationToken
Email verification tokens

**Table**: `verification_tokens`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Token ID |
| user_id | UUID | FOREIGN KEY → users(id) | Associated user |
| token | VARCHAR(255) | UNIQUE, NOT NULL | Verification token |
| expires_at | TIMESTAMP | NOT NULL | Expiration time |
| used_at | TIMESTAMP | | When token was used |
| created_at | TIMESTAMP | NOT NULL | Creation timestamp |

**Indexes**:
- `idx_verification_tokens_token` on `token`
- `idx_verification_tokens_user_id` on `user_id`

### UserPreferences
User settings and preferences

**Table**: `user_preferences`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Preference ID |
| user_id | UUID | FOREIGN KEY → users(id), UNIQUE | Associated user |
| language | VARCHAR(10) | NOT NULL, DEFAULT 'en' | Preferred language |
| timezone | VARCHAR(50) | NOT NULL, DEFAULT 'UTC' | User timezone |
| notifications_enabled | BOOLEAN | NOT NULL, DEFAULT true | Email notifications |
| theme | VARCHAR(20) | NOT NULL, DEFAULT 'light' | UI theme preference |
| updated_at | TIMESTAMP | NOT NULL | Last update |

## Relationships

```
users (1) ──────< (many) verification_tokens
users (1) ──────< (1) user_preferences
```

## Database Migrations

### Migration Tool
**Flyway 9.22.0**

### Migration Location
`src/main/resources/db/migration/`

### Migration Files

1. `V1__create_users_table.sql` - Initial users table
2. `V2__create_verification_tokens_table.sql` - Verification tokens
3. `V3__create_user_preferences_table.sql` - User preferences
4. `V4__add_indexes.sql` - Performance indexes
5. `V5__add_deleted_at_column.sql` - Soft delete support

### Migration Strategy
- **Development**: Auto-migrate on startup
- **Production**: Manual migration via CI/CD pipeline
- **Rollback**: Separate rollback scripts in `db/rollback/`

## Data Invariants

### Business Rules
1. **Email uniqueness**: Email must be unique across all active users
2. **Status transitions**: 
   - ACTIVE → INACTIVE (allowed)
   - INACTIVE → ACTIVE (allowed)
   - Any → SUSPENDED (allowed, admin only)
   - SUSPENDED → ACTIVE (requires approval)
3. **Soft delete**: Deleted users keep `deleted_at` timestamp, email released after 90 days
4. **Verification tokens**: Expire after 24 hours
5. **One token per user**: Only one active verification token per user

### Data Integrity
- **Referential integrity**: Enforced via foreign keys
- **Cascading deletes**: ON DELETE CASCADE for verification_tokens
- **Null constraints**: All required fields enforced at DB level
- **Check constraints**: Email format validated via regex at application level

## Repository Methods

### UserRepository (extends JpaRepository)

**Custom queries**:
```java
Optional<User> findByEmail(String email);
List<User> findByStatus(UserStatus status);
Page<User> findByStatusAndEmailContaining(UserStatus status, String email, Pageable pageable);
List<User> findByCreatedAtBetween(LocalDateTime start, LocalDateTime end);
```

### VerificationTokenRepository

**Custom queries**:
```java
Optional<VerificationToken> findByToken(String token);
List<VerificationToken> findByUserIdAndUsedAtIsNull(UUID userId);
void deleteByExpiresAtBefore(LocalDateTime dateTime);
```

## Query Performance

- **N+1 Query Prevention**: Use `@EntityGraph` for user + preferences fetching
- **Pagination**: All list endpoints use pagination (default size: 20)
- **Caching**: No caching layer (considered for Phase 2)
- **Connection Pooling**: HikariCP with max 20 connections

---

## Metadata

```yaml
source: AUTO
completeness: COMPLETE
needs-human: false
risk: LOW
last-updated: 2026-03-19
notes: "Extracted from JPA entities and Flyway migrations"
```
