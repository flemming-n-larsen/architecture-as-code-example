# 💡 Article Ideas

Future articles for the **Architecture as Code** series.

---

## 5. Vibe Coding vs. Professional AI Development: Know When to Throw It Away

**Status:** Idea

**Core idea:** AI has made prototyping so fast and cheap that the exploration phase is now nearly free. That's genuinely valuable — but vibe coding is not production software. The gap between "it works on my machine" and "it's maintainable in 18 months" is exactly where Architecture as Code and Spec-Driven Development live.

**The spectrum:**

| Mode                | Goal                | Lifespan | Needs                          |
|---------------------|---------------------|----------|--------------------------------|
| Vibe Coding         | Explore / prototype | Days     | Nothing — throw it away        |
| Professional AI dev | Production software | Years    | Architecture, specs, standards |

**Topics to cover:**

- What vibe coding actually is — and why it's genuinely useful for exploration and prototyping
- Why it breaks down at scale: no architecture guardrails, no specs, no maintainability
- The "legacy code at scale" risk: AI will happily generate unmaintainable code if you let it (ref: Dave Farley & Steve Smith)
- The prototype-to-production trap: when teams ship vibe code because "it works"
- How AoC + SDD is the professional counterpart — not the enemy of speed, but the enabler of sustained speed
- The honest message: vibe coding isn't wrong — it's just not the whole job

**Inspiration:** Dave Farley & Steve Smith discussion on the Modern Software Engineering channel — distinguishing citizen developers using AI for personal scripts vs. professional engineering at enterprise scale.

---

## 6. Spec-Driven Test Strategy: Turning Acceptance Criteria into Tests

**Status:** Next up (referenced in [article 4](4.%20Think%20in%20Specs%20-%20The%20Modern%20Developers%20Mindset/README.md))

**Core idea:** Acceptance criteria written in specs are not just documentation — they are test definitions waiting to be executed. This article shows how to go from spec → acceptance test → implementation, closing the verification loop.

**Topics to cover:**

- ATDD / BDD as a natural extension of SDD
- Mapping acceptance criteria (from `proposal.md` / `spec.md`) directly to test cases
- Who writes the tests — human, AI, or both?
- The role of the spec as the single source of truth for "done"
- Gherkin / plain-language specs vs. code-level test frameworks
- How agentic AI can generate test scaffolding from specs
- When to test manually vs. automate — and how specs help decide
- Continuous Delivery angle: tests as the deployment gate, not code review
- Reference: [Acceptance Testing — CD Training](https://courses.cd.training/pages/acceptance-testing)
- Reference: David Farley's work on ATDD and Continuous Delivery

---

## 7. AI Review Personas: Thinking Partners from First Principles

**Status:** Idea

**Core idea:** Create AI "personas" that embody the principles of well-known software thinkers — and use them as review lenses for architecture decisions, specs, and code. Not as gimmicks, but as structured thinking tools.

**The concept:**

- Thinkers like Martin Fowler, David Farley, Kent Beck, Eric Evans, and Gregor Hohpe have large, well-documented bodies of work — books, articles, talks, blog posts
- Their principles are clear, consistent, and well-articulated — exactly what makes a good AI persona
- Instead of asking "is this good?", you ask: *"What would Farley say about this deployment strategy?"* or *"Does this violate Fowler's refactoring principles?"*
- It's a structured rubber duck — but one that thinks in Continuous Delivery, DDD, or XP

**Possible personas:**

| Persona       | Lens                                             | Source material                  |
|---------------|--------------------------------------------------|----------------------------------|
| Martin Fowler | Refactoring, patterns, evolutionary architecture | Refactoring, PoEAA, bliki        |
| David Farley  | Continuous Delivery, modern software engineering | CD book, Modern SE book, YouTube |
| Kent Beck     | TDD, simplicity, XP values                       | TDD by Example, XP Explained     |
| Eric Evans    | Domain-Driven Design, bounded contexts           | DDD book                         |
| Gregor Hohpe  | Integration patterns, architecture elevator      | EIP, Software Architect Elevator |

**Your own persona — AoC-SDD:**

- Architecture-as-code + spec-driven development + agentic AI workflows
- The combination is specific and opinionated, even if individual ideas build on existing work
- Could be captured as a reusable agent instruction (like `AGENTS.md`)

**Topics to cover:**

- How to build a persona: system prompts, custom agents, or `AGENTS.md`-style instructions
- Practical workflow: "Run this ADR past the Farley lens and the Fowler lens"
- When persona review adds value vs. when it's noise
- The line between tribute and parody — keep it respectful and useful
- Could these personas become open-source community contributions?
- Building your own persona: documenting your principles clearly enough for an AI to apply them

**Honest tensions to address:**

- The architecture design space (monolith vs. microservices, layered vs. ports-and-adapters, etc.) is finite. LLMs that already generate code will likely generate specs, ADRs, and architecture decisions too — and possibly well.
- If the value of specs is in *judging* them rather than *producing* them, this article needs to be honest about how much judgment actually remains uniquely human — and for how long.
- Whether AI commoditizes all knowledge work, not just coding, is a real open question. This article should engage with it honestly rather than assume developers will always be needed in their current role.

---

> **Note:** This is a personal article series published on GitHub and [Hashnode](https://hashnode.com/), and referenced from LinkedIn — please don't submit PRs directly against articles.
> Got an idea or want to collaborate on a future one? Reach out at **flemming.n.larsen (at) gmail.com**.




