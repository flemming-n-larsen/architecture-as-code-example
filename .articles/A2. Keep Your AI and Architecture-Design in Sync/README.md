# Keep Your AI and Architecture/Design in Sync

**Spec-driven development for AI agents that respect your design decisions**

---

👉 [Read on Hashnode](https://architecture-as-code.hashnode.dev/keep-your-ai-and-architecturedesign-in-sync)

---

**📖 Prerequisites:** This article builds directly on the concepts from the first article:
[Keep Your Architecture Diagrams in Code, Not in Tools](../A1.%20Keep%20Your%20Architecture%20Diagrams%20in%20Code,%20Not%20in%20Tools/README.md)
([also on Hashnode](https://architecture-as-code.hashnode.dev/keep-your-architecture-diagrams-in-code-not-in-tools)).
If you haven't read it yet, start there first—it establishes the foundation of architecture-as-code that this article
extends.

---

In my previous article, I showed
how [keeping architecture diagrams in code](https://architecture-as-code.hashnode.dev/keep-your-architecture-diagrams-in-code-not-in-tools)
creates a foundation for AI-readable documentation. Architecture diagrams as Markdown + Mermaid give AI agents the
structural view of your system.

But there's still a gap.

Your AI coding assistant can see that you have an `Order` entity with a state machine, but it doesn't understand the
business rules, validation logic, or why certain design decisions were made. When you ask it to implement a new feature,
it generates code that compiles but potentially violates your architectural patterns and constraints.

**This is the "internal view" problem:** AI agents need more than structure—they need the specifications that capture
your design intent, business rules, and the reasoning behind architectural decisions.

**Note:** This article introduces the concept of spec-driven development (SDD) and demonstrates my personal workflow
using OpenSpec as an example. It's not a comprehensive OpenSpec tutorial—for that, refer to
the [official documentation](https://github.com/Fission-AI/OpenSpec). Instead, I'll show you the principles and how I
apply them in practice.

---

## Terminology: AI Agents Used in This Article

Before we dive in, let's clarify the AI terminology used throughout this article:

### What is an Agentic AI?

When I refer to an **AI assistant** or **AI agent** in this article, I mean an **agentic AI**—an AI that can:

* **Execute multi-step tasks** autonomously
* **Read and write files** in your codebase
* **Run terminal commands**
* **Make decisions** based on context and instructions

Examples include **Claude Code**, **GitHub Copilot (agent mode)**, **Cursor**, **Windsurf**, and similar coding
assistants that go beyond simple autocomplete.

### Strong AI vs Regular AI

I distinguish between two categories based on capability and cost:

**🧠 Strong AI**
- **Description:** Premium, frontier-class models with advanced reasoning and high-level strategy
- **Examples:** Claude 4.5 Opus, Gemini Ultra
- **Use For:** Spec creation, architectural planning, requirement analysis

**⚡ Regular AI**
- **Description:** High-performance coding assistants, cost-effective for implementation
- **Examples:** Claude 4.5 Sonnet, GPT-5.2, Gemini 3 Pro
- **Use For:** Code implementation, task execution, archiving

**Why the distinction?** **Strong AI** models excel at understanding complex requirements and reasoning about edge
cases—but they are more resource-intensive. **Regular AI** models are incredibly fast and perfectly capable of
implementing well-defined tasks from clear specifications. Use **strong AI** for planning, and **regular AI** for
execution.

From this point forward, I'll use only these terms: **strong AI** and **regular AI**.

---

## The Sync Problem

Here's what happens when you use AI agents ad-hoc, without specifications:

1. **You ask your AI assistant to add a "cancel order" feature**
2. **It generates code that works functionally** ✅
3. **But it bypasses your existing state validation**
4. **And ignores your refund policy business rules** ❌
5. **The code compiles, tests pass, but your architecture degrades** ⚠️

The AI agent did what you asked, but it lacked the "internal view" of your system's design decisions. Without
specifications, AI agents work in isolation from your architectural intent.

**The solution:** spec ↔ code synchronization.

When you provide AI agents with both architecture diagrams AND specifications, they have the complete context needed to
generate code that respects your design patterns, business rules, and architectural boundaries.

---

## OpenSpec vs OpenAPI (and Other Alternatives)

First, let's clear up a common confusion with the terms:

- ❌ **OpenAPI** = REST API specification format (Swagger)
- ✅ **OpenSpec** = Software development methodology with specifications

[OpenSpec](https://github.com/Fission-AI/OpenSpec) is a lightweight spec-driven development approach, not an API
documentation tool.

### Why Not Other Alternatives?

There are several popular spec-driven development methodologies:

- **[GitHub Spec-Kit](https://github.com/github/spec-kit)** - GitHub's approach to specifications
- **[BMAD (Build More, Architect Dreams)](https://github.com/bmad-code-org/BMAD-METHOD)** - Comprehensive architectural
  methodology
- **[Kiro (by Amazon/AWS)](https://kiro.dev/)** - AWS-backed development framework

I chose **OpenSpec** for three reasons:

1. **Focus on Software Development:** It's designed specifically for coding workflows, not documentation
2. **Easy to get started:** Simple chat-based process without complex templates
3. **Brownfield-friendly:** Works with existing codebases (where most of us actually work)

Most methodologies assume greenfield projects. OpenSpec recognizes that developers primarily work on existing systems.

However, I'm not dogmatic about this choice—pick what works for your team. The key is having a spec-driven approach that
provides the "internal view" for your AI agents. Spec-driven development is still a maturing practice, so expect
methodologies to continue evolving.

---

## The OpenSpec Process

OpenSpec provides a structured workflow for spec-driven development. You can find the complete process in
the [official OpenSpec documentation](https://github.com/Fission-AI/OpenSpec?tab=readme-ov-file#how-it-works).

Here's how I structure it when working with AI agents (my own numbering for clarity):

### 🤖 Step 1: Create Initial Specs (Brownfield or Greenfield)

**AI-driven** - Use **strong AI** to document the current system's behavior and design decisions for existing projects,
or define initial requirements and architecture for new projects. These become your source of truth in
`openspec/specs/`.

**💡 Tip:** Use your AI's **"plan" mode** (or equivalent) for this step. This mode encourages the AI to ask clarifying
questions and think through edge cases before generating output—exactly what you want for specification creation.
This is collaborative work between you and the AI.

### 👤 Step 2: Review the Foundation

**Human review** - You must carefully review and validate that everything in your specs is correct. This becomes your
architectural foundation.

**⚠️ Warning:** This is critical—don't skip it! Flawed specs will propagate errors through all future changes.
The AI creates, but you validate. 👤 You will not lose any time soon to AI as this is where humans excel! 💡

### The Change Cycle

**3. 🤖 Create Change Proposal** - AI-driven: Define what you want to add or modify  
**4. 👤 Review the proposal** - Human review: Refine it before starting any implementation!  
**5. 🔁 Execute one task at a time** - AI-driven: Implement incrementally (loop until all tasks complete)  
**6. 🤖 Archive when done** - AI-driven: The delta updates the main specs

You create a new change proposal for each feature you want to add or modify.

**💡 Why one task at a time?** You could ask the AI to handle all tasks at once, but I don't recommend it:

- **Error correction**: Mistakes caught early don't propagate through all remaining tasks
- **AI focus**: Like humans, AI works better when focused on a single task with limited context
- **Better code reviews**: Incremental PRs are easier to review than one massive "big bang" change
- **Flexibility**: You can pause between tasks to handle other work

---

## When to Use Change Proposals (And When Not To)

**Not all tasks require a change proposal.** Use your judgment to determine the appropriate workflow.

### ✅ Use Change Proposals For:

- **New features** that add or modify business logic
- **Architectural changes** that affect multiple components
- **Design decisions** that need to be documented
- **Complex bug fixes** that involve business rules or validation logic
- **API changes** that affect contracts between components

### ❌ Skip Change Proposals For:

- **Debugging** and troubleshooting issues
- **Fixing warnings** or linting errors
- **Minor refactoring** that doesn't impact design (renaming variables, extracting methods)
- **Dependency updates** that don't change behavior
- **Code formatting** and style improvements
- **Simple bug fixes** with obvious solutions

**For these simpler tasks:** Work as you normally would with your AI assistant. The key is to ensure your `AGENTS.md`
provides good guidelines so the AI respects your code conventions even during routine maintenance work.

**The principle:** Change proposals are for capturing design intent and architectural decisions. If there's no design
decision to document, you don't need a proposal.

---

## AI Agent Role Differentiation

Not all AI agents are equal, and you should use them strategically (spend your AI credits wisely):

### 🤖 Spec Creation (Steps 1, 3): Use Strong AI

**When:** Creating specifications, asking clarifying questions, exploring requirements

**Why:** Specification creation requires understanding complex requirements, asking insightful questions, and
reasoning about edge cases. This benefits from models with large context windows and strong reasoning capabilities.

**💡 Use "plan" mode:** Most agentic AI tools have a "plan" or "architect" mode that prioritizes thinking and
questioning over immediate action. Use this mode for spec creation—it encourages the AI to ask clarifying questions
rather than jumping straight to generating output.

**Example chat prompts I use:**

- `"Create a new change proposal for: Add customer loyalty points system"`
- `"Review this change proposal and ask questions about anything unclear"`
- `"What business rules should we consider for the loyalty points expiration?"`

### 👤 Review Mode (Steps 2, 4): Human Judgment Required

**When:** Validating specifications before building on them

**Why:** Critical decisions about business rules, architectural trade-offs, and design intent require your
judgment. The AI can suggest, but you must validate.

**💡 Team Review:** Consider creating a PR for specification changes (especially for Steps 2 and 4). This allows team
members to review and validate business rules, architectural decisions, and edge cases before any code is written.
Specifications are architectural decisions—they benefit from collaborative review just like code does.

### 🤖 Execution & Archiving (Steps 5, 6): Use Regular AI

**When:** Implementing individual tasks from the change proposal, archiving completed changes

**Why:** Once the specification is clear, implementation and archiving are more straightforward tasks that don't require
the same level of reasoning or context capacity.

**Example workflow:**

- The change proposal includes tasks (your AI generates them as part of the proposal)
- Use the AI for code generation following the specification, one task at a time
- Each task references back to the change proposal for context

**The pattern:** Strong AI handles specification creation, you validate the decisions, and regular AI handles
implementation and archiving.

---

## Folder Structure: /openspec + /docs

OpenSpec uses the `/openspec` folder convention. This complements (doesn't replace) your `/docs` architecture
diagrams:

```
your-project/
├── AGENTS.md                    # AI agent guidelines and instructions
├── docs/
│   └── architecture/
│       ├── domain/
│       │   ├── customer.md      # Entity structure + diagrams
│       │   ├── order.md         # State machines + workflows  
│       │   └── payment.md       # ER diagrams + class diagrams
│       └── flows/
│           ├── create-order.md  # Sequence diagrams
│           └── payment-processing.md
├── openspec/
│   ├── specs/                   # Source of truth specifications
│   │   ├── order/
│   │   │   └── spec.md          # Order domain specification
│   │   └── customer/
│   │       └── spec.md          # Customer domain specification
│   └── changes/                 # Active and archived change proposals
│       ├── loyalty-points/      # Active change proposal
│       │   ├── proposal.md
│       │   ├── tasks.md
│       │   └── specs/           # Spec deltas for this change
│       └── archived/
│           └── user-registration/  # Completed change proposal
└── src/
    └── ... # Your application code
```

**The relationship:**

- `/docs` provides **structural understanding** (what entities exist, how they relate)
- `/openspec/specs` provides **behavioral specifications** (business rules, validation logic, design decisions)
- `/openspec/changes` captures **proposed modifications** with tasks and spec deltas

Together, they give AI agents the complete "internal view" of your system.

---

## AI Hygiene: Using AGENTS.md

Beyond specifications, you should establish clear guidelines for how AI agents should work with your codebase. This is
where `AGENTS.md` comes in.

**What is AGENTS.md?** It's a file in your repository root that provides common AI guidelines and instructions for code
generation. Think of it as a "contract" between your team and the AI agents you work with.

**Why use it?** It gives you a clear, predictable place to define:

- **Code style and conventions** - How you want code formatted and structured
- **Architecture patterns** - Which patterns to follow (and which to avoid)
- **Testing requirements** - What level of test coverage you expect
- **Documentation standards** - How code should be documented
- **Common pitfalls** - Known issues AI agents should avoid in your codebase

**Note:** Some AI tools do not automatically read AGENTS.md. To overcome this, you can either:

1. **Use tool-specific instruction files** that redirect to AGENTS.md (e.g., `.github/copilot-instructions.md` or
   `CLAUDE.md` containing: "Always read /AGENTS.md"), or
2. **Reference it in your prompts:** e.g., `"Follow the guidelines in AGENTS.md while implementing this feature"`

### Example AGENTS.md Structure

```markdown
# AI Agent Guidelines

## Code Style

- Use TypeScript strict mode
- Follow functional programming patterns where possible
- Prefer composition over inheritance
- Maximum function length: 50 lines

## Architecture Patterns

- Follow the existing repository structure in /docs and /openspec
- All business logic must have corresponding specifications
- State management uses Redux Toolkit
- API calls must use the existing service layer pattern

## Testing Requirements

- Minimum 80% code coverage for business logic
- Unit tests must follow the Arrange-Act-Assert pattern
- Integration tests required for all API endpoints
- Reference business rules from /openspec in test descriptions

## Documentation

- All public APIs must have JSDoc comments
- Complex business logic requires inline explanations
- Reference specification files when implementing business rules

## Common Pitfalls to Avoid

- Don't bypass the validation layer
- Don't create new patterns when existing ones exist
- Don't skip error handling
- Don't ignore the specifications in /openspec
```

### How AI Agents Use AGENTS.md

When you provide context to an AI agent (any coding assistant), include the AGENTS.md file. The AI will:

1. **Follow your conventions** instead of making assumptions
2. **Respect your architecture** instead of introducing new patterns
3. **Generate consistent code** across different AI sessions
4. **Avoid common mistakes** specific to your codebase

This creates a "predictable AI behavior" where different team members get consistent results from AI assistance.

### Integration with OpenSpec

`AGENTS.md` complements your specifications:

- **/docs** tells the AI **where it fits** (architecture, system structure)
- **/openspec** tells the AI **what to build** (business logic, requirements)
- **AGENTS.md** tells the AI **how to build it** (code style, patterns, conventions)

Together, they provide complete guidance for AI-generated code that aligns with your team's standards and architectural
decisions.

---

## Practical Example: Adding Customer Loyalty Points

Let me show you how this works in practice. I'll extend
the [architecture-as-code-example](https://github.com/flemming-n-larsen/architecture-as-code-example) repository to
demonstrate the change cycle workflow (assuming you've already completed Steps 1-2 with your initial specs).

### Step 3: Create Change Proposal with Strong AI

**My prompt:**

```
"Create a new change proposal for: Add customer loyalty points system to the e-commerce platform. Customers earn 1 point per dollar spent, can redeem points for discounts, and points expire after 12 months."
```

**AI response:** *(This would be a detailed change proposal with business rules, edge cases, and implementation tasks)*

### Step 4: Human Review with AI Assistance

**🫵 You must review the change proposal** - validate business rules, architectural decisions, and edge cases.

**Optional: Use AI to help refine:**

```
"Review this change proposal. What business rules should we consider for edge cases like refunds, partial orders, and account deletions?"
```

The AI can help you think through edge cases and ask clarifying questions, but **you validate and approve** the final
proposal. This iterative refinement with AI assistance ensures the proposal captures all design decisions before any
code is written.

**🚨 Critical:** Never skip human review. A flawed proposal will propagate errors through all implementation tasks.

### Step 5: Implementation with Regular AI

The change proposal already includes the tasks. Now I use regular AI to implement one task at a time.

Each task references the change proposal for context:

```typescript
// Task: Implement LoyaltyPoints entity
// Reference: /openspec/changes/loyalty-points/specs/customer/spec.md

class LoyaltyPoints {
    // Implementation guided by the specification...
}
```

The AI assistant generates code that follows the architectural patterns from `/docs`, respects the business rules
from `/openspec/specs`, and adheres to the coding conventions from `/AGENTS.md`.

---

## Integration with Your Existing Workflow

If you're already using the architecture-as-code approach from my previous article, adding OpenSpec is straightforward.
Your `/docs` architecture diagrams remain valuable structural context—OpenSpec's `/openspec` folder and `AGENTS.md`
simply add the behavioral specifications on top.

See the **Getting Started** section below for step-by-step instructions.

### PR Review Process

Your pull requests now include:

- **Code changes** (as always)
- **Architecture diagram updates** (from previous article methodology)
- **Specification updates** (the delta from archived change proposals)

Reviewers can see the complete context: what changed in the structure (diagrams), what changed in the behavior (specs),
and how it was implemented (code). This makes it much easier to figure out what the PR is all about instead of "just"
reviewing plain code changes.

---

## Why This Works Better Than Ad-Hoc AI

### Before: Ad-Hoc AI Usage

- AI agent sees only the immediate code context
- Generates solutions that work in isolation
- No understanding of architectural patterns or business rules
- Struggles more as codebase grows—harder to maintain context and update the intended code
- Code quality degrades over time as patterns are violated

### After: Spec-Driven AI Usage

- AI agent has the complete "internal view"
- Understands both structure (/docs), behavior (/openspec), and coding conventions (/AGENTS.md)
- Generates code that respects existing patterns and business rules
- Architecture integrity is maintained as the system evolves

The key insight: **AI agents are powerful, but they need context.** Specifications provide that context at the right
level of detail.

**With great AI power comes great responsibility:** The more powerful your AI agents become, the more important it is to
keep them "on the rails" with clear specifications. Without specs, a powerful AI can quickly generate large amounts of
code that compiles and runs—but violates your architecture in ways that compound over time. Spec-driven development is
your guardrail.

**💡 Note:** Spec-driven development is a valuable practice even without AI. Writing specifications before implementation
helps teams align on requirements, catch design issues early, and document architectural decisions. AI agents simply
make this practice more critical—they can generate code much faster, so the cost of unclear specifications is amplified.

---

## Getting Started

0. **Read the prerequisite article first** - If you haven't already,
   read [Keep Your Architecture Diagrams in Code, Not in Tools](https://architecture-as-code.hashnode.dev/keep-your-architecture-diagrams-in-code-not-in-tools)
   to establish the `/docs` foundation
1. **Pick an existing project** (brownfield approach - like most real work)
2. **Create an `/openspec` folder** alongside your existing code
3. **Create an `AGENTS.md` file** in your repository root with your AI guidelines
4. **Document one current feature** as your initial specs baseline
5. **Try the workflow with your next feature:**
    - Use strong AI to create the change proposal (the AI generates tasks as part of the proposal)
    - Review and refine with questions
    - Implement one task at a time with regular AI (referencing AGENTS.md)
    - Archive the change when complete

6. **Build the habit** - specifications before implementation for features and design changes

### Chat Prompts to Get Started

**For initial specs (strong AI):**

```
"Create a specification document for the existing [feature name] in our [domain] system. Include business rules, validation logic, and design decisions."
```

**For change proposals:**

```
"Create a new change proposal for: [new feature description]"
```

**For archiving:**

```
"Archive the [change name] change and update the main specs with the implemented changes"
```

---

## What's Next

The combination of **architecture-as-code** (structural understanding) + **spec-driven development** (behavioral
context) creates a foundation for truly architecture-aware AI development.

Your AI agents now have the complete "internal view":

- **What exists** (entity diagrams, ER schemas, state machines)
- **How it behaves** (business rules, validation logic, design decisions)
- **Why it was designed that way** (architectural decision records, specifications)

This isn't just about better code generation—it's about maintaining architectural integrity as your system evolves with
AI assistance.

Try adding specifications to one existing feature. See how it changes the quality of AI-generated code when the agents
understand not just what you're building, but why you're building it that way.

The repository with the complete OpenSpec integration will be available shortly:

👉 **[architecture-as-code-example (with OpenSpec)](https://github.com/flemming-n-larsen/architecture-as-code-example)**

---

## Final Words

Most developers have already experienced the "wow" moment with AI assistants—that first realization of how much faster
you can code with AI help. It's eye-opening, and productivity jumps immediately.

**Spec-driven development is your next breakthrough.** 🚀

It transforms AI from a helpful code generator into an architecture-aware development partner that respects your design
decisions and maintains the integrity of your system as it evolves. This is the difference between being productive
with AI and building maintainable systems with AI.

---

## 📖 Navigation

← **[Previous: Keep Your Architecture Diagrams in Code, Not in Tools](../A1.%20Keep%20Your%20Architecture%20Diagrams%20in%20Code,%20Not%20in%20Tools/README.md)** (Part 1)

→ **[Next: Architecture as Code in Practice](../A3.%20Architecture%20as%20Code%20in%20Practice/README.md)** (Part 3)

---

#SpecDrivenDevelopment #SDD #OpenSpec #AIAssisted #SoftwareArchitecture #DeveloperTools #TechWriting
