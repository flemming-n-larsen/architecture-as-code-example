# User Story: Refund Order

**ID:** STORY-005

**Status:** Planned

**Priority:** Low

---

## User Story Statement

As an **admin**, I want to **issue refunds for orders**, so that I can **handle returns and customer complaints**.

---

## Acceptance Criteria

- [ ] Admin can search for orders by order ID or customer email
- [ ] Admin can issue full or partial refunds
- [ ] Refunds are processed through payment gateway (Stripe)
- [ ] Customer receives refund confirmation email
- [ ] Refunded orders update status appropriately
- [ ] Refunds appear in financial reports

---

## Related Entities

- [Order](../architecture/models/domain/order.md) — Order being refunded
- [Payment](../architecture/models/domain/payment.md) — Payment refunded

---

## Related Flows

- [Payment Processing Flow](../architecture/models/flows/payment-processing.md) — Refund handling

---

## Related Requirements

- **FR-009:** Receipt generation ([Requirements](../requirements.md))

---

## Business Rules

- Refunds are only allowed for orders in `confirmed`, `shipped`, or `delivered` status
- Partial refunds cannot exceed the original order total
- Refunds are processed through the same payment gateway used for the original transaction
- Refund requests must be logged with the initiating admin's ID and reason

---

## Acceptance Tests

```gherkin
Scenario: Admin issues a full refund
  Given I am logged in as an admin
  And order "order-123" has status "delivered" and payment "successful"
  When I issue a full refund for order "order-123"
  Then the payment status is updated to "refunded"
  And the customer receives a refund confirmation email

Scenario: Admin issues a partial refund
  Given I am logged in as an admin
  And order "order-456" has a total of 100.00
  When I issue a partial refund of 40.00 for order "order-456"
  Then a refund of 40.00 is processed through Stripe
  And the customer is notified of the partial refund

Scenario: Refund rejected for pending order
  Given order "order-789" has status "pending"
  When I try to issue a refund for order "order-789"
  Then the refund is rejected with "order not eligible for refund"
```

---

## Related User Stories

- [STORY-002: Place Order](story-002-place-order.md) — Original order

---

## Definition of Done

- [ ] Admin UI for refunds
- [ ] Stripe refund integration
- [ ] Notification emails
- [ ] Tests pass


