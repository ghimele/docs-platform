# FUNC-NN / TECH-NN: Title

**Status:** Draft  
**Last updated:** YYYY-MM-DD  
**Owner:** <!-- name or team -->  
**Reviewed by:** <!-- required before leaving Draft; comma-separated names -->  
**Approved date:** <!-- YYYY-MM-DD; filled when status moves to Approved -->  
**Version:** 0.1  
**Related ADRs:** <!-- ADR-NN or remove line -->  

---

<!-- DELETE ONE OF THE TWO LINES BELOW depending on spec type -->
<!-- This is a FUNCTIONAL spec — describes WHAT the system does (stakeholder-facing) -->
<!-- This is a TECHNICAL spec — defines the PUBLIC CONTRACT of a component:
     APIs, message schemas, wire formats, error codes, integration protocols.
     For internal implementation details, see the corresponding design document
     in docs/design/. -->

---

## 1. Purpose

<!-- What feature, behaviour, or contract does this spec define?
     Who is the audience? -->

---

## 2. Scope

### In Scope

-

### Out of Scope

-

---

## 3. Background

<!-- Why is this spec needed? What problem does it solve?
     Link to any related RFC, issue, or ADR. -->

---

## 4. Requirements

<!-- For functional specs: use user-story or requirement format.
     For technical specs: use precise interface/contract language. -->

### Functional Requirements

| ID | Requirement | Priority |
| -- | ----------- | -------- |
| FR-01 | <!-- description --> | Must |
| FR-02 | | Should |

### Non-Functional Requirements

| ID | Requirement | Target |
| -- | ----------- | ------ |
| NFR-01 | <!-- e.g. latency --> | <!-- e.g. p99 < 100ms --> |

---

## 5. Detailed Specification

<!-- Main content.
     For functional specs: describe behaviour, workflows, and user interactions.
     For technical specs: define the public contract — types, signatures,
     error codes, data formats, sequence diagrams.
     Do NOT include internal implementation details here;
     those belong in a design document (docs/design/). -->

---

## 6. Acceptance Criteria

<!-- Testable conditions that must be true for this spec to be considered met.
     Each criterion has a unique ID used to trace it to tests and implementation.
     Fill the Test column when tests are written (see docs/testing/strategy.md section 8). -->

| ID | Criterion | Test |
| -- | --------- | ---- |
| AC-01 | <!-- criterion --> | <!-- e.g. AuthServiceTest::Login_ValidCreds_ReturnsToken --> |
| AC-02 | <!-- criterion --> | <!-- test name or "N/A" for non-testable criteria --> |

---

## 7. Tasks

<!-- Break the acceptance criteria into small, ordered work items.
     Each task should be independently implementable and testable.
     Tasks are the bridge between "what must be true" (AC) and "who did it" (Implementation Status).

     Guidelines:
     - Derive tasks from ACs — every AC should be covered by at least one task.
     - Keep tasks small: one function, one endpoint, one migration — not "build auth".
     - Order tasks by dependency: later tasks may depend on earlier ones.
     - A task may cover multiple ACs, and an AC may need multiple tasks.
     - Mark status as work progresses: Pending → In Progress → Done → Blocked. -->

| ID | Description | AC(s) | Depends On | Status |
| -- | ----------- | ----- | ---------- | ------ |
| T-01 | <!-- e.g. Create user registration endpoint with email validation --> | AC-01 | — | Pending |
| T-02 | <!-- e.g. Add password hashing using bcrypt --> | AC-01 | T-01 | Pending |
| T-03 | <!-- e.g. Return 409 when email already exists --> | AC-02 | T-01 | Pending |

---

## 8. Implementation Status

<!-- Track implementation progress per acceptance criterion.
     Update this section as work progresses.
     Status values: Pending | In Progress | Done | Blocked -->

| AC ID | Status | PR / Commit | Verified Date |
| ----- | ------ | ----------- | ------------- |
| AC-01 | Pending | <!-- e.g. #123 or abc1234 --> | |
| AC-02 | Pending | | |

---

## 9. Changelog

| Version | Date | Author | Changes |
| ------- | ---- | ------ | ------- |
| 0.1 | YYYY-MM-DD | <!-- name --> | Initial draft |

<!-- Record status transitions here too:
     | 0.2 | 2026-04-01 | J. Smith | Status → Under Review |
     | 1.0 | 2026-04-10 | J. Smith | Approved by A. Jones  | -->

---

## 10. References

<!-- Status lifecycle: Draft → Under Review → Approved → In Progress → Implemented → Verified
     See docs/STYLE.md section 5 for full rules and approval requirements.
     See docs/testing/strategy.md section 8 for spec-driven test naming.
     See section 7 above for task breakdown guidance. -->

-
