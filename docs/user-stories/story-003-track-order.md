# User Story: Track Order Status

**ID:** STORY-003

**Status:** Planned

**Priority:** Medium

---

## User Story Statement

As a **customer**, I want to **track the status of my order**, so that I **know when to expect delivery**.

---

## Acceptance Criteria

- [ ] Customer can view all their orders
- [ ] Each order displays current status (pending, confirmed, shipped, delivered)
- [ ] Order detail page shows items, quantities, prices, and total
- [ ] Order detail page shows order date and estimated delivery date
- [ ] Customer receives email notifications on status changes
- [ ] Order status updates are real-time (or near real-time)
- [ ] Customer can view order history (past orders)

---

## Related Entities

- [Customer](../architecture/models/domain/customer.md) — Customer viewing orders
- [Order](../architecture/models/domain/order.md) — Order status tracked

---

## Related Requirements

- **FR-005:** View order history and status ([Requirements](../requirements.md))

---

## Business Rules

- Customers can only view their own orders
- Order history is sorted by order date descending (most recent first)
- Status updates should be reflected within 60 seconds of the change occurring

---

## Acceptance Tests

```gherkin
Scenario: Customer views their order list
  Given I am logged in as a customer
  When I navigate to my orders page
  Then I see a list of my orders sorted by date descending

Scenario: Customer views order details
  Given I am logged in as a customer
  And order "order-123" belongs to me
  When I view the details of order "order-123"
  Then I see the items, quantities, prices, and total
  And I see the current status and estimated delivery date

Scenario: Customer cannot view another customer's order
  Given I am logged in as customer A
  When I try to access an order belonging to customer B
  Then I receive a 403 Forbidden response
```

---

## Related User Stories

- [STORY-002: Place Order](story-002-place-order.md) — Order creation

---

## API Endpoints

### `GET /customers/{customerId}/orders`

**Response:**
```json
{
  "orders": [
    {
      "order_id": "order-123",
      "status": "shipped",
      "order_date": "2026-01-10T14:00:00Z",
      "total_amount": 2629.97,
      "item_count": 3
    },
    {
      "order_id": "order-456",
      "status": "delivered",
      "order_date": "2026-01-05T10:30:00Z",
      "total_amount": 149.99,
      "item_count": 1
    }
  ]
}
```

### `GET /orders/{orderId}`

**Response:**
```json
{
  "order_id": "order-123",
  "status": "shipped",
  "order_date": "2026-01-10T14:00:00Z",
  "estimated_delivery": "2026-01-15",
  "items": [
    {
      "product_name": "Laptop",
      "quantity": 2,
      "unit_price": 1299.99,
      "line_total": 2599.98
    }
  ],
  "total_amount": 2629.97,
  "shipping_address": "123 Main St, City, State 12345"
}
```

---

## Definition of Done

- [ ] API endpoints implemented
- [ ] UI for order list and details
- [ ] Email notifications on status changes
- [ ] Tests pass

---

**Related:** [Place Order](story-002-place-order.md) — Order creation
