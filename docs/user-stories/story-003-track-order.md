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

- [Customer](../architecture/domain/customer.md) — Customer viewing orders
- [Order](../architecture/domain/order.md) — Order status tracked

---

## Related Requirements

- **FR-005:** View order history and status ([Requirements](../requirements.md))

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
