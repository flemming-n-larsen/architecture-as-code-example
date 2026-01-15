# Customer Specification

**Domain:** Customer Management  
**Last Updated:** 2026-01-15

## Purpose

Customer account management and profile data for the e-commerce platform.

## Requirements

### Requirement: Customer Registration

The system SHALL support email-based registration with verification.

#### Scenario: Successful registration
- WHEN a user submits valid registration data
- THEN an account is created in unverified state
- AND a verification email is sent

#### Scenario: Email verification
- WHEN a user clicks the verification link within 24 hours
- THEN the account is activated
- AND a welcome email is sent

#### Scenario: Verification timeout
- WHEN verification is not completed within 24 hours
- THEN the registration is expired
- AND the account is cleaned up after 48 hours

### Requirement: Password Security

The system MUST enforce password complexity requirements.

#### Scenario: Valid password
- WHEN a password meets complexity requirements (8+ chars, uppercase, lowercase, number)
- THEN the password is accepted

#### Scenario: Invalid password
- WHEN a password fails complexity requirements
- THEN registration is rejected with specific guidance

### Requirement: Spam Prevention

The system SHALL prevent spam account creation.

#### Scenario: Rate limiting
- WHEN more than 3 registration attempts occur from the same IP within an hour
- THEN additional attempts are blocked
- AND the IP is logged for review

## Business Rules

### Account Status
- Customers can be in states: unverified, active, suspended
- Only active customers can place orders
- Suspended accounts cannot earn or redeem loyalty points

### Profile Requirements
- Email must be unique across the platform
- Valid contact email is required for order notifications

## Related Entities

- **Customer**: Main customer entity
- **EmailVerification**: Verification token management
- **RegistrationAttempt**: Rate limiting tracking
