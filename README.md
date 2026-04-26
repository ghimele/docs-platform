# docs-platform

Shared documentation scaffold, templates, and Copilot prompts for spec-driven
development.

This repository is the source of truth for:

- Documentation structure copied into consuming repos
- Templates for ADRs, RFCs, architecture, design, and specs
- Formatting and lifecycle conventions
- Agent prompts that support the RFC → ADR → spec → plan → tasks → code workflow

---

## Latest Changes

Recent platform updates include:

- **Simplified agent set:** seven agents collapsed into two — `spec` and `code`.
  `spec` handles the full RFC → ADR → spec → plan → tasks workflow in a single
  conversation, skipping phases not needed for the tier. `code` handles
  task-by-task implementation with full traceability back to the spec.
- **GitHub Copilot (VS Code) support:** prompt files now include Copilot-native
  frontmatter (`mode: agent`, `tools`, `applyTo`) so they run directly via
  `Chat: Run Prompt File` without copy-pasting.
- **`.github/copilot-instructions.md`:** auto-loaded by Copilot every session —
  replaces manual context-setting with workspace-wide rules, agent index, and
  security rules.
- **`instructions/` folder:** language-specific coding conventions loaded by the
  `code` agent at runtime. `csharp-dotnet.instructions.md` auto-applies to all
  `.cs` files via `applyTo` frontmatter.
- **`code` agent runs tests and stages commits:** after writing code the agent
  runs the relevant tests (`dotnet test --filter` / `ctest -R`) and prepares a
  traced commit message before asking for confirmation.
- Brownfield guidance, workflow sizing tiers, spec lifecycle, and AC-ID
  traceability conventions carried forward unchanged.

See [CHANGELOG.md](CHANGELOG.md) for full details and migration notes.

---

## Workflow at a Glance

Not every change needs the same ceremony.

| Tier | When to use | Flow |
| ---- | ----------- | ---- |
| `S` | Patch, typo, config tweak, no behavioural change | PR only — no agent needed |
| `M` | Focused feature, single component, ≤ 3 ACs | `spec` → code |
| `L` | Multi-AC or cross-component change | `spec` → tasks → `code` |
| `XL` | Open question, new system, cross-cutting decision | `spec` (RFC → ADR → spec → plan → tasks) → `code` |

---

## Agents

| Agent | File | Purpose |
| ----- | ---- | ------- |
| `spec` | `agent/spec.prompt.md` | Everything from RFC to task breakdown |
| `code` | `agent/code.prompt.md` | Task-by-task implementation with traceability |

### How to invoke in VS Code

```text
Ctrl+Shift+P → Chat: Run Prompt File → select agent/spec.prompt.md
```

Or in Copilot Chat:

```text
Run #file:agent/spec.prompt.md
```

### Handoff

`spec` produces the approved task list → `code` implements one task at a time.
Pass the spec ID and task ID when starting `code`: `TECH-01, T-02`.

---

## How to Use This Repo

### New repository

On GitHub, use `docs-platform` as a template repository to start with a clean
documentation scaffold.

For manual setup, clone `docs-platform` next to the target folder and run the
init script from that folder:

Bash (macOS / Linux / WSL):

```bash
git clone https://github.com/yourorg/docs-platform
cd your-target-folder
../docs-platform/scripts/init-docs.sh
```

PowerShell (Windows):

```powershell
git clone https://github.com/yourorg/docs-platform
cd your-target-folder
..\docs-platform\scripts\init-docs.ps1
```

### Existing repository

Use `scripts/sync-docs.sh` to pull platform-owned template and prompt updates
into an existing repo without touching project-specific documentation.

---

## Repository Layout

`scaffold/` is the canonical payload copied into consuming repos.

```text
docs-platform/
├── scaffold/
│   ├── .github/
│   │   └── copilot-instructions.md   # auto-loaded by Copilot every session
│   ├── AGENTS.md
│   ├── CONTRIBUTING.md
│   ├── CHANGELOG.md
│   ├── STYLE.md
│   ├── glossary.md
│   ├── adr/
│   ├── architecture/
│   ├── design/
│   ├── rfc/
│   ├── security/
│   ├── specs/
│   ├── templates/
│   └── testing/
├── instructions/
│   └── csharp-dotnet.instructions.md # auto-applied to *.cs by Copilot
├── scripts/
│   ├── init-docs.ps1
│   ├── init-docs.sh
│   └── sync-docs.sh
└── agent/
    ├── spec.prompt.md                # RFC → ADR → spec → plan → tasks
    └── code.prompt.md                # task implementation + traceability
```

---

## Sync Surface

What `sync-docs.sh` updates and what it leaves alone:

| Path | Updated by sync |
| ---- | --------------- |
| `docs/templates/` | Yes |
| `docs/STYLE.md` | Yes |
| `docs/copilot-chat.md` | Yes |
| `.markdownlint.json` | Yes |
| `.github/copilot-instructions.md` | Yes |
| `agent/*.prompt.md` | Yes |
| `instructions/*.instructions.md` | Yes |
| `docs/.platform-version` | Yes |
| `docs/glossary.md` | No |
| `docs/adr/` | No |
| `docs/rfc/` | No |
| `docs/design/` | No |
| `docs/architecture/` | No |
| `docs/specs/` | No |
| `AGENTS.md` | No |
| `CONTRIBUTING.md` | No |
| `CHANGELOG.md` | No |

---

## Contributing

Changes to structure, templates, or shared conventions should be made inside
`scaffold/` and recorded in [CHANGELOG.md](CHANGELOG.md) when they affect
consuming repos.

If you change the documentation model in a way that affects consuming projects:

- Add an unreleased changelog entry with migration guidance
- Keep `agent/` prompts aligned with the scaffold and scripts
- Keep `.github/copilot-instructions.md` aligned with `AGENTS.md`
- Keep `instructions/*.instructions.md` aligned with `docs/security/coding-standards.md`
- Treat breaking changes explicitly — especially spec numbering, lifecycle, and folder ownership rules
