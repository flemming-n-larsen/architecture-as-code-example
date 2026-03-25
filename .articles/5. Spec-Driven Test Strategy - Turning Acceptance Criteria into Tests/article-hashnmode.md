# 🧪 Spec-Driven Test Strategy — Turning Acceptance Criteria into Tests

**How to turn proposal and spec into executable proof**

---

This article builds on the foundation from the previous 'Architecture as Code' articles:

- [Keep Your Architecture Diagrams in Code, Not in Tools](https://architecture-as-code.hashnode.dev/keep-your-architecture-diagrams-in-code-not-in-tools)
- [Keep Your AI and Architecture-Design in Sync](https://architecture-as-code.hashnode.dev/keep-your-ai-and-architecturedesign-in-sync)
- [Architecture as Code in Practice](https://architecture-as-code.hashnode.dev/architecture-as-code-in-practice)
- [Think in Specs — The Modern Developer's Mindset](https://architecture-as-code.hashnode.dev/think-in-specs-the-modern-developers-mindset)

---

## 🎯 TL;DR

Acceptance criteria are not just documentation. They are **test definitions waiting to be executed**.

If every scenario in your spec has:

1. a stable ID,
2. a declared test type,
3. a positive and negative test pair, and
4. a traceable reference in test code,

then a change proposal stops being "just a plan" and becomes a **self-proving unit of work**.

That is the real goal of a spec-driven test strategy: not "more tests," but a tighter chain from **intent → proof**.

And if we want to move faster with AI, this is the anchor:

- clear intent
- clear proof
- enforce the contract

Without that guard, we may generate code quickly — but we have no reliable guard rails for whether the AI is actually
doing the right thing.

Or put even more bluntly:

> **Stop guessing. Start measuring. Start proving.**

---

## 🔁 The Missing Link from Article 4

In [article 4](https://architecture-as-code.hashnode.dev/think-in-specs-the-modern-developers-mindset), I argued that the real work in the agentic AI age is still architecture + design + implementation — just with AI increasingly doing the code generation.

But that raises the obvious question:

> **How do we know the generated implementation actually fulfills the _intent_ of the spec?**

The answer is not "read 100 changed files line by line and hope."  
The answer is: **make the acceptance criteria executable.**

That means the loop becomes:

<img src="https://raw.githubusercontent.com/flemming-n-larsen/architecture-as-code-example/main/.articles/5.%20Spec-Driven%20Test%20Strategy%20-%20Turning%20Acceptance%20Criteria%20into%20Tests/illustrations/change-proposal-loop.png" alt="Change proposal to proof loop" width="225">

If that chain is intact, you no longer have "tests somewhere."  
You have **proof attached directly to design intent**.

---

## 🧩 The Running Example: Loyalty Points

To make this concrete, I'll use the `loyalty-points` change proposal already in this repository:

- [`openspec/changes/loyalty-points/proposal.md`](https://github.com/flemming-n-larsen/architecture-as-code-example/blob/main/openspec/changes/loyalty-points/proposal.md)
- [`openspec/changes/loyalty-points/specs/customer/spec.md`](https://github.com/flemming-n-larsen/architecture-as-code-example/blob/main/openspec/changes/loyalty-points/specs/customer/spec.md)

That proposal is intentionally simple enough to follow, but rich enough to show the pattern:

- earning points
- redeeming points
- rejecting invalid redemption
- expiring old points
- warning before expiry

In other words: enough business rules to demonstrate why a spec-driven test contract matters.

---

## 1️⃣ Give Every Acceptance Criterion a Stable ID

The first rule is simple:

> **Every scenario gets a stable ID.**

I like the format:

```text
[PREFIX-NNN]
```

Examples:

- `LP-001`
- `LP-002`
- `MR-014`
- `DRAM-003`

Why bother?

Because without IDs, acceptance criteria are hard to reference precisely:

- developers refer to "that second scenario under redemption"
- AI agents guess which scenario a test belongs to
- reviewers cannot easily trace test coverage back to intent
- CI has nothing reliable to enforce against

And the contract should go both ways: once a scenario has an ID, the tests that prove it should carry that ID too. But that does **not** mean every test in the codebase must map to an acceptance criterion. Some tests are about environment, toolchain, safety rails, or system readiness rather than product behavior. Those should still declare what they are — for example with a `SANITY` marker or an explicit test category — so nobody has to guess what they are meant to prove.

With IDs, a scenario becomes an addressable requirement.

### A practical naming rule

Cucumber and Gherkin do not define a standard scenario ID scheme. Their guidance is mostly about the **title**:
describe behavior, not implementation details.

So the practical best practice is to separate the two concerns:

- the **scenario title** is for humans and should describe the behavior
- the **ID** is for traceability and tooling

In practice, that means:

- the prefix comes from the spec or feature name
- the number is sequential and zero-padded
- the ID stays stable once assigned
- the scenario title stays readable and behavior-focused
- if a scenario is removed later, keep the historical traceability rather than pretending it never existed

If you are writing executable Gherkin, many teams put the ID in a tag such as `@AC:LP-005`.
If you are writing Markdown specs, putting the ID in the heading like ``[LP-005]`` works just as well.

This is one of those tiny conventions that looks bureaucratic until you try to automate anything without it.

### Example

Here is what the loyalty-points spec delta now looks like. In this section, the key thing to notice is the
`[LP-001]` and `[LP-002]` suffixes in the scenario headings:

```markdown
#### Scenario: Points earned on delivery `[LP-001]`

**Test:** Unit, Integration

- **GIVEN** an order has been marked as delivered
- **WHEN** the order total is at least $5.00
- **THEN** 1 point per dollar is awarded to the customer
- **AND** points are capped at 500 per order

#### Scenario: Minimum order not met — no points awarded `[LP-002]`

**Test:** Unit

- **GIVEN** an order has been marked as delivered
- **WHEN** the order total is less than $5.00
- **THEN** no loyalty points are awarded
```

The important addition in this section is the stable scenario ID in the title — `[LP-001]`, `[LP-002]`, and so on.
That is what makes everything downstream traceable.

You'll also notice the `**Test:**` line under each scenario. That is the second half of the contract, and it is what
the next section is about: declaring how each acceptance criterion is supposed to be proved.

---

## 2️⃣ Declare the Test Type on Every Scenario

The second rule is just as important:

> **Every scenario must declare what kind of test proves it.**

I use a mandatory field directly under the scenario heading:

```markdown
**Test:** Unit
```

Or, when a scenario deserves more than one level of proof:

```markdown
**Test:** Unit, Integration
```

This matters because "test it" is not specific enough.

A pure calculation rule, a controller boundary, a database contract, and a full workflow should not all be tested the same way. If you do not state the intended test type in the spec, people — and AI tools — have to guess.

And if a scenario has no declared test type, that is a smell for the same reason a test without an AC ID is a smell: the proof strategy has become implicit instead of explicit.

### The layers

Here's a practical layered strategy:

<img src="https://raw.githubusercontent.com/flemming-n-larsen/architecture-as-code-example/main/.articles/5.%20Spec-Driven%20Test%20Strategy%20-%20Turning%20Acceptance%20Criteria%20into%20Tests/illustrations/layered-strategy.png" alt="Layered testing strategy" width="210">

| Category | Layer | Typical frameworks | Use it for |
|---|---|---|---|
| `Unit` | L1 | JUnit + Mockito, `pytest`, Go `testing`, Jest/Vitest, xUnit + Moq | Pure logic, no I/O, no framework startup |
| `Slice` | L2 | `@WebFluxTest`, `@DataJdbcTest`, ASP.NET `WebApplicationFactory`, FastAPI/Flask test clients, supertest | Controller behavior, repository queries, framework wiring |
| `Integration` | L3 | Testcontainers, Docker Compose-based tests, `pytest` integration suites, Go integration tests | Database, Kafka, SQS, gRPC, external contracts |
| `E2E` | L4 | Cucumber, Playwright, Cypress, Robot Framework, SpecFlow | Full workflows across service boundaries |
| `Performance` | L5 | JMeter, k6, Gatling, Locust | Load, latency, throughput |
| `Architectural` | — | ArchUnit, NetArchTest, dependency/static analysis tools | Structural rules, dependency boundaries |
| `Manual` | — | — | Subjective or environment-specific checks |
| `Sanity` | — | JUnit, `pytest`, shell checks, smoke scripts | Toolchain/environment preconditions |

The exact frameworks can change. The important part is that the **category is declared in the spec**.

That gives you four wins:

1. the author has to think about *how this requirement is proved*,
2. the implementer knows which testing layer to use, and
3. CI can enforce the contract later, and
4. the team can see whether the required test framework and infrastructure are actually in place.

Declaring `Integration`, `E2E`, or `Performance` in the spec is a good way to surface missing setup early — before implementation is "done" but impossible to prove properly.

---

## 3️⃣ Require a Positive and Negative Test for Every AC

This is the part teams often say they want, but rarely state clearly enough:

> **Every acceptance criterion should have at least one positive and one negative test.**

The positive test proves the happy path.

The negative test proves the boundary, rejection, or failure behavior.

This is not just a personal preference. It lines up with long-established test design ideas such as
[Equivalence Partitioning](https://en.wikipedia.org/wiki/Equivalence_partitioning) and
[Boundary Value Analysis](https://en.wikipedia.org/wiki/Boundary-value_analysis): do not just test the valid center of
the input space — test the edges and the invalid partitions too.

Together, they answer a much more interesting question than "does it work?" They answer:

> **Does it work, and does it fail in the way we intended?**

### Why both matter

If you only write positive tests, you prove success is possible.

If you also write negative tests, you prove:

- invalid inputs are rejected
- limits are enforced
- forbidden behavior stays forbidden
- edge conditions are deliberate, not accidental

That is usually the difference between "looks okay in a demo" and "safe to depend on in production."

### A useful smell test

If a scenario makes it difficult to describe both a positive and a negative test, that is often a sign that:

- the scenario bundles multiple rules together,
- the failure behavior is underspecified, or
- the requirement is phrased too vaguely to be testable.

That is not a testing problem.  
That is a **spec quality problem**.

### Example coverage table

Here is a simple way to make the contract visible:

| AC | What it means | Positive test | Negative test |
|---|---|---|---|
| `LP-001` | Points are earned on delivered orders of at least `$5.00` | Delivered `$50` order awards `50` points | Delivered `$4.99` order awards `0` points |
| `LP-004` | Valid redemption reduces the order total | Redeem `100` points successfully at checkout | Redeem with insufficient balance is rejected |
| `LP-005` | Redemption below minimum is rejected | Redemption at exactly `100` points is accepted | Redemption at `99` points is rejected |
| `LP-006` | Redemption above `50%` of order total is rejected | Redeem points worth exactly `50%` of order total | Redeem points worth `50.01%` of order total |
| `LP-007` | Points expire after 12 months | Expiration job removes eligible points after the cutoff | Points are not expired before the cutoff |
| `LP-009` | Customer is warned before expiry | Warning is sent when expiry is within 30 days | No warning is sent too early |

The point is not the table format itself.  
The point is that the pairing is explicit and reviewable.

---

## 4️⃣ Mark Test Code with the AC It Covers

Once the spec has stable IDs, your tests should carry those IDs forward.

In plain JUnit, that can be as simple as `@Tag`:

```java
@Test
@Tag("LP-005")
void shouldRejectRedemption_whenFewerThan100PointsRequested() {
    // ...
}
```

If `@Tag` is not the right tool in your stack, use an explicit marker comment:

```java
// AC: LP-007
@Test
void shouldExpirePoints_afterTwelveMonthsAtMidnightUtc() {
    // ...
}
```

In Cucumber, the tag can live in the feature file:

```gherkin
@AC:LP-009
Scenario: Warning is sent 30 days before expiry
  Given a customer has points expiring within 30 days
  When the warning job runs
  Then the customer receives a warning notification
```

And for non-product checks, use a different marker entirely:

```java
// SANITY: Testcontainers PostgreSQL starts successfully
@Test
void postgresContainerStarts() {
    // ...
}
```

### Why this is worth the discipline

Because now the link is machine-readable:

- spec scenario → `LP-007`
- test method → `LP-007`
- CI can cross-reference them
- reviewers can trace proof back to intent instantly

Without markers, the relationship exists only in someone's head.

That does not scale well to teams, and it scales even worse to AI-generated code.

Put differently:

- a scenario without an ID is underspecified
- a scenario without a `**Test:**` field is under-designed
- a product-behavior test without an AC ID marker is hard to place
- a non-AC test should still identify itself clearly, e.g. as `Sanity`

Any one of those should make you stop and ask what broke in the traceability chain.

---

## 📦 A Change Proposal Should Contain a Test Package

This is the idea I care about most:

> **A change proposal is not complete unless it contains the _test package_ — the proof bundle for the change.**

**Test package — the proof bundle for the change** is the wording I prefer here. It is not a formal industry term. The
closest established ideas are
[Specification by Example](https://en.wikipedia.org/wiki/Specification_by_example),
[Acceptance Test-Driven Development](https://en.wikipedia.org/wiki/Acceptance_test%E2%80%93driven_development),
and the broader language of [Verification and Validation](https://en.wikipedia.org/wiki/Verification_and_validation).
What I mean by it is simple: the proposal should carry the examples and tests that prove the change fulfills its
intended behavior.

Not just:

- the feature description,
- the business rules,
- the design notes,
- the tasks.

But also:

- the proof strategy,
- the mapped acceptance criteria,
- the positive and negative test set.

That is what makes a proposal a coherent unit of work rather than a nice document that gets ignored after implementation starts.

And ideally, the proposal itself should go through a pull request before implementation starts. The point is to give
your teammates a chance to review the intent, catch flaws, challenge assumptions, and spot missing edge cases while the
change is still cheap to reshape. Reviewing the proposal and specs first is usually far higher leverage than reviewing a
large batch of generated code after the fact.

<img src="https://raw.githubusercontent.com/flemming-n-larsen/architecture-as-code-example/main/.articles/5.%20Spec-Driven%20Test%20Strategy%20-%20Turning%20Acceptance%20Criteria%20into%20Tests/illustrations/test-package.png" alt="Proposal, test package, and implementation relationship" width="900">

If the code passes the test package, then the code fulfills the intent of the proposal.

That is the standard we should want.

Not "the diff looked plausible."

Not "the AI seemed confident."

Not "it passed one happy-path test."

But:

> **The declared intent was covered, exercised, and verified.**

If you want a more established label for this mindset, it sits close to
[Specification by Example](https://en.wikipedia.org/wiki/Specification_by_example): examples become the shared source
of truth for both the specification and the functional proof. That is also why BDD tools such as
[Cucumber](https://cucumber.io/docs/bdd/) describe examples as living documentation that is automatically checked
against system behavior.

---

## 📏 A Change Proposal Can Be Too Big

There is an important practical limit here:

> **A change proposal should be a coherent unit of intent — not a dumping ground for every related idea.**

If a proposal grows into:

- too many unrelated tasks,
- too many moving parts to review coherently,
- too much test surface to understand as one package, or
- too much work-in-flight to validate comfortably,

then it is worth asking whether you still have **one change proposal** — or several changes pretending to be one.

That does not mean every proposal must be tiny.

It means every proposal should still feel like **one thing**:

- one meaningful slice of behavior,
- one proof story,
- one reviewable unit of intent.

When that stops being true, splitting into multiple proposals is usually healthier:

- easier to review,
- easier to test,
- easier to reason about,
- easier to merge and archive cleanly,
- and faster to get done and archived before the proposal goes stale or drifts out of sync with other specs and code changes being made by the team.

The point is not "small for the sake of small."  
The point is **coherent enough to prove**.

---

## ✅ One Task at a Time, With Its Own Proof

There is also a useful nuance here:

> **A proposal may be fairly large overall if execution happens one task at a time, with each task carrying its own proving tests.**

That rhythm matters a lot in practice.

Instead of treating the proposal as one giant implementation-and-test event, treat it as a sequence:

<img src="https://raw.githubusercontent.com/flemming-n-larsen/architecture-as-code-example/main/.articles/5.%20Spec-Driven%20Test%20Strategy%20-%20Turning%20Acceptance%20Criteria%20into%20Tests/illustrations/process.png" alt="Incremental implementation and proof process" width="250">

The workflow becomes:

1. implement one task,
2. write or finish the tests needed to prove that task,
3. review the result,
4. commit it,
5. then move on.

> 💡 **Tip:** If a change proposal is a bit dated, or the codebase has moved significantly since it was written, tell
> the AI to first check and fix the proposal so it is up to date and back in sync with the current codebase before
> starting implementation. It is much cheaper to refresh the intent first than to implement the wrong thing cleanly.

That gives you several practical advantages:

- smaller review units,
- easier debugging when something breaks,
- less ambiguity about which test proves which change,
- cleaner CI/CD feedback,
- less friction from tools like SonarCloud because incomplete work is not left hanging across many tasks at once,
- and a lower risk that you discover too late that the spec needs to be revisited or rewritten.

This is also why proposal size and task size are related, but not identical.

A proposal can stay reasonably broad **if**:

- the tasks are well separated,
- each task can be proved independently,
- and you do not have to carry half-finished proof across the whole proposal before getting feedback.

So the rule of thumb I would use is:

> **Keep the proposal coherent, and keep the execution incremental.**

That combination gives you the best of both worlds:

- enough scope to describe the full intent,
- but small enough proof steps to review, test, and commit without drowning your pipeline,
- and without creating big-bang PRs with too many changed files and new tests to grasp comfortably.

---

## 🛑 When Implementation or Tests Keep Fighting You, Stop the Line

There is another pattern worth calling out explicitly:

> **If the AI keeps struggling with the implementation, or the tests are unexpectedly hard to make work, that is often a design signal — not just an execution problem.**

This is one of the most useful feedback loops in spec-driven work.

Sometimes the trouble is not that the agent is weak, or the developer is missing something obvious. Sometimes the real problem is:

- the implementation is not as straightforward as the proposal assumed,
- the acceptance criteria are underspecified,
- the design is missing a prerequisite decision,
- the architecture needs another pass first,
- or a third-party framework / API behaves differently than expected.

Those are not failures of discipline.  
They are discoveries.

And discoveries are exactly why the process has to stay agile.

### The wrong reaction

The wrong reaction is to brute-force your way through:

- keep re-prompting the AI until something vaguely works,
- keep patching the tests until they go green for unclear reasons,
- keep adding workaround after workaround just to get past the current task.

That is how you automate your way past a real design problem.

### The right reaction

The right reaction is:

1. stop,
2. ask what the struggle is telling you,
3. reassess the proposal, spec, design, or architecture,
4. update the relevant documents,
5. then continue with the new understanding.

That is not failure.  
That is **agile feedback** doing its job.

You made the best plan you could with the knowledge you had at the time. Reality may still reveal:

- hidden framework constraints,
- awkward APIs,
- architectural gaps,
- or business rules that looked clear until implementation made them concrete.

You could not always have known that up front.

### A useful quality principle

This is where the Toyota-style
["pull the brake"](https://en.wikipedia.org/wiki/Andon_(manufacturing)) /
["stop the line"](https://en.wikipedia.org/wiki/Jidoka) mindset applies.

When the line signals that something is wrong, the goal is not to keep production moving at any cost. The goal is to stop the accident before it compounds.

In software terms:

> **If implementation or proof keeps fighting back, stop and ask whether the design needs to change.**

That may mean:

- splitting the proposal,
- adding a missing ADR,
- updating the acceptance criteria,
- changing the task sequence,
- rethinking the approach entirely,
- or discovering that a framework or API issue was lurking underneath the surface all along.

But whatever you do, do not confuse repeated friction with a mere tooling inconvenience.  
Very often, it is the system telling you the plan needs another iteration.

---

## 🧭 This Is TAD, Not TDD

This approach sits closest to what I would call **Test After Design** — or, if you prefer, **Test After Development in a Spec-Driven workflow**.

That distinction matters.

### TDD says:

- write the failing test first
- let the test drive the design

### ATDD says:

- write acceptance tests first
- let those tests drive the feature behavior

### This article's approach says:

- write the **spec first**
- let the change proposal drive design intent
- then write the test package that proves the implementation matches that intent

I am honestly less interested in arguing about whether this should be called TDD, TAD, ATDD, or something else.
What matters is whether we end up with clear proof of intent and a useful demo of the feature.

This is close in spirit to [BDD](https://cucumber.io/docs/bdd/), especially the idea of using behavior-focused examples
as executable documentation and shared understanding. But again, the label is not the point. The proof of intent is.

In a spec-driven workflow, the design driver is already the proposal itself:

- `proposal.md` defines the change
- `spec.md` defines the acceptance criteria
- `tasks.md` defines the execution order
- tests prove the work was done correctly

That is a different center of gravity.

My personal take is that the exact label matters less than this:

The spec is the design artifact.  
The tests are the **executable proof**:

- they prove the intent,
- they demo the feature,
- and then they remain behind as a reusable regression guard.

And one more practical belief sits underneath this for me: if a test becomes huge, it is often a sign that the design
in the code is off. Smaller, more focused tests are usually better because they are easier to understand, easier to
trust, and more likely to reflect clean design boundaries.

---

## 🤖 Who Writes the Tests — Human, AI, or Both?

Once the scenario has:

- a stable AC ID,
- a declared test category, and
- explicit positive/negative intent,

an AI agent has enough structure to scaffold a surprisingly good first draft of the tests.

That is not magic. It is just good input.

For example, if the spec says:

```markdown
#### Scenario: Redemption exceeds 50% of order total `[LP-006]`

**Test:** Unit

- **GIVEN** a customer attempts to redeem points worth more than 50% of the order total
- **WHEN** the redemption request is submitted
- **THEN** the redemption is rejected with an appropriate error
```

then an AI has everything it needs to generate:

- the correct test layer,
- the method name,
- the setup shape,
- the expected behavior,
- and the traceability marker.

Humans still review the result, of course. But now the review is grounded in something much stronger than taste or intuition:

> **Does this test actually prove `LP-006`?**

That is a much better review question than "do I like this test style?"

---

## ✅ CI Should Enforce the Contract

Once your spec and tests carry machine-readable markers, CI can check the contract automatically.

This is critical to the whole idea.

If we want AI to write more of the code for us, then we need two things:

1. a clear statement of **intent**, and
2. a clear statement of **proof**.

The CI/CD pipeline then becomes the **guard**. Its job is to verify that the implementation still lines up with the
declared intent and that the proof is actually present. It should be strict about tests that have no clear traceability
marker, and equally strict about tests being marked `Manual` only when they genuinely cannot or should not be automated.

The better we get at this, the less we need to review every PR in microscopic detail. We can trust that the intent was
followed because the pipeline is checking the contract for us. That is where AI stops being just a code generator and
starts becoming a real accelerator for delivery.

The basic enforcement loop is:

1. scan the specs for all non-manual AC IDs,
2. verify each scenario declares a `**Test:**` category,
3. scan the tests for `@Tag`, `// AC:`, or `@AC:` references,
4. cross-reference the two sets,
5. fail the build if an AC has no test coverage, and flag product-behavior tests that exist without traceable AC markers or another explicit category such as `Sanity`.

That turns "please remember to test this" into a policy.

<img src="https://raw.githubusercontent.com/flemming-n-larsen/architecture-as-code-example/main/.articles/5.%20Spec-Driven%20Test%20Strategy%20-%20Turning%20Acceptance%20Criteria%20into%20Tests/illustrations/policy.png" alt="CI policy matrix for test layers" width="350">

### A practical CI matrix

| Layer | Purpose | When to run |
|---|---|---|
| L1 `Unit` | fast inner-loop logic checks | every push |
| L2 `Slice` | framework wiring / boundary checks | every push |
| L3 `Integration` | real infrastructure contracts | every push or PR |
| L4 `E2E` | full workflow verification | PRs and merges to main |
| L5 `Performance` | load and throughput validation | on demand / scheduled |

And most importantly:

> **A non-manual AC without a matching test reference should fail the build — and any test that lacks both an AC reference and an explicit non-AC category should be treated as suspicious too.**

That is what turns the spec from documentation into an enforceable contract.

---

## 👀 What This Changes in Review

Traditional review often asks reviewers to reconstruct intent from a big diff.

Spec-driven review flips that around.

You review:

1. the intent,
2. the acceptance criteria,
3. the test package proving them,
4. and then the generated code as a lower-level confirmation.

This is not something that only makes sense with AI. You could do all of this with purely human-written code too. The
same review logic still holds: review the intent, review the proof, and let the code follow from that.

What AI changes is the speed. It makes it possible to do more of this work faster, using an automation you can
actually converse with, refine, and redirect as you go.

That does **not** mean code review disappears overnight.

It means the center of trust starts to shift.

| Traditional review | Spec-driven review |
|---|---|
| "What was this code trying to do?" | "Does the code fulfill the approved ACs?" |
| Diff is the primary artifact | Proposal is the primary artifact |
| Tests are secondary reassurance | Tests are the proof bundle |
| Coverage is often implicit | Coverage is explicit and traceable |

This is especially important in an AI-assisted workflow, because AI can generate a lot of plausible-looking code very quickly.

That speed is only an advantage if your proof strategy is just as structured.

---

## 🌱 The Bigger Idea: Intent Should Be Provable

At this point, the pattern becomes simple:

> Approved intent plus passing proof gives you confidence in the implementation.

The deeper shift here is not really about testing.

It is about moving from:

> "We implemented something that sounds right."

to:

> "We can prove the implementation satisfies the intent we approved."

That is a stronger engineering posture whether the code was written by a human, an AI, or both.

---

## 📌 Summary

If you want acceptance criteria to do real work, treat them as executable contracts:

| Rule | Why it matters |
|---|---|
| Give every scenario a stable ID | Makes requirements addressable and traceable |
| Add a mandatory `**Test:**` field | Declares the proof layer explicitly |
| Require positive + negative tests | Verifies both success and rejection behavior |
| Mark tests with AC references | Connects code-level proof back to design intent |
| Enforce coverage in CI | Turns traceability into policy |
| Treat the proposal as a test package | Makes the change self-proving |

That is the heart of spec-driven test strategy:

> **The spec is not done until the proof is designed.**

And the implementation is not done until that proof passes.

---

## 🔗 References

| Resource | Description |
|---|---|
| [OpenSpec](https://openspec.dev/) | Open specification format for change proposals and spec-driven workflows |
| [Spec-Driven Development — Wikipedia](https://en.wikipedia.org/wiki/Spec-driven_development) | Overview of the SDD methodology |
| [Martin Fowler — Test Pyramid](https://martinfowler.com/bliki/TestPyramid.html) | Why a balanced test portfolio needs more focused tests than broad end-to-end ones |
| [Equivalence Partitioning — Wikipedia](https://en.wikipedia.org/wiki/Equivalence_partitioning) | Classic test design technique for covering valid and invalid partitions |
| [Boundary Value Analysis — Wikipedia](https://en.wikipedia.org/wiki/Boundary-value_analysis) | Why edge conditions deserve explicit test coverage |
| [Specification by Example — Wikipedia](https://en.wikipedia.org/wiki/Specification_by_example) | Examples as a single source of truth for both specification and functional proof |
| [Cucumber BDD Guide](https://cucumber.io/docs/bdd/) | BDD as shared examples plus executable documentation |
| [Cucumber Gherkin Reference](https://cucumber.io/docs/gherkin/reference/) | Syntax and semantics of `Given / When / Then` |
| [Acceptance Testing — CD Training](https://courses.cd.training/pages/acceptance-testing) | Practical material on acceptance testing in Continuous Delivery |
| [Dan North — Introducing BDD](https://dannorth.net/introducing-bdd/) | Foundational explanation of BDD |
| [Specification by Example](https://specificationbyexample.com/) | Gojko Adzic's work on executable specifications |
| [Testcontainers](https://testcontainers.com/) | Real dependency testing with disposable infrastructure |

---

## 📖 Navigation

← **[Previous: Think in Specs — The Modern Developer's Mindset](https://architecture-as-code.hashnode.dev/think-in-specs-the-modern-developers-mindset)**

→ **[Up next: Expert Knowledge as Code: Portable AI Lenses](https://github.com/flemming-n-larsen/architecture-as-code-example/blob/main/.articles/ideas.md#expert-knowledge-as-code-portable-ai-lenses)** **(Future article)**

---

**Repository:** [architecture-as-code-example](https://github.com/flemming-n-larsen/architecture-as-code-example/)

---

#SpecDrivenDevelopment #AcceptanceTesting #BDD #OpenSpec #ArchitectureAsCode #AgenticAI
