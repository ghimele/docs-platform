# Glossary

**Status:** Active  
**Last updated:** 2026-03-30  
**Owner:** Project Team  

This file is the single authoritative source for domain terms, abbreviations,
and project-specific vocabulary.

Agents: load this file before generating or editing any documentation or code comments.

---

## How to Use

- Terms are listed alphabetically
- Each entry includes: definition, usage notes, and related terms
- When a term has a specific meaning in this project that differs from common usage, that is noted explicitly

---

## Terms

### A

**Acceptance Criteria (AC)**  
Testable conditions listed in a spec that must be true for the spec to be considered met. Each criterion has a unique ID (e.g. AC-01) used to trace it to tests and implementation. See `docs/templates/spec.md` section 6.

**ADR (Architectural Decision Record)**  
A document that captures a significant architectural decision, the context in which it was made, the options considered, and the rationale for the choice made. ADRs are immutable once accepted. See `docs/adr/`.

### B

*(no entries yet)*

### C

**CHANGELOG**  
A file at the repository root that records all notable changes to the project, organized by version and release date.

**Component Boundary**  
The public interface of a component — everything callable or observable from outside. Content crossing this boundary belongs in a TECH spec; content behind it belongs in a design document. See `docs/STYLE.md` section 6.

### D

**Design Document**  
A document describing component internals, trade-offs, algorithms, and implementation rationale — everything behind the component's public interface. Design docs evolve with implementation. See `docs/design/`.

### E

*(no entries yet)*

### F

**Functional Specification (FUNC spec)**  
A spec describing what the system does from a stakeholder perspective. Written for product owners, architects, and QA. Named `FUNC-NN-short-title.md`. See `docs/specs/functional/`.

### G

*(no entries yet)*

### H

*(no entries yet)*

### I

**Invariant**  
A rule or constraint that must always hold true in the system. Invariants are documented in the Constraints & Invariants section of architecture and design documents, and are numbered with category prefixes (I, A, R, N).

### J

*(no entries yet)*

### K

*(no entries yet)*

### L

*(no entries yet)*

### M

*(no entries yet)*

### N

*(no entries yet)*

### O

*(no entries yet)*

### P

**Public Contract**  
The set of APIs, message schemas, wire formats, error codes, and integration protocols that a component exposes to its consumers. Defined in TECH specs. See `docs/specs/technical/`.

### Q

*(no entries yet)*

### R

**RFC (Request for Comments)**  
A proposal document for a decision or change that is still under discussion. RFCs graduate to ADRs once a decision is made. See `docs/rfc/`.

### S

**Spec (Specification)**  
A document that defines expected behaviour. Functional specs describe what the system does; technical specs describe how it does it. Specs follow a stricter lifecycle than other documents: `Draft → Under Review → Approved → In Progress → Implemented → Verified`. See `docs/specs/`.

### T

**Task**  
A small, ordered work item derived from one or more acceptance criteria. Tasks are independently implementable and testable, and bridge the gap between what must be true (AC) and who did it (Implementation Status). Tasks are defined in spec section 7. Status values: `Pending`, `In Progress`, `Done`, `Blocked`.

**Technical Specification (TECH spec)**  
A spec defining the public contract of a component — APIs, message schemas, wire formats, error codes, and integration protocols. Named `TECH-NN-short-title.md`. The TECH spec is the authoritative source for the contract; design docs derive from it. See `docs/specs/technical/`.

**Traceability**  
The ability to trace a requirement from spec acceptance criteria through to test cases, PRs, and verified implementation. Maintained via AC IDs in test names, PR references, and the spec's Implementation Status table.

### U

*(no entries yet)*

### V

*(no entries yet)*

### W

*(no entries yet)*

### X

*(no entries yet)*

### Y

*(no entries yet)*

### Z

*(no entries yet)*

---

## Abbreviations

| Abbreviation | Full Form |
| ------------ | --------- |
| ADR | Architectural Decision Record |
| AC | Acceptance Criteria |
| FUNC | Functional Specification |
| RFC | Request for Comments |
| TECH | Technical Specification |
| WAL | Write-Ahead Log |
| LSN | Log Sequence Number |

---

*Add new terms alphabetically. Do not remove existing terms — mark them as deprecated if no longer in use.*
