# Change Proposal: Customer Loyalty Points System

**Status:** Active  
**Created:** 2026-01-15  
**Author:** Development Team

## Summary

Add a customer loyalty points system to the existing e-commerce platform. Customers earn points for purchases and can redeem them for discounts on future orders.

## Motivation

Increase customer retention and encourage repeat purchases by rewarding loyal customers with redeemable points.

## Requirements

### Core Functionality
- Customers earn 1 point per dollar spent on confirmed orders
- Points can be redeemed for order discounts (1 point = $0.01 discount)
- Points expire 12 months after earning date
- Points are awarded only when order status reaches "delivered"
- Points are deducted immediately when redeemed during checkout

### Business Rules

#### Point Earning
- Points are calculated on order total after taxes and shipping
- Points are NOT earned on discounted amounts (if points were used)
- Points are awarded per order completion, not per payment
- Minimum order value for point earning: $5.00
- Maximum points per order: 500 points

#### Point Redemption
- Minimum redemption: 100 points ($1.00 discount)
- Maximum redemption per order: 50% of order total
- Points must be redeemed at checkout, not retroactively
- Partial point redemption is allowed
- Redeemed points cannot be refunded if order is cancelled

#### Point Expiration
- Points expire exactly 12 months after earning date
- Expiration occurs daily at midnight UTC
- Customers are notified 30 days before expiration
- Expired points cannot be recovered

### Edge Cases

#### Refunds and Returns
- If a delivered order is returned/refunded, earned points are deducted
- If customer has insufficient points for deduction, account goes negative
- Negative point balances must be resolved before earning new points
- Redeemed points on returned orders are restored to customer

#### Account Management
- Points are transferred if customer accounts are merged
- Points are permanently lost if account is deleted
- Suspended accounts cannot earn or redeem points

## Spec Updates

See `specs/customer/spec.md` for the delta showing additions to the Customer specification.
