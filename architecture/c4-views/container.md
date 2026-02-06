# Container View

**Level:** C4 Model - Level 2 (System Decomposition)
**Source:** [Structurizr DSL](./structurizr-dsl/container.dsl)

## Overview

The **E-Commerce Container View** is the second level of the C4 model that zooms into the E-Commerce Platform to reveal the major containers (applications, microservices, and data stores) that compose the system. This view shows the technology choices and communication protocols between containers.

## Architecture Diagram

![Container View](./images/container.svg)

This diagram illustrates the complete container architecture, showing:
- The **Web Application** as the client interface
- The **API Gateway** as the central routing hub
- Individual **Microservices** handling different business domains
- **Infrastructure & Support Services** (Message Broker, Cache)
- **Data Storage** layer with domain-specific databases

## Architecture Overview

The E-Commerce Platform follows a **microservices architecture** with clear separation of concerns across the following layers:

### 1️⃣ Client & Gateway Layer

**Web Application** 🌐
- **Technology:** React, TypeScript
- **Type:** Client-side SPA (Single Page Application)
- **Responsibility:** Provides the user interface for customers to browse products, place orders, and manage accounts
- **Interaction:** Communicates via HTTPS with the API Gateway

**API Gateway** 🚪
- **Technology:** Kong, NGINX
- **Type:** API Gateway / Request Router
- **Responsibility:** Single entry point for all client requests; routes to appropriate microservices; handles cross-cutting concerns
- **Interaction:** Exposes REST/JSON endpoints to Web Application; routes to Backend Services

### 2️⃣ Business Domain Microservices

**Customer Service** 👥
- **Technology:** Node.js
- **Responsibility:** Manages customer profiles, registrations, authentication, and account information
- **Interactions:**
  - REST/JSON from API Gateway
  - SQL with Customer Database
  - Redis caching for frequently accessed profiles
  - AMQP events via Message Broker
- **🔗 Deep Dive:** See [Customer Service Component View](./order-service-component.md) for internal architecture

**Order Service** 📦
- **Technology:** Node.js
- **Responsibility:** Handles order creation, tracking, state transitions, and fulfillment workflows
- **Interactions:**
  - REST/JSON from API Gateway
  - SQL with Order Database
  - Redis caching for active orders
  - AMQP events via Message Broker
  - REST calls to Customer Service and Product Service
- **🔗 Deep Dive:** See [Order Service Component View](./order-service-component.md) for internal architecture

**Product Service** 🏷️
- **Technology:** Node.js
- **Responsibility:** Manages product catalog, pricing, inventory levels, and product information
- **Interactions:**
  - REST/JSON from API Gateway
  - SQL with Product Database
  - Redis caching for catalog data
  - AMQP events via Message Broker

**Payment Service** 💳
- **Technology:** Node.js
- **Responsibility:** Securely processes payments, manages transaction state, and handles refunds
- **Interactions:**
  - REST/JSON from API Gateway
  - SQL with Payment Database
  - AMQP events via Message Broker
  - HTTPS/API calls to external Payment Gateway (Stripe/PayPal)
- **🔗 Deep Dive:** See [Payment Service Component View](./payment-service-component.md) for internal architecture

### 3️⃣ Infrastructure & Support Services

**Message Broker** 📨
- **Technology:** RabbitMQ
- **Type:** Event Bus / Message Queue
- **Responsibility:** Enables asynchronous, event-driven communication between services for loose coupling and eventual consistency
- **Protocol:** AMQP
- **Example Events:**
  - `CustomerRegistered` → Customer Service
  - `OrderCreated` → Payment Service, Inventory Service
  - `PaymentProcessed` → Order Service
  - `OrderShipped` → Customer Service (notifications)

**Cache** ⚡
- **Technology:** Redis
- **Type:** In-Memory Data Store
- **Responsibility:** Caches frequently accessed data to improve response times and reduce database load
- **Used By:** Customer Service, Order Service, Product Service
- **Protocol:** Redis Protocol

### 4️⃣ Data Storage Layer

**Customer Database** 🗄️
- **Technology:** PostgreSQL
- **Type:** Relational Database
- **Purpose:** Stores customer accounts, profiles, contact information, and authentication data
- **Owner:** Customer Service

**Order Database** 🗄️
- **Technology:** PostgreSQL
- **Type:** Relational Database
- **Purpose:** Stores order records, order items, shipment details, and order history
- **Owner:** Order Service

**Product Database** 🗄️
- **Technology:** PostgreSQL
- **Type:** Relational Database
- **Purpose:** Stores product catalog, descriptions, pricing, inventory levels, and availability
- **Owner:** Product Service

**Payment Database** 🗄️
- **Technology:** PostgreSQL
- **Type:** Relational Database
- **Purpose:** Stores payment transactions, payment methods, refund history, and audit trails
- **Owner:** Payment Service

## Communication Patterns

### Synchronous Communication 🔄

**User to Web App:** HTTPS
- Customers interact with the web application over secure HTTPS connections

**Web App to API Gateway:** REST/JSON
- The frontend makes API calls to the gateway for all backend operations

**API Gateway to Microservices:** REST/JSON
- The API gateway routes requests to the appropriate microservices

**Cross-Service Calls:** REST/JSON
- Order Service calls Customer Service and Product Service for validation and inventory checks

**Microservices to External Systems:** HTTPS/API
- Payment Service integrates with Payment Gateway (Stripe/PayPal)
- Services send notifications to Email Service

### Asynchronous Communication 📨

**Event Publishing/Subscription:** AMQP (Message Broker)
- Order Service publishes `OrderCreated` events
- Payment Service publishes `PaymentProcessed` events
- Services subscribe to relevant events for loose coupling and eventual consistency
- Enables fault tolerance and resilience through decoupling

### Data Access 💾

**Microservices to Databases:** SQL (PostgreSQL)
- Each service maintains its own database for data isolation
- Follows the database-per-service pattern to ensure service autonomy
- Prevents tight coupling through shared databases

**Caching Layer:** Redis Protocol
- Customer Service, Order Service, and Product Service use Redis for high-frequency reads
- Reduces database load and improves response times

## Key Design Patterns

| Pattern | Description | Benefits |
|---------|-------------|----------|
| **API Gateway Pattern** | Centralizes request routing and provides a single entry point for clients | Simplifies client integration, enables cross-cutting concerns (auth, logging) |
| **Microservices Pattern** | Each service owns its domain and database, enabling independent scaling | Scalability, maintainability, team autonomy |
| **Database-per-Service Pattern** | Data isolation and autonomy for each microservice | Service independence, reduced coupling |
| **Event-Driven Architecture** | Asynchronous communication via message broker for loose coupling | Resilience, scalability, eventual consistency |
| **Caching Strategy** | In-memory caching for performance optimization | Reduced latency, lower database load |
| **Circuit Breaker / Error Handling** | Resilience patterns for service failures | Fault tolerance, graceful degradation |

## Technology Stack Summary

| Layer | Technology |
|-------|-----------|
| **Frontend** | React, TypeScript |
| **API Gateway** | Kong/NGINX |
| **Microservices** | Node.js |
| **Event Bus** | RabbitMQ |
| **Databases** | PostgreSQL |
| **Cache** | Redis |

## Related Documentation

- **[System Context](./system-context.md)** — High-level system boundaries and external actors
- **[Order Service Component](./order-service-component.md)** — Detailed Order Service architecture
- **[Payment Service Component](./payment-service-component.md)** — Detailed Payment Service architecture
- **[Architecture Decision Records](../adr/README.md)** — Key architectural decisions
- **[Domain Models](../models/domain/README.md)** — Entity definitions and relationships
- **[System Flows](../models/flows/README.md)** — Business process workflows
