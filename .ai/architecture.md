# Architecture Patterns

## Repository Structure

- Follow the existing structure in `/docs` and `/openspec`
- All business logic must have corresponding specifications in `/openspec/specs`
- Architecture diagrams in `/docs` must be updated when entity structure changes

## Code Organization

- Domain entities follow the existing pattern (see `/docs/architecture/domain/`)
- Business rules are defined in `/openspec/specs/`
- State machines must match the diagrams in entity documentation
- API endpoints follow RESTful conventions

## Design Patterns

- Use Repository pattern for data access
- Use Service layer for business logic
- Use Factory pattern for complex object creation
- Avoid God objects (single responsibility principle)

## Do's and Don'ts

- Don't create new design patterns when existing ones work
- Don't bypass the validation layer — always use the existing validation service
- Follow established patterns from `/docs/architecture`
- Don't mutate state directly — use immutable patterns (spread operators, immer)
- Don't hardcode configuration values — use environment variables or config files
