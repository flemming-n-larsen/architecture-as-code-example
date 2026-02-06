# OpenSpec

This directory contains specifications for the e-commerce platform using the **OpenSpec** approach for spec-driven development with AI agents.

## What is OpenSpec?

**OpenSpec** is a specification methodology designed for **spec-driven development with AI**. It provides a structured approach to writing specifications that AI agents can understand, validate, and use to generate implementations.

**Key Benefits:**
- AI agents can read and understand specifications
- Enables spec-first development workflow with AI assistance
- Provides clear, testable requirements for AI code generation
- Supports iterative refinement through change proposals
- Maintains single source of truth for system behavior

**Learn More:**
- 🌐 [openspec.dev](https://openspec.dev/)
- 🐙 [GitHub: Fission-AI/OpenSpec](https://github.com/Fission-AI/OpenSpec)

## Directory Structure

### 📁 `/specs` - Current Specifications

Active specifications that define the current state of the system. These are the source of truth for system behavior.

| Specification | Domain | Description |
|:--------------|:-------|:------------|
| [customer/spec.md](specs/customer/spec.md) | Customer Management | Customer registration, authentication, profile management, account status |
| [order/spec.md](specs/order/spec.md) | Order Management | Order lifecycle, state machine (pending → confirmed → shipped → delivered), cancellation rules |
| [payment/spec.md](specs/payment/spec.md) | Payment Processing | Payment authorization, retry logic, refund processing |

### 📁 `/changes` - Change Proposals

Proposed and completed changes to the system. Active proposals represent work in progress; archived proposals are completed features.

#### Active Proposals

| Proposal | Status | Description |
|:---------|:-------|:------------|
| [loyalty-points/](changes/loyalty-points/) | 🚧 Active | Customer loyalty points system - earn points on orders, redeem for discounts |

**Contents:**
- [proposal.md](changes/loyalty-points/proposal.md) - Detailed change proposal
- [tasks.md](changes/loyalty-points/tasks.md) - Implementation tasks
- [specs/customer/spec.md](changes/loyalty-points/specs/customer/spec.md) - Spec changes for Customer domain

#### Archived Proposals

| Proposal | Completed | Description |
|:---------|:----------|:------------|
| [user-registration/](changes/archived/user-registration/) | ✅ Dec 2025 | Enhanced registration with email verification, password validation, spam prevention |

## How to Use

### For AI Agents

When implementing features:
1. Reference the relevant spec in `/specs` for current system behavior
2. Check `/changes` for any active proposals that modify that behavior
3. Follow the scenarios as test cases for implementation
4. Ensure all business rules are enforced in code

### For Developers

1. **Read specs first** - Understand requirements before coding
2. **Check active changes** - See what's being added or modified
3. **Use scenarios as tests** - Convert scenarios into acceptance tests
4. **Update specs when complete** - Keep specs in sync with implementation

### Creating a Change Proposal

1. Create a new directory under `/changes/<feature-name>/`
2. Add `proposal.md` with motivation, requirements, and business rules
3. Add `tasks.md` with implementation checklist
4. Create `specs/` subdirectory with specification deltas
5. Once complete, move to `/changes/archived/` and update main specs

## Related Documentation

- **[AGENTS.md](../AGENTS.md)** - Guidelines for AI agents working with this codebase
- **[Architecture](../architecture/)** - System architecture, ADRs, C4 diagrams
- **[Domain Models](../architecture/models/)** - Entity definitions and relationships
- **[User Stories](../docs/user-stories/)** - User-facing feature descriptions

