# Design

**Status:** Active  
**Last updated:** 2026-03-30  

This folder contains component-level design documents.

Design documents describe **component internals, trade-offs, and implementation rationale**.
They cover everything that lives *behind* a component's public interface: internal structure,
algorithms, data flow within the component, and the reasoning behind non-obvious choices.

> **Boundary rule:** If it crosses a component boundary (APIs, message schemas, wire formats),
> it belongs in a [technical spec](../specs/). If it is internal to the component, it belongs here.

For system-level data flows and cross-cutting invariants, see `../architecture/`.

---

## How Design Relates to Other Documents

Design documents sit at the end of the documentation chain:

```text
Architecture (system constraints) → TECH spec (component contract) → Design (internals)
```

- A design doc implements the **internal side** of a TECH spec's public contract.
- It must respect system-wide invariants defined in architecture docs.
- Reference the corresponding TECH spec in the `Related ADRs` header or References section.

---

## Documents

### C++ Components

| Document | Description | Status |
| -------- | ----------- | ------ |
| *(none yet)* | | |

### .NET Components

| Document | Description | Status |
| -------- | ----------- | ------ |
| *(none yet)* | | |

---

## Subfolders

- `cpp/` — design documents for C++ components
- `dotnet/` — design documents for .NET components

---

## When to Add a Document Here

Add a design document when describing:

- Internal structure of a class, module, or subsystem
- Algorithms and data structures chosen, and why
- Trade-offs considered during implementation
- Invariants specific to a component
- Anti-patterns that must be avoided in a given area

## What Does NOT Belong Here

- Public API signatures, error codes, message schemas → [technical spec](../specs/)
- Feature requirements and acceptance criteria → [functional spec](../specs/)
- System-level data flows and cross-cutting concerns → [architecture doc](../architecture/)
- Discrete architectural decisions → [ADR](../adr/)
