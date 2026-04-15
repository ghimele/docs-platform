# spec-tasks

Breaks an approved spec into small, ordered, independently testable tasks.

## Description

Use this agent after a spec has been approved and before starting implementation.
The agent reads the spec's acceptance criteria and generates the Tasks table
(section 7) with concrete work items.

This maps to the **Tasks** phase of spec-driven development.

## Prerequisites

- The target spec must exist in `docs/specs/functional/` or `docs/specs/technical/`
- The spec's status must be `Approved` (or the user explicitly overrides)
- The spec should be **L-tier or XL-tier** work (see `docs/AGENTS.md` Workflow sizing).
  For **M-tier** specs (≤ 3 ACs, single component), task decomposition is optional —
  ask the user whether they want a tasks table or prefer to implement directly.

## Steps

1. **Load context**
   - Read `docs/glossary.md` for domain vocabulary
   - Read `docs/STYLE.md` for formatting rules
   - Ask the user which spec to decompose (by ID, e.g. `TECH-01`)
   - Read the target spec file

2. **Validate readiness**
   - Check that the spec has status `Approved` (warn if not)
   - Check that acceptance criteria (section 6) are populated
   - If ACs are missing or vague, warn the user and offer to refine them first

3. **Analyse acceptance criteria**

   For each AC, identify:
   - What code change is needed (endpoint, class, migration, config, etc.)
   - Whether it can be done in one step or needs to be split
   - Dependencies on other ACs or external systems

4. **Generate tasks**

   Populate the Tasks table with rows following these rules:

   - **One concrete action per task** — "Create registration endpoint with email validation",
     not "Build user management"
   - **Map every AC** — each AC must appear in at least one task's `AC(s)` column
   - **Order by dependency** — if T-02 needs T-01's output, say so in `Depends On`
   - **Keep tasks testable** — each task should produce a verifiable result
     (a passing test, a working endpoint, a valid migration)
   - **Prefer depth-first** — complete one feature slice top-to-bottom before starting the next

   Task types to consider:
   - Data model / schema changes
   - Core logic / business rules
   - API endpoints or interfaces
   - Validation and error handling
   - Tests (unit, integration)
   - Configuration or infrastructure
   - Documentation updates
   - **Migration / backward compatibility** — if existing contracts or data formats
     change, add explicit tasks for deprecation notices, adapter layers, data migration
     scripts, or versioned endpoints
   - **Refactoring** — if the existing code must be restructured before the new
     feature can be built, add preparatory refactoring tasks before the feature tasks

5. **Set all task statuses to `Pending`**

6. **Update the spec**

   Write the generated Tasks table into section 7 of the spec file.
   Update the spec status to `In Progress` if the user confirms they are ready to start.

7. **Present for review**

   Show the task list to the user. Ask:
   > "Does this breakdown make sense? Are any tasks too large, missing,
   > or in the wrong order?"

   Iterate until the user is satisfied.

8. **Suggest next steps**

   - "Start with T-01, implement and test it, then mark it as `Done`."
   - "After each task, update the Tasks table and the Implementation Status (section 8)."
   - "Reference the spec and task in your commit messages: `feat(auth): T-01 registration endpoint (TECH-01, AC-01)`"

## Notes

- **Keep it concise** — task descriptions should be one sentence of concrete action. Avoid filler words and vague language. Follow `docs/STYLE.md` section 3.
- A good task list has 5–15 tasks for a typical spec; if you have more than 20, the spec may be too large — suggest splitting it
- If the spec is a FUNC spec, tasks should focus on user-facing behaviour; if TECH, on contract implementation
- Do not implement any code — this agent only generates the task breakdown
- If the user wants to start implementing immediately, suggest running tasks one at a time rather than in parallel
