# Architecture Decision Records (ADRs)

An Architecture Decision Record (ADR) is a document that captures an important architectural decision made along with its context and consequences.

This directory contains the ADRs for the e-commerce system architecture, organized chronologically. Each ADR follows the MADR (Markdown Architecture Decision Records) format. See the MADR specification: https://adr.github.io/madr/

---

## Table of Contents

| Status | ID | Title | Date |
|--------|----|----|------|
| ✅ Accepted | [0001](./0001-use-uuid-primary-keys.md) | Use UUIDs for Primary Keys | 2026-01-12 |
| 🔄 Pending | [0002](./0002-microservices-architecture.md) | Microservices Architecture | - |
| 🔄 Pending | [0003](./0003-event-driven-communication.md) | Event-Driven Communication | - |

---

## Quick Reference

### [ADR-0001: Use UUIDs for Primary Keys](./0001-use-uuid-primary-keys.md)
**Status:** Accepted (2026-01-12)

Establishes UUIDs (version 4) as the primary key strategy for all database tables to support distributed architecture, horizontal scaling, multi-region deployment, and data import/export safely.

**Key Points:**
- Distributed ID generation without central coordination
- Safe for merging data across environments
- Security through non-sequential IDs
- Mitigates larger storage with proper indexing

---

### [ADR-0002: Microservices Architecture](./0002-microservices-architecture.md)
**Status:** Pending

Defines the microservices architecture pattern for the e-commerce system.

*(Full content to be developed)*

---

### [ADR-0003: Event-Driven Communication](./0003-event-driven-communication.md)
**Status:** Pending

Specifies the event-driven communication mechanism between microservices.

*(Full content to be developed)*

---

## Status Legend

- **✅ Accepted** - Decision has been approved and is in effect
- **🔄 Pending** - Decision is under review or discussion
- **🚫 Superseded** - Decision has been replaced by another ADR
- **⚠️ Deprecated** - Decision is no longer recommended

## How to create an ADR

1. Create a new file in this directory named `000N-short-title.md` (increment the next available ID).
2. Add YAML frontmatter with at minimum: `id`, `title`, `status`, `date`, and `deciders`.
3. Fill the canonical sections: `Context`, `Decision`, `Consequences`, `Rationale`, `Alternatives`, `Implementation`, `References`, and `Review and Updates`.
4. Open a Pull Request and request review from the Architecture Team. Once accepted, update `status` to `Accepted` and add the decision `date`.

---

## Related Documentation

- [Markdown Architectural Decision Records](https://adr.github.io/madr/)
- [Architecture Overview](../README.md)
- [Domain Models](../models/README.md)
- [C4 Views](../c4-views/README.md)
