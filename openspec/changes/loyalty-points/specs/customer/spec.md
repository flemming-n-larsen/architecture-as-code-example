# Delta for Customer Specification

## ADDED Requirements

### Requirement: Loyalty Points Earning

The system SHALL award loyalty points when orders are delivered.

#### Scenario: Points earned on delivery `[LP-001]`

**Test:** Unit, Integration

- **GIVEN** an order has been marked as delivered
- **WHEN** the order total is at least $5.00
- **THEN** 1 point per dollar is awarded to the customer
- **AND** points are capped at 500 per order

#### Scenario: Minimum order not met — no points awarded `[LP-002]`

**Test:** Unit

- **GIVEN** an order has been marked as delivered
- **WHEN** the order total is less than $5.00
- **THEN** no loyalty points are awarded

#### Scenario: No points on discounted portion `[LP-003]`

**Test:** Unit

- **GIVEN** a customer redeems points on an order
- **WHEN** the order is delivered
- **THEN** no new points are earned on the discounted amount

### Requirement: Loyalty Points Redemption

The system SHALL allow customers to redeem points for discounts.

#### Scenario: Valid redemption `[LP-004]`

**Test:** Unit, Integration

- **GIVEN** a customer has at least 100 points
- **WHEN** the customer redeems points at checkout
- **AND** the redemption amount does not exceed 50% of the order total
- **THEN** the order total is reduced by the point value (1 point = $0.01)

#### Scenario: Minimum redemption not met `[LP-005]`

**Test:** Unit

- **GIVEN** a customer attempts to redeem fewer than 100 points at checkout
- **WHEN** the redemption request is submitted
- **THEN** the redemption is rejected
- **AND** the customer receives guidance on the minimum required

#### Scenario: Redemption exceeds 50% of order total `[LP-006]`

**Test:** Unit

- **GIVEN** a customer attempts to redeem points worth more than 50% of the order total
- **WHEN** the redemption request is submitted
- **THEN** the redemption is rejected with an appropriate error

### Requirement: Loyalty Points Expiration

The system MUST expire unused points after 12 months.

#### Scenario: Points expired after 12 months `[LP-007]`

**Test:** Integration

- **GIVEN** a loyalty points record with an expiration date 12 months after earning
- **WHEN** the expiration job runs at midnight UTC after the expiration date
- **THEN** the points are marked as expired
- **AND** the customer's point balance is reduced accordingly

#### Scenario: Points not expired before 12 months `[LP-008]`

**Test:** Unit

- **GIVEN** a loyalty points record earned 11 months and 30 days ago
- **WHEN** the expiration job runs at midnight UTC
- **THEN** the points remain valid and are NOT expired

#### Scenario: Expiration warning sent 30 days before expiry `[LP-009]`

**Test:** Integration

- **GIVEN** a customer has points expiring within 30 days
- **WHEN** the daily expiration warning job runs
- **THEN** the customer receives a notification about the upcoming expiration

## ADDED Entity: LoyaltyPoints

```
LoyaltyPoints {
  id: uuid (PK)
  customerId: uuid (FK -> Customer.id)
  orderId: uuid (FK -> Order.id, nullable)
  pointsEarned: integer (positive for earned, negative for redeemed)
  transactionType: enum ['EARNED', 'REDEEMED', 'EXPIRED', 'REFUND_ADJUSTMENT']
  expirationDate: datetime (nullable, only for EARNED points)
  createdAt: datetime
  description: string
}
```

## MODIFIED Entity: Customer

```
Customer {
  // ...existing fields...
  currentPointBalance: integer (computed field)
  totalPointsEarned: integer (lifetime total)
  totalPointsRedeemed: integer (lifetime total)
}
```

## MODIFIED Entity: Order

```
Order {
  // ...existing fields...
  pointsEarned: integer (calculated at delivery)
  pointsRedeemed: integer (applied at checkout)
  pointsDiscountAmount: decimal (dollar value of redeemed points)
}
```
