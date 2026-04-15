# Changelog

All notable changes to docs-platform are documented here.
Consuming repos should review this file when running `sync-docs.sh`.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

---

## [Unreleased]

### Changed

- `init-docs.sh` and `init-docs.ps1` now support scaffolding into a plain folder without requiring `.git`
- Init scripts now reuse the local `docs-platform` checkout when run from a manual clone instead of re-cloning the platform repo
- Init scripts now support explicit local source override via `DOCS_PLATFORM_PATH` / `-PlatformPath`
- Init scripts now copy platform-owned prompt files from `agent/` into consuming repos
- `sync-docs.sh` now updates platform-owned prompt files under `agent/` in consuming repos
- Added `docs/copilot-chat.md` guide explaining how to use the platform prompts in VS Code Copilot Chat, with examples for `S`, `M`, `L`, and `XL` tiers
- Added brownfield (existing codebase) guidance across scaffold and agent prompts
  - `AGENTS.md`: new "Working in an existing codebase (brownfield)" subsection under Rules for Agents — scan for existing artefacts, read existing code, account for backward compatibility, acknowledge what already works, prefer incremental change
  - `agent/spec-generate.prompt.md`: step 2 now scans for existing specs/code; interview adds "What exists today?" question; Background section includes current-state paragraph; Requirements include migration for contract changes
  - `agent/spec-plan.prompt.md`: step 1 now reads existing source code before proposing designs; notes advise updating existing docs over creating new ones
  - `agent/rfc-generate.prompt.md`: interview adds "What exists today?" question; options must state what existing code changes; "do nothing" reworded to "keep current behaviour"
  - `agent/spec-tasks.prompt.md`: task types now include migration/backward-compatibility tasks and preparatory refactoring tasks
- Added size-based workflow selection (S/M/L/XL tiers)
  - `AGENTS.md`: new "Workflow sizing" subsection with tier table, selection criteria, and agent rules — placed before the Spec-Driven Development Workflow section
  - `CONTRIBUTING.md`: workflow steps now include "pick a tier"; added tier summary table in section 2
  - `agent/spec-generate.prompt.md`: new step 1 checks tier before generating a spec; step 9 suggests next steps based on tier
  - `agent/rfc-generate.prompt.md`: new step 1 confirms XL-tier applicability before generating an RFC
  - `agent/spec-tasks.prompt.md`: prerequisites now note that task decomposition is optional for M-tier work
- Added conciseness guidance across scaffold and agent prompts
  - `STYLE.md`: new section 3 "Conciseness" with rules
    (one idea per paragraph, lead with conclusion, delete filler, prefer tables
    and Mermaid, proportional sections, omit empty optional sections) and
    length-guideline table (FUNC 1–3 pp, TECH 2–4 pp, Architecture 2–5 pp,
    Design 1–3 pp, ADR 0.5–1 p, RFC 1–2 pp); all subsequent sections
    renumbered (+1)
  - Agent prompts (`spec-generate`, `spec-plan`, `spec-tasks`, `rfc-generate`, `rfc-resolve`): added conciseness note referencing STYLE.md section 3 with per-doc-type page targets
  - Cross-file references updated: `CONTRIBUTING.md`, `templates/spec.md`, `glossary.md` now point to renumbered STYLE.md sections
  - **Breaking:** STYLE.md section numbers shifted by one (e.g. Spec Lifecycle is now section 5, not 4); consuming repos referencing section numbers should update
- Added agent-driven generation prompts for spec-driven development workflow
  - `agent/rfc-generate.prompt.md`: interviews user about a problem/decision, generates an RFC with options, pros/cons, open questions, and impact analysis (Explore phase)
  - `agent/rfc-resolve.prompt.md`: resolves a concluded RFC by generating an ADR from the chosen option, closing the RFC, and suggesting spec generation (Decision checkpoint)
  - `agent/spec-generate.prompt.md`: interviews user, determines spec type, generates a complete FUNC or TECH spec from a high-level description (Specify phase)
  - `agent/spec-tasks.prompt.md`: reads approved spec ACs and generates ordered, testable task breakdown in section 7 (Tasks phase)
  - `agent/spec-plan.prompt.md`: reads approved spec and generates architecture/design documents with stack constraints and cross-links (Plan phase)
- Added task decomposition layer to spec template (inspired by Spec Kit's `/tasks` phase)
  - `templates/spec.md`: new section 7 "Tasks" with ordered, dependency-aware work items mapped to ACs; sections renumbered (Implementation Status → 8, Changelog → 9, References → 10)
  - `AGENTS.md`: new "Task decomposition" rules — populate tasks when spec is Approved, keep tasks small and testable, update status as work progresses
  - `testing/strategy.md`, `CONTRIBUTING.md`: updated section references (Implementation Status is now section 8)
  - `glossary.md`: added "Task" term definition
  - **Breaking:** spec template section numbering changed again (new section 7 shifts all subsequent sections); existing specs should be renumbered
- Clarified boundary between technical specs and design documents (Option B: interface vs internal split)
  - `specs/README.md`: TECH specs now explicitly scoped to public-facing contracts (APIs, schemas, wire formats)
  - `design/README.md`: design docs now explicitly scoped to component internals behind the public interface
  - `STYLE.md`: added new section 4 "Spec vs Design — Boundary Rule" with comparison table
  - `templates/spec.md`: updated guidance comments to reinforce public-contract scope
  - `templates/design.md`: updated guidance comments to reference corresponding TECH specs
  - **Breaking:** consuming repos using TECH specs for internal implementation details should move that content to design documents
- Added spec-specific status lifecycle and approval workflow
  - `STYLE.md`: new section 4 "Spec Lifecycle & Approval" with status progression, approval requirements, and rejection rules
  - `templates/spec.md`: added `Reviewed by` and `Approved date` header fields; status transition guidance in changelog and references
  - `CONTRIBUTING.md`: new section 5 "Spec Review & Approval" with submission, reviewer, approval, and rejection procedures
  - `AGENTS.md`: agents must follow spec status lifecycle; cannot approve specs or skip the review gate
  - **Breaking:** spec template header has new required fields (`Reviewed by`, `Approved date`); existing specs should add these fields
- Added spec-driven traceability: acceptance criteria → tests → implementation
  - `templates/spec.md`: AC section now uses an ID + Test mapping table; new section 7 "Implementation Status" tracks per-AC progress with PR links and verification dates
  - `testing/strategy.md`: new section 8 "Spec-Driven Testing" with AC-prefixed test naming conventions for C++ and .NET, and guidance for linking tests back to specs
  - `CONTRIBUTING.md`: added spec-referencing conventions for PR titles, descriptions, and commit messages (e.g. `Implements TECH-001, AC-02`)
  - `AGENTS.md`: new "Traceability" rules — agents must update AC tables when writing tests or implementing specs, and reference spec IDs in commits
  - **Breaking:** spec template section numbering changed (new section 7 shifts Changelog to 8 and References to 9); existing specs should be renumbered
- Added spec-driven development workflow and document creation flow
  - `AGENTS.md`: new "Spec-Driven Development Workflow" section with document creation flow diagram, decision tree, and flow between document types
  - `architecture/README.md`: added "How Architecture Flows to Other Documents" section with chain: Architecture → TECH spec → Design
  - `design/README.md`: added "How Design Relates to Other Documents" section referencing the same chain
  - `glossary.md`: added terms for Acceptance Criteria, Component Boundary, Design Document, Functional Specification, Public Contract, Technical Specification, Traceability; updated Spec entry with lifecycle; added FUNC, AC, TECH abbreviations

### Removed

- Removed `scaffold/api/` folder — redundant with TECH specs, which now own all public contract definitions
  - Removed all `api/` references from `AGENTS.md`, `README.md`, `specs/README.md`, `testing/strategy.md`, `glossary.md`
  - **Breaking:** consuming repos with `docs/api/` should migrate content into `docs/specs/technical/` as TECH specs

### Added

- Initial scaffold structure with architecture, design, specs, adr, rfc, testing, security, templates
- `init-docs.sh` for first-time repo scaffolding
- `sync-docs.sh` for updating templates in existing repos
- `doc-scaffold` and `doc-sync` Copilot agent prompts
- Azure DevOps sync pipeline template
- `.platform-version` tracking file

---

<!-- Add new releases above this line -->
