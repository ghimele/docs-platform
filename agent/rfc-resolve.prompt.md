# rfc-resolve

Resolves a concluded RFC by generating an ADR, updating the RFC status,
and optionally kicking off spec generation.

## Description

Use this agent when an RFC discussion has reached a conclusion and you are ready
to record the decision. The agent reads the RFC, generates an ADR from the chosen
option, closes the RFC, and suggests whether a spec should be created next.

This is the **decision checkpoint** between exploration (RFC) and commitment (ADR + spec).

## Prerequisites

- The target RFC must exist in `docs/rfc/`
- The RFC should have its open questions resolved (warn if any remain unchecked)

## Steps

1. **Load context**
   - Read `docs/glossary.md` for domain vocabulary
   - Read `docs/STYLE.md` for formatting rules
   - Read `docs/templates/adr.md` for the template structure
   - Ask the user which RFC to resolve (by ID, e.g. `RFC-01`)
   - Read the target RFC file
   - Scan `docs/adr/` to determine the next sequential ADR ID

2. **Validate readiness**
   - Check that the RFC has status `Open`
   - Check that open questions (section 4) are resolved — warn if any remain
   - If the RFC was already resolved (`Accepted`/`Rejected`/`Withdrawn`), ask
     the user to confirm they want to update it

3. **Ask for the decision**

   - **Which option was chosen?** (reference the Options Considered section)
   - **Why?** Brief rationale — this becomes the ADR's Rationale section
   - **Was the outcome Accepted, Rejected, or Withdrawn?**

   If `Rejected` or `Withdrawn`, skip to step 6 (no ADR needed).

4. **Generate the ADR** (Accepted only)

   Create the ADR file using the template. Derive content from the RFC:

   - **Context** — from RFC's Problem Statement, adapted to past tense
     ("We needed to decide..." not "We need to decide...")
   - **Decision** — clear statement: "We will [chosen option]."
   - **Options Considered** — carry over from RFC, including pros/cons
   - **Rationale** — from the user's "why" answer, referencing constraints from Context
   - **Consequences** — derive from the chosen option's pros (positive), cons (negative),
     and any risks identified during discussion
   - **Constraints & Invariants** — extract any rules that must always hold as a result
     of this decision; use ADR-NN prefix codes
   - **References** — link back to the source RFC

5. **Update the ADR index**

   Add the new ADR to `docs/adr/README.md` in the index table.

6. **Close the RFC**

   Update the RFC file:
   - Set status to `Accepted`, `Rejected`, or `Withdrawn`
   - Fill the Decision section (section 7):
     - **Outcome:** the chosen status
     - **Date:** today
     - **ADR:** link to the new ADR (if accepted)
     - **Reason:** brief rationale

7. **Update the RFC index**

   Update the status column in `docs/rfc/README.md` for this RFC.

8. **Present for review**

   Show the generated ADR and updated RFC to the user. Ask:
   > "Does this ADR accurately capture the decision and its consequences?
   > Are there invariants or risks I missed?"

   Iterate until the user is satisfied.

9. **Suggest next steps**

   Based on the decision outcome:

   - **Accepted:**
     - "Does this decision require a new spec? If so, run `spec-generate` to create one."
     - "If this affects existing specs, update their `Related ADRs` header."
     - "If this supersedes an earlier ADR, mark the old one as `Superseded by ADR-NN`."
   - **Rejected:**
     - "The RFC is closed. The file is kept as a record of what was considered."
   - **Withdrawn:**
     - "The RFC is closed. Consider reopening if circumstances change."

## Notes

- **Keep it concise** — follow `docs/STYLE.md` section 3: ADRs should be 0.5–1 page. Lead with the decision, use a table for options, delete filler. Omit empty optional sections.
- Never delete the RFC file — it serves as a record of the discussion
- ADRs are immutable once accepted — get it right before finalising
- If the decision supersedes an existing ADR, update the old ADR's status to
  `Superseded by ADR-NN` but do not modify its content
- The agent should NOT create specs during this step — suggest `spec-generate` as a next step
- If the user wants to reject an RFC, an ADR is not created — only the RFC is updated
