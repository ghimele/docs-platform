# spec-generate

Generates a FUNC or TECH spec from a high-level description provided by the user.

## Description

Use this agent when you have a problem or feature idea and want to produce a full
specification. The agent interviews the user to understand intent, then generates
a complete spec using `docs/templates/spec.md`.

This maps to the **Specify** phase of spec-driven development.

## Steps

1. **Check workflow tier**
   - Ask the user: "How big is this change?" and present the tier table from `docs/AGENTS.md`
   - If **S (Patch)**: tell the user no spec is needed — describe the fix in the PR
   - If **M, L, or XL**: proceed with spec generation
   - If **XL** and no RFC exists yet: suggest running `rfc-generate` first

2. **Load context**
   - Read `docs/glossary.md` for domain vocabulary
   - Read `docs/STYLE.md` for formatting rules
   - Read `docs/templates/spec.md` for the template structure
   - Scan `docs/specs/` to determine the next sequential ID
   - **Scan for existing artefacts** — search `docs/specs/`, `docs/architecture/`,
     `docs/design/`, and `docs/adr/` for documents covering the same area.
     If a spec already exists, ask the user whether to **update it** or create a new one.
   - **Read existing code** — if the feature touches existing components, read the
     relevant source files to understand current behaviour, contracts, and patterns

3. **Interview the user**

   Ask the following questions (skip any the user has already answered):

   - **What are you building?** One sentence describing the feature or contract.
   - **Who is the audience?** Stakeholders (→ FUNC) or developers/other components (→ TECH)?
   - **What problem does this solve?** Why is this needed now?
   - **What does success look like?** Key outcomes or behaviours the user cares about.
   - **What is out of scope?** Anything explicitly excluded.
   - **Are there related ADRs, RFCs, or existing specs?** Cross-links to include.
   - **What exists today?** Is there existing code, an API, or a contract that this
     changes? What must remain backward-compatible?

4. **Determine spec type**

   Based on the audience answer:
   - If stakeholders, product owners, or QA → create a **FUNC** spec
   - If developers, agents, or other components → create a **TECH** spec
   - If unclear, ask: "Will another team or component consume this contract?"

5. **Generate the spec**

   Create the spec file using the template. Fill every section:

   - **Purpose** — from "what are you building" + "who is the audience"
   - **Scope** — from "what does success look like" + "what is out of scope"
   - **Background** — from "what problem does this solve" + related docs.
     In a brownfield context, include a "Current State" paragraph describing
     existing behaviour before explaining what changes.
   - **Requirements** — derive FR/NFR rows from the success criteria
     - For FUNC specs: use user-story format ("As a [role], I want [action], so that [outcome]")
     - For TECH specs: use contract language ("The endpoint MUST return 200 with [schema]")
     - If modifying an existing contract, include a **Migration** requirement
       describing how consumers of the old contract will transition
   - **Detailed Specification** — expand on requirements with workflows, data formats, or sequence diagrams
   - **Acceptance Criteria** — derive testable AC rows from requirements, each with a unique ID

   Leave these sections empty for later phases:
   - Tasks (section 7) — populated by `spec-tasks`
   - Implementation Status (section 8) — populated during implementation
   - Changelog — add initial `0.1` row with today's date

6. **Set header fields**

   - **Status:** `Draft`
   - **Owner:** ask the user or use the one provided
   - **Reviewed by:** leave as placeholder
   - **Version:** `0.1`
   - **Related ADRs:** fill if the user provided any

7. **Update the index**

   Add the new spec to `docs/specs/README.md` in the appropriate table
   (Functional or Technical).

8. **Present for review**

   Show the generated spec to the user. Ask:
   > "Does this capture what you want to build? Are there missing requirements,
   > edge cases, or acceptance criteria I should add?"

   Iterate until the user is satisfied.

9. **Suggest next steps**

   - "When ready, set status to `Under Review` and open a PR for approval."
   - For **M-tier** work: "You can skip task decomposition and implement directly."
   - For **L/XL-tier** work: "Run `spec-tasks` to break this into implementable work items."

## Notes

- **Keep it concise** — follow `docs/STYLE.md` section 3: one idea per paragraph, lead with the conclusion, delete filler. Target 1–3 pages for FUNC specs, 2–4 for TECH specs. Prefer tables over prose and Mermaid diagrams over textual descriptions. Omit empty optional sections rather than leaving placeholders.
- Never skip the interview — vague specs produce vague implementations
- Prefer concrete acceptance criteria over abstract ones ("returns 200 with token" not "works correctly")
- For TECH specs, include at least one sequence diagram in the Detailed Specification (Mermaid format)
- Do not populate the Tasks or Implementation Status sections — those are separate phases
- If the user mentions an existing RFC, reference it in Background and check if an ADR should be created first
