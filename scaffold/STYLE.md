# STYLE.md — Documentation Style Guide

**Status:** Active  
**Last updated:** 2026-03-30  
**Owner:** Project Team  

---

## 1. Purpose

This document defines formatting, structure, and naming rules for all documentation
in this repository. All contributors and agents must follow these rules.

---

## 2. Header Block

Every document must begin with the following header block immediately after the title:

```markdown
**Status:** Active  
**Last updated:** YYYY-MM-DD  
**Owner:** Team or person responsible  
**Related ADRs:** ADR-001, ADR-002  (omit line if none)
```

Valid status values: `Draft` | `Active` | `Deprecated` | `Superseded`

**Spec documents** use an extended status lifecycle (see section 5).

Do **not** use YAML front matter.

---

## 3. Conciseness

Documentation exists to be read and acted on, not to be comprehensive for its own sake.
Verbose specs and design docs cause review fatigue and get ignored.

### Rules

- **One idea per paragraph.** If a paragraph covers two topics, split it.
- **Lead with the conclusion.** State the decision or requirement first, then the rationale.
- **Delete filler.** Remove words like "basically", "essentially", "it should be noted that".
- **Prefer tables over prose** for lists of requirements, options, or comparisons.
- **Prefer Mermaid diagrams over text** for flows, sequences, and relationships.
- **Keep sections proportional to their importance.** A minor constraint does not need three paragraphs.
- **Omit empty sections.** If a template section does not apply, delete it rather than writing "N/A".

### Length guidelines

| Document type | Target length | Warning sign |
| ------------- | ------------- | ------------ |
| Spec (FUNC or TECH) | 1–3 pages | > 5 pages — consider splitting into multiple specs |
| Design doc | 1–4 pages | > 6 pages — consider splitting by subsystem |
| Architecture doc | 2–5 pages | > 8 pages — consider splitting by data flow |
| ADR | 0.5–2 pages | > 3 pages — move background to an RFC reference |
| RFC | 1–3 pages | > 5 pages — too many options or too much detail |

These are guidelines, not hard limits. A complex spec may legitimately be longer.
But if a document exceeds the warning threshold, ask whether it is trying to do too much.

---

## 4. Required Sections by Document Type

### Architecture documents

1. Purpose
2. Scope (In Scope / Out of Scope)
3. Context
4. Detailed Description
5. Constraints & Invariants
6. Trade-offs & Limitations
7. References

### Design documents

1. Purpose
2. Scope (In Scope / Out of Scope)
3. Context
4. Detailed Description
5. Constraints & Invariants
6. Trade-offs & Limitations
7. Anti-Patterns
8. References

### ADR documents

Follow `docs/templates/adr.md` exactly.

### RFC documents

Follow `docs/templates/rfc.md` exactly.

### Spec documents

Follow `docs/templates/spec.md` exactly.

---

## 5. Spec Lifecycle & Approval

### 5.1 Status Progression

Specs follow a stricter lifecycle than other documents. The valid status values for
specs are:

```
Draft → Under Review → Approved → In Progress → Implemented → Verified
                 ↘ Rejected
```

| Status | Meaning | Who triggers |
| ------ | ------- | ------------ |
| `Draft` | Initial authoring; not ready for review | Author |
| `Under Review` | Circulated for feedback; content is frozen except for review-driven edits | Author |
| `Rejected` | Review outcome: spec will not be implemented | Reviewer(s) |
| `Approved` | Review outcome: spec is accepted for implementation | Reviewer(s) |
| `In Progress` | Implementation has started; linked PR(s) exist | Author / implementer |
| `Implemented` | All acceptance criteria are implemented in code | Author / implementer |
| `Verified` | All acceptance criteria have passing tests or evidence | QA / reviewer |

> A spec may also be `Deprecated` or `Superseded` at any point after `Approved`,
> following the same rules as other documents.

### 5.2 Approval Requirements

Every spec must list a **Reviewed by** field in its header. The field is required
before moving past `Draft`.

- **Functional specs** must be reviewed by at least one product owner or architect.
- **Technical specs** must be reviewed by at least one senior developer or architect.
- The **Owner** and **Reviewer** must be different people.

A spec moves to `Approved` when all listed reviewers have signed off.
Sign-off is recorded by adding the reviewer's name and date to the header.

### 5.3 Rejection

If a spec is rejected during review:

1. Set status to `Rejected`.
2. Add a row to the changelog explaining the reason.
3. Do not delete the file — it serves as a record of what was considered.

---

## 6. Spec vs Design — Boundary Rule

Technical specs and design documents both cover "how", but at different levels:

| / | Technical Spec (`TECH-NN`) | Design Document |
| - | --------------------------- | --------------- |
| **Covers** | Public-facing contracts: APIs, message schemas, wire formats, error codes, integration protocols | Component internals: algorithms, data structures, internal data flow, implementation rationale |
| **Boundary test** | Crosses a component boundary (callable or observable from outside) | Lives behind the component's public interface |
| **Versioned** | Yes — has changelog and acceptance criteria | No — evolves with implementation |
| **Audience** | Developers, agents, consumers of the component | Developers and agents working inside the component |

> **Rule of thumb:** if another team or component needs to know about it, write a TECH spec.
> If only the team that owns the component needs to know, write a design document.

**Functional specs** (`FUNC-NN`) are never ambiguous — they describe *what* the system does
from a stakeholder perspective and are always separate from design.

---

## 7. Naming Conventions

| Type | Pattern | Example |
| ---- | ------- | ------- |
| ADR | `NN-short-title.md` | `01-append-only-storage.md` |
| RFC | `RFC-NN-short-title.md` | `RFC-01-vector-search.md` |
| Functional spec | `FUNC-NN-short-title.md` | `FUNC-01-user-auth.md` |
| Technical spec | `TECH-NN-short-title.md` | `TECH-01-api-contract.md` |
| Architecture doc | `kebab-case.md` | `write-read-pipelines.md` |
| Design doc | `kebab-case.md` | `memory-model.md` |

All filenames use lowercase kebab-case. No spaces.

---

## 8. Invariant Numbering

When listing invariants in a Constraints & Invariants section, use a category prefix:

- `I` — Identity invariants
- `A` — Atom / data invariants
- `R` — Reference / relationship invariants
- `N` — Node / projection invariants

Example: `I1`, `A3`, `R2`

---

## 9. Cross-linking

- Always link to related ADRs in the document header and in the References section
- Use relative paths: `../adr/01-append-only-storage.md`
- Never use absolute URLs for internal documents

---

## 10. Diagrams

- Use Mermaid for all diagrams (renders natively on GitHub)
- Prefer `flowchart`, `sequenceDiagram`, and `erDiagram`
- Label all nodes clearly
- Keep diagrams focused — one concept per diagram

---

## 11. Markdown Lint

This repository enforces `.markdownlint.json` at the repo root.
Run the linter before submitting documentation changes:

```bash
npx markdownlint-cli "docs/**/*.md"
```
