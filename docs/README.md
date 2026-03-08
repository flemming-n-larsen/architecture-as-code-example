# E-Commerce System Documentation

Welcome! This documentation describes the architecture, requirements, and user stories for our e-commerce platform.

## 🧭 Quick Navigation

### 🏗️ Architecture Documentation
- **[Architecture Overview](architecture/README.md)** — System design, entities, and workflows
  - [Domain Model](architecture/models/domain/README.md) — Core business entities (Customer, Order, Product, Payment)
  - [Workflows](architecture/models/flows/README.md) — How the system processes requests
  - [Decisions](architecture/adr/README.md) — Architecture Decision Records (ADRs)
  - [Requirements](requirements.md) — Functional and non-functional requirements
  - [User Stories](user-stories/README.md) — Feature backlog and acceptance criteria

## 📖 How to Use This Documentation

This documentation is **not meant to be read linearly**. Instead:

1. **Start with [Architecture Overview](architecture/README.md)** for the big picture
2. **Understand system [Requirements](requirements.md)** and constraints
3. **Dive into specific [Domain Models](architecture/models/domain/README.md)** you're interested in
4. **Navigate [Workflows](architecture/models/flows/README.md)** to understand how data flows through the system
5. **Review [User Stories](user-stories/README.md)** for feature requirements and acceptance criteria
6. **Explore [Architecture Decisions](architecture/adr/README.md)** to understand the "why" behind design choices
7. **Use cross-links** within each page to explore related concepts

## 🎯 Key Principles

- 📝 **Everything in Code** — All diagrams live in Markdown as Mermaid, versioned with source code
- 🔗 **Hyperlinked** — Navigate based on what you need, not a linear reading order
- 🎯 **Modular** — One file per concept, self-contained but linked to related concepts
- ✏️ **Editable** — Change diagrams and documentation in pull requests alongside code changes
- 🤖 **AI-Friendly** — AI agents can help improve individual documentation files
- 📤 **Export Ready** — Convert to PNG/SVG/Confluence as needed

## 🏗️ Architecture at a Glance

Our system consists of:

- **5 Core Entities:** Customer, Order, OrderItem, Product, Payment
- **3 Primary Flows:** Order creation, payment processing, inventory management
- **Microservices Architecture** with event-driven communication
- **PostgreSQL Database** with ACID transactions
- **REST APIs** for all services

## 🚀 Getting Started

### For Developers
- Review [Architecture Overview](architecture/README.md) to understand the system design
- Check [Domain Model](architecture/models/domain/README.md) for entity details
- Follow [Workflows](architecture/models/flows/README.md) to understand request processing
- Implement features aligned with [User Stories](user-stories/README.md)

### For Product Managers
- Start with [Requirements](requirements.md) for functional and non-functional requirements
- Review [User Stories](user-stories/README.md) to see features and acceptance criteria
- Check [Architecture Overview](architecture/README.md) to understand technical constraints

### For Architects
- Explore [Architecture Decisions](architecture/adr/README.md) for key design choices
- Review [Requirements](requirements.md) for non-functional requirements and constraints
- Check entity relationships in [Domain Model](architecture/models/domain/README.md)

## 🤝 Contributing to Documentation

To update documentation:

1. Edit the relevant `.md` file in the `docs/` folder
2. Update embedded Mermaid diagrams directly in the file
3. Include changes in your pull request alongside code changes
4. Ensure all cross-links are correct

Example:

```bash
git checkout -b feature/add-wishlist
# Edit code in src/
# Edit docs/architecture/domain/wishlist.md
git add src/ docs/
git commit -m "feat: add wishlist feature with documentation"
```

## 📊 Documentation Structure

```
docs/
├── README.md (this file)
└── 🏗️ Architecture Documentation/
    ├── architecture/
    │   ├── README.md (big picture)
    │   ├── models/domain/ (entities)
    │   ├── models/flows/ (workflows)
    │   └── adr/ (ADRs)
    ├── requirements.md (functional & non-functional)
    └── user-stories/ (feature definitions & acceptance criteria)
```

**All three components are part of the Architecture Documentation index:**
- `architecture/` → How the system is structured (technical design)
- `requirements.md` → What the system must do (business & quality attributes)
- `user-stories/` → What users can do (feature backlog)

---

## 🔗 Quick Links

- **[Architecture Overview](architecture/README.md)** — System design at a glance
- **[Requirements](requirements.md)** — What the system must do
- **[User Stories](user-stories/README.md)** — User-facing features
- **[Domain Model](architecture/models/domain/README.md)** — Core entities
- **[Workflows](architecture/models/flows/README.md)** — How data flows
- **[Decisions](architecture/adr/README.md)** — Architecture Decision Records

---

**Ready to explore?** Start with the [Architecture Overview](architecture/README.md) 🚀


