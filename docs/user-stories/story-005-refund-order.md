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

- [Order](../architecture/domain/order.md) — Order being refunded
- [Payment](../architecture/domain/payment.md) — Payment refunded

---

## Related Flows

- [Payment Processing Flow](../architecture/flows/payment-processing.md) — Refund handling

---

## Related Requirements

- **FR-009:** Receipt generation ([Requirements](../requirements.md))

---

## Definition of Done

- [ ] Admin UI for refunds
- [ ] Stripe refund integration
- [ ] Notification emails
- [ ] Tests pass

---

**Related:** [Place Order](story-002-place-order.md) — Original order

