---
description: "Guides a change from open question to verified implementation. Handles RFC, ADR, spec generation, design/architecture docs, and task breakdown — skipping steps not needed for the tier."
mode: agent
tools:
  - codebase
  - editFiles
  - readFile
---

# spec

Guides a change from open question to verified implementation.
Handles RFC, ADR, spec generation, design/architecture docs, and task breakdown
in a single conversation — skipping steps that are not needed.

---

## Phase 0: Size the work

Ask: **"How big is this change?"**

| Tier | When | Steps needed |
| ---- | ---- | ------------ |
| **M** | Single component, ≤ 3 ACs, clear direction | Spec only |
| **L** | Multi-AC or cross-component | Spec → tasks |
| **XL** | Open question, new system, cross-cutting | RFC → ADR → spec → plan → tasks |

If the user is unsure, ask: "Is the decision already made, or are there multiple viable approaches still under discussion?" Open question → XL. Clear direction → M or L based on scope.

Read `#file:docs/glossary.md` and `#file:docs/STYLE.md` before proceeding.

---

## Phase 1: RFC (XL only)

Skip this phase if the decision is already made.

**Interview:**
- What is the problem and why is the current state insufficient?
- What options are you considering? (If only one: "What would happen if you did nothing?")
- What constraints apply? (Performance, compliance, compatibility, team expertise.)
- What exists today — what works, what would break, what must stay backward-compatible?
- Discussion deadline?

**Read `#file:docs/templates/rfc.md` then create `docs/rfc/RFC-NN-short-title.md`:**
- At least two options with concrete pros/cons (avoid vague trade-offs: "simpler" → "reduces code from ~500 to ~200 lines")
- Include "keep current behaviour" as an option when applicable
- Open questions must be specific and answerable, not vague
- Status: `Open`

Add to `docs/rfc/README.md` index.

**Ask:** "Does this capture the problem and options? Anything missing?"
Iterate until satisfied, then ask: "Has a decision been reached, or do you need more discussion time?"

If decided, continue to Phase 2. Otherwise stop here.

---

## Phase 2: ADR (XL only)

Skip this phase if no RFC was created.

Ask:
- Which option was chosen?
- Why? (Brief rationale.)
- Outcome: Accepted, Rejected, or Withdrawn?

If Rejected or Withdrawn: update the RFC status and Decision section, update `docs/rfc/README.md`. Stop — no ADR needed.

**Read `#file:docs/templates/adr.md` then create `docs/adr/NN-short-title.md`:**
- Context from RFC Problem Statement (past tense: "We needed to decide...")
- Decision: "We will [chosen option]."
- Carry over Options Considered with pros/cons
- Consequences derived from the chosen option's pros, cons, and discussion risks
- Constraints & Invariants: rules that must always hold, prefixed `ADR-NN-I1` etc.

Update `docs/adr/README.md` index.
Update the RFC: set status, fill Decision section, link to new ADR.

**Ask:** "Does this ADR accurately capture the decision? Any invariants or risks missed?"

---

## Phase 3: Spec

### Scan first

Search `#codebase` for existing documents in `docs/specs/`, `docs/adr/`, `docs/design/`, `docs/architecture/` covering the same area. If a spec exists, ask: "Update it or create a new one?"

Read relevant source files to understand current behaviour before specifying new behaviour.

### Determine spec type

- Stakeholders / product / QA as audience → **FUNC spec**
- Developers / other components consuming a contract → **TECH spec**
- If unclear: "Will another team or component consume this contract directly?"

### Interview (skip anything already answered in Phase 1)

- What are you building? (One sentence.)
- What problem does this solve?
- What does success look like?
- What is explicitly out of scope?
- What exists today that this changes, and what must stay backward-compatible?
- Related ADRs or RFCs?

### Read `#file:docs/templates/spec.md` then create `docs/specs/[functional|technical]/NN-short-title.md`

- **Background:** include a "Current State" paragraph before describing the change
- **Requirements:** use user-story format for FUNC; contract language ("MUST", "MUST NOT") for TECH
- If modifying an existing contract, include a **Migration** requirement
- **Acceptance Criteria:** testable, specific ("returns 200 with token", not "works correctly")
- TECH specs must include at least one Mermaid sequence diagram
- Leave Tasks (section 7) and Implementation Status (section 8) empty
- Status: `Draft`, Version: `0.1`

Add to `docs/specs/README.md` index.

**Ask:** "Does this capture what you want to build? Missing requirements, edge cases, or ACs?"

For **M-tier**: stop here. Tell the user: "When ready, set status to `Under Review` and open a PR for approval. You can implement directly after approval — no task breakdown needed unless the work spans multiple PRs."

---

## Phase 4: Plan (XL, or L/M if requested)

Skip unless the spec introduces a new system-wide data flow, a new component, or the user requests it.

Determine what to generate:

| Condition | Output |
| --------- | ------ |
| New system-wide data flow or cross-cutting concern | Architecture doc |
| New component or significant internal design | Design doc |
| Both | Both |
| Trivial implementation of existing pattern | Neither — skip this phase |

**Read `#file:docs/templates/architecture.md` then create `docs/architecture/kebab-case.md`** if needed: system-level data flows, cross-cutting invariants, at least one Mermaid diagram. Reference the spec and any ADRs. If a doc already covers this area, update it rather than creating a new one.

**Read `#file:docs/templates/design.md` then create `docs/design/[cpp|dotnet]/kebab-case.md`** if needed: component internals only — do not duplicate the TECH spec's public contract. Cover internal structure, algorithms, data flow, anti-patterns. Include a "Current State" section if the component already exists.

Add to the relevant `README.md` index. Cross-link the spec's `Related ADRs` header if new architectural decisions were made.

**Ask:** "Does this capture the right approach? Constraints, integration points, or trade-offs missed?"

---

## Phase 5: Tasks (L and XL)

Skip for M-tier unless the work spans multiple PRs.

Verify the spec has status `Approved` (warn if not) and that ACs are populated.

**Generate the Tasks table** for spec section 7:
- One concrete action per task ("Create registration endpoint with email validation", not "Build auth")
- Every AC covered by at least one task
- Tasks ordered by dependency; state `Depends On` where relevant
- Each task produces a verifiable result (passing test, working endpoint, valid migration)
- Include explicit tasks for: data model changes, validation/error handling, tests, migration/backward compatibility, preparatory refactoring
- 5–15 tasks is typical; if more than 20, suggest splitting the spec

Set all statuses to `Pending`. If the user confirms they are starting, set spec status to `In Progress`.

**Ask:** "Does this breakdown make sense? Any tasks too large, missing, or in the wrong order?"

Then tell the user:
- "Start with T-01, implement and test it, then mark it `Done`."
- "Use the `code` agent for each task: run `agent/code.prompt.md` and pass the spec ID and task ID."
- "Reference spec and task in commits: `feat(area): T-01 description (TECH-NN, AC-01)`"
- "After each task, update the Tasks table and Implementation Status (section 8)."

---

## Notes

- **Conciseness:** follow `docs/STYLE.md` section 3. Lead with the conclusion, delete filler, prefer tables and Mermaid over prose. Target lengths: RFC 1–2 pages, ADR 0.5–1 page, FUNC spec 1–3 pages, TECH spec 2–4 pages, architecture doc 2–5 pages, design doc 1–3 pages.
- Never approve a spec — only a human reviewer can set status to `Approved`
- Never delete RFC or ADR files — they are permanent records
- ADRs are immutable once accepted — if a decision is superseded, create a new ADR
- If a proposed TECH spec would violate an architectural invariant, flag it and suggest an ADR first
- When updating an existing spec: preserve the changelog, bump the version, mark superseded content as deprecated inline rather than deleting it
