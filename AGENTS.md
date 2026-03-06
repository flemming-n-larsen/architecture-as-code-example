# AI Agent Guidelines

This file is the entry point for AI agents working with this codebase. It links to focused instruction files under `.ai/` — read the relevant ones for the task at hand.

## Instruction Index

| Topic                 | File                                           | When to read                                   |
|-----------------------|------------------------------------------------|------------------------------------------------|
| Code Style            | [.ai/code-style.md](.ai/code-style.md)         | Writing or reviewing any code                  |
| Architecture Patterns | [.ai/architecture.md](.ai/architecture.md)     | Adding features, structuring modules           |
| Testing               | [.ai/testing.md](.ai/testing.md)               | Writing or modifying tests                     |
| Documentation         | [.ai/documentation.md](.ai/documentation.md)   | Adding public APIs or referencing specs        |
| Business Logic        | [.ai/business-logic.md](.ai/business-logic.md) | Implementing orders, payments, or domain rules |
| Performance           | [.ai/performance.md](.ai/performance.md)       | Database queries, caching, list endpoints      |
| Security              | [.ai/security.md](.ai/security.md)             | Input handling, auth, external calls           |

## Key Source-of-Truth Locations

- `/docs/architecture/` — C4 diagrams, domain models, ADRs, flows
- `/openspec/specs/` — authoritative business rules per domain
- `/openspec/changes/` — in-flight and archived change proposals

## When in Doubt

1. Check existing code for similar implementations
3. Consult `/docs/architecture` for structural patterns
2. Consult `/openspec` for business rules
4. Keep it simple — don't over-engineer
