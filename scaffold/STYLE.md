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

Do **not** use YAML front matter.

---

## 3. Required Sections by Document Type

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

## 4. Naming Conventions

| Type | Pattern | Example |
| ---- | ------- | ------- |
| ADR | `NNN-short-title.md` | `001-append-only-storage.md` |
| RFC | `RFC-NNN-short-title.md` | `RFC-001-vector-search.md` |
| Functional spec | `FUNC-NNN-short-title.md` | `FUNC-001-user-auth.md` |
| Technical spec | `TECH-NNN-short-title.md` | `TECH-001-api-contract.md` |
| Architecture doc | `kebab-case.md` | `write-read-pipelines.md` |
| Design doc | `kebab-case.md` | `memory-model.md` |

All filenames use lowercase kebab-case. No spaces.

---

## 5. Invariant Numbering

When listing invariants in a Constraints & Invariants section, use a category prefix:

- `I` — Identity invariants
- `A` — Atom / data invariants
- `R` — Reference / relationship invariants
- `N` — Node / projection invariants

Example: `I1`, `A3`, `R2`

---

## 6. Cross-linking

- Always link to related ADRs in the document header and in the References section
- Use relative paths: `../adr/001-append-only-storage.md`
- Never use absolute URLs for internal documents

---

## 7. Diagrams

- Use Mermaid for all diagrams (renders natively on GitHub)
- Prefer `flowchart`, `sequenceDiagram`, and `erDiagram`
- Label all nodes clearly
- Keep diagrams focused — one concept per diagram

---

## 8. Markdown Lint

This repository enforces `.markdownlint.json` at the repo root.
Run the linter before submitting documentation changes:

```bash
npx markdownlint-cli "docs/**/*.md"
```
