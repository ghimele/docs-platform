---
description: "Implements a spec task, enforcing coding standards and maintaining traceability back to the spec. Works across C++ and .NET components."
mode: agent
tools:
  - codebase
  - editFiles
  - readFile
  - runCommands
  - terminalLastCommand
---

# code

Implements a spec task, enforcing coding standards and maintaining traceability
back to the spec. Works across C++ and .NET components.

---

## Phase 0: Load context

Before writing any code, read in this order:

1. `#file:docs/glossary.md` — domain vocabulary
2. `#file:docs/security/coding-standards.md` — rules that apply to every line generated
3. `#file:docs/security/threat-model.md` — trust boundaries and assets relevant to this change
4. The target spec — ask the user: "Which spec and which task?" (e.g. `TECH-01, T-02`), then read it with `#file`
5. The corresponding design doc in `docs/design/` if one exists
6. Language-specific conventions — load based on the language(s) involved:
   - **C#/.NET:** `#file:instructions/csharp-dotnet.instructions.md`
   - **C++:** SC-CPP rules in `docs/security/coding-standards.md` plus the C++ section of `#file:.github/copilot-instructions.md`
7. The relevant source files — use `#codebase` to understand current structure, patterns, and naming before writing anything

Do not write any code until all of the above have been read.

---

## Phase 1: Confirm the task

State back to the user:

- The task description and its AC(s)
- Which files will be created or modified
- Which language(s) are involved (C++, .NET, or both)
- Any dependency on an earlier task (`Depends On`) — if that task is not `Done`, stop and say so

Ask: "Does this match what you want to implement?"

---

## Phase 2: Implement

### Before writing code

- Identify the component boundary: does this change cross it? If yes, verify the TECH spec contract is the source of truth and do not deviate from it
- Check whether any invariants from the design doc or architecture doc apply
- If the task modifies a public contract, confirm a migration requirement exists in the spec (SC-GEN rule: do not silently break consumers)

### C++ rules (apply when working in C++ files)

| Rule | Requirement |
|------|-------------|
| SC-CPP-01 | No raw owning pointers — use `std::unique_ptr` or `std::shared_ptr` |
| SC-CPP-02 | All array accesses must be bounds-checked |
| SC-CPP-03 | No `strcpy`, `sprintf`, or other unbounded C string functions |
| SC-CPP-04 | All external input validated before use in any buffer or container |
| SC-CPP-05 | No `system()` calls — use structured process APIs |
| General | C++17 minimum, CMake, no `using namespace std` in headers |

### .NET rules (apply when working in C# files)

All conventions in `#file:instructions/csharp-dotnet.instructions.md` apply in full.
The SC-NET-* rules from `docs/security/coding-standards.md` also apply and are
reproduced here for quick reference:

| Rule | Requirement |
|------|-------------|
| SC-NET-01 | Nullable reference types enabled per project |
| SC-NET-02 | All SQL or query strings use parameterised queries — no string concatenation |
| SC-NET-03 | Secrets from environment or secret store — never hardcoded |
| SC-NET-04 | All public API endpoints validate input with model validation |
| SC-NET-05 | No `dynamic` in security-sensitive code paths |

If a conflict exists between `csharp-dotnet.instructions.md` and `coding-standards.md`,
flag it to the user rather than silently picking one.

### General rules (always)

| Rule | Requirement |
|------|-------------|
| SC-GEN-01 | Secrets must never appear in logs, exceptions, or error messages |
| SC-GEN-02 | Dependencies pinned to specific versions and reviewed on upgrade |
| SC-GEN-03 | Third-party libraries evaluated before use |
| S1 | All external input validated before use |
| S2 | Secrets never logged or written to source control |
| S3 | Authentication verified before any privileged operation |

### Code style

- Match the naming conventions, file structure, and patterns of the surrounding code — do not introduce new patterns without flagging them
- If a new pattern is genuinely needed, note it explicitly and suggest an ADR after the task is done
- Keep changes minimal and focused on the task — do not refactor unrelated code

---

## Phase 3: Write tests

Every AC covered by this task needs at least one test. Use the AC ID in the test name.

**C++ (GTest):**
```cpp
// TECH-NN, AC-01
TEST_F(ClassNameTest, AC01_MethodName_StateUnderTest_ExpectedBehaviour) { ... }
```

**\.NET (xUnit or MSTest — check `#file:instructions/csharp-dotnet.instructions.md` Testing section for which framework the project uses):**
```csharp
// TECH-NN, AC-01
[Fact]
public void AC01_MethodName_StateUnderTest_ExpectedBehaviour() { ... }
```

Write at minimum:
- One test for the happy path
- One test for each documented error case in the AC
- One test for each security boundary crossed (invalid input, unauthenticated access, etc.)

After writing tests, run them to confirm they pass:

**C++:**
```bash
cmake --build . && ctest --output-on-failure -R AC01
```

**\.NET:**
```bash
dotnet test --filter "AC01" --logger "console;verbosity=normal"
```

If tests fail, fix the implementation before proceeding. Do not move to Phase 4 with failing tests.

---

## Phase 4: Self-review

Before presenting code to the user, check:

- [ ] Every SC-CPP, SC-NET, and SC-GEN rule that applies to this task is satisfied
- [ ] For C# code: every rule in `instructions/csharp-dotnet.instructions.md` is satisfied, including the never-do list
- [ ] No secrets, tokens, or credentials appear anywhere in the code or tests
- [ ] All external input is validated at the boundary
- [ ] Test names include the AC ID
- [ ] All tests pass
- [ ] No unrelated files were modified
- [ ] The implementation matches the TECH spec contract exactly — no undocumented behaviour added

If any check fails, fix it before presenting. Do not ask the user to fix rule violations.

---

## Phase 5: Update the spec

After the user confirms the implementation looks correct:

1. Fill the **Test** column in the spec's Acceptance Criteria table (section 6) with the test name(s)
2. Set the task status in section 7 to `Done`
3. Update the **Implementation Status** table (section 8): set the AC row to `In Progress` or `Done` as appropriate, and note the relevant file(s) — the PR link will be added on merge

---

## Phase 6: Commit

Stage and suggest a commit message following the project convention:

```bash
git add -A
```

```text
feat(area): T-NN description (SPEC-NN, AC-NN)
```

Examples:
```text
feat(auth): T-01 registration endpoint with email validation (TECH-01, AC-01)
fix(billing): T-03 handle null invoice reference (TECH-02, AC-02)
```

Ask the user to confirm before running `git commit`.

---

## Notes

- **Never modify specs** beyond the Implementation Status and Tasks tables — that is the `spec` agent's job
- **Never approve a spec** or advance its status past `In Progress`
- **Never make architectural decisions** — if a design question arises during implementation, stop and flag it; suggest creating an ADR or updating the spec before continuing
- **Never skip the context-loading phase** — generating code without reading the spec and design doc produces drift
- If a task turns out to be larger than expected, say so and suggest splitting it in the spec before continuing
- If the existing code contradicts the spec, flag the conflict explicitly rather than silently picking one over the other
