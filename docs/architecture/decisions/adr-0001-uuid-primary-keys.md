# ADR-0001: Use UUIDs for Primary Keys

**Status:** Accepted

**Date:** 2026-01-12

**Decision Makers:** Architecture Team

---

## Context

We need to choose a primary key strategy for all database tables in our e-commerce system. The system will be distributed with multiple services, and we plan to support:

- Horizontal scaling of services
- Multi-region deployment in the future
- Database sharding/partitioning
- Data import/export between environments

### Options Considered

1. **Auto-incrementing integers** (e.g., SERIAL in PostgreSQL)
2. **UUIDs (Universally Unique Identifiers)**
3. **ULID (Universally Unique Lexicographically Sortable Identifier)**
4. **Snowflake IDs** (Twitter-style distributed IDs)

---

## Decision

We will use **UUIDs (version 4)** for all primary keys across all tables.

---

## Rationale

### Advantages of UUIDs

#### 1. **Distributed ID Generation**
- IDs can be generated anywhere (application, database, client)
- No need for central coordination or database round-trip
- Critical for microservices architecture

#### 2. **Merge and Import Safety**
- No ID collisions when merging data from different environments
- Safe to import/export data between dev/staging/production
- Simplifies data migration and testing

#### 3. **Multi-Region Support**
- Multiple regions can generate IDs independently
- No cross-region coordination required
- Future-proofs for global expansion

#### 4. **Security Through Obscurity**
- Non-sequential IDs make enumeration attacks harder
- Can't guess next/previous ID
- User can't infer business metrics from ID values

#### 5. **No Database Dependency**
- IDs generated in application code
- Reduces database load
- Supports offline ID generation (future mobile apps)

### Disadvantages and Mitigations

#### 1. **Larger Storage Size**
- UUID: 16 bytes vs. INTEGER: 4 bytes
- **Mitigation:** Storage is cheap; query performance is acceptable for our scale (<1M products)
- Use appropriate indexes

#### 2. **Less Human-Readable**
```
UUID: 550e8400-e29b-41d4-a716-446655440000
INT:  12345
```
- **Mitigation:** 
  - Display friendly names/titles in UI
  - Use display IDs for customer-facing references (order numbers)
  - Keep UUIDs for internal references

#### 3. **Index Performance**
- Random UUIDs cause index fragmentation
- **Mitigation:**
  - Use UUID v7 (timestamp-based) for high-write tables (future optimization)
  - Current scale doesn't warrant this complexity
  - Benchmark before optimizing

#### 4. **Joins May Be Slower**
- Larger keys = slower joins (in theory)
- **Mitigation:**
  - Proper indexing
  - Query optimization
  - Our query patterns don't show performance issues at current scale

---

## Implementation

### Database Schema

```sql
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    -- other fields
);

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    -- other fields
);
```

### Application Code (TypeScript Example)

```typescript
import { v4 as uuidv4 } from 'uuid';

const newCustomer = {
    id: uuidv4(),  // Generate UUID in application
    email: 'user@example.com',
    name: 'John Doe'
};

await db.insert('customers', newCustomer);
```

### API Responses

```json
{
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "order_number": "ORD-1001",  // Friendly display ID
    "created_at": "2026-01-12T10:30:00Z"
}
```

---

## Alternatives Considered

### Auto-Incrementing Integers

**Pros:**
- Smaller storage (4 bytes)
- Human-readable
- Sequential = good index locality

**Cons:**
- Requires database coordination
- Collisions when merging data
- Exposes business metrics (order #12345 = 12,345 orders placed)
- Doesn't scale to distributed systems

**Decision:** Rejected due to distributed architecture requirements

---

### ULID

**Pros:**
- Lexicographically sortable (timestamp prefix)
- Better index performance than UUID v4
- URL-safe encoding

**Cons:**
- Less standard than UUID
- Fewer library support
- Timestamp component may leak information

**Decision:** Deferred; consider for future optimization if UUID v4 shows performance issues

---

### Snowflake IDs

**Pros:**
- Sortable by time
- Small (8 bytes)
- Distributed coordination

**Cons:**
- Requires centralized ID generator service
- Complexity not warranted at current scale
- Custom implementation required

**Decision:** Rejected; added complexity without clear benefit at our scale

---

## Consequences

### Positive

- ✅ Services can generate IDs independently
- ✅ No database round-trips for ID generation
- ✅ Safe data import/export between environments
- ✅ Future-proof for multi-region deployment
- ✅ Security improvement (non-sequential IDs)

### Negative

- ❌ Larger storage footprint (16 bytes vs. 4 bytes)
- ❌ Less human-readable in logs/debugging
- ❌ Slightly slower joins (in theory; not observed in practice)

### Neutral

- Developer familiarity: UUIDs are well-known
- Library support: Excellent across all languages/frameworks
- Monitoring: Need to track storage growth

---

## Related Decisions

- **ADR-0002 (future):** Database sharding strategy
- **ADR-0003 (future):** Multi-region deployment architecture

---

## References

- [PostgreSQL UUID Data Type](https://www.postgresql.org/docs/current/datatype-uuid.html)
- [RFC 4122: UUID Specification](https://www.rfc-editor.org/rfc/rfc4122)
- [UUID vs. Auto-Increment Comparison](https://vladmihalcea.com/uuid-vs-identity/)

---

## Review and Updates

- **2026-01-12:** Decision approved by architecture team
- **Next Review:** 2026-07-12 (6 months) or when scale >1M records

---

**Related Documentation:**
- [Architecture Overview](../README.md)
- [Customer Entity](../domain/customer.md)
- [Order Entity](../domain/order.md)
- [Product Entity](../domain/product.md)

