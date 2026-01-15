# Delta for Customer Specification

## ADDED Requirements

### Requirement: Loyalty Points Earning

The system SHALL award loyalty points when orders are delivered.

#### Scenario: Points earned on delivery
- WHEN an order is delivered
- AND order total is at least $5.00
- THEN 1 point per dollar is awarded to customer
- AND points are capped at 500 per order

#### Scenario: No points on discounted portion
- WHEN points are redeemed on an order
- THEN no new points are earned on the discounted amount

### Requirement: Loyalty Points Redemption

The system SHALL allow customers to redeem points for discounts.

#### Scenario: Valid redemption
- WHEN a customer redeems points at checkout
- AND redemption is at least 100 points
- AND redemption does not exceed 50% of order total
- THEN order total is reduced by point value (1 point = $0.01)

#### Scenario: Minimum redemption not met
- WHEN a customer attempts to redeem fewer than 100 points
- THEN redemption is rejected with guidance

### Requirement: Loyalty Points Expiration

The system MUST expire unused points after 12 months.

#### Scenario: Point expiration
- WHEN points are 12 months old
- THEN they are automatically expired at midnight UTC
- AND customer is notified

#### Scenario: Expiration warning
- WHEN points will expire within 30 days
- THEN customer receives notification

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
