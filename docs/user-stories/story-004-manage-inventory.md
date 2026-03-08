# User Story: Manage Inventory

**ID:** STORY-004

**Status:** Planned

**Priority:** High

---

## User Story Statement

As an **admin**, I want to **manage product inventory**, so that I can **keep stock levels accurate and prevent overselling**.

---

## Acceptance Criteria

- [ ] Admin can view current stock levels for all products
- [ ] Admin can add stock when new inventory arrives
- [ ] Admin can adjust stock after physical inventory counts
- [ ] Admin can view stock movement history for each product
- [ ] System sends alerts when stock falls below threshold (< 10 units)
- [ ] System prevents stock from going negative
- [ ] All stock changes are logged for audit

---

## Related Entities

- [Product](../architecture/models/domain/product.md) — Product inventory managed

---

## Related Flows

- [Inventory Management Flow](../architecture/models/flows/inventory-management.md) — Stock tracking

---

## Related Requirements

- **FR-010:** Track stock levels ([Requirements](../requirements.md))
- **FR-011:** Prevent overselling ([Requirements](../requirements.md))

---

## Business Rules

- Stock quantity can never go below zero
- Low-stock alert threshold is 10 units (configurable per product)
- All stock adjustments must be logged with reason and actor
- Only admins with inventory management permissions can modify stock levels

---

## Acceptance Tests

```gherkin
Scenario: Admin views current stock levels
  Given I am logged in as an admin
  When I navigate to the inventory management page
  Then I see all products with their current stock levels

Scenario: Admin adds stock for a product
  Given I am logged in as an admin
  And product "Laptop" has 5 units in stock
  When I add 20 units to product "Laptop"
  Then product "Laptop" shows 25 units in stock
  And a stock movement record is created

Scenario: System sends low-stock alert
  Given product "Mouse" has 12 units in stock
  When 3 units are sold
  Then an alert is triggered for product "Mouse" (9 units remaining < threshold)

Scenario: Stock cannot go negative
  Given product "Keyboard" has 2 units in stock
  When an order requests 3 units of "Keyboard"
  Then the order is rejected with "insufficient stock" error
```

---

## Related User Stories

- [STORY-002: Place Order](story-002-place-order.md) — Stock reduced on order
- [STORY-005: Refund Order](story-005-refund-order.md) — Stock restored on refund (if applicable)

---

## Definition of Done

- [ ] Admin UI for inventory management
- [ ] Stock alerts implemented
- [ ] Audit log working
- [ ] Tests pass


