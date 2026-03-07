# Architecture Overview

This directory contains comprehensive architecture documentation for the e-commerce platform, organized into key sections for easy navigation.

You can read my blog about [Architecture as Code](https://architecture-as-code.hashnode.dev/) which uses this repository
to demonstrate how the concept.

## 📚 Documentation Index

### 1. **Architecture Decision Records (ADRs)**
**[👉 /adr](./adr/)**

Captures the significant architectural decisions made during system design and evolution.
- [0001: Use UUID Primary Keys](adr/0001-use-uuid-primary-keys.md)
- [0002: Microservices Architecture](adr/0002-microservices-architecture.md)
- [0003: Event-Driven Communication](adr/0003-event-driven-communication.md)

*Best for:* Understanding the "why" behind architectural choices and their trade-offs.

---

### 2. **C4 Views**
**[👉 /c4-views](./c4-views/)**

Hierarchical architecture diagrams at different levels of abstraction (Context, Container, Component).
- **System Context** — High-level view of the entire platform and external systems
- **Container View** — Major building blocks and internal structure
- **Component Views** — Deep dives into individual microservices (Order Service, Payment Service, etc.)

*Best for:* Visualizing system architecture and understanding how components interact.

---

### 3. **Architecture Models**
**[👉 /models](./models/)**

Core domain models and business flow documentation that serve as the foundation for the system.
- **Domain Models** — Core entities (Customer, Order, Payment, Product, etc.) and their relationships
- **Business Flows** — Process flows like order creation, payment processing, and inventory management

*Best for:* Understanding entities, their attributes, and how business processes execute across the system.

---

### 4. **Infrastructure as Code (IaC)**
**[👉 /iac](./iac/)**

Infrastructure specs that define *where* the system runs and *what guardrails* govern it. IaC files are
version-controlled contracts for your environment — reviewable and enforceable before anything hits a pipeline.
- **[Networking](iac/networking.md)** — VPC topology, subnets, and security-group rules
- **[IAM](iac/iam.md)** — Per-service roles and least-privilege policies
- **[Environments](iac/environments.md)** — Dev / staging / prod definitions and promotion guardrails

*Best for:* Understanding the infrastructure boundaries, identity constraints, and deployment guardrails that
enforce the architecture decisions at the platform level.

---

## Quick Start

1. **New to the project?** Start with [C4 Views - System Context](c4-views/system-context.md)
2. **Want to understand design decisions?** Check the [ADRs](./adr/)
3. **Need to understand data models?** See [Architecture Models](./models/)
4. **Deploying or reviewing infra?** See [Infrastructure as Code](./iac/)
