# AGENTS.md — Repository Agent Instructions

This file defines conventions for AI agents working in this repository.
Read this file before performing any task involving code, documentation, or configuration.

---

## Repository Overview

This repository contains a Visual Studio solution with both C++ and .NET projects.

- `src/` — source code (C++ and .NET projects)
- `docs/` — all documentation (architecture, design, specs, ADRs, RFCs)
- `scripts/` — build and utility scripts
- `.github/` — GitHub Actions workflows and issue templates

---

## Documentation Structure

| Folder | Purpose | Mutability |
| ------ | ------- | ---------- |
| `docs/architecture/` | System-level data flows, pipelines, cross-cutting invariants | Stable — change only with ADR |
| `docs/design/` | Component internals, trade-offs, implementation rationale | Active — updated as implementation evolves |
| `docs/specs/functional/` | What the system does (stakeholder-facing) | Versioned |
| `docs/specs/technical/` | How the system does it (developer-facing contracts) | Versioned |
| `docs/adr/` | Accepted architectural decisions — immutable history | **Never delete or rewrite** |
| `docs/rfc/` | Open proposals under discussion — can be freely edited | Draft |
| `docs/api/` | Public interface contracts per language | Versioned |
| `docs/testing/` | Test strategy and conventions per language | Active |
| `docs/security/` | Threat model and coding standards | Active |
| `docs/templates/` | Document templates — do not treat as real docs | Stable |

---

## Rules for Agents

### Always

- Read `docs/glossary.md` before working on any documentation task
- Use templates from `docs/templates/` when creating new documents
- Cross-link new docs to related ADRs in the `References` section
- Update the relevant `README.md` index when adding a new file
- Follow the header format defined in `docs/STYLE.md`

### Never

- Delete or rewrite files in `docs/adr/` — supersede them with a new ADR instead
- Modify `docs/templates/` files as content — they are templates only
- Use YAML front matter — use the inline header block format (see `docs/STYLE.md`)
- Create a new ADR for a decision still under discussion — use `docs/rfc/` instead

### When proposing an ADR

1. Check `docs/rfc/` for an existing RFC on the same topic
2. Assign the next sequential ID by scanning `docs/adr/`
3. Use `docs/templates/adr.md` as the base
4. Update `docs/adr/README.md` index

### When updating a spec

- Preserve the changelog table at the bottom of the document
- Bump the version in the document header
- Do not remove superseded content — mark it as deprecated inline

---

## Code Conventions

### C++ Projects

- Standard: C++17 minimum
- Build system: CMake
- No raw owning pointers — use `std::unique_ptr` / `std::shared_ptr`
- No `using namespace std` in headers

### .NET Projects

- Target framework: as specified per project `.csproj`
- Nullable reference types enabled
- No `var` for non-obvious types

---

## Files Agents Must Not Modify

- `AGENTS.md` (this file) — humans only
- `CONTRIBUTING.md` — humans only
- `LICENSE` — humans only
- Any file in `docs/adr/` — immutable history
