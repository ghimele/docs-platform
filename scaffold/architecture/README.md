# Architecture

**Status:** Active  
**Last updated:** 2026-03-30  

This folder contains system-level architecture documents.

Architecture documents describe **data flows, pipelines, and cross-cutting invariants**.
They answer the question: *how does the system work as a whole?*

For component-level internals and trade-offs, see `../design/`.

---

## Documents

| Document | Description | Status |
| -------- | ----------- | ------ |
| *(none yet — add entries here as documents are created)* | | |

---

## When to Add a Document Here

Add an architecture document when describing:

- Data flow across multiple components
- System-wide invariants that all components must respect
- Integration points between C++ and .NET layers
- Persistence, concurrency, or consistency strategies at system level

Do **not** add implementation details or component internals here — those belong in `../design/`.
