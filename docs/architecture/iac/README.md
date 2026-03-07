# Infrastructure as Code (IaC) — The "Where & Guardrails"

This directory documents the infrastructure layer of the e-commerce platform as a set of **machine-readable specs**.
IaC files (Terraform, Bicep, Pulumi, etc.) are the source of truth for *where* the system runs and *what guardrails*
govern it — and they belong in architectural documentation alongside ADRs, C4 diagrams, and domain models.

> **Key insight:** An IaC file is not just automation — it is a version-controlled contract for your environment.
> Treating it as a spec means you can review, lint, and enforce it *before* anything hits a pipeline.

---

## 📚 IaC Spec Index

| Spec                                  | Description                                              |
|:--------------------------------------|:---------------------------------------------------------|
| [Networking](./networking.md)         | VPC topology, subnets, and security-group rules          |
| [IAM](./iam.md)                       | Per-service roles and least-privilege policies           |
| [Environments](./environments.md)     | Dev / staging / prod definitions and promotion guardrails |

---

## 🏗️ How IaC Fits the Four Pillars

```
architecture/
├── adr/          # WHY:         Architecture Decision Records
├── c4-views/     # WHAT:        System structure (Context → Container → Component)
├── models/       # HOW:         Domain entities and business flows
└── iac/          # WHERE & GUARDRAILS: Infrastructure specs and environment policy
```

The ADRs drive the infrastructure shape. For example:
- **ADR-0002 (Microservices)** → one isolated network segment and one IAM identity per service
- **ADR-0003 (Event-Driven)** → RabbitMQ broker in a private subnet, per-service publish/subscribe permissions
- **ADR-0001 (UUIDs)** → no infrastructure constraint, but documented for completeness in secret naming conventions

---

## 🔗 Related Documentation

- [ADR-0002: Microservices Architecture](../adr/0002-microservices-architecture.md)
- [ADR-0003: Event-Driven Communication](../adr/0003-event-driven-communication.md)
- [Container View](../c4-views/container.md) — the C4 view this IaC layer implements
- [Microsoft: What is Infrastructure as Code?](https://learn.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code)

