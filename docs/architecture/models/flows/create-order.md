# Create Order Flow

This flow describes how customers create orders in the system.

## Overview

When a customer places an order:
1. Client sends order request with customer ID and items
2. System validates customer exists and products are in stock
3. System creates order and order items in a transaction
4. System reduces product inventory atomically
5. System initiates payment processing
6. System commits transaction and returns order confirmation

## Sequence Diagram

```mermaid
sequenceDiagram
    participant Client
    participant OrderService
    participant ProductService
    participant PaymentService
    participant Database

    Client ->> OrderService: POST /orders<br/>{customer_id, items[]}

    Note over OrderService: Validate request

    OrderService ->> ProductService: GET /products/check-stock<br/>{product_ids[]}
    ProductService ->> Database: SELECT * FROM products<br/>WHERE id IN (...)
    Database -->> ProductService: Product data
    
    alt Stock available
        ProductService -->> OrderService: ✓ Stock OK
    else Insufficient stock
        ProductService -->> OrderService: ✗ Out of stock
        OrderService -->> Client: 400 Bad Request<br/>{error: "Insufficient stock"}
    end

    OrderService ->> Database: BEGIN TRANSACTION
    Database -->> OrderService: Transaction started

    OrderService ->> Database: INSERT INTO orders<br/>(customer_id, order_date, total_amount, status)
    Database -->> OrderService: order_id = uuid-123

    loop For each item
        OrderService ->> Database: INSERT INTO order_items<br/>(order_id, product_id, quantity, unit_price)
        Database -->> OrderService: Item inserted
    end

    OrderService ->> ProductService: PATCH /products/reduce-stock<br/>{product_id, quantity}
    
    ProductService ->> Database: UPDATE products<br/>SET stock_quantity = stock_quantity - $quantity<br/>WHERE id = $product_id<br/>AND stock_quantity >= $quantity
    
    alt Stock reduced successfully
        Database -->> ProductService: 1 row updated
        ProductService -->> OrderService: ✓ Stock updated
    else Concurrent order depleted stock
        Database -->> ProductService: 0 rows updated
        ProductService -->> OrderService: ✗ Insufficient stock
        OrderService ->> Database: ROLLBACK
        OrderService -->> Client: 400 Bad Request<br/>{error: "Stock depleted"}
    end

    OrderService ->> PaymentService: POST /payments<br/>{order_id, amount}
    PaymentService ->> PaymentService: Process with Stripe
    
    alt Payment successful
        PaymentService ->> Database: INSERT INTO payments<br/>(order_id, amount, status='successful')
        Database -->> PaymentService: Payment recorded
        PaymentService -->> OrderService: ✓ Payment successful
        
        OrderService ->> Database: UPDATE orders<br/>SET status = 'confirmed'
        OrderService ->> Database: COMMIT TRANSACTION
        Database -->> OrderService: Transaction committed
        
        OrderService ->> Database: SELECT * FROM orders<br/>WHERE id = uuid-123
        Database -->> OrderService: Full order data
        
        OrderService -->> Client: 201 Created<br/>{order_id, status, items[], total}
    else Payment failed
        PaymentService ->> Database: INSERT INTO payments<br/>(order_id, amount, status='failed')
        PaymentService -->> OrderService: ✗ Payment failed
        
        OrderService ->> Database: ROLLBACK TRANSACTION
        Database -->> OrderService: Transaction rolled back
        
        OrderService -->> Client: 402 Payment Required<br/>{error: "Payment failed"}
    end
```

## Step-by-Step Description

### 1. Validate Request
- Ensure customer_id exists
- Ensure items array is not empty
- Validate each item has product_id, quantity

### 2. Check Stock Availability
- Query all products in the order
- Verify each product has sufficient stock
- Return error immediately if any product is out of stock

### 3. Begin Database Transaction
- Start ACID transaction to ensure atomicity
- All subsequent operations are part of this transaction

### 4. Create Order Record
- Insert order with status "pending"
- Calculate total_amount from items
- Record order_date timestamp

### 5. Create Order Items
- Insert one record per item
- Capture current unit_price (may differ from current product price)
- Link each item to the order

### 6. Reduce Product Stock
- Update stock_quantity atomically
- Use WHERE clause to ensure sufficient stock still exists
- Handle race conditions with concurrent orders

### 7. Process Payment
- Create payment record
- Call external payment gateway (Stripe)
- Record gateway_transaction_id

### 8. Finalize Order
- If payment successful:
  - Update order status to "confirmed"
  - Commit transaction
  - Return order confirmation
- If payment failed:
  - Rollback entire transaction
  - Restore inventory
  - Return payment error

## Error Handling

### Insufficient Stock (Before Transaction)
```json
{
  "error": "Insufficient stock",
  "details": [
    {
      "product_id": "uuid-abc",
      "product_name": "Laptop",
      "requested": 5,
      "available": 2
    }
  ]
}
```

**Response:** `400 Bad Request`

### Stock Depleted During Transaction
Race condition where another order consumed stock while this order was processing.

**Resolution:**
- Rollback transaction
- Restore all changes
- Return error to client
- Client can retry

**Response:** `400 Bad Request`

### Payment Failure
```json
{
  "error": "Payment failed",
  "reason": "Insufficient funds",
  "order_id": "uuid-123",
  "retry_allowed": true
}
```

**Response:** `402 Payment Required`

**Resolution:**
- Transaction rolled back
- Inventory restored
- Customer can retry with different payment method

### Database Timeout
- Transaction automatically rolled back
- Client receives `503 Service Unavailable`
- Client should retry after delay

## Concurrency Control

### Preventing Overselling

Use database row-level locking:

```sql
UPDATE products
SET stock_quantity = stock_quantity - $1
WHERE id = $2
  AND stock_quantity >= $1;  -- Atomic check-and-update
```

If `UPDATE` returns 0 rows, stock was insufficient.

### Alternative: Pessimistic Locking

```sql
BEGIN TRANSACTION;

SELECT stock_quantity 
FROM products 
WHERE id = $1 
FOR UPDATE;  -- Lock row until transaction completes

-- Check stock manually
-- Update if sufficient
-- Create order item

COMMIT;
```

## Performance Considerations

### Database Indexes
```sql
CREATE INDEX idx_products_id ON products(id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

### Response Time Targets
- Stock check: < 100ms
- Order creation: < 500ms
- Payment processing: < 2s
- Total end-to-end: < 3s (p99)

### Optimization Strategies
- Batch stock checks in single query
- Use connection pooling for database
- Cache product data (invalidate on stock updates)
- Async payment confirmation (optional)

## Related Entities

- [Customer](../domain/customer.md) — Places the order
- [Order](../domain/order.md) — Entity created by this flow
- [OrderItem](../domain/order-item.md) — Items added to order
- [Product](../domain/product.md) — Stock checked and updated
- [Payment](../domain/payment.md) — Payment processed

## Related Flows

- [Payment Processing Flow](payment-processing.md) — Detailed payment steps
- [Inventory Management Flow](inventory-management.md) — Stock tracking

## Related Requirements

- **FR-004:** Place orders ([Requirements](../../requirements.md))
- **FR-011:** Prevent overselling ([Requirements](../../requirements.md))
- **FR-012:** Atomic inventory updates ([Requirements](../../requirements.md))
- **NFR-001:** Order creation performance ([Requirements](../../requirements.md))
- **NFR-006:** ACID transactions ([Requirements](../../requirements.md))

## Related User Stories

- [Place Order](../../user-stories/story-002-place-order.md)

## Testing Scenarios

### Happy Path
1. Customer has valid account
2. All products in stock
3. Payment successful
4. Order confirmed

### Concurrent Orders
1. Two customers order same product simultaneously
2. Only sufficient stock for one order
3. First order succeeds
4. Second order fails with "insufficient stock"

### Payment Failure
1. Order created successfully
2. Payment fails (insufficient funds)
3. Transaction rolled back
4. Inventory restored
5. Customer can retry

---

**Next:** See [Payment Processing Flow](payment-processing.md) for detailed payment handling.

