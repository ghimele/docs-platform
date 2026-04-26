# Copilot Workspace Instructions

This file is loaded automatically by GitHub Copilot for every conversation in this repository.
It defines the rules, structure, and conventions that apply to all agent-assisted work.

---

## Repository Structure

| Folder | Purpose | Mutability |
|--------|---------|------------|
| `src/` | Source code — C++ and .NET projects | Active |
| `docs/architecture/` | System-level data flows, cross-cutting invariants | Stable — change only with ADR |
| `docs/design/` | Component internals, trade-offs, implementation rationale | Active — evolves with implementation |
| `docs/specs/functional/` | What the system does (stakeholder-facing) | Versioned |
| `docs/specs/technical/` | Public contracts between components (developer-facing) | Versioned |
| `docs/adr/` | Accepted architectural decisions — immutable history | **Never delete or rewrite** |
| `docs/rfc/` | Open proposals under discussion | Draft |
| `docs/security/` | Threat model and coding standards | Active |
| `docs/templates/` | Document templates — not real documents | Stable |
| `agent/` | Copilot prompt files — platform owned | Updated via sync only |
| `instructions/` | Language and framework coding conventions | Active |

---

## Agents Available

| Agent | File | When to use |
|-------|------|-------------|
| `spec` | `agent/spec.prompt.md` | Starting any M, L, or XL change — RFC, ADR, spec, design docs, tasks |
| `code` | `agent/code.prompt.md` | Implementing a specific task from an approved spec |

**How to invoke:**
- `Ctrl+Shift+P` → `Chat: Run Prompt File` → select the agent
- Or open Copilot Chat and type: `Run #file:agent/spec.prompt.md`

**Handoff:** `spec` produces the task list → `code` implements one task at a time.

---

## Always Rules

- Read `docs/glossary.md` before working on any documentation task
- Use templates from `docs/templates/` when creating new documents
- Cross-link new docs to related ADRs in the `References` section
- Update the relevant `README.md` index when adding a new file
- Follow the header format in `docs/STYLE.md`
- Match existing naming conventions, file structure, and patterns — do not introduce new patterns without flagging them

---

## Brownfield Rules

Most work happens in a codebase that already has code, specs, and docs. Before creating anything new:

1. Search `docs/specs/`, `docs/architecture/`, `docs/design/`, `docs/adr/` for existing documents covering the same area — prefer updating over creating
2. Read the existing source files before specifying or generating new code
3. If the change modifies a public contract, the spec must include a migration or deprecation plan
4. State what is being kept, not just what is changing — use a "Current State" paragraph in Background sections
5. Favour extending existing patterns over introducing new ones — if a new pattern is needed, record the reason in an ADR

---

## Never Rules

- Delete or rewrite files in `docs/adr/` — supersede them with a new ADR instead
- Modify `docs/templates/` files as content — they are templates only
- Use YAML front matter in documentation — use the inline header block format
- Create a new ADR for a decision still under discussion — use `docs/rfc/` instead
- Approve a spec — only a human reviewer can set status to `Approved`
- Skip reading the relevant spec and design doc before writing code

---

## Workflow Tiers

Choose the tier that matches the size and risk of the work. When in doubt, go one tier higher.

| Tier | When | Required artefacts |
|------|------|--------------------|
| **S — Patch** | Bug fix, typo, config tweak — no behaviour change | PR description only — no agent needed |
| **M — Focused** | Single component, clear scope, ≤ 3 ACs | Spec → code |
| **L — Standard** | Multi-AC or cross-component | Spec → tasks → code |
| **XL — Full** | New system, open question, cross-cutting change | RFC → ADR → spec → plan → tasks → code |

---

## Spec Lifecycle

```
Draft → Under Review → Approved → In Progress → Implemented → Verified
```

- Agents can move a spec to `In Progress` — no further
- Only a human reviewer can set `Approved`
- Never skip `Under Review` — content is frozen at that point except for review-driven edits

---

## Traceability Rules

- Prefix test names with the AC ID: `AC01_MethodName_StateUnderTest_ExpectedBehaviour`
- After writing a test, fill the **Test** column in the spec's Acceptance Criteria table (section 6)
- After implementing an AC, update the spec's **Implementation Status** table (section 8) with the PR/commit reference
- Reference spec IDs in every commit message: `feat(auth): T-01 registration endpoint (TECH-01, AC-01)`
- When all tasks for an AC are `Done`, update the corresponding Implementation Status row

---

## C++ Conventions

- Standard: C++17 minimum
- Build system: CMake
- No raw owning pointers — use `std::unique_ptr` / `std::shared_ptr`
- All array accesses must be bounds-checked
- No `strcpy`, `sprintf`, or other unbounded C string functions
- No `system()` calls — use structured process APIs
- No `using namespace std` in headers
- All external input validated before use in any buffer or container

---

## .NET Conventions

Full conventions in `instructions/csharp-dotnet.instructions.md` — loaded automatically for all `.cs` files.

Quick reference:

- Nullable reference types enabled in all new projects
- Constructor injection only — no service locator
- `CancellationToken` propagated through every async call chain
- Never `.Result` / `.Wait()` on tasks
- Parameterised queries only — no SQL string concatenation
- Secrets from environment or secret store — never hardcoded
- Structured logging with `ILogger<T>` and message templates — no string interpolation in log calls

---

## Security Rules (All Languages)

| Rule | Requirement |
|------|-------------|
| SC-GEN-01 | Secrets must never appear in logs, exceptions, or error messages |
| SC-GEN-02 | Dependencies pinned to specific versions and reviewed on upgrade |
| SC-GEN-03 | Third-party libraries evaluated before use |
| S1 | All external input validated before use |
| S2 | Secrets never logged or written to source control |
| S3 | Authentication verified before any privileged operation |

Full security rules: `docs/security/coding-standards.md`
Threat model: `docs/security/threat-model.md`

---

## Files Copilot Must Not Modify

- `.github/copilot-instructions.md` (this file)
- `CONTRIBUTING.md`
- Any file in `docs/adr/` — immutable history
- Any file in `docs/templates/` — templates only
- `agent/*.prompt.md` — update via `sync-docs.sh` only
