# Inventory Management Flow

This flow describes how product inventory is tracked and updated across the system.

## Overview

Inventory management ensures:
- Real-time stock tracking
- Prevention of overselling
- Atomic stock updates with orders
- Inventory replenishment workflows

## Actors

- **Order Service** — Reduces stock when orders are placed
- **Product Service** — Manages product catalog and stock levels
- **Admin Users** — Restock inventory and adjust quantities
- **Inventory Service** (optional) — Dedicated service for complex inventory operations

## Stock Update Flow (Order Placement)

```mermaid
sequenceDiagram
    participant OrderService
    participant ProductService
    participant Database
    participant InventoryAlert

    OrderService ->> ProductService: PATCH /products/{id}/reduce-stock<br/>{quantity: 3}
    
    ProductService ->> Database: BEGIN TRANSACTION
    Database -->> ProductService: Transaction started
    
    ProductService ->> Database: SELECT stock_quantity<br/>FROM products<br/>WHERE id = $1<br/>FOR UPDATE
    Database -->> ProductService: current_stock = 25
    
    alt Sufficient stock
        ProductService ->> Database: UPDATE products<br/>SET stock_quantity = 22,<br/>updated_at = NOW()<br/>WHERE id = $1
        Database -->> ProductService: 1 row updated
        
        ProductService ->> Database: INSERT INTO stock_movements<br/>(product_id, delta, reason, reference_id)
        Database -->> ProductService: Movement logged
        
        ProductService ->> Database: COMMIT
        Database -->> ProductService: Transaction committed
        
        alt Stock now low (< 10)
            ProductService ->> InventoryAlert: Low stock alert<br/>{product_id, current_stock: 22}
            InventoryAlert -->> ProductService: Alert sent
        end
        
        ProductService -->> OrderService: ✓ Stock reduced<br/>{new_quantity: 22}
        
    else Insufficient stock
        ProductService ->> Database: ROLLBACK
        Database -->> ProductService: Transaction rolled back
        
        ProductService -->> OrderService: ✗ Insufficient stock<br/>{available: 25, requested: 30}
    end
```

## Stock Replenishment Flow

```mermaid
sequenceDiagram
    participant Admin
    participant ProductService
    participant Database
    participant InventoryAlert

    Admin ->> ProductService: PATCH /products/{id}/add-stock<br/>{quantity: 100, reason: "Restock"}
    
    ProductService ->> Database: BEGIN TRANSACTION
    Database -->> ProductService: Transaction started
    
    ProductService ->> Database: UPDATE products<br/>SET stock_quantity = stock_quantity + 100,<br/>updated_at = NOW()<br/>WHERE id = $1
    Database -->> ProductService: 1 row updated
    
    ProductService ->> Database: INSERT INTO stock_movements<br/>(product_id, delta: +100, reason: "Restock")
    Database -->> ProductService: Movement logged
    
    ProductService ->> Database: COMMIT
    Database -->> ProductService: Transaction committed
    
    ProductService ->> InventoryAlert: Stock replenished notification<br/>{product_id, new_quantity: 125}
    InventoryAlert -->> ProductService: ✓ Notification sent
    
    ProductService -->> Admin: ✓ Stock added<br/>{new_quantity: 125}
```

## Inventory Audit Flow

```mermaid
sequenceDiagram
    participant Admin
    participant ProductService
    participant Database

    Admin ->> ProductService: PATCH /products/{id}/adjust-stock<br/>{actual_quantity: 18, reason: "Physical count"}
    
    Note over ProductService: Physical inventory count<br/>differs from system quantity
    
    ProductService ->> Database: BEGIN TRANSACTION
    Database -->> ProductService: Transaction started
    
    ProductService ->> Database: SELECT stock_quantity<br/>FROM products<br/>WHERE id = $1
    Database -->> ProductService: system_quantity = 20
    
    ProductService ->> ProductService: Calculate delta<br/>delta = 18 - 20 = -2
    
    ProductService ->> Database: UPDATE products<br/>SET stock_quantity = 18,<br/>updated_at = NOW()<br/>WHERE id = $1
    Database -->> ProductService: 1 row updated
    
    ProductService ->> Database: INSERT INTO stock_movements<br/>(product_id, delta: -2,<br/>reason: "Physical count adjustment")
    Database -->> ProductService: Movement logged
    
    ProductService ->> Database: COMMIT
    Database -->> ProductService: Transaction committed
    
    ProductService -->> Admin: ✓ Stock adjusted<br/>{old: 20, new: 18, delta: -2}
```

## Stock Movement Tracking

All stock changes are logged in a `stock_movements` table for audit trail:

```mermaid
erDiagram
    PRODUCT ||--o{ STOCK_MOVEMENT : has
    
    PRODUCT {
        uuid id PK
        string name
        int stock_quantity
    }
    
    STOCK_MOVEMENT {
        uuid id PK
        uuid product_id FK
        int delta
        string reason
        uuid reference_id
        datetime created_at
    }
```

### Stock Movement Reasons

| Reason | Delta | Description |
|--------|-------|-------------|
| `order_placed` | Negative | Stock reduced for order |
| `order_cancelled` | Positive | Stock restored after cancellation |
| `restock` | Positive | New inventory received |
| `adjustment` | +/- | Physical count correction |
| `damage` | Negative | Damaged goods removed |
| `return` | Positive | Customer return |

## Concurrency Control

### Pessimistic Locking (Recommended)

```sql
BEGIN TRANSACTION;

-- Lock the product row
SELECT stock_quantity 
FROM products 
WHERE id = $1 
FOR UPDATE;

-- Check if sufficient stock
IF stock_quantity >= $requested_quantity THEN
    UPDATE products 
    SET stock_quantity = stock_quantity - $requested_quantity
    WHERE id = $1;
    
    INSERT INTO stock_movements (product_id, delta, reason)
    VALUES ($1, -$requested_quantity, 'order_placed');
    
    COMMIT;
ELSE
    ROLLBACK;
    RETURN 'Insufficient stock';
END IF;
```

### Benefits
- Prevents race conditions
- Guarantees no overselling
- Simple to reason about

### Trade-offs
- Row is locked during transaction
- Reduces concurrency for popular products
- Acceptable for most e-commerce scenarios

## Low Stock Alerts

```mermaid
stateDiagram-v2
    [*] --> InStock: stock > 10
    InStock --> LowStock: stock ≤ 10
    LowStock --> OutOfStock: stock = 0
    OutOfStock --> LowStock: Restocked (stock ≤ 10)
    OutOfStock --> InStock: Restocked (stock > 10)
    LowStock --> InStock: Restocked (stock > 10)
    
    note right of LowStock: Send alert to admin
    note right of OutOfStock: Hide from catalog<br/>Send urgent alert
```

### Alert Thresholds
- **Low Stock:** stock_quantity ≤ 10 → Email admin
- **Out of Stock:** stock_quantity = 0 → Urgent notification + hide from catalog
- **Restocked:** stock_quantity increases → Confirm notification

## Inventory Report Example

```mermaid
graph TD
    A[Inventory Report] --> B[Total Products: 150]
    A --> C[In Stock: 120]
    A --> D[Low Stock: 25]
    A --> E[Out of Stock: 5]
    
    D --> F[Products with stock ≤ 10<br/>Requires attention]
    E --> G[Products with stock = 0<br/>Urgent restock needed]
```

## Business Rules

### Minimum Stock Levels
- Products should maintain minimum 10 units (safety stock)
- Alert sent when stock falls below threshold
- Automatic reorder system (future enhancement)

### Maximum Stock Levels
- No hard limit on stock_quantity
- Consider warehouse capacity in practice
- Monitor slow-moving inventory (>90 days without sale)

### Stock Reservations (Advanced)
For high-demand products, consider temporary reservations:

```mermaid
sequenceDiagram
    participant Customer
    participant OrderService
    participant ProductService
    
    Customer ->> OrderService: Add to cart
    OrderService ->> ProductService: Reserve stock (15 min)
    ProductService -->> OrderService: ✓ Reserved
    
    alt Customer completes checkout
        OrderService ->> ProductService: Confirm reservation
        ProductService -->> OrderService: ✓ Stock reduced
    else 15 minutes expire
        ProductService ->> ProductService: Release reservation
        Note over ProductService: Stock available again
    end
```

## Error Handling

### Negative Stock Attempt
```sql
UPDATE products
SET stock_quantity = stock_quantity - $1
WHERE id = $2
  AND stock_quantity >= $1;  -- Prevents negative stock
```

If UPDATE affects 0 rows, insufficient stock.

### Concurrent Updates
Database transaction isolation ensures:
- One order at a time can modify a product's stock
- Serializable operations
- No lost updates

### Stale Data
- Use optimistic locking with version column (alternative approach)
- Refresh stock data before display
- Cache invalidation on stock updates

## Performance Optimization

### Caching Strategy
```
Product stock (high-traffic products):
- Cache TTL: 5 seconds
- Invalidate on stock update
- Acceptable slight staleness for read-heavy operations
```

### Database Indexes
```sql
CREATE INDEX idx_products_stock ON products(stock_quantity) 
WHERE stock_quantity <= 10;  -- Partial index for low-stock queries

CREATE INDEX idx_stock_movements_product ON stock_movements(product_id, created_at DESC);
```

### Monitoring Queries
```sql
-- Low stock products
SELECT id, name, stock_quantity 
FROM products 
WHERE stock_quantity <= 10 
ORDER BY stock_quantity ASC;

-- Out of stock products
SELECT id, name 
FROM products 
WHERE stock_quantity = 0;

-- Stock movement history for product
SELECT * 
FROM stock_movements 
WHERE product_id = $1 
ORDER BY created_at DESC 
LIMIT 50;
```

## Related Entities

- [Product](../domain/product.md) — Products with tracked inventory
- [Order](../domain/order.md) — Orders that reduce stock
- [OrderItem](../domain/order-item.md) — Items that reference products

## Related Flows

- [Create Order Flow](create-order.md) — Reduces stock when order is placed

## Related Requirements

- **FR-010:** Track stock levels ([Requirements](../../requirements.md))
- **FR-011:** Prevent overselling ([Requirements](../../requirements.md))
- **FR-012:** Atomic inventory updates ([Requirements](../../requirements.md))

## Related User Stories

- [Manage Inventory](../../user-stories/story-004-manage-inventory.md)
- [Place Order](../../user-stories/story-002-place-order.md)

## Testing Scenarios

### Concurrent Stock Reduction
1. Two orders placed simultaneously for same product
2. Product has stock = 5
3. Each order requests 3 units
4. First order succeeds (stock → 2)
5. Second order fails (insufficient stock)

### Stock Movement Audit
1. Product starts with stock = 100
2. Order placed: -5 (stock = 95)
3. Order cancelled: +5 (stock = 100)
4. Restock: +50 (stock = 150)
5. Physical count adjustment: -2 (stock = 148)
6. All movements logged in stock_movements table

---

**Related:** See [Create Order Flow](create-order.md) for how inventory updates fit into order creation.

