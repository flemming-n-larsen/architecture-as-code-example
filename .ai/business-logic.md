# Business Logic Implementation

## Order Processing

- Always validate order state transitions (see `/openspec/specs/order/spec.md`)
- Check inventory before confirming orders
- Payment must be authorized before order confirmation
- Refunds are processed for cancelled confirmed orders

## Payment Processing

- Maximum 3 retry attempts for failed payments
- All payment operations must be idempotent
- Use payment service layer — don't call payment gateway directly
- Log all payment transactions for audit

## Error Handling

Always use specific error handling with context:

```typescript
// Good: specific error with context
try {
    await orderService.confirmOrder(orderId);
} catch (error) {
    if (error instanceof InsufficientInventoryError) {
        throw new BusinessLogicError('Cannot confirm order: insufficient inventory', {orderId});
    }
    throw error;
}

// Bad: generic catch-all
try {
    await orderService.confirmOrder(orderId);
} catch (error) {
    console.log('Error');
}
```

- Don't skip error handling or use silent failures
- Implement comprehensive error handling with meaningful messages
- Reference specifications in code comments (see `/openspec`)
