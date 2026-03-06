# Testing Requirements

## Coverage

- Minimum 80% code coverage for business logic
- 100% coverage for critical paths (payment, order processing)
- Integration tests required for all API endpoints

## Test Structure

- Follow Arrange-Act-Assert pattern
- One assertion per test when possible
- Test file names: `*.test.ts` or `*.spec.ts`
- Reference business rules from `/openspec` in test descriptions

## Example

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
