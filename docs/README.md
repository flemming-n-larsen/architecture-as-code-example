# E-Commerce System Documentation

Welcome! This documentation describes the architecture, requirements, and user stories for our e-commerce platform.

## 🧭 Quick Navigation

- **[Architecture Overview](architecture/)** — System design, entities, and workflows
  - [Domain Model](architecture/domain/) — Core business entities (Customer, Order, Product, Payment)
  - [Workflows](architecture/flows/) — How the system processes requests
  - [Decisions](architecture/decisions/) — Architecture Decision Records (ADRs)

- **[Requirements](requirements.md)** — Functional and non-functional requirements

- **[User Stories](user-stories/)** — Feature backlog and acceptance criteria

## 📖 How to Use This Documentation

This documentation is **not meant to be read linearly**. Instead:

1. **Start with [Architecture Overview](architecture/)** for the big picture
2. **Dive into specific [Domain Model](architecture/domain/)** pages you're interested in
3. **Navigate [Workflows](architecture/flows/)** to understand how data flows through the system
4. **Check [User Stories](user-stories/)** for feature requirements
5. **Use cross-links** within each page to explore related concepts

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
- Review [Architecture Overview](architecture/) to understand the system design
- Check [Domain Model](architecture/domain/) for entity details
- Follow [Workflows](architecture/flows/) to understand request processing

### For Product Managers
- Start with [User Stories](user-stories/) to see features and acceptance criteria
- Review [Requirements](requirements.md) for functional and non-functional requirements

### For Architects
- Explore [Architecture Decisions](architecture/decisions/) for key design choices
- Review entity relationships in [Architecture Overview](architecture/)

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
├── requirements.md
├── architecture/
│   ├── README.md (big picture)
│   ├── domain/ (entities)
│   ├── flows/ (workflows)
│   └── decisions/ (ADRs)
└── user-stories/
    └── (feature definitions)
```

---

**Ready to explore?** Start with the [Architecture Overview](architecture/) 🚀


