# Architecture Models

This directory contains the core domain models and business flow documentation for the architecture. It serves as the foundation for understanding how entities interact and processes are executed within the system.

## Overview

The architecture models are organized into two main categories:

- **[Domain Models](#domain-models)**: Core entities and their relationships
- **[Business Flows](#business-flows)**: Process flows and interactions between services

---

## Domain Models

Domain models represent the core entities and their business logic. Each model defines the structure, attributes, and operations relevant to its domain.

### Entity Models

| Model | Description |
|-------|-------------|
| [Customer](./domain/customer.md) | User accounts that place orders and manage payment methods |
| [Order](./domain/order.md) | Purchase orders with items, status tracking, and payment information |
| [Order Item](./domain/order-item.md) | Individual line items within an order |
| [Payment](./domain/payment.md) | Payment transactions and method management |
| [Product](./domain/product.md) | Inventory products with pricing and stock management |

**[Full Domain Models Documentation →](./domain/README.md)**

---

## Business Flows

Business flows describe how entities interact across services to complete important business processes. These flows include validation, data consistency, and error handling patterns.

### Process Flows

| Flow | Description |
|------|-------------|
| [Create Order](./flows/create-order.md) | Process for customers to place new orders with inventory and payment validation |
| [Payment Processing](./flows/payment-processing.md) | Payment transaction handling and status updates |
| [Inventory Management](./flows/inventory-management.md) | Stock tracking and allocation across orders |

**[Full Business Flows Documentation →](./flows/README.md)**

---

## Key Concepts

- **Microservices Architecture**: Services communicate via events and APIs
- **Event-Driven Communication**: Asynchronous updates via domain events
- **UUID Primary Keys**: Unique identifiers for distributed systems
- **Transaction Management**: ACID compliance across service boundaries

For architectural decision context, see [Architecture Decision Records (ADRs)](../adr/README.md).

---

## Navigation

- [Back to Architecture](../README.md)
- [Architecture Decision Records](../adr/README.md)
- [C4 System Views](../c4-views/README.md)
