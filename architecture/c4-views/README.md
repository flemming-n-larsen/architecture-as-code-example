# C4 Views

This folder contains the project's C4 architecture views (Context, Container, Component) and supporting assets (images and Structurizr DSL files). The C4 model provides a hierarchical view of the system at different levels of abstraction.

## Quick Navigation

### 1. **System Context** — The Big Picture
**[→ system-context.md](./system-context.md)**

Start here for a bird's-eye view of the entire e-commerce platform. This diagram shows:
- The **E-Commerce Platform** at the center
- **External actors:** Customers and Administrators
- **External systems:** Payment Gateway and Email Service
- **Key capabilities:** Product catalog, order management, payment processing, inventory, notifications

*Best for:* Understanding system boundaries and high-level stakeholder interactions.

---

### 2. **Container View** — System Decomposition
**[→ container.md](./container.md)**

Zoom into the platform's internal structure to see the major building blocks:
- **Frontend:** Web Application (React/TypeScript SPA)
- **API Layer:** API Gateway (Kong/NGINX)
- **Microservices:** Customer, Order, Payment, Product, and Inventory Services
- **Data Layer:** Databases, caches, and message brokers
- **Communication protocols:** REST/JSON, AMQP, SQL

*Best for:* Understanding the major components and how they communicate.

---

### 3. **Component Views** — Deep Dives into Services

#### Order Service Component
**[→ order-service-component.md](./order-service-component.md)**

Internal architecture of the Order Service microservice:
- **API & Request Handling:** Order Controller, Error Handler
- **Business Logic:** Order Manager, Order Validator
- **Persistence:** Order Repository, Database
- **Asynchronous Communication:** Event Publisher
- **Responsibilities:** Order creation, state transitions, fulfillment tracking, event publishing

*Best for:* Understanding how orders are processed end-to-end.

---

#### Payment Service Component
**[→ payment-service-component.md](./payment-service-component.md)**

Internal architecture of the Payment Service microservice:
- **API & Request Handling:** Payment Controller, Error Handler
- **Business Logic:** Payment Manager, Payment Validator, Refund Handler
- **Persistence:** Payment Repository, Database
- **External Integrations:** Payment Gateway Adapter (Stripe, PayPal)
- **Responsibilities:** Payment processing, state management, refunds, transaction history

*Best for:* Understanding payment workflows and security considerations.

---

## Supporting Assets

### 📁 Folder Structure

| Folder | Purpose |
|--------|---------|
| `images/` | Rendered SVG diagrams (visual representations of all views) |
| `structurizr-dsl/` | Structurizr DSL source files (can regenerate diagrams from these) |

### 📊 Files

| File | Description |
|------|-------------|
| `system-context.dsl` | DSL for System Context diagram |
| `container.dsl` | DSL for Container View diagram |
| `order-service-component.dsl` | DSL for Order Service Component diagram |
| `payment-service-component.dsl` | DSL for Payment Service Component diagram |

---

## How to Use This Documentation

1. **New to the architecture?** Start with [System Context](./system-context.md) for the overall picture.
2. **Need to understand the overall platform structure?** Read [Container View](./container.md) next.
3. **Digging into a specific service?** Jump to the relevant Component View:
   - [Order Service](./order-service-component.md) for order workflows
   - [Payment Service](./payment-service-component.md) for payment workflows

---

## Viewing & Editing Diagrams

- Each markdown file includes an **embedded SVG diagram** for visual reference
- Original **Structurizr DSL files** are in the `structurizr-dsl/` folder
- To regenerate diagrams from DSL: use the [Structurizr CLI](https://docs.structurizr.com/cli) or [Structurizr editor](https://structurizr.com/)

---

## Related Documentation

For more context on the architecture, see:
- [Architecture Decision Records (ADRs)](../adr/) — Design decisions and rationale
- [Domain Models](../models/domain/) — Core business entities
- [Domain Flows](../models/flows/) — Key business processes
