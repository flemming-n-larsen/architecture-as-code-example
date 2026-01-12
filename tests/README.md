# Tests Placeholder

This folder would contain all test files.

## Recommended Structure

```
tests/
├── unit/
│   ├── models/
│   │   ├── Customer.test.ts
│   │   ├── Order.test.ts
│   │   └── Product.test.ts
│   └── services/
│       ├── orderService.test.ts
│       └── paymentService.test.ts
├── integration/
│   ├── orderCreation.test.ts
│   ├── paymentProcessing.test.ts
│   └── inventoryManagement.test.ts
└── e2e/
    ├── placeOrder.test.ts
    └── customerRegistration.test.ts
```

## Testing Philosophy

Tests are part of documentation! They show:
- How the system should behave
- What edge cases are handled
- How entities interact

Reference user stories in test descriptions:
```typescript
// See: docs/user-stories/story-002-place-order.md
describe('Place Order (STORY-002)', () => {
    it('should prevent overselling with concurrent orders', async () => {
        // Test implementation
    });
});
```

