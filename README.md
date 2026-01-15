# Architecture Diagrams in Code

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/flemming-n-larsen/architecture-as-code-example?style=social)](https://github.com/flemming-n-larsen/architecture-as-code-example)

A complete example demonstrating how to keep architecture diagrams **in your repository** using Markdown + Mermaid, instead of expensive external tools. This repository also demonstrates **OpenSpec integration** for managing specifications and change proposals with AI agents.

## 🎯 The Problem This Solves

Traditional architecture documentation suffers from:

- **Sync Issues** — Diagrams in Confluence, draw.io, or Visio get out of sync with code
- **No Version Control** — Can't diff or review architecture changes alongside code
- **Tool Lock-in** — Proprietary formats that AI agents can't read or help improve
- **Maintenance Burden** — Updating diagrams across multiple tools is slow and error-prone

## ✨ The Solution

Keep all architecture diagrams **as plain text Mermaid** in Markdown files, versioned with your code:

✅ **Single Source of Truth** — Diagrams live in the repository with code  
✅ **Git-Native** — Version controlled, diffable, reviewable in pull requests  
✅ **AI-Friendly** — Plain text that AI agents can read, understand, and help improve  
✅ **Tool-Agnostic** — No expensive licenses, works in any IDE or text editor  
✅ **Export Anywhere** — Convert to PNG, SVG, Confluence, or draw.io when needed  
✅ **Modular** — Each concept (entity, flow, story) in its own file for easy navigation

## 📂 Repository Structure

```
├── AGENTS.md                         # AI agent guidelines and instructions
├── docs/                             # Architecture diagrams and documentation
│   ├── architecture/
│   │   ├── domain/                   # Entity diagrams & relationships
│   │   │   ├── customer.md
│   │   │   ├── order.md
│   │   │   ├── order-item.md
│   │   │   ├── product.md
│   │   │   └── payment.md
│   │   ├── flows/                    # Sequence diagrams & workflows
│   │   │   ├── create-order.md
│   │   │   ├── payment-processing.md
│   │   │   └── inventory-management.md
│   │   └── decisions/                # Architecture Decision Records
│   │       └── adr-0001-uuid-primary-keys.md
│   ├── user-stories/                 # Feature backlog
│   └── requirements.md               # System requirements
├── openspec/                         # Specifications (OpenSpec structure)
│   ├── specs/                        # Source of truth specifications
│   │   ├── customer/
│   │   │   └── spec.md
│   │   ├── order/
│   │   │   └── spec.md
│   │   └── payment/
│   │       └── spec.md
│   └── changes/                      # Active and archived change proposals
│       ├── loyalty-points/           # Active change proposal
│       │   ├── proposal.md
│       │   ├── tasks.md
│       │   └── specs/
│       │       └── customer/
│       │           └── spec.md       # Spec delta for this change
│       └── archived/                 # Completed change proposals
│           └── user-registration/
│               ├── proposal.md
│               └── tasks.md
└── src/                              # Application code
```

## 📚 Documentation Structure

All architecture, requirements, and user stories are in the `docs/` folder:

- **[Documentation Hub](docs/README.md)** — Start here for navigation
- **[Architecture Overview](docs/architecture/README.md)** — System design and domain model
- **[Requirements](docs/requirements.md)** — Functional and non-functional requirements
- **[User Stories](docs/user-stories/README.md)** — Feature backlog and acceptance criteria

### 📌 Start Here

> **New here?** Start with these two files to understand the approach:

1. **[📊 Architecture Overview](docs/architecture/README.md)** — Complete domain model with all 5 entities
2. **[🔄 Create Order Flow](docs/architecture/flows/create-order.md)** — Sequence diagram showing real-world workflow

### Quick Links

- **Domain Model:**
  - [Customer](docs/architecture/domain/customer.md)
  - [Order](docs/architecture/domain/order.md)
  - [OrderItem](docs/architecture/domain/order-item.md)
  - [Product](docs/architecture/domain/product.md)
  - [Payment](docs/architecture/domain/payment.md)

- **Business Flows:**
  - [Create Order Flow](docs/architecture/flows/create-order.md)
  - [Payment Processing Flow](docs/architecture/flows/payment-processing.md)
  - [Inventory Management Flow](docs/architecture/flows/inventory-management.md)

- **Specifications (OpenSpec):**
  - [Customer Spec](openspec/specs/customer/spec.md)
  - [Order Spec](openspec/specs/order/spec.md)
  - [Payment Spec](openspec/specs/payment/spec.md)

- **Change Proposals:**
  - [Loyalty Points (Active)](openspec/changes/loyalty-points/proposal.md)

## 🚀 How This Repository Works

### 1. Modular Documentation

Each concept lives in its own file:

```
docs/architecture/domain/customer.md  ← Customer entity with diagrams
docs/architecture/domain/order.md     ← Order entity with diagrams
docs/architecture/flows/create-order.md ← Order creation sequence diagram
```

### 2. Mermaid Diagrams Embedded

Every entity and flow includes inline Mermaid diagrams:

```mermaid
classDiagram
    class Customer {
        uuid id
        string email
        string name
        getOrders()
    }
```

### 3. Hyperlinked Navigation

Documents cross-link to related concepts:

```markdown
See the [Customer](domain/customer.md) entity for more details.
This flows through the [Create Order Flow](flows/create-order.md).
```

### 4. Version Controlled with Code

Update diagrams in the same pull request as code changes:

```bash
git checkout -b feature/customer-tiers
# Edit src/Customer.ts
# Edit docs/architecture/domain/customer.md
git commit -m "feat: add customer tier system"
```

## 💡 Key Benefits

### For Developers
- See architecture diagrams **in your IDE** alongside code
- Review diagram changes **in pull requests**
- No context switching to external tools

### For Architects
- Keep diagrams **in sync with implementation**
- Modular structure scales to large systems
- Export to any format when needed (PNG, Confluence, etc.)

### For AI Collaboration
- AI agents can **read and understand** plain text diagrams
- Get help **refactoring both code and diagrams** together
- No proprietary formats blocking AI assistance

### For Teams
- **Single source of truth** in the repository
- Diagrams are **reviewed alongside code**
- No expensive tool licenses required

## 🤖 OpenSpec Integration

This repository demonstrates how **OpenSpec** integrates with the architecture-as-code approach for managing specifications and AI-assisted development.

### AI Terminology

This example uses two AI categories:

| Term           | Description                                                                    | Examples                                 | Use For                                                     |
|:---------------|:-------------------------------------------------------------------------------|:-----------------------------------------|:------------------------------------------------------------|
| **Strong AI**  | Premium, frontier-class models with advanced reasoning and high-level strategy | Claude 4.5 Opus, Gemini Ultra            | Spec creation, architectural planning, requirement analysis |
| **Regular AI** | High-performance coding assistants, cost-effective for implementation          | Claude 4.5 Sonnet, GPT-5.2, Gemini 3 Pro | Code implementation, task execution, archiving              |

When we say "AI agent", we mean an **agentic AI** that can execute multi-step tasks, read/write files, and run commands autonomously.

### How The Parts Work Together

| Component | Purpose | Examples |
|:----------|:--------|:---------|
| **AGENTS.md** | Guidelines for AI agents | Code style, conventions, patterns, what to avoid |
| **/docs** | System structure | Class diagrams, ER schemas, sequence flows, entity relationships |
| **/openspec** | System behavior | Source of truth specifications, change proposals, business rules |

### AI Agent Usage Pattern

**Planning Mode (Strong AI):**
```
"Create a new change proposal for: Add customer loyalty points system"

"Review this change proposal and ask questions about edge cases"

"Archive the loyalty-points change and update the specs"
```

**Execution Mode (Regular AI):**
```typescript
// Reference: /openspec/changes/loyalty-points/specs/customer/spec.md
// Follow guidelines in AGENTS.md
// Implement LoyaltyPoints entity following business rules

class LoyaltyPoints {
    // AI generates code that follows the specification and AGENTS.md guidelines...
}
```

**💡 Tip:** Always reference both the specification AND AGENTS.md in your prompts for consistent, architecture-aligned code generation.

### OpenSpec Workflow

1. **Create Initial Specs:** Document existing system behavior in `/openspec/specs/`
2. **Foundation Review:** Ensure baseline specs are accurate
3. **Create Change Proposal:** Create `/openspec/changes/<feature>/` with proposal.md and tasks.md
4. **Review:** Use strong AI to refine and ask clarifying questions
5. **Execute:** Use regular AI to implement tasks one at a time
6. **Archive:** Move completed change to `changes/archived/` and merge spec deltas
7. **Iterate:** Create next change proposal

## 📖 Example: Customer Entity

From [docs/architecture/domain/customer.md](docs/architecture/domain/customer.md):

**Class Diagram:**

```mermaid
classDiagram
    class Customer {
        uuid id
        string email
        string name
        datetime createdAt
        getOrders()
        addPaymentMethod()
    }
```

**Database Schema:**

```mermaid
erDiagram
    CUSTOMER {
        uuid id PK
        string email UK
        string name
        string phone
        datetime created_at
    }
```

Each entity file includes:
- Business logic explanation
- Class diagram showing methods and fields
- Database schema (ER diagram)
- Relationships to other entities (with links)
- Related workflows and user stories

## 🔄 Example: Create Order Flow

From [docs/architecture/flows/create-order.md](docs/architecture/flows/create-order.md):

Sequence diagrams show how requests flow through the system:

```mermaid
sequenceDiagram
    participant Client
    participant OrderService
    participant ProductService
    participant Database
    
    Client ->> OrderService: POST /orders
    OrderService ->> ProductService: Check stock
    OrderService ->> Database: Create order
    Database -->> Client: Order confirmation
```

*(Simplified for README — see the actual file for complete flow)*

## 🛠️ Using This Repository

### For Learning

1. Start with [docs/README.md](docs/README.md) for orientation
2. Explore [docs/architecture/](docs/architecture/) for domain model and workflows
3. See how entities cross-link to flows and user stories
4. Notice how diagrams are embedded directly in explanations

### For Your Own Project

1. **Fork or clone** this repository
2. **Customize** entity names and relationships for your domain
3. **Add** new entities in `docs/architecture/domain/`
4. **Add** new flows in `docs/architecture/flows/`
5. **Update** cross-links as you restructure
6. **Commit** docs alongside code changes

### For Exporting

All diagrams can be exported:

- **To PNG/SVG:** Use https://mermaid.live or CLI tools
- **To Confluence:** Use Mermaid plugin or export as images
- **To draw.io:** Import Mermaid via app.diagrams.net

The repository is the **source of truth**; exports are derivatives.

## 🎓 What You'll Learn

After exploring this repository, you'll understand:

- ✅ How to organize architecture documentation modularly
- ✅ How to embed Mermaid diagrams in Markdown
- ✅ How to use hyperlinks for navigation (not linear reading)
- ✅ How to version diagrams with Git
- ✅ How to review diagrams in pull requests
- ✅ How to keep documentation in sync with code
- ✅ How AI agents can help maintain documentation

## 📝 Making Changes

To update documentation:

1. Edit the relevant `.md` file in `docs/`
2. Update Mermaid diagrams directly in the file
3. Update cross-links if you change file structure
4. Include docs changes in pull requests alongside code

Example workflow:

```bash
git checkout -b docs/add-shipping-entity
# Create docs/architecture/domain/shipping.md
# Update docs/architecture/README.md to reference it
git add docs/
git commit -m "docs: add shipping entity"
git push origin docs/add-shipping-entity
```

## 🌟 Philosophy

This repository demonstrates:

- **Architecture as Code** — Diagrams are code artifacts, not external documents
- **Monorepo Best Practices** — Single source of truth for code + docs
- **DRY Principle** — Define each concept once, reference via links
- **Progressive Disclosure** — Navigate to what you need, not forced linear reading
- **AI Collaboration** — Plain text enables AI agents to help maintain docs
- **Spec-Driven Development** — Specifications document intent before implementation
- **Change Management** — Proposals track system evolution with clear audit trails

### Key Benefits

**For AI Agents:**
- **Complete context:** Structure (/docs), behavior (/openspec), and guidelines (AGENTS.md)
- **Clear boundaries:** Specifications prevent architectural violations
- **Consistent patterns:** AGENTS.md ensures consistent code style across AI sessions

**For Developers:**
- **Brownfield friendly:** Works with existing codebases (not just greenfield)
- **Chat-based:** Simple prompts, no complex templates
- **Version controlled:** Specifications and guidelines evolve with code in same repository
- **Predictable AI:** AGENTS.md creates consistent AI behavior across team members

**For Architecture:**
- **Integrity maintained:** AI agents understand design intent
- **Evolution tracked:** Change specifications document system growth
- **Knowledge preserved:** Decisions and reasoning captured in specifications
- **Standards enforced:** AGENTS.md ensures code quality and consistency

## 📚 Related Resources

- **Mermaid Documentation:** https://mermaid.js.org/
- **Mermaid Live Editor:** https://mermaid.live
- **C4 Model (advanced):** https://c4model.com/
- **Architecture Decision Records (ADRs):** https://adr.github.io/

## 🤝 Contributing

This is an educational example repository. Feel free to:

- Fork and adapt for your own projects
- Submit issues for clarifications or improvements
- Share how you've adapted this approach in your organization

## 📄 License

MIT License — Free to use and adapt for any purpose.

---

**Ready to get started?** Begin with [docs/README.md](docs/README.md) and explore the architecture! 🚀
