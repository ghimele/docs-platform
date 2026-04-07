# docs-platform

Shared documentation structure, templates, and conventions for all projects.

This repository is the single source of truth for:

- Documentation folder structure
- Document templates (ADR, RFC, architecture, design, spec)
- Style and formatting conventions
- Agent instructions scaffold

---

## How to use this repo

### New repository (first-time setup)

**On GitHub:** this repo is marked as a template. When creating a new repo,
select `docs-platform` as the repository template. The full scaffold is copied
automatically with a clean initial commit.

**On Azure DevOps (or manual):**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/yourorg/docs-platform/main/scripts/init-docs.sh)
```

Or clone this repo and run locally:

```bash
git clone https://github.com/yourorg/docs-platform
cd your-target-repo
bash ../docs-platform/scripts/init-docs.sh
```

### Existing repository (sync templates)

To pull updated templates and conventions without touching your actual docs:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/yourorg/docs-platform/main/scripts/sync-docs.sh)
```

Or via the Azure DevOps pipeline — see `.azure/pipelines/sync-docs.yml` in your repo.

---

## Repository structure

```text
docs-platform/
├── scaffold/          # files copied into target repos
│   ├── AGENTS.md
│   ├── CONTRIBUTING.md
│   ├── CHANGELOG.md
│   ├── .markdownlint.json
│   └── docs/
│       ├── README.md
│       ├── STYLE.md
│       ├── glossary.md
│       ├── architecture/
│       ├── design/
│       ├── specs/
│       ├── adr/
│       ├── rfc/
│       ├── api/
│       ├── testing/
│       ├── security/
│       └── templates/
├── scripts/
│   ├── init-docs.sh   # first-time scaffold
│   └── sync-docs.sh   # update templates in existing repos
└── agent/
    ├── doc-scaffold.prompt.md   # Copilot agent: scaffold a new repo
    └── doc-sync.prompt.md       # Copilot agent: sync templates
```

---

## What gets synced vs what is yours

| Path | Owned by | Updated by sync |
| ---- | -------- | --------------- |
| `docs/templates/` | docs-platform | ✅ Yes |
| `docs/STYLE.md` | docs-platform | ✅ Yes |
| `.markdownlint.json` | docs-platform | ✅ Yes |
| `docs/glossary.md` | Your repo | ❌ Never |
| `docs/adr/` | Your repo | ❌ Never |
| `docs/rfc/` | Your repo | ❌ Never |
| `docs/design/` | Your repo | ❌ Never |
| `docs/architecture/` | Your repo | ❌ Never |
| `docs/specs/` | Your repo | ❌ Never |
| `AGENTS.md` | Your repo | ❌ Never |
| `CONTRIBUTING.md` | Your repo | ❌ Never |

---

## Contributing to this repo

Changes to `scaffold/templates/` or `docs/STYLE.md` will propagate to all
repos on their next sync. Make changes carefully and document them in
`CHANGELOG.md`.

For structural changes (adding a new folder to scaffold), open an RFC in
`docs/rfc/` before implementing.
