# 📋 Think in Specs — The Modern Developer's Mindset

**Developing Software in the Agentic AI Age**

---

👉 [Read on Hashnode](https://architecture-as-code.hashnode.dev/think-in-specs-the-modern-developers-mindset)

---

This article builds on the foundation from the previous 'Architecture as Code' articles:

- [Keep Your Architecture Diagrams in Code, Not in Tools](https://architecture-as-code.hashnode.dev/keep-your-architecture-diagrams-in-code-not-in-tools)
- [Keep Your AI and Architecture-Design in Sync](https://architecture-as-code.hashnode.dev/keep-your-ai-and-architecturedesign-in-sync)
- [Architecture as Code in Practice](https://architecture-as-code.hashnode.dev/architecture-as-code-in-practice)

---

## 🎯 TL;DR

Your job is still software development — **just without the coding.**

The previous articles showed *how* to store architecture as code (AoC), *how* to design features before writing code ([SDD](https://en.wikipedia.org/wiki/Spec-driven_development)), and *how* to use agentic AI to do the implementation. This article is about the mindset that ties it all together: **nothing has fundamentally changed about how we develop software — we still work across architecture, design, and implementation.** We have simply stopped being required to write the production code ourselves.

---

## 🧭 The Three Layers (Still the Same as Always)

Software development has always moved through three layers:

```mermaid
graph TD
    A["🏛️ Architecture<br><i>Why decisions were made.<br>ADRs, C4 diagrams, domain models, flows.</i>"]
    B["📋 Design<br><i>How we intend to build it.<br>Specs, acceptance criteria, tasks.</i>"]
    C["⚙️ Implementation<br><i>The actual code.<br>Written by an agentic AI.</i>"]

    A --> B
    B --> C
    C -->|"Feedback & new decisions"| A
```

In the agentic AI age, these map directly to:

| Layer              | Practice                      | Tooling                                             |
|--------------------|-------------------------------|-----------------------------------------------------|
| **Architecture**   | Architecture as Code (AoC)    | Markdown, Mermaid, [ADRs](https://adr.github.io/madr/), [C4 Views](https://c4model.com/) |
| **Design**         | [Spec-Driven Development (SDD)](https://en.wikipedia.org/wiki/Spec-driven_development) | [OpenSpec](https://openspec.dev/), proposal.md, design.md, tasks.md, spec.md |
| **Implementation** | Agentic AI                    | Claude Code, GitHub Copilot, Cursor…                |

The key insight: **AI is excellent at implementation. Humans are still required for architecture and design.** Feed the AI well-structured context, and it will reward you with code that respects your intent.

> ⚠️ **A word of honesty:** LLMs are not truly *intelligent* — they are extraordinarily capable automation engines. They recognize patterns, complete instructions, and generate plausible output at scale. That is exactly why they excel at implementation: code is highly structured and pattern-rich. Architecture and design, by contrast, require *judgment*, *intent*, and *accountability* — things that still require a human in the loop.

---

## 🕰️ The Role Has Always Evolved

This is not the first time the developer's job has changed. It has been changing continuously:

| Era     | Tool / Shift                 | What changed                                    |
|---------|------------------------------|-------------------------------------------------|
| 1940s   | Plugboards & paper tape      | Humans *were* the computers                     |
| 1950s   | Assembly & FORTRAN           | Abstracted away machine code                    |
| 1970s   | Structured languages (C)     | Abstracted away hardware-specific assembly      |
| 1980s   | IDEs & debuggers             | Integrated the edit-compile-debug toolchain     |
| 1990s   | OOP & version control        | Encapsulated complexity; tracked change history |
| 2000s   | Managed runtimes (.NET, JVM) | Abstracted away memory management               |
| 2010s   | Cloud, containers, CI/CD     | Abstracted away infrastructure                  |
| 2020s   | AI code completion (Copilot) | Abstracted away boilerplate                     |
| **Now** | **Agentic AI**               | **Abstracted away the coding**                  |

Each step made developers *more powerful*, not obsolete. Agentic AI is no different — it just raises the bar for what "doing the work" means. The developers who thrive are the ones who double down on architecture and design, because that is what the AI cannot do for you.

As AI automation continues to advance, the AI's share of the implementation work will only grow. But developers will likely remain in the loop — not because the AI can execute, but because **intent, judgment, and accountability** are human responsibilities. An LLM has no stake in the outcome. You do.

---

## 🗂️ ADRs as Machine-Readable Intent

Agentic AI thrives on **context** and **intent** — both of which are usually buried in a developer's head rather than in the source code. [Architectural Decision Records (ADRs)](https://adr.github.io/madr/) turn that tribal knowledge into machine-readable instructions.

Here is why they are a game-changer for autonomous agents:

| Benefit                 | Without ADRs                                | With ADRs                                                |
|-------------------------|---------------------------------------------|----------------------------------------------------------|
| **Guardrails**          | Agent picks any library or pattern it likes | Agent stays within explicitly accepted decisions         |
| **Refactoring safety**  | Agent "fixes" code that was intentional     | Agent understands the *why* and leaves it alone          |
| **Reasoning alignment** | Agent guesses the rationale                 | Agent reads the logical derivation                       |
| **Impact analysis**     | Agent proposes changes blindly              | Agent cross-references its plan against accepted records |
| **ADR generation**      | Written manually, often skipped             | Agent drafts the ADR from the PR diff                    |

> **Bottom line:** ADRs turn "tribal knowledge" into "machine-readable intent."

See [Architecture as Code in Practice](../3.%20Architecture%20as%20Code%20in%20Practice/README.md) for how to structure ADRs alongside C4 diagrams and domain models in your repository.

---

## 📐 Spec-Driven Development (SDD)

[SDD](https://en.wikipedia.org/wiki/Spec-driven_development) means writing a spec that captures design intent *before* any code is written. The agentic AI then uses that spec as its instruction manual.

A change proposal (e.g. using [OpenSpec](https://openspec.dev/)) contains:

- **`proposal.md`** — the what, why, and acceptance criteria
- **`design.md`** — the detailed technical design for this change
- **`specs/`** — per-feature specifications (referenced, never duplicated from architecture)
- **`tasks.md`** — the ordered list of implementation tasks

The workflow is deliberately front-loaded:

```mermaid
graph TD
    P["👤 + 🤖 Write change proposal<br><i>(strong AI in plan mode)</i>"]
    R["👤 Review & refine<br><i>(human judgment — don't skip this)</i>"]
    I["🤖 Implement task by task<br><i>(regular AI)</i>"]
    A["🤖 Archive & merge delta into specs<br><i>(regular AI)</i>"]

    P --> R --> I --> A
    A -->|"Next change"| P
```

> 💡 **Tip:** Always run spec creation with the AI in **plan mode** — it will ask about anything ambiguous rather than guess. Tell it to keep specs DRY and to-the-point.

> 💡 **Tip:** Specs should *reference* architecture documents (ADRs, domain models), never duplicate them. Architecture changes; references stay valid. Duplication drifts.

### Why the upfront cost is worth it

- **Forces clarity before commitment** — design issues surface when they are inexpensive to fix, not after implementation
- **AI as a nitpicker** — plan-mode AI exposes ambiguity and underspecified edge cases at review, not during testing
- **Documentation by construction** — the spec *is* the design document; it exists before the code does
- **Change proposals replace code reviews** — reviewers verify the proposal is sound and internalize the design; once the spec is approved and the AI has implemented it, a human code review of the generated code adds little additional confidence

> In short: SDD moves the hard thinking — and the human judgment — to the moment when it has the highest leverage.

For the full OpenSpec workflow (steps, prompts, and a worked example), see [Keep Your AI and Architecture-Design in Sync](https://architecture-as-code.hashnode.dev/keep-your-ai-and-architecturedesign-in-sync).

---

## 🔁 The Complete Workflow

AoC + SDD + Agentic AI form a closed loop:

```mermaid
graph TD
    AoC["🏛️ Architecture as Code<br>ADRs · C4 · Domain models · Flows"]
    SDD["📋 Spec-Driven Development<br>Change proposals · Specs · Tasks"]
    AI["⚙️ Agentic AI<br>Implementation · Archiving"]
    Repo["📜 Mono-repo<br>Single source of truth"]

    Repo --> AoC
    Repo --> SDD
    AoC -->|"Context & constraints"| SDD
    SDD -->|"Intent & tasks"| AI
    AI -->|"Archived delta"| Repo
```

One true benefit of this approach: **documentation must be written up front.** The AI needs accurate, up-to-date context — the same way a new team member would. Outdated or missing documentation produces poor AI output for the same reason it produces poor human output.

---

## 🧪 But What About AI Code Quality?

A common concern: *"AI-generated code is unreliable — how can you trust it?"*

Neither humans nor LLMs produce deterministic code — and that was never the goal. The goal is code that fulfills the **intended behavior** and meets the **acceptance criteria**. LLMs will make mistakes, just like humans do. But *why* do mistakes happen in the first place? Typically: wrong information, missing information, or weak information. That is exactly the problem that specs solve — and they solve it for human developers too.

**This entire spec-driven process works without AI.** Good documentation has always reduced defects and miscommunication. AI simply makes it more valuable, because now *two* consumers read your specs: humans and machines.

### How you verify correctness

- **Acceptance Testing (ATDD/BDD)** — Define tests that cover every acceptance criterion *before* implementation. If the tests pass, the code fulfills its intent — regardless of who or what wrote it. See [Acceptance Testing (CD Training)](https://courses.cd.training/pages/acceptance-testing) for a practical introduction.
- **Normal review process** — You can still review AI-generated code the same way you review human-written code. You can also correct specs during implementation, the same way you would update Jira tickets. There is no difference.
- **Iterate on specs** — Specs are living documents. When implementation reveals a gap, update the spec. The feedback loop is the same as it has always been.

### What the research says

A peer-reviewed study co-authored by David Farley — *"Echoes of AI: Investigating the Downstream Effects of AI Assistants on Software Maintainability"* (2025) — found **no significant difference** in maintenance cost between AI-assisted and human-generated code. When used by experienced developers, AI-assisted code actually showed slightly better code health and faster initial development ([ResearchGate](https://www.researchgate.net/publication/393261441_Echoes_of_AI_Investigating_the_Downstream_Effects_of_AI_Assistants_on_Software_Maintainability)).

MIT researchers have also shown that structured context and better specifications directly improve AI code accuracy — which is exactly what spec-driven development provides ([MIT News, 2025](https://news.mit.edu/2025/making-ai-generated-code-more-accurate-0418)).

> Using architecture as code and spec-driven development with AI is not a "dream." It is our new reality. The dream is thinking software development will not evolve with AI.

---

## 🙏 Acknowledgments

Special thanks to **[David Farley](https://www.youtube.com/@ContinuousDelivery)** — one of the most insightful voices in modern software engineering. His peer-reviewed research *["Echoes of AI: Investigating the Downstream Effects of AI Assistants on Software Maintainability"](https://www.researchgate.net/publication/393261441_Echoes_of_AI_Investigating_the_Downstream_Effects_of_AI_Assistants_on_Software_Maintainability)* (2025) was a key reference for this article, providing empirical evidence that well-structured AI-assisted development does not compromise code quality.

Thanks also to the **[Modern Software Engineering](https://www.youtube.com/watch?v=b9EbCb5A408)** YouTube channel for the excellent video walkthrough of the research findings. David's talks — including those on [GOTO Conferences](https://www.youtube.com/@ABORGJAMADO) — consistently deliver relevant, practical insights that I wholeheartedly encourage every developer to watch. I hope referencing his work here does it justice — it has deeply influenced the thinking behind this article.

---

## 🔗 References

| Resource                                                                                                                                                                         | Description                                                                                       |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| [OpenSpec](https://openspec.dev/)                                                                                                                                                | The open specification format used for change proposals and spec-driven workflows in this article |
| [Spec-Driven Development — Wikipedia](https://en.wikipedia.org/wiki/Spec-driven_development)                                                                                     | Overview of the SDD methodology                                                                   |
| [MADR — Markdown Architectural Decision Records](https://adr.github.io/madr/)                                                                                                    | A lightweight ADR template format designed to be readable by both humans and machines             |
| [C4 Model](https://c4model.com/)                                                                                                                                                 | The C4 approach to visualizing software architecture (Context, Containers, Components, Code)      |
| [The C4 Model for Visualizing Software Architecture](https://leanpub.com/the-c4-model-for-visualising-software-architecture)                                                     | Simon Brown's book on the C4 model                                                                |
| [Structurizr DSL](https://structurizr.com/dsl)                                                                                                                                   | Domain-specific language for defining C4 architecture models as code                              |
| [Architecture Decision Records (ADR GitHub org)](https://adr.github.io/)                                                                                                         | Community resources, tooling, and templates for ADRs                                              |
| [thoughtworks.com — Evolutionary Architecture](https://www.thoughtworks.com/radar/techniques/evolutionary-architecture)                                                          | Background on treating architecture as a living, evolving artifact                                |
| [Echoes of AI — ResearchGate](https://www.researchgate.net/publication/393261441_Echoes_of_AI_Investigating_the_Downstream_Effects_of_AI_Assistants_on_Software_Maintainability) | Peer-reviewed study on AI-assisted code maintainability (Farley et al., 2025)                     |
| [Making AI-generated code more accurate — MIT News](https://news.mit.edu/2025/making-ai-generated-code-more-accurate-0418)                                                       | MIT research on improving AI code accuracy through structured specifications                      |
| [Acceptance Testing — CD Training](https://courses.cd.training/pages/acceptance-testing)                                                                                         | Practical introduction to ATDD and BDD for verifying acceptance criteria                          |
| [Modern Software Engineering — YouTube](https://www.youtube.com/watch?v=b9EbCb5A408)                                                                                             | Video walkthrough of the research findings on AI-assisted code quality                            |

---

## 📖 Navigation

← **[Previous: Architecture as Code in Practice](https://architecture-as-code.hashnode.dev/architecture-as-code-in-practice)**

→ **[Up next: Spec-Driven Test Strategy: Turning Acceptance Criteria into Tests](https://github.com/flemming-n-larsen/architecture-as-code-example/blob/main/.articles/5.%20Spec-Driven%20Test%20Strategy%20-%20Turning%20Acceptance%20Criteria%20into%20Tests/README.md)**

---

**Repository:** [architecture-as-code-example](https://github.com/flemming-n-larsen/architecture-as-code-example/)

---

#SpecDrivenDevelopment #ArchitectureAsCode #AgenticAI #SoftwareArchitecture #DeveloperMindset #TechWriting #OpenSpec
