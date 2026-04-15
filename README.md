# docs-platform

Shared documentation scaffold, templates, and Copilot prompts for spec-driven
development.

This repository is the source of truth for:

- Documentation structure copied into consuming repos
- Templates for ADRs, RFCs, architecture, design, and specs
- Formatting and lifecycle conventions
- Agent prompts that support the RFC -> ADR -> spec -> plan -> tasks workflow

---

## Latest changes

Recent platform updates include:

- Brownfield guidance: agents should scan existing docs and code first, prefer
    updating existing artefacts, and account for backward compatibility
- Workflow sizing tiers: `S`, `M`, `L`, `XL` now determine how much process a
    change needs
- Expanded prompt set: RFC generation/resolution plus spec generation, planning,
    and task decomposition
- Spec lifecycle and traceability: review state, approval fields, acceptance
    criteria tables, tasks, and implementation tracking
- Clear boundary between technical specs and design docs: technical specs define
    public contracts, design docs cover internals
- Removal of `docs/api/`: public contracts now live in `docs/specs/technical/`

See [CHANGELOG.md](CHANGELOG.md) for full details and migration notes.

---

## Workflow at a glance

Not every change needs the same ceremony.

| Tier | When to use | Flow |
| ---- | ----------- | ---- |
| `S` | Patch, typo, config tweak, no behavioural change | PR only |
| `M` | Focused feature, single component, small scope | Spec -> code |
| `L` | Multi-AC or cross-component change | Spec -> tasks -> code |
| `XL` | Open question, new system, cross-cutting decision | RFC -> ADR -> spec -> plan -> tasks -> code |

---

## How to use this repo

### New repository

On GitHub, use `docs-platform` as a template repository to start with a clean
documentation scaffold.

For manual setup, clone `docs-platform` next to the target folder and run the
init script from that folder. The init scripts now reuse the local
`docs-platform` checkout directly, so they do not re-clone the platform repo.
The target folder does not need to be a git repository.

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

Optional overrides:

`PlatformRepo` and `Ref` are used when the script must fetch a remote platform
copy. For local usage, the script prefers the checkout it is running from.

```powershell
..\docs-platform\scripts\init-docs.ps1 -PlatformRepo 'https://dev.azure.com/yourorg/docs-platform' -Ref 'main'
```

Environment variables `DOCS_PLATFORM_REPO`, `DOCS_PLATFORM_REF`, and
`DOCS_PLATFORM_PATH` are also supported.

### Existing repository

Use `scripts/sync-docs.sh` to pull platform-owned template updates into an
existing repo without touching project-specific documentation content.

The sync surface is intentionally narrow:

- `docs/STYLE.md`
- `docs/templates/*`
- `.markdownlint.json`
- `docs/.platform-version`

---

## Repository layout

`scaffold/` is the canonical payload for consuming repos.
When structure or template rules change, update `scaffold/` first.

```text
docs-platform/
├── scaffold/                 # source of truth copied into consuming repos
│   ├── AGENTS.md
│   ├── CONTRIBUTING.md
│   ├── CHANGELOG.md
│   ├── README.md             # becomes docs/README.md in consuming repos
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
├── scripts/
│   ├── init-docs.ps1
│   ├── init-docs.sh
│   └── sync-docs.sh
└── agent/
        ├── doc-scaffold.prompt.md
        ├── doc-sync.prompt.md
        ├── rfc-generate.prompt.md
        ├── rfc-resolve.prompt.md
        ├── spec-generate.prompt.md
        ├── spec-plan.prompt.md
        └── spec-tasks.prompt.md
```

---

## Prompt set

The `agent/` folder now covers the full document workflow:

| Prompt | Purpose |
| ------ | ------- |
| `doc-scaffold` | Scaffold documentation into a new repo |
| `doc-sync` | Sync platform-owned templates and conventions |
| `rfc-generate` | Create an RFC for an open question or cross-cutting decision |
| `rfc-resolve` | Turn a resolved RFC into an ADR and close the RFC |
| `spec-generate` | Create a FUNC or TECH spec from a high-level requirement |
| `spec-plan` | Generate architecture and design docs from an approved spec |
| `spec-tasks` | Break an approved spec into ordered, testable tasks |

---

## What sync updates and what it leaves alone

| Path | Updated by sync |
| ---- | --------------- |
| `docs/templates/` | Yes |
| `docs/STYLE.md` | Yes |
| `.markdownlint.json` | Yes |
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
- Treat breaking changes explicitly, especially spec numbering, lifecycle, and
    folder ownership rules
