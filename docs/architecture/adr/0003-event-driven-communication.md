---
id: 0003
title: Event-Driven Communication
status: Pending
date: 2026-02-25
deciders:
  - Architecture Team
tags:
  - messaging
  - events
superseded_by: null
---

# ADR-0003: Event-Driven Communication

**Status:** Pending

**Date:** 2026-02-25

**Deciders:** Architecture Team

---

## Context

As we adopt a microservices architecture, services need to communicate while minimizing coupling. Some interactions require immediate responses (e.g., user requests), while others can be eventually consistent (e.g., updating inventory after order creation). We must choose communication patterns that balance consistency, latency, and operational complexity.

## Decision

We will adopt an event-driven communication model for asynchronous interactions where eventual consistency is acceptable. A reliable message broker (e.g., Kafka or RabbitMQ) will be used for event distribution. Synchronous HTTP/gRPC calls will remain an option for synchronous request-response needs.

## Consequences

Positive:

- Loose coupling between services
- Better scalability for high-throughput event flows
- Enables reactive / reactive-extensions style architectures

Negative:

- Increased operational overhead to manage messaging infrastructure
- Complexity around message schema evolution and versioning
- Need for idempotency and delivery semantics handling in consumers

## Rationale

Event-driven communication decouples producers and consumers, enabling independent scaling and resilience. For flows that tolerate eventual consistency (e.g., order -> inventory updates), this approach reduces synchronous dependencies and improves system throughput.

## Alternatives

1. Synchronous HTTP/gRPC calls

- Pros: Simpler mental model, immediate responses
- Cons: Tighter coupling, cascading failures, harder to scale

2. Polling a shared data store

- Pros: Simpler to implement initially
- Cons: Inefficient, increased latency, and more coupling

## Implementation

Implementation considerations:

1. Choose a broker (Kafka for high-throughput ordered streams, RabbitMQ for simpler routing and lower operational burden)
2. Define event naming conventions and versioning strategy
3. Implement schema registry or contract testing (e.g., use Avro/Protobuf/JSON Schema)
4. Ensure consumers are idempotent and handle retries/deduplication
5. Provide operational runbooks for broker maintenance and monitoring

## References

- [C4 views and components](../c4-views/order-service-component.md)
- [Event design patterns](https://martinfowler.com/articles/201701-event-driven.html)

## Review and Updates

- Created: 2026-02-25 (Pending review by Architecture Team)
- Next Review: 2026-08-25