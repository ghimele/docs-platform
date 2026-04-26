# Changelog

All notable changes to docs-platform are documented here.
Consuming repos should review this file when running `sync-docs.sh`.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

---

## [Unreleased]

### Changed

- **Agent set reduced from seven to two** — all workflow agents collapsed into
  `agent/spec.prompt.md` and `agent/code.prompt.md`:
  - `spec` handles the full RFC → ADR → spec → plan → tasks workflow in a single
    conversation, skipping phases not needed for the tier (M, L, or XL)
  - `code` handles task-by-task implementation with spec traceability, security
    rule enforcement, test execution, and commit preparation
  - Removed: `doc-scaffold.prompt.md`, `doc-sync.prompt.md`, `rfc-generate.prompt.md`,
    `rfc-resolve.prompt.md`, `spec-generate.prompt.md`, `spec-plan.prompt.md`,
    `spec-tasks.prompt.md`
  - **Breaking:** consuming repos referencing old prompt files by name in
    `copilot-chat.md` or custom scripts should update to the two new agent names
- **Prompt files are now GitHub Copilot (VS Code) native** — all `.prompt.md`
  files include Copilot frontmatter (`mode: agent`, `tools`) so they run
  directly via `Chat: Run Prompt File` without copy-pasting content into chat.
  File references use `#file:` syntax; workspace search uses `#codebase`
- `agent/code.prompt.md` runs tests after writing them (`dotnet test --filter` /
  `ctest -R`) and blocks on failure before proceeding to the self-review phase.
  Also runs `git add -A` and prepares a traced commit message, asking for
  confirmation before committing
- `init-docs.sh` and `init-docs.ps1` now copy two additional folder trees:
  - `.github/` — includes `copilot-instructions.md` for automatic Copilot loading
  - `instructions/` — includes `*.instructions.md` language convention files
  - PowerShell script refactored: repeated copy logic extracted into
    `Copy-NewFilesOnly` helper function
  - "Next steps" output updated to mention the two new folders
- `README.md` updated: prompt set table replaced with two-agent table, repository
  layout tree updated, sync surface table updated, contributing alignment rules added

### Added

- **`.github/copilot-instructions.md`** added to scaffold — loaded automatically
  by GitHub Copilot for every workspace conversation. Contains: repository
  structure map, agent index with invocation instructions, always/never/brownfield
  rules, workflow tier table, spec lifecycle, traceability rules, C++ conventions,
  .NET conventions summary, and security rules. Replaces manual context-setting.
  - **Breaking:** consuming repos that already have `.github/copilot-instructions.md`
    will not have it overwritten by init (skip-if-exists). Run `sync-docs.sh` to
    update it going forward.
- **`instructions/` folder** added to scaffold and sync surface — holds
  language-specific coding convention files loaded by the `code` agent at runtime:
  - `instructions/csharp-dotnet.instructions.md` — full C#/.NET conventions
    covering nullable reference types, async/await, DI, EF Core, error handling,
    P/Invoke, logging, testing (xUnit/MSTest), formatting (CSharpier/dotnet format),
    and a never-do list. Includes `applyTo: "**/*.cs"` frontmatter so Copilot
    auto-applies it to all C# files. Covers both .NET 6+ and .NET Framework 4.8.
- **`sync-docs.sh` sync surface expanded** — `.github/copilot-instructions.md`
  and `instructions/*.instructions.md` added as platform-owned files updated
  on sync

### Removed

- `agent/doc-scaffold.prompt.md` — scaffold is a one-time script operation,
  not an agent conversation
- `agent/doc-sync.prompt.md` — sync is a one-line bash/PowerShell command,
  not an agent conversation
- `agent/rfc-generate.prompt.md` — functionality absorbed into `spec` Phase 1
- `agent/rfc-resolve.prompt.md` — functionality absorbed into `spec` Phase 2
- `agent/spec-generate.prompt.md` — functionality absorbed into `spec` Phase 3
- `agent/spec-plan.prompt.md` — functionality absorbed into `spec` Phase 4
- `agent/spec-tasks.prompt.md` — functionality absorbed into `spec` Phase 5

---

## [Previous Unreleased entries — carried forward]

### Changed

- `init-docs.sh` and `init-docs.ps1` now support scaffolding into a plain folder without requiring `.git`
- Init scripts now reuse the local `docs-platform` checkout when run from a manual clone instead of re-cloning the platform repo
- Init scripts now support explicit local source override via `DOCS_PLATFORM_PATH` / `-PlatformPath`
- Init scripts now copy platform-owned prompt files from `agent/` into consuming repos
- `sync-docs.sh` now updates platform-owned prompt files under `agent/` in consuming repos
- Added `docs/copilot-chat.md` guide explaining how to use the platform prompts in VS Code Copilot Chat, with examples for `S`, `M`, `L`, and `XL` tiers
- Added brownfield (existing codebase) guidance across scaffold and agent prompts
- Added size-based workflow selection (S/M/L/XL tiers)
- Added conciseness guidance across scaffold and agent prompts
  - **Breaking:** STYLE.md section numbers shifted by one (e.g. Spec Lifecycle is now section 5, not 4)
- Added agent-driven generation prompts for spec-driven development workflow
- Added task decomposition layer to spec template
  - **Breaking:** spec template section numbering changed (new section 7 shifts all subsequent sections)
- Clarified boundary between technical specs and design documents
  - **Breaking:** consuming repos using TECH specs for internal implementation details should move that content to design documents
- Added spec-specific status lifecycle and approval workflow
  - **Breaking:** spec template header has new required fields (`Reviewed by`, `Approved date`)
- Added spec-driven traceability: acceptance criteria → tests → implementation
  - **Breaking:** spec template section numbering changed (new section 7 shifts Changelog to 8 and References to 9)
- Added spec-driven development workflow and document creation flow

### Removed

- Removed `scaffold/api/` folder — redundant with TECH specs
  - **Breaking:** consuming repos with `docs/api/` should migrate content into `docs/specs/technical/`

### Added

- Initial scaffold structure with architecture, design, specs, adr, rfc, testing, security, templates
- `init-docs.sh` for first-time repo scaffolding
- `sync-docs.sh` for updating templates in existing repos
- Azure DevOps sync pipeline template
- `.platform-version` tracking file

---

<!-- Add new releases above this line -->
