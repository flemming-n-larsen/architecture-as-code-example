# 🏗️ Architecture as Code in Practice

**Enhancing your architecture documentation with ADRs and C4 diagrams**

---

👉 [Read on Hashnode](https://architecture-as-code.hashnode.dev/architecture-as-code-in-practice)

---

This article builds on the foundation from the previous 'Architecture as Code' articles:

- [Keep Your Architecture Diagrams in Code, Not in Tools](../A1.%20Keep%20Your%20Architecture%20Diagrams%20in%20Code,%20Not%20in%20Tools/README.md) ([Hashnode](https://architecture-as-code.hashnode.dev/keep-your-architecture-diagrams-in-code-not-in-tools))
- [Keep Your AI and Architecture-Design in Sync](../A2.%20Keep%20Your%20AI%20and%20Architecture-Design%20in%20Sync/README.md) ([Hashnode](https://architecture-as-code.hashnode.dev/keep-your-ai-and-architecturedesign-in-sync))

---

In my previous articles, I showed how keeping architecture diagrams as plain text (Markdown) in your repository creates
a foundation for AI-readable documentation, and how specs help AI understand your design intent.

Model and sequence diagrams are commonly included in architecture documentation and can be written directly in Markdown
using embedded Mermaid diagrams. But diagrams alone describe what the architecture is—not why those choices were made.

Diagrams alone aren't enough for production systems. You also need:

- **Why decisions were made** (the context and trade‑offs)
- **Multiple views** (from system context down to implementation)
- **A clear, scalable structure** for your architecture documentation

This is where the approach in my previous articles alone isn't enough.

---

## 🎯 TL;DR: The Complete Structure

If you're just browsing online and want the essential takeaway, here it is:

```
architecture/
├── adr/                    # Why decisions were made
│   ├── 0001-use-uuid-primary-keys.md
│   ├── 0002-microservices-architecture.md
│   └── 0003-event-driven-communication.md
├── c4-views/               # What the system looks like (4 zoom levels)
│   ├── system-context.md
│   ├── container.md
│   ├── order-service-component.md
│   └── payment-service-component.md
└── models/                 # How entities relate and workflows
    ├── domain/
    │   ├── customer.md
    │   ├── order.md
    │   └── payment.md
    └── flows/
        ├── create-order.md
        └── payment-processing.md
```

**The three pillars:**
Three pillars: ADRs (why), C4 diagrams (what), and domain models (how). Keep everything as plain text,
version-controlled, and AI-readable so architecture stays discoverable and actionable.

---

## 📊 Beyond Diagrams: Adding Context and Decisions

Diagrams (model, sequence, flow) explain what the system looks like and how it behaves, but they don't record the
reasons behind design choices.

For production-grade documentation you need three things:
1. **ADRs** ([templates](https://adr.github.io/adr-templates/)) — record the context, alternatives, and rationale (*why*)
2. **C4 diagrams** ([c4model.com](https://c4model.com/)) — show structure at multiple zoom levels (*what*)
3. **A clear, scalable structure** — where to find artifacts and how they relate (*how*/where)

Next I'll show how to organize these artifacts in your repo.

---

## 📋 Architecture Decision Records: Document the Why

Six months from now, someone will ask: "Why did we choose UUIDs instead of auto‑increment IDs?"
If the answer only lives in Slack or in a person's head, the context is gone. ADRs fix that.

An ADR record:

- The decision
- Status and who approved it
- The context and constraints at the time
- Options that were considered
- The chosen rationale
- Consequences and trade‑offs

### The MADR Format

We use [MADR (Markdown Architectural Decision Records)](https://adr.github.io/madr/) because it's lightweight,
standardized, and plain text—easy to review, search, and version with git.

Below is a simplified ADR example to illustrate the format:

```markdown
# Use UUIDs for Primary Keys

* Status: accepted
* Date: 2026-01-12
* Deciders: Architecture Team

Technical Story: Choose a primary-key strategy for all database tables in our distributed e-commerce
platform.

## Context and Problem Statement

Our system is a distributed, service-oriented platform with requirements that include:

- Horizontal scaling of services
- Possible multi-region deployment in the future
- Database sharding, replication, and data migration between environments
- Strong operational and security requirements (observability, auditability)

How can we generate primary keys that support these constraints while keeping performance,
operational simplicity, and safety in mind?

## Decision Drivers

- Support independent ID generation across services (no central coordinator)
- Safe data import/export and merging across environments
- Reasonable storage and index performance
- Avoid leaking sequential or guessable identifiers
- Simplicity of implementation and ecosystem support

## Considered Options

- Option 1: Auto-increment integers (SERIAL in PostgreSQL) — Simple and compact but requires
  centralized coordination (per-database) and causes collisions when merging datasets.
- Option 2: UUIDs (v4) — Globally unique, easy to generate anywhere, widely supported; larger
  storage footprint and less human-friendly in logs.
- Option 3: ULID — Lexicographically sortable ID with good uniqueness and somewhat smaller
  footprint than UUIDs; requires extra libraries in some stacks.
- Option 4: Snowflake-style IDs — Compact, sortable, and efficient but requires coordinated
  generators and operational infrastructure (time/node bits).

## Decision Outcome

Chosen option: Option 2 — UUIDs (v4).

Rationale: We chose UUIDs (v4) because they let services generate identifiers locally without
a central coordinator, eliminate collision risk when merging data across environments, and
have broad ecosystem support. UUIDs increase storage and index size and are less human‑
friendly in logs, but those tradeoffs are acceptable given our distributed, multi‑region,
and data‑migration requirements. We will mitigate readability concerns using short aliases
or admin‑facing identifiers where appropriate.

### Consequences

* ✅ Services can generate IDs locally with no coordination
* ✅ Safe merging/importing of data between environments
* ❌ Larger storage and index size compared with 32-bit integers
* ❌ Less human-friendly IDs in logs and UIs (mitigations: short aliases or readable keys)

## More Information

### Implementation Examples

    CREATE TABLE customers (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        email VARCHAR(255) UNIQUE NOT NULL
    );

...

### Review Schedule

- **Next Review:** 2026-07-12 (6 months)

```

The full ADR contains implementation notes, examples, and mitigation strategies — detailed enough to be
useful, yet concise enough to read in a review. It captures the rationale you need to understand and act on
past decisions.

### Why MADR (and plain-text ADRs) work

- **Structured**: A consistent template makes information predictable and easy to scan.
- **Discoverable**: Plain text is searchable by IDEs, grep, and AI tools, so decisions are straightforward to find.
- **Versioned**: ADRs live in git; the rationale and its changes are preserved in commits and PR history.
- **Reviewable**: ADRs can be reviewed in pull requests alongside the code they affect.
- **Actionable**: ADRs link to implementation notes, follow-up tasks, or specs, closing the loop between
  decisions and code.

### ADR Organization

```
architecture/
├── adr/
│ ├── README.md # Index with status table
│ ├── 0001-use-uuid-primary-keys.md
│ ├── 0002-microservices-architecture.md
│ └── 0003-event-driven-communication.md
```

The README includes a status table:

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| [0001](../../docs/architecture/adr/0001-use-uuid-primary-keys.md) | Use UUIDs for Primary Keys | Accepted | 2026-01-12 |
| [0002](../../docs/architecture/adr/0002-microservices-architecture.md) | Adopt Microservices Architecture | Accepted | 2026-01-15 |
| [0003](../../docs/architecture/adr/0003-event-driven-communication.md) | Use Event-Driven Communication | Accepted | 2026-01-20 |

This makes it trivial to see all decisions at a glance.

---

## C4 Diagrams: Zoom Levels for Architecture

Diagrams and ADRs solve different problems: diagrams show structure and behavior; ADRs
explain the decisions that produced that structure. Use the C4 model to present the system at
multiple, targeted zoom levels so each audience gets the right information without overload.

### What is C4?

The C4 model defines four diagram levels that act like a geographic map—you can zoom in or
out depending on the reader's needs:

1. **System Context** (10,000-foot view) — The system, its users, and external dependencies.
   Useful for non-technical stakeholders and new team members who need the big picture.
2. **Container** (1,000-foot view) — The major applications and services (web apps, APIs,
   databases, message brokers) and how they interact. Suited for architects, senior developers,
   and DevOps engineers.
3. **Component** (100-foot view) — Internal components within a container and their
   relationships. Intended for developers working on a specific service.
4. **Code** (10-foot view) — Code-level structure (classes, modules); usually only needed for
   detailed design or maintenance tasks.

Each level answers different questions for different audiences—keep each view focused, link
between levels, and cross-reference ADRs where decisions affect structure.

### Supporting diagrams

Beyond the four C4 levels, three supporting diagram types are often helpful:

- **System landscape** — shows the product in the broader ecosystem (other systems, partners); audience: executives and
  cross‑team stakeholders.
- **Dynamic (sequence / interaction)** — scenario-based flow diagrams that show runtime interactions for specific use
  cases; audience: developers and architects.
- **Deployment** — runtime topology showing environments, nodes, and network boundaries; audience: SRE/ops and
  architects.

Keep each view focused, cross-link diagrams to relevant ADRs, and include only the views that add clarity for their
intended audience.

### Level 1: System Context

**Question:** *What is this system and how does it relate to the world?*

**Audience:** Executives, product managers, new team members

```dsl
workspace "E-Commerce System" {
    model {
        customer = person "Customer"
        admin = person "Administrator"
        paymentGateway = softwareSystem "Payment Gateway" "External"
        emailSystem = softwareSystem "Email Service" "External"
        
        ecommerceSystem = softwareSystem "E-Commerce Platform" {
            ...
        }
        
        customer -> ecommerceSystem "Browses products, places orders"
        ecommerceSystem -> paymentGateway "Processes payments via"
        ecommerceSystem -> emailSystem "Sends emails via"
    }
    
    views {
        systemContext ecommerceSystem {
            include *
            autoLayout
        }
    }
}
```

👉 View the diagram [online](https://github.com/flemming-n-larsen/architecture-as-code-example/blob/44eeb3a97268ca0948c8d3e8d947dddc2fa1a20e/architecture/c4-views/system-context.md#architecture-diagram)

This view gives the 10,000‑foot perspective: the system's actors, external dependencies (for example,
payment and email services), and how users interact with the platform.

### Level 2: Container

**Question:** *What are the primary applications and services, what responsibilities do they
hold, and how do they communicate?*

**Audience:** Architects, senior developers, and SRE/DevOps

```dsl
workspace "E-Commerce System - Container View" {
    model {
        customer = person "Customer"
        
        ecommerceSystem = softwareSystem "E-Commerce Platform" {
            webApp = container "Web Application" "React, TypeScript"
            apiGateway = container "API Gateway" "Kong, NGINX"
            
            customerService = container "Customer Service" "Node.js"
            orderService = container "Order Service" "Node.js"
            productService = container "Product Service" "Node.js"
            paymentService = container "Payment Service" "Node.js"
            
            messageBroker = container "Message Broker" "RabbitMQ"
            
            customerDB = container "Customer Database" "PostgreSQL"
            orderDB = container "Order Database" "PostgreSQL"
            ...
        }
        
        customer -> webApp "Uses"
        webApp -> apiGateway "Calls"
        apiGateway -> customerService "Routes to"
        ...
        orderService -> messageBroker "Publishes OrderCreated"
        messageBroker -> productService "Delivers OrderCreated"
    }
}
```

👉 View the diagram [online](https://github.com/flemming-n-larsen/architecture-as-code-example/blob/44eeb3a97268ca0948c8d3e8d947dddc2fa1a20e/architecture/c4-views/container.md#architecture-diagram)

This shows microservices, databases, the message broker, and both synchronous (REST) and asynchronous
(events) communication.

### Level 3: Component

This view digs into a single service to show its internal building blocks: components, their
responsibilities, and the interactions (sync calls or events) between them. Use the component
view to explain how the service implements business logic, how it persists state, and which
components publish or subscribe to events.

**Question:** *What components make up this service and how do they collaborate to implement
its features?*

**Audience:** Developers and maintainers working on a specific service

Below is a simplified component view for the Order Service that highlights controllers, business
logic, repositories, and event publishers/subscribers.

Here's the Order Service component view (simplified):

```dsl
workspace "Order Service - Component View" {
    model {
        orderService = softwareSystem "Order Service" {
            orderController = container "Order Controller" "REST API"
            orderManager = container "Order Manager" "Business Logic"
            orderValidator = container "Order Validator" "Validation"
            orderStateMachine = container "Order State Machine"
            orderRepository = container "Order Repository" "Data Access"
            orderEventPublisher = container "Event Publisher"
            orderEventSubscriber = container "Event Subscriber"
            ...
        }
        
        orderController -> orderValidator "Validates order"
        orderController -> orderManager "Creates order"
        orderManager -> orderRepository "Saves order"
        orderManager -> orderEventPublisher "Publishes OrderCreated"
        ...
    }
}
```

👉 View the diagram [online](https://github.com/flemming-n-larsen/architecture-as-code-example/blob/44eeb3a97268ca0948c8d3e8d947dddc2fa1a20e/architecture/c4-views/order-service-component.md#architecture-diagram)

This shows the internal architecture: controllers, business logic, repositories, and event handlers.

### Level 4: Code and Deployment

We rarely create Code-level C4 diagrams — class/module diagrams are usually a better fit for code
structure. C4's Deployment diagrams, however, are useful for describing infrastructure topology,
deployment targets, network boundaries, and runtime concerns that matter to operations and SRE.

For this article we stop at the Component level and point readers to domain models for entity
and workflow details.

### Why Structurizr DSL?

Mermaid is great for quick diagrams and domain models. For C4 diagrams at scale, however,
Structurizr DSL provides stronger semantics and a smoother authoring workflow. Key benefits:

- **C4-native**: expresses C4 concepts directly, so intent maps cleanly to the model
- **Consistent styling**: generates professional, uniform diagrams with minimal manual layout
- **Flexible export**: export to SVG, PNG, PlantUML, or view diagrams in the
  [Structurizr Playground](https://playground.structurizr.com/)
- **Auto-layout**: keeps diagrams tidy as they grow, reducing manual positioning work

The DSL files live in your repository as plain text, just like Mermaid:

```
architecture/
├── c4-views/
│   ├── structurizr-dsl/
│   │   ├── system-context.dsl
│   │   ├── container.dsl
│   │   ├── order-service-component.dsl
│   │   └── payment-service-component.dsl
│   ├── images/
│   │   ├── system-context.svg
│   │   ├── container.svg
│   │   └── ...
│   ├── system-context.md
│   ├── container.md
│   └── README.md
```

You edit the `.dsl` files, generate `.svg` images, and embed them in Markdown wrappers for navigation.

> **Note on SVG:** SVG files are text-based (XML), scalable, and programmable (🤖❤️)—you can further customize them or
> embed them directly in your documentation. Unlike PNG (binary and pixelated), SVG diagrams look sharp at any size,
> take up minimal space, and integrate seamlessly with version control and AI tooling.

---

## The Complete Structure

Putting it all together, here's a production-grade architecture documentation structure:

```
architecture/
├── README.md                    # Overview and navigation
├── adr/                         # Architecture Decision Records
│   ├── README.md
│   ├── 0001-use-uuid-primary-keys.md
│   ├── 0002-microservices-architecture.md
│   └── 0003-event-driven-communication.md
├── c4-views/                    # C4 model views
│   ├── README.md
│   ├── structurizr-dsl/
│   │   ├── system-context.dsl
│   │   ├── container.dsl
│   │   ├── order-service-component.dsl
│   │   └── payment-service-component.dsl
│   ├── images/
│   │   └── *.svg
│   ├── system-context.md
│   ├── container.md
│   ├── order-service-component.md
│   └── payment-service-component.md
└── models/                      # Domain models and workflows
    ├── README.md
    ├── domain/
    │   ├── customer.md
    │   ├── order.md
    │   ├── product.md
    │   └── payment.md
    └── flows/
        ├── create-order.md
        ├── payment-processing.md
        └── inventory-management.md
```

### Navigation Pattern

Every README acts as a navigation hub:

- `/architecture/README.md` → Links to ADRs, C4 views, and models
- `/architecture/adr/README.md` → Status table of all decisions
- `/architecture/c4-views/README.md` → Links to all view levels
- `/architecture/models/README.md` → Links to domain and flows

> Tip: Put a `README.md` in every architecture folder — GitHub shows a folder's README when
> you open the folder, so the README acts as a small navigation hub that gives immediate
> context and links.

Cross‑link documents so readers can jump between related artifacts. For example:

```markdown
## Related documentation

- [Container view](/docs/architecture/c4-views/container.md) — shows this service in context
- [ADR‑0003: Event‑Driven Communication](/docs/architecture/adr/0003-event-driven-communication.md)
- [Order domain model](/docs/architecture/models/domain/order.md)
```

This pattern creates a simple, navigable web of knowledge.

---

## Other sections to consider as the architecture matures

- `requirements.md` — high‑level functional and non‑functional requirements
- `glossary.md` — domain terms and ubiquitous language
- `deployment/` — infrastructure-as-code, environment configuration, and deployment patterns
- `security/` — security policies, authentication/authorization patterns, and threat models
- `testing/` — architecture validation, fitness functions, and integration checks

These files are omitted from the condensed example to keep the repo focused, but they follow the same principles: plain
text, version‑controlled, AI‑readable, and modular.

---

## ⚙️ What's Next: Automation

Manually converting Structurizr DSL into SVGs doesn't scale. In the follow-up article I'll present a compact automation
pipeline that links two parts: GitHub Copilot's
**[Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)** to
parse Structurizr DSL and emit diagram files, and **[GitHub Actions](https://docs.github.com/en/actions)**
to run the generator on pushes and pull requests.

The pipeline will generate SVGs from DSL, refresh the Markdown wrappers that embed those diagrams, and (optionally)
commit the generated assets back to the repository. The result is straightforward: diagrams regenerate automatically as
the model evolves, keeping visuals and documentation aligned with minimal manual effort.

---

## 🔗 Connecting Architecture to Code

Architecture documentation only helps when it guides implementation. OpenSpec provides a practical feedback loop that
turns ADRs and C4 diagrams into verifiable specifications.

When your architecture lives as code, you can translate decisions and models into OpenSpec proposals and then validate
implementation against those proposals. A typical flow looks like this:

1. An ADR is approved (for example: "Use Event‑Driven Communication")
2. Create an OpenSpec change proposal describing *how* the decision will be implemented
3. Implement the change in the codebase
4. Run OpenSpec validation to confirm the code matches the proposal
5. Keep ADRs, specs, and code synchronized as the system evolves

This pattern works for both Greenfield projects (decide first, then implement) and Brownfield systems (implement
gradually and validate as you refactor). For example, after approving ADR‑0003 you might create an OpenSpec proposal
that specifies:

- which services publish which events
- the event schema and payload structure
- which services should subscribe to each event
- error-handling, retry, and delivery expectations

Developers implement the changes guided by both the ADR (the *why*) and the OpenSpec proposal (the *how*). OpenSpec then
verifies the implementation, and the results feed back into the architecture records, closing the loop:

> Architecture → OpenSpec → Code → Verified Against OpenSpec → Back to Architecture

For a detailed walkthrough of how the three pillars (ADRs, C4 diagrams, and domain models) come together in this
feedback loop, see
**[The Three-Pillar Approach](https://github.com/flemming-n-larsen/architecture-as-code-example/tree/44eeb3a97268ca0948c8d3e8d947dddc2fa1a20e#%EF%B8%8F-the-three-pillar-approach)**
and **[The Complete Loop](https://github.com/flemming-n-larsen/architecture-as-code-example/tree/44eeb3a97268ca0948c8d3e8d947dddc2fa1a20e#the-complete-loop)** in the
companion repository.

---

## The Complete Example

I've published a companion repository that contains the full, working example:

👉 **[architecture-as-code-example](https://github.com/flemming-n-larsen/architecture-as-code-example/tree/44eeb3a97268ca0948c8d3e8d947dddc2fa1a20e)**

The repo includes a ready-to-use set of artifacts you can fork or adapt:

- Three ADRs in MADR format
- Four C4 views (Structurizr DSL files and generated diagrams)
- Five domain models with Mermaid diagrams
- Three workflow/sequence diagrams
- A complete navigation structure and README

Clone the repository, adapt the content to your project, and make it yours.

---

## Final Thoughts

This approach is more than documentation — it's executable architecture.

Rather than storing decisions in wikis and diagrams in external tools, keep ADRs, C4 views,
and domain models as plain text in the repository. That makes architecture discoverable,
reviewable, versioned, and actionable by both people and AI.

Why this matters

### For Architects & Senior/Principal Developers

You can create a feedback loop that closes the gap between design and implementation:

1. **ADRs** capture decisions and rationale — the context teams and AI need to make changes safely.
2. **C4 diagrams** describe structure at multiple zoom levels, so intent is visible to the right audience.
3. **OpenSpec** converts decisions and models into machine-readable specifications.
4. **Code validation** checks the implementation against those specifications.
5. **Close the loop** — validation results and changes feed back into ADRs and specs so the architecture and code stay
   aligned.

This is: **Architecture → OpenSpec → Code → Verified Against OpenSpec → Back to Architecture** — instrumented for AI.

### AI as Your Architecture Assistant

When architecture is kept as plain text, AI agents can:

- Analyze ADRs and propose matching OpenSpec change proposals
- Compare code changes against architectural decisions and specifications
- Recommend architecture updates as the codebase evolves
- Auto-generate updated diagrams when models or DSL files change
- Keep documentation and implementation synchronized with minimal manual effort

Together these capabilities turn architecture from a passive artifact into an active, machine-readable specification
that guides development and verifies the implementation.

### The Scalability Problem Solved

As systems grow, traditional documentation approaches break down: wikis rot, diagram tools fall out of sync, decisions
vanish in PR noise, and new team members waste time hunting for context.

**Plain‑text "architecture as code" fixes this.**

When architecture lives in the repository—versioned with git, reviewed in PRs, and searchable by humans and AI—your
documentation scales with the system. New services, decisions, models, and diagrams become first‑class, linkable
artifacts that evolve alongside the codebase.

### The Next Frontier

This is just the beginning. With
**[Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)** and automation via
**[GitHub Actions](https://docs.github.com/en/actions)**, you can:

- Generate C4 diagrams (SVG) automatically on every PR or merge
- Validate code continuously against OpenSpec proposals
- Surface architecture improvements from code patterns and tests
- Keep architecture and implementation continuously in sync

Teams that adopt this pipeline gain a practical edge: architecture becomes executable, auditable, and self‑maintaining.

Try it: feed your ADRs and C4 models into OpenSpec, run the automation, and watch what happens when architecture is code
that AI can reason about.

That's the future of executable architecture. 🚀

---

## 📚 References and Further Reading

### Architecture Decision Records (ADRs)
- [ADR.github.io](https://adr.github.io/) — Official ADR documentation and templates
- [MADR Template](https://adr.github.io/madr/) — Markdown Architectural Decision Records specification
- [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) — Original Michael Nygard article

### C4 Model
- [C4 Model](https://c4model.com/) — Official C4 model documentation and examples
- [Structurizr](https://structurizr.com/) — C4 tooling and DSL documentation
- [Structurizr DSL Language Reference](https://github.com/structurizr/dsl/wiki/Language-Reference)
- [Structurizr Playground](https://playground.structurizr.com/) — Online editor for DSL files

### Domain-Driven Design & Models
- [Domain-Driven Design](https://www.domainlanguage.com/ddd/) — Eric Evans' foundational work
- [Ubiquitous Language](https://martinfowler.com/bliki/UbiquitousLanguage.html) — Martin Fowler's explanation

### Mermaid Diagrams
- [Mermaid.js](https://mermaid.js.org/) — Diagram syntax and examples
- [Mermaid in Markdown](https://mermaid.js.org/intro/) — Embedding diagrams in Markdown

### Specification & Validation
- [OpenSpec](https://openspec.dev/) — Machine-readable specifications for code validation
- [Fitness Functions](https://www.thoughtworks.com/insights/articles/fitness-function-driven-development) — Verifying architecture through automated checks

### Tools & Automation
- [GitHub Actions](https://docs.github.com/en/actions) — CI/CD automation
- [GitHub Copilot Agent Skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills) — Custom agents for code generation

---

## 📖 Navigation

← **[Previous: Keep Your AI and Architecture-Design in Sync](../A2.%20Keep%20Your%20AI%20and%20Architecture-Design%20in%20Sync/README.md)** (Part 2)

This completes the Architecture as Code series. For more details, explore the companion repository below.

---

**Previous Articles:**

← [Keep Your Architecture Diagrams in Code, Not in Tools](../A1.%20Keep%20Your%20Architecture%20Diagrams%20in%20Code,%20Not%20in%20Tools/README.md) ([Hashnode](https://architecture-as-code.hashnode.dev/keep-your-architecture-diagrams-in-code-not-in-tools))
← [Keep Your AI and Architecture-Design in Sync](../A2.%20Keep%20Your%20AI%20and%20Architecture-Design%20in%20Sync/README.md) ([Hashnode](https://architecture-as-code.hashnode.dev/keep-your-ai-and-architecturedesign-in-sync))

**Repository:** [architecture-as-code-example](https://github.com/flemming-n-larsen/architecture-as-code-example/tree/44eeb3a97268ca0948c8d3e8d947dddc2fa1a20e)

#ArchitectureAsCode #ADR #C4Model #Structurizr #SoftwareArchitecture #DeveloperTools #TechWriting
