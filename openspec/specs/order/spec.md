# Order Specification

**Domain:** Order Management  
**Last Updated:** 2026-01-15

## Purpose

Order management for the e-commerce platform, handling purchase transactions with full lifecycle management.

## Requirements

### Requirement: Order Creation

The system SHALL validate all order creation requests before processing.

#### Scenario: Valid order creation
- WHEN a customer submits a valid order
- THEN the order is created in pending state
- AND inventory is checked for availability

#### Scenario: Invalid product
- WHEN a customer orders a non-existent or inactive product
- THEN the order is rejected with an error message

### Requirement: Order State Machine

The system SHALL enforce the following state transitions: pending → confirmed → shipped → delivered.

#### Scenario: Order confirmation
- WHEN an order is in pending state
- AND payment is authorized
- AND inventory is available
- THEN the order transitions to confirmed state

#### Scenario: Order shipment
- WHEN an order is in confirmed state
- AND items are picked and packed
- THEN the order transitions to shipped state

#### Scenario: Order delivery
- WHEN an order is in shipped state
- AND carrier confirms delivery
- THEN the order transitions to delivered state
- AND loyalty points are awarded (if loyalty system is active)

### Requirement: Order Cancellation

The system MUST enforce cancellation rules based on order state.

#### Scenario: Cancel pending order
- WHEN a pending order is cancelled
- THEN no payment refund is needed
- AND the order is marked cancelled

#### Scenario: Cancel confirmed order
- WHEN a confirmed order is cancelled
- THEN payment MUST be refunded
- AND reserved inventory is released

#### Scenario: Cancel shipped order
- WHEN a shipped order cancellation is requested
- THEN the cancellation is rejected
- AND customer is directed to return process

## Business Rules

### Order Total Validation
- Order total must be at least $5.00 (minimum order value)
- Order total cannot exceed $50,000 (fraud prevention)
- Tax calculation must be applied based on shipping address
- Shipping cost must be calculated based on weight and destination

### Inventory Management
- Stock validation occurs at order creation
- Inventory is reserved when order moves to confirmed
- Reserved inventory is released if order is cancelled
- Out-of-stock items prevent order confirmation

### Price Consistency
- Order item prices must match current product catalog prices
- Price changes after order creation do not affect existing orders

## Related Entities

- **Order**: Main order entity with state machine
- **OrderItem**: Individual line items within orders
- **Product**: Catalog items being ordered
- **Customer**: Customer placing the order
- **Payment**: Payment transactions for the order
