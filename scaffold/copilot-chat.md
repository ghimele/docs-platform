# Using Copilot Chat Prompts

**Status:** Active  
**Last updated:** 2026-04-15  
**Owner:** docs-platform maintainers  

---

## 1. Purpose

This guide explains how to use the platform prompt files in `agent/` from
VS Code Copilot Chat.

It focuses on two things:

- How to think about the available prompts in the spec-driven workflow
- What to ask Copilot for each workflow tier: `S`, `M`, `L`, and `XL`

---

## 2. Where the Prompts Live

After scaffolding, the platform-owned prompt files are copied into:

```text
agent/
```

These files are updated by `sync-docs.sh` and should normally be treated as
platform-owned guidance.

Available prompts:

- `agent/doc-scaffold.prompt.md`
- `agent/doc-sync.prompt.md`
- `agent/rfc-generate.prompt.md`
- `agent/rfc-resolve.prompt.md`
- `agent/spec-generate.prompt.md`
- `agent/spec-plan.prompt.md`
- `agent/spec-tasks.prompt.md`

---

## 3. How to Use Them in Copilot Chat

Open Copilot Chat in VS Code and ask for the workflow step you want.

You do not need to paste the full prompt file into chat every time. The practical
pattern is:

1. Mention the workflow step you want.
2. Give Copilot the business or technical context.
3. State the expected output file or document type.
4. Tell it whether this is `S`, `M`, `L`, or `XL` work.

Good prompt shape:

```text
Use the spec-generate workflow for this M-tier change.
We are adding email-based sign-in to the customer portal.
Audience is product + QA.
Create a functional spec and update the relevant index.
```

If you want tighter control, refer to the prompt by name explicitly:

```text
Follow agent/spec-generate.prompt.md for this feature.
```

---

## 4. Which Prompt to Use

| Goal | Prompt |
| ---- | ------ |
| First-time docs setup | `doc-scaffold` |
| Pull latest platform updates | `doc-sync` |
| Explore an open decision | `rfc-generate` |
| Record the chosen decision | `rfc-resolve` |
| Write a spec from a feature idea | `spec-generate` |
| Create architecture or design docs | `spec-plan` |
| Break approved spec into tasks | `spec-tasks` |

---

## 5. Tier Examples

### S-tier: Patch

Use `S` when the change is small and does not need a spec.

Typical cases:

- Typo fixes
- Small configuration corrections
- Bug fixes with no contract or behaviour design work

Example Copilot Chat request:

```text
This is an S-tier patch.
Fix the typo in the onboarding error message and update the PR description language.
No spec is needed.
```

Expected result:

- Copilot makes the code or docs fix directly
- No RFC, ADR, spec, or task breakdown is created

### M-tier: Focused

Use `M` for a small, clear feature, usually within one component and with a small
number of acceptance criteria.

Typical cases:

- Add a single endpoint
- Add a focused workflow step
- Define one contained contract or feature

Example Copilot Chat request:

```text
Use the spec-generate workflow for this M-tier change.
We need a functional spec for passwordless email login in the admin portal.
Audience is product, QA, and engineering.
Current state: users can only sign in with password.
Out of scope: social login and MFA.
Create the spec and update the specs index.
```

Expected result:

- Copilot generates a focused `FUNC` or `TECH` spec
- Tasks are optional
- Implementation can usually start after review

### L-tier: Standard

Use `L` when the work has multiple acceptance criteria or spans multiple components.

Typical cases:

- A feature with frontend + backend changes
- A contract change that affects more than one consumer
- Work that benefits from task sequencing

Example Copilot Chat request:

```text
Use the spec-generate workflow for this L-tier change, then prepare tasks.
We are adding invoice export to CSV across the API and admin UI.
The export format will be used by finance operations.
Current state: invoices can be viewed but not exported.
Create the spec first, then use spec-tasks to break it into ordered tasks.
```

Expected result:

- Copilot creates the spec
- Copilot then decomposes it into tasks with dependencies
- This is the normal path for structured feature delivery

### XL-tier: Full

Use `XL` when the decision is open, the change is cross-cutting, or a new system
or pattern is being introduced.

Typical cases:

- New platform capability
- Cross-cutting architecture change
- Multiple viable implementation approaches

Example Copilot Chat request:

```text
This is an XL-tier change.
Use rfc-generate first.
We need to decide how to add event-driven integration between billing and fulfillment.
Options include direct HTTP calls, queue-based events, or an outbox pattern.
Current state: billing and fulfillment are loosely coordinated by manual retries.
After the RFC is resolved, we will need an ADR, then a technical spec, then planning and tasks.
```

Expected result:

- `rfc-generate` explores the decision space
- `rfc-resolve` records the selected decision as an ADR
- `spec-generate` defines the implementation contract
- `spec-plan` creates architecture/design support docs
- `spec-tasks` prepares implementation steps

---

## 6. Example Prompt Chains

### M-tier chain

```text
Use spec-generate for this M-tier feature.
We are adding account lockout after repeated failed sign-in attempts.
Audience is product, QA, and backend developers.
Create the spec and stop after the draft is ready.
```

### L-tier chain

```text
Use spec-generate for this L-tier feature.
After the spec is drafted, use spec-tasks to create the task breakdown.
Feature: customers can download monthly usage reports as CSV from the portal.
Current state: reports are view-only.
```

### XL-tier chain

```text
Use the full XL workflow.
Start with rfc-generate for multi-region tenant routing.
Once a direction is chosen, use rfc-resolve, then spec-generate, then spec-plan, then spec-tasks.
```

---

## 7. Good Copilot Inputs

Copilot will produce better output if you provide:

- Current state: what exists today
- Audience: stakeholder-facing or developer-facing
- Scope: what is in and out
- Constraints: performance, compliance, migration, compatibility
- Tier: `S`, `M`, `L`, or `XL`

Weak input:

```text
Make a spec for auth.
```

Better input:

```text
Use spec-generate for this M-tier change.
We are adding password reset by email for internal users.
Audience is product, QA, and backend developers.
Current state: admins reset passwords manually.
Constraint: links expire after 15 minutes.
Out of scope: MFA reset.
```

---

## 8. When to Stop

Do not automatically run the full chain every time.

- Stop after `spec-generate` for many `M` changes
- Stop after `spec-tasks` if the user wants to implement manually
- Use `rfc-generate` only when the decision is genuinely open

The goal is proportional process, not maximum paperwork.

---

## 9. References

- `README.md`
- `AGENTS.md`
- `agent/spec-generate.prompt.md`
- `agent/spec-plan.prompt.md`
- `agent/spec-tasks.prompt.md`
- `agent/rfc-generate.prompt.md`
- `agent/rfc-resolve.prompt.md`
