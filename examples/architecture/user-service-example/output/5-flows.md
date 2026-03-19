# Key Flows

## Flow 1: User Registration

**Trigger**: POST /api/v1/users

### Steps

1. **API receives CreateUserRequest**
   - Controller validates input (email format, required fields)
   
2. **Check email uniqueness**
   - Query: `UserRepository.findByEmail(email)`
   - If exists → Return 409 Conflict
   
3. **Create user entity**
   - Status: ACTIVE
   - Email_verified: false
   - Generate UUID
   
4. **Save to database**
   - Transaction begins
   - Insert into `users` table
   - Create default `user_preferences`
   - Transaction commits
   
5. **Generate verification token**
   - Create VerificationToken entity
   - Token: Random UUID
   - Expires: Current time + 24 hours
   - Save to `verification_tokens` table
   
6. **Publish UserCreatedEvent**
   - Exchange: `user.events`
   - Routing key: `user.created`
   - Payload: userId, email, timestamp
   
7. **Send verification email** (async)
   - Call NotificationService
   - POST /api/v1/notifications/email
   - Body: {userId, token, email}
   
8. **Return response**
   - Status: 201 Created
   - Body: UserDTO

### Error Scenarios

- **Email already exists**: Return 409 with error message
- **Validation failure**: Return 400 with field errors
- **Database error**: Rollback transaction, return 500
- **Notification failure**: User created but email not sent (logged, retryable)

---

## Flow 2: Email Verification

**Trigger**: GET /api/v1/users/verify?token={token}

### Steps

1. **Receive verification request**
   - Extract token from query parameter
   
2. **Find verification token**
   - Query: `VerificationTokenRepository.findByToken(token)`
   - If not found → Return 400 "Invalid token"
   
3. **Validate token**
   - Check if `used_at` is null
   - Check if `expires_at > now()`
   - If invalid → Return 400 "Token expired or already used"
   
4. **Update user status**
   - Set `email_verified = true`
   - Update `updated_at` timestamp
   
5. **Mark token as used**
   - Set `used_at = now()`
   - Save token
   
6. **Publish EmailVerifiedEvent**
   - To audit service
   - Log verification success
   
7. **Return success response**
   - Status: 200 OK
   - Redirect to success page

### Error Scenarios

- **Token not found**: Return 400 "Invalid verification token"
- **Token expired**: Return 400 "Verification link has expired"
- **Token already used**: Return 400 "Email already verified"

---

## Flow 3: User Profile Update

**Trigger**: PUT /api/v1/users/{id}

### Steps

1. **API receives UpdateUserRequest**
   - Extract user ID from path
   - Validate input fields
   
2. **Fetch existing user**
   - Query: `UserRepository.findById(id)`
   - If not found → Return 404
   
3. **Check authorization** (via Auth Service)
   - Validate user can update this profile
   - Call: POST /api/v1/auth/validate-token
   - If unauthorized → Return 403
   
4. **Apply updates**
   - Map request fields to entity
   - Validate email uniqueness if changed
   - Update `updated_at` timestamp
   
5. **Save changes**
   - Transaction begins
   - Update `users` table
   - Transaction commits
   
6. **Publish UserUpdatedEvent**
   - Exchange: `user.events`
   - Routing key: `user.updated`
   - Include changed fields
   
7. **Return updated user**
   - Status: 200 OK
   - Body: Updated UserDTO

### Decision Points

- **Email changed?**
  - Yes → Check uniqueness, set email_verified=false, trigger new verification
  - No → Continue

- **Status changed?**
  - Validate status transition rules
  - Log status change to audit service

### Error Scenarios

- **User not found**: Return 404
- **Unauthorized**: Return 403
- **Email conflict**: Return 409
- **Invalid status transition**: Return 400

---

## Flow 4: User Search

**Trigger**: GET /api/v1/users/search?email={email}&status={status}&page={page}

### Steps

1. **Parse query parameters**
   - Email filter (optional)
   - Status filter (optional)
   - Pagination params (page, size)
   
2. **Build search criteria**
   - Dynamic query based on provided filters
   - Default page size: 20
   
3. **Execute search**
   - Query: `UserRepository.findByStatusAndEmailContaining(...)`
   - Apply pagination
   
4. **Map to DTOs**
   - Convert entities to UserDTOs
   - Exclude sensitive fields
   
5. **Return paginated results**
   - Status: 200 OK
   - Body: Page<UserDTO> with metadata

### Performance Considerations

- **Indexed fields**: Search uses indexed columns (email, status)
- **Pagination**: Always paginated to prevent large result sets
- **Query timeout**: 5 seconds max query time

---

## Flow 5: User Soft Delete

**Trigger**: DELETE /api/v1/users/{id}

### Steps

1. **Receive delete request**
   - Extract user ID from path
   
2. **Check authorization**
   - Validate admin permissions
   - If not admin → Return 403
   
3. **Fetch user**
   - Query: `UserRepository.findById(id)`
   - If not found → Return 404
   
4. **Soft delete user**
   - Set `deleted_at = now()`
   - Status → INACTIVE
   - Keep all data for audit
   
5. **Invalidate sessions** (call Auth Service)
   - POST /api/v1/auth/invalidate-user-sessions
   - Force logout from all devices
   
6. **Publish UserDeletedEvent**
   - Exchange: `user.events`
   - Routing key: `user.deleted`
   
7. **Schedule hard delete** (async job)
   - After 90 days, permanently delete
   
8. **Return success**
   - Status: 204 No Content

### Error Scenarios

- **User not found**: Return 404
- **Unauthorized**: Return 403
- **User already deleted**: Return 409

---

## Metadata

```yaml
source: SEMI
completeness: COMPLETE
needs-human: false
risk: MEDIUM
last-updated: 2026-03-19
notes: "Flows documented based on controller and service layer analysis"
```
