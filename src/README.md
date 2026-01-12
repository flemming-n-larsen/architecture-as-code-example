# Source Code Placeholder

This folder would contain the actual application source code.

## Recommended Structure

```
src/
├── controllers/
│   ├── customerController.ts
│   ├── orderController.ts
│   ├── productController.ts
│   └── paymentController.ts
├── models/
│   ├── Customer.ts
│   ├── Order.ts
│   ├── OrderItem.ts
│   ├── Product.ts
│   └── Payment.ts
├── services/
│   ├── orderService.ts
│   ├── paymentService.ts
│   └── inventoryService.ts
├── routes/
│   ├── customerRoutes.ts
│   ├── orderRoutes.ts
│   └── productRoutes.ts
├── database/
│   ├── connection.ts
│   └── migrations/
└── index.ts
```

## Key Principle

**Source code and documentation live together** in the same repository. When code changes, update the relevant documentation in `docs/` in the same commit.

Example commit:
```
feat: add customer tier system

- Add tier field to Customer model
- Update docs/architecture/domain/customer.md with tier diagram
- Update order calculation to apply tier discounts
```

This ensures documentation never gets out of sync with implementation!

