# rfc-generate

Generates an RFC from a high-level problem or question provided by the user.

## Description

Use this agent when you have an open question, a decision to make, or multiple
approaches to consider. The agent interviews the user to understand the problem
space, then generates a complete RFC using `docs/templates/rfc.md`.

This maps to the **exploration half** of the Specify phase — the part where you
think through options before committing to a direction.

## Steps

1. **Confirm this needs an RFC**
   - An RFC is appropriate for **XL-tier** work: new systems, open questions with
     multiple viable approaches, or cross-cutting changes (see `docs/AGENTS.md` Workflow sizing)
   - If the user already knows the answer, suggest skipping the RFC and going
     directly to an ADR or spec

2. **Load context**
   - Read `docs/glossary.md` for domain vocabulary
   - Read `docs/STYLE.md` for formatting rules
   - Read `docs/templates/rfc.md` for the template structure
   - Scan `docs/rfc/` to determine the next sequential ID
   - Scan `docs/adr/` to check if a decision already exists on this topic

3. **Check for prior work**
   - If an ADR already covers this topic, tell the user and ask whether
     they want to supersede it or address a different aspect
   - If an existing RFC is open on the same topic, suggest updating it instead

4. **Interview the user**

   Ask the following questions (skip any the user has already answered):

   - **What is the problem?** What is the current state and why is it insufficient?
   - **What options are you considering?** At least two — if the user only has one,
     ask: "What would happen if you did nothing? What is the opposite approach?"
   - **What constraints apply?** Performance targets, compliance, team expertise,
     existing system limitations.
   - **What exists today?** Describe the current system state — what works, what
     would break, and what must remain backward-compatible.
   - **What is the impact?** Which code, docs, and agents would be affected?
   - **What is the discussion timeline?** Concrete date or open-ended?

5. **Generate the RFC**

   Create the RFC file using the template. Fill every section:

   - **Summary** — one paragraph from "what is the problem" + the proposed direction
   - **Problem Statement** — from the interview, with links to issues or existing docs
   - **Proposed Solution** — the user's preferred option, expanded with a Mermaid diagram if applicable
   - **Options Considered** — at least two options with concrete pros and cons
     - Include "do nothing / keep current behaviour" as an option when applicable
     - Avoid vague pros/cons ("simpler" → "reduces code from ~500 to ~200 lines")
     - For each option, state what existing code or contracts would need to change
   - **Open Questions** — unresolved issues surfaced during the interview
   - **Impact** — on code, documentation, and agents
   - **Acceptance Criteria** — conditions that must be true for the RFC to graduate to an ADR
   - **Decision** — leave blank (filled when resolved)

6. **Set header fields**

   - **Status:** `Open`
   - **Author:** ask the user or use the one provided
   - **Discussion deadline:** from the interview
   - **Related ADRs:** fill if any exist

7. **Update the index**

   Add the new RFC to `docs/rfc/README.md` in the index table.

8. **Present for review**

   Show the generated RFC to the user. Ask:
   > "Does this capture the problem and options accurately? Are there
   > options, constraints, or open questions I missed?"

   Iterate until the user is satisfied.

9. **Suggest next steps**

   - "Share this RFC with the team for discussion."
   - "Once a decision is reached, run `rfc-resolve` to graduate this to an ADR."

## Notes

- **Keep it concise** — follow `docs/STYLE.md` section 3: one idea per paragraph, lead with the conclusion, delete filler. Target 1–2 pages. Use tables for option comparisons and Mermaid diagrams for flows. Omit empty optional sections.
- An RFC is not a spec — it captures the *decision space*, not the *solution*
- Always include at least two options with concrete trade-offs
- If the user already knows the answer, suggest skipping the RFC and going directly to an ADR
- Do not create an ADR during this step — that is the job of `rfc-resolve`
- Open questions should be specific and answerable ("What is the expected p99 latency?"), not vague ("Is this a good idea?")
