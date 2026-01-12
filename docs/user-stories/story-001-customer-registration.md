# User Story: Customer Registration

**ID:** STORY-001

**Status:** In Progress

**Priority:** High

---

## User Story Statement

As a **new user**, I want to **create an account with my email and password**, so that I can **place orders and track my purchases**.

---

## Acceptance Criteria

- [ ] User can register with email, name, and password
- [ ] Email must be unique across all customers
- [ ] Password must meet security requirements (see below)
- [ ] User receives verification email after registration
- [ ] User cannot place orders until email is verified
- [ ] Registration form shows real-time validation
- [ ] Clear error messages for validation failures

---

## Related Entities

- [Customer](../architecture/domain/customer.md) — Customer entity created

---

## Related Flows

- Email verification flow (not yet documented)

---

## Related Requirements

- **FR-001:** User registration ([Requirements](../requirements.md))
- **FR-002:** Profile updates ([Requirements](../requirements.md))
- **NFR-010:** Password security ([Requirements](../requirements.md))

---

## Business Rules

### Email Validation
- Must follow RFC 5322 standard
- Case-insensitive comparison
- Must be unique across all customers

### Password Requirements
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- Optional: special character

### Email Verification
- Verification link valid for 24 hours
- Unverified accounts auto-deleted after 7 days
- User can request new verification email

---

## UI Mockup Notes

### Registration Form
- Email input (type=email)
- Password input (type=password) with show/hide toggle
- Password strength indicator
- Name input (full name)
- "Register" button
- Link to login page for existing users
- Privacy policy agreement checkbox

### Validation
- Real-time validation as user types
- Clear error messages
- Success message after submission
- Redirect to verification pending page

---

## Acceptance Tests

```gherkin
Feature: Customer Registration

  Scenario: Successful registration
    Given I am on the registration page
    When I enter a valid email "user@example.com"
    And I enter my name "John Doe"
    And I enter a valid password "SecurePass123"
    And I click the "Register" button
    Then I should see "Verification email sent"
    And I should receive an email with a verification link

  Scenario: Duplicate email
    Given a customer exists with email "existing@example.com"
    When I try to register with email "existing@example.com"
    Then I should see "Email already registered"

  Scenario: Weak password
    Given I am on the registration page
    When I enter password "weak"
    Then I should see "Password does not meet requirements"
```

---

## Definition of Done

- [ ] API endpoints implemented and tested
- [ ] Unit tests written (≥80% coverage)
- [ ] Integration tests pass
- [ ] Email service integration working
- [ ] Password hashing verified (bcrypt cost ≥ 12)
- [ ] UI implemented and responsive
- [ ] Accessibility requirements met (WCAG 2.1 AA)
- [ ] Security review completed
- [ ] Documentation updated
- [ ] Deployed to staging and verified

---

## Technical Notes

### Password Hashing (TypeScript Example)

```typescript
import bcrypt from 'bcrypt';

const saltRounds = 12;

async function hashPassword(password: string): Promise<string> {
    return await bcrypt.hash(password, saltRounds);
}

async function verifyPassword(password: string, hash: string): Promise<boolean> {
    return await bcrypt.compare(password, hash);
}
```

### Email Verification Token

```typescript
import crypto from 'crypto';

function generateVerificationToken(): string {
    return crypto.randomBytes(32).toString('hex');
}
```

---

## Open Questions

- **Q:** Should we support OAuth (Google, Facebook) in v1?
  - **A:** No, defer to v2 for simplicity

- **Q:** What happens if verification email isn't received?
  - **A:** Add "Resend verification" link on login attempt

---

## Related User Stories

- [Place Order](story-002-place-order.md) — Requires verified account

---

**Next:** See [Place Order](story-002-place-order.md) for order placement flow.
