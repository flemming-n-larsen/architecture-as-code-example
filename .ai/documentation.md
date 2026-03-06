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

## Directory README Files

Every directory containing documentation must have a `README.md` file. Git hosting platforms (GitHub, GitLab, Bitbucket, etc.) automatically render the `README.md` as the directory's landing page when a user navigates to it — making it the primary entry point for anyone browsing the repository. Without it, a directory is just a list of files with no context.

Each `README.md` should:
- Describe the purpose and contents of the directory
- Link to key files within it

## Specification References

When implementing features from change proposals, include references:

```typescript
// Reference: /openspec/changes/loyalty-points/proposal.md
// Business rule: Points expire 12 months after earning date
```
