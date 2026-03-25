# 💡 Article Ideas

Future articles for the **Architecture as Code** series.

---

## Vibe Coding vs. Professional AI Development: Know When to Throw It Away

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

## Spec-Driven Test Strategy: Turning Acceptance Criteria into Tests

**Status:** Drafted in repo ([article 5](5.%20Spec-Driven%20Test%20Strategy%20-%20Turning%20Acceptance%20Criteria%20into%20Tests/README.md); referenced in [article 4](4.%20Think%20in%20Specs%20-%20The%20Modern%20Developers%20Mindset/README.md))

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

## Expert Knowledge as Code: Portable AI Lenses

**Status:** Idea

**Core idea:** Specs tell the AI *what to build this time*. Lenses tell the AI *how we build things here, always*. Without a
knowledge layer, every spec starts from zero and the AI carries no memory across projects. Expert Knowledge as Code encodes
expert knowledge — patterns, constraints, conventions, architectural judgment — as portable, versioned lens files that
travel with you across projects and AI tools.

**Credit:** The specs-vs-knowledge distinction was sharpened by a conversation with Totto, who pointed out that specs
alone leave the AI without memory across projects. The framing stuck — but the terminology and approach here are my own.

**The two layers:**

| Layer  | What it encodes                                       | Scope               | Changes           | Example files                        |
|--------|-------------------------------------------------------|---------------------|-------------------|--------------------------------------|
| Specs  | What to build — intent, acceptance criteria, tasks    | Per feature/change  | Every sprint      | `proposal.md`, `spec.md`, `tasks.md` |
| Lenses | How we build — patterns, conventions, expert judgment | Across all projects | Slowly, by choice | `AGENTS.md`, `.ai/*.md`, lens files  |

**The key insight:** Specs give you faster execution per task. A knowledge layer gives you
compounding returns across everything. Both layers matter — and they are complementary, not competing.

**What counts as a "lens file"?**

- **Team conventions:** Code style, naming rules, error handling patterns, testing strategy (`AGENTS.md`, `.ai/`)
- **Architectural guardrails:** "We use ports-and-adapters", "No synchronous cross-service calls", ADR summaries
- **Expert lenses:** Principles from well-known thinkers, encoded as review instructions

**Expert lenses — thinking partners from first principles:**

Thinkers like Martin Fowler, David Farley, Kent Beck, Eric Evans, Rich Hickey, and Gregor Hohpe have large,
well-documented bodies of work. Their principles are clear, consistent, and well-articulated — exactly what makes a good
lens file. The names below are used as *inspiration*, not endorsements — the lens files themselves encode principles, not
personas. Instead of asking "is this good?", you ask: *"Review this against the Farley lens"* or *"Does this violate
Fowler's refactoring principles?"*

| Expert lens   | Focus                                            | Source material                  |
|---------------|--------------------------------------------------|----------------------------------|
| Martin Fowler | Refactoring, patterns, evolutionary architecture | Refactoring, PoEAA, bliki        |
| David Farley  | Continuous Delivery, modern software engineering | CD book, Modern SE book, YouTube |
| Kent Beck     | TDD, simplicity, XP values                       | TDD by Example, XP Explained     |
| Eric Evans    | Domain-Driven Design, bounded contexts           | DDD book                         |
| Rich Hickey   | Simplicity, data-oriented design, immutability   | Simple Made Easy, Clojure talks  |
| Gregor Hohpe  | Integration patterns, architecture elevator      | EIP, Software Architect Elevator |

**Your own lens file — AoC-SDD:**

- Architecture-as-code + spec-driven development + agentic AI workflows
- The combination is specific and opinionated, even if individual ideas build on existing work
- Already partially captured in `AGENTS.md` and `.ai/` — this article makes the pattern explicit and portable

**Topics to cover:**

- The specs vs. lenses distinction — why you need both layers
- What a lens file looks like in practice: structure, format, versioning
- How lens files travel: across repos, across AI tools (Copilot, Cursor, Claude, etc.)
- Expert lenses as lens files — practical workflow: *"Run this ADR past the Farley lens and the Fowler lens"*
- Building your own lens file: documenting your principles clearly enough for an AI to apply them
- Could expert lenses become open-source community contributions?
- When lens-based review adds value vs. when it is noise
- The line between tribute and parody with expert lenses — keep it respectful and useful

**Honest tensions to address:**

- The architecture design space (monolith vs. microservices, layered vs. ports-and-adapters, etc.) is finite. LLMs that
  already generate code will likely generate specs, ADRs, and architecture decisions too — and possibly well.
- If the value of specs is in *judging* them rather than *producing* them, this article needs to be honest about how much
  judgment actually remains uniquely human — and for how long.
- Whether AI commoditizes all knowledge work, not just coding, is a real open question. This article should engage with
  it honestly rather than assume developers will always be needed in their current role.
- "Expert Knowledge as Code" is a framing, not an established methodology — this article contributes a new lens (pun
  intended) on how to structure AI knowledge, not a textbook term. Be upfront about that.

---

> **Note:** This is a personal article series published on GitHub and [Hashnode](https://hashnode.com/), and referenced from LinkedIn — please don't submit PRs directly against articles.
> Got an idea or want to collaborate on a future one? Reach out at **flemming.n.larsen (at) gmail.com**.
