# Contributing

Thank you for your interest in contributing to this project.

This document describes the mechanics of contribution.
It does not describe architectural rules, constraints, or design principles.

---

## 1. Required Reading

Before contributing, read:

- `docs/README.md` — documentation map and navigation
- `docs/STYLE.md` — document formatting rules
- `docs/glossary.md` — shared vocabulary
- Relevant ADRs in `docs/adr/`

These documents define the rules and constraints of the system.

---

## 2. Contribution Workflow

1. Fork the repository
2. Create a feature branch
3. **Pick a workflow tier** (see table below)
4. Create the required artefacts for that tier
5. Make your changes
6. Update documentation when required
7. Submit a pull request

### Workflow tiers

Choose the tier that matches the size and risk of the change.
See `docs/AGENTS.md` for detailed selection criteria.

| Tier | When | Required before merging |
| ---- | ---- | ----------------------- |
| **S — Patch** | Bug fix, typo, config — no behaviour change | PR description only |
| **M — Focused** | Single-component feature, ≤ 3 ACs | Spec (FUNC or TECH) |
| **L — Standard** | Multi-AC feature or cross-component work | Spec + tasks breakdown |
| **XL — Full** | New system, open question, cross-cutting | RFC → ADR → spec → plan → tasks |

When in doubt, pick one tier higher.

---

## 3. Pull Request Expectations

A pull request should:

- Clearly describe the change
- Reference relevant documentation or ADRs
- Be limited in scope
- Include documentation updates if behaviour changes

### Referencing specs in PRs

When a PR implements part or all of a spec:

1. Title or description must reference the spec ID (e.g. `Implements TECH-001`).
2. List which acceptance criteria are addressed (e.g. `Covers AC-01, AC-02`).
3. After merge, update the spec's **Implementation Status** table (section 8) with the PR link and set each covered AC to `Done`.

### Commit messages

When a commit directly addresses a spec acceptance criterion, include the spec and
AC IDs in the commit message:

```text
feat(auth): implement token validation (TECH-001, AC-02)
```

---

## 4. Documentation Changes

When modifying documentation:

- Follow templates in `docs/templates/`
- Follow style rules in `docs/STYLE.md`
- Update the `README.md` index of the affected folder
- Never delete or rewrite files in `docs/adr/` — supersede them instead

---

## 5. Spec Review & Approval

Specs follow a stricter lifecycle than other documents (see `docs/STYLE.md` section 5).

### Submitting a spec for review

1. Set status to `Under Review` and freeze content.
2. Fill the **Reviewed by** field with the intended reviewer(s).
3. Open a pull request titled `spec: FUNC-NN / TECH-NN — Title`.
4. Request reviews from the listed reviewer(s).

### Reviewer responsibilities

- Verify scope, requirements, and acceptance criteria are clear and testable.
- Check cross-links to ADRs, architecture, and related specs.
- Approve the PR to signal sign-off.

### Approval

- All listed reviewers must approve the PR.
- The **Owner** and **Reviewer(s)** must be different people.
- On approval, the author sets status to `Approved`, fills **Approved date**, and merges.

### Rejection

- If rejected, the author sets status to `Rejected`, adds a changelog entry with the reason, and closes the PR. The file is kept as a record.

---

## 6. Questions

If you are unsure about a change, open an issue before submitting a pull request.
