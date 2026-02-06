# Architecture Overview

This directory contains comprehensive architecture documentation for the e-commerce platform, organized into key sections for easy navigation.

## 📚 Documentation Index

### 1. **Architecture Decision Records (ADRs)**
**[→ /adr](./adr/)**

Captures the significant architectural decisions made during system design and evolution.
- [0001: Use UUID Primary Keys](./adr/0001-use-uuid-primary-keys.md)
- [0002: Microservices Architecture](./adr/0002-microservices-architecture.md)
- [0003: Event-Driven Communication](./adr/0003-event-driven-communication.md)

*Best for:* Understanding the "why" behind architectural choices and their trade-offs.

---

### 2. **C4 Views**
**[→ /c4-views](./c4-views/)**

Hierarchical architecture diagrams at different levels of abstraction (Context, Container, Component).
- **System Context** — High-level view of the entire platform and external systems
- **Container View** — Major building blocks and internal structure
- **Component Views** — Deep dives into individual microservices (Order Service, Payment Service, etc.)

*Best for:* Visualizing system architecture and understanding how components interact.

---

### 3. **Architecture Models**
**[→ /models](./models/)**

Core domain models and business flow documentation that serve as the foundation for the system.
- **Domain Models** — Core entities (Customer, Order, Payment, Product, etc.) and their relationships
- **Business Flows** — Process flows like order creation, payment processing, and inventory management

*Best for:* Understanding entities, their attributes, and how business processes execute across the system.

---

## Quick Start

1. **New to the project?** Start with [C4 Views - System Context](./c4-views/system-context.md)
2. **Want to understand design decisions?** Check the [ADRs](./adr/)
3. **Need to understand data models?** See [Architecture Models](./models/)
