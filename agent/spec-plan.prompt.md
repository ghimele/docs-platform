# spec-plan

Generates architecture and design documents from an approved spec.

## Description

Use this agent after a spec has been approved to produce the supporting
architecture and/or design documents. The agent reads the spec's requirements
and acceptance criteria, then generates the appropriate documents using
`docs/templates/architecture.md` and `docs/templates/design.md`.

This maps to the **Plan** phase of spec-driven development.

## Prerequisites

- The target spec must exist in `docs/specs/functional/` or `docs/specs/technical/`
- The spec's status should be `Approved` or later

## Steps

1. **Load context**
   - Read `docs/glossary.md` for domain vocabulary
   - Read `docs/STYLE.md` for formatting rules
   - Read `docs/templates/architecture.md` and `docs/templates/design.md`
   - Ask the user which spec to plan from (by ID, e.g. `TECH-01`)
   - Read the target spec file
   - Scan existing `docs/architecture/` and `docs/design/` for related documents
   - **Read existing code** — identify the source files that implement the affected
     components. Understand current class structure, data flow, and patterns before
     proposing new designs

2. **Determine what to generate**

   Ask the user:
   - **Stack and constraints** — languages, frameworks, infrastructure, compliance requirements
   - **Integration points** — what existing systems or components does this touch?
   - **Performance or scaling targets** — any NFRs from the spec that drive architectural choices?

   Then determine which documents are needed:

   | Condition | Document to create |
   | --------- | ------------------ |
   | Spec introduces a new system-wide data flow or cross-cutting concern | Architecture doc |
   | Spec defines a component contract (TECH spec) | Design doc for the implementing component |
   | Spec touches multiple existing components | Architecture doc + update existing design docs |
   | Spec is a FUNC spec with no architectural impact | Design doc only (or none if trivial) |

   If the user has a preference, defer to it.

3. **Generate architecture document** (if needed)

   Create the document using the architecture template. Fill:

   - **Purpose** — which spec this architecture supports
   - **Scope** — system boundaries affected by this spec
   - **Context** — integration points, dependencies, data flows
   - **Detailed Description** — system-level design with Mermaid diagrams
   - **Constraints & Invariants** — derived from spec NFRs and existing architectural invariants
   - **Trade-offs & Limitations** — decisions made and their costs
   - **References** — link to the source spec and any related ADRs

   If an architecture doc already exists for this area, suggest updating it
   instead of creating a new one.

4. **Generate design document** (if needed)

   Create the document using the design template. Fill:

   - **Purpose** — which component implements the spec's contract
   - **Scope** — reference the TECH spec for the public contract; this doc covers internals only
   - **Context** — what this component depends on, what depends on it
   - **Detailed Description** — internal structure, key classes, algorithms, data flow
   - **Constraints & Invariants** — component-specific rules
   - **Trade-offs & Limitations** — why this approach over alternatives
   - **Anti-Patterns** — what NOT to do, especially useful for agents generating code
   - **References** — link to the source spec, architecture doc, and related ADRs

5. **Cross-link**

   - Update the spec's `Related ADRs` header if new architectural decisions were made
   - Add the new documents to the relevant `README.md` index
   - If an ADR is needed for a significant decision made during planning, suggest creating one

6. **Present for review**

   Show the generated documents to the user. Ask:
   > "Does this architecture/design capture the right approach? Are there
   > constraints, integration points, or trade-offs I missed?"

   Iterate until the user is satisfied.

7. **Suggest next steps**

   - "Run `spec-tasks` to break the spec into implementable work items."
   - "If any significant decisions were made during planning, consider recording them as ADRs."

## Notes

- **Keep it concise** — follow `docs/STYLE.md` section 3: one idea per paragraph, lead with the conclusion, delete filler. Target 2–5 pages for architecture docs, 1–3 for design docs. Prefer tables and Mermaid diagrams over prose. Omit empty optional sections.
- Do not duplicate the spec's public contract in the design doc — reference it
- Architecture docs should be stable; avoid putting implementation details that will change frequently
- If the user's stack constraints conflict with spec requirements, flag the conflict explicitly
- Include at least one Mermaid diagram (data flow, component diagram, or sequence diagram)
- Do not generate tasks or implement code — those are separate phases
- **Brownfield:** prefer extending existing architecture and design docs over creating
  new ones. When a design doc already describes the component being changed, update it.
  Include a "Current State" or "Before" section so the reader understands what is changing.
