# AI Agent Guidelines

**Purpose:** This file provides guidelines for AI agents working with this codebase. It ensures consistent,
architecture-aligned code generation across different AI sessions and team members.

---

## Code Style

### TypeScript/JavaScript

- Use TypeScript strict mode (`"strict": true`)
- Prefer `const` over `let`, avoid `var`
- Use functional programming patterns where appropriate
- Maximum function length: 50 lines
- Use meaningful variable names (no single-letter variables except loop counters)
- Always handle errors explicitly (no silent failures)

### Formatting

- Use 2-space indentation
- Use semicolons
- Single quotes for strings
- Trailing commas in multi-line objects/arrays

---

## Architecture Patterns

### Repository Structure

- Follow the existing structure in `/docs` and `/openspec`
- All business logic must have corresponding specifications in `/openspec/specs`
- Architecture diagrams in `/docs` must be updated when entity structure changes

### Code Organization

- Domain entities follow the existing pattern (see `/docs/architecture/domain/`)
- Business rules are defined in `/openspec/specs/`
- State machines must match the diagrams in entity documentation
- API endpoints follow RESTful conventions

### Design Patterns

- Use Repository pattern for data access
- Use Service layer for business logic
- Use Factory pattern for complex object creation
- Avoid God objects (single responsibility principle)

---

## Testing Requirements

### Coverage

- Minimum 80% code coverage for business logic
- 100% coverage for critical paths (payment, order processing)
- Integration tests required for all API endpoints

### Test Structure

- Follow Arrange-Act-Assert pattern
- One assertion per test when possible
- Test file names: `*.test.ts` or `*.spec.ts`
- Reference business rules from `/openspec` in test descriptions

### Example Test Pattern

```typescript
describe('Order.cancelOrder', () => {
    it('should cancel pending order and refund payment (ref: /openspec/business-rules/order-validation.md)', () => {
        // Arrange
        const order = createTestOrder({status: 'pending'});

        // Act
        const result = order.cancelOrder();

        // Assert
        expect(result.status).toBe('cancelled');
        expect(result.refundIssued).toBe(true);
    });
});
```

---

## Documentation Standards

### Code Comments

- All public APIs must have JSDoc comments
- Complex business logic requires inline explanations
- Reference specification files when implementing business rules
- Explain "why" not "what" in comments

### JSDoc Example

```typescript
/**
 * Calculates loyalty points earned for an order
 * @param orderTotal - Order total after taxes and shipping
 * @returns Points earned (1 point per dollar, max 500 points)
 * @see /openspec/changes/loyalty-points/specs/customer/spec.md
 */
function calculateLoyaltyPoints(orderTotal: number): number {
    // Implementation...
}
```

### Specification References

When implementing features from change proposals, include references:

```typescript
// Reference: /openspec/changes/loyalty-points/proposal.md
// Business rule: Points expire 12 months after earning date
```

---

## Common Pitfalls to Avoid

### ❌ Don't Do This

- Don't bypass the validation layer
- Don't create new design patterns when existing ones work
- Don't skip error handling
- Don't ignore the specifications in `/openspec`
- Don't mutate state directly (use immutable patterns)
- Don't use `any` type in TypeScript
- Don't hardcode configuration values
- Don't skip PR reviews for "small changes"

### ✅ Do This Instead

- Always use the existing validation service
- Follow established patterns from `/docs/architecture`
- Implement comprehensive error handling with meaningful messages
- Reference specifications in code comments
- Use immutable state updates (spread operators, immer)
- Use proper TypeScript types
- Use environment variables or configuration files
- All changes go through PR review process

---

## Business Logic Implementation

### Order Processing

- Always validate order state transitions (see `/openspec/specs/order/spec.md`)
- Check inventory before confirming orders
- Payment must be authorized before order confirmation
- Refunds are processed for cancelled confirmed orders

### Payment Processing

- Maximum 3 retry attempts for failed payments
- All payment operations must be idempotent
- Use payment service layer (don't call payment gateway directly)
- Log all payment transactions for audit

### Error Handling

```typescript
// ✅ Good: Specific error handling with context
try {
    await orderService.confirmOrder(orderId);
} catch (error) {
    if (error instanceof InsufficientInventoryError) {
        throw new BusinessLogicError('Cannot confirm order: insufficient inventory', {orderId});
    }
    throw error;
}

// ❌ Bad: Generic catch-all
try {
    await orderService.confirmOrder(orderId);
} catch (error) {
    console.log('Error');
}
```

---

## Performance Considerations

- Cache product prices for 5 minutes
- Batch database operations where possible
- Use database indexes for frequently queried fields
- Implement pagination for list endpoints (default: 20 items per page)
- Avoid N+1 queries (use eager loading)

---

## Security Guidelines

- Never log sensitive data (passwords, credit cards, tokens)
- Validate all user input
- Use parameterized queries (prevent SQL injection)
- Implement rate limiting on public endpoints
- Use HTTPS for all external communications

---

## When in Doubt

1. **Check existing code** - Look for similar implementations
2. **Reference specifications** - Check `/openspec` for business rules
3. **Review architecture** - Consult `/docs/architecture` for patterns
4. **Ask questions** - Use AI planning mode to clarify requirements
5. **Keep it simple** - Don't over-engineer solutions

---

**Last Updated:** 2026-01-15  
**Version:** 1.0

This file should be referenced in AI prompts: `"Follow the guidelines in AGENTS.md while implementing this feature."`
