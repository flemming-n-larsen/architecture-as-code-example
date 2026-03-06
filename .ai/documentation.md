# Documentation Standards

## Code Comments

- All public APIs must have JSDoc comments
- Complex business logic requires inline explanations
- Reference specification files when implementing business rules
- Explain "why" not "what" in comments

## JSDoc Example

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

## Specification References

When implementing features from change proposals, include references:

```typescript
// Reference: /openspec/changes/loyalty-points/proposal.md
// Business rule: Points expire 12 months after earning date
```
