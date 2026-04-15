# doc-scaffold

Scaffolds the standard documentation structure into the current repository
using the shared docs-platform templates.

## Description

Use this agent when setting up documentation in a new repository for the first time.
It runs `init-docs.sh` from docs-platform, then guides the user through the
required post-scaffold customisation steps.

## Steps

1. **Check prerequisites**
   - Confirm the user is in the root of a git repository
   - Check whether `docs/` already exists — if yes, suggest `doc-sync` instead
   - Check whether `scripts/init-docs.sh` is present — if not, fetch it from docs-platform

2. **Run scaffold**

  ```bash
  bash scripts/init-docs.sh
  ```

  Report which files were created and which were skipped.
   Confirm that the scaffolded `agent/` prompt files were copied.

3. **Prompt for project-specific customisation**

  After scaffolding, ask the user for the following and update files accordingly:

- **Project name and one-line description** → update `docs/README.md` title and intro
- **Primary languages** (C++, .NET, both) → update `docs/testing/strategy.md` to keep only relevant sections
- **Team or owner name** → replace all `<!-- name or team -->` placeholders in scaffold files
- **Azure DevOps org URL** (if applicable) → note in `AGENTS.md`

4. **Update glossary**
   Ask the user for 3–5 key domain terms to seed `docs/glossary.md`.
   Add them in the correct alphabetical position.

5. **Remind about AGENTS.md**
   Tell the user:
   > "Open `AGENTS.md` and add your project-specific code conventions under the
   > C++ and .NET sections. This is the most important step for agent-assisted development."

6. **Explain prompt ownership**
   Tell the user:
   > "Files under `agent/` are platform-owned prompts. Update them via sync rather
   > than editing them directly unless you intentionally want to diverge from docs-platform."

7. **Suggest initial commit**

   ```bash
   git add -A
   git commit -m "chore: init docs structure from docs-platform"
   ```

## Notes

- Never modify files in `docs/adr/`, `docs/rfc/`, or `docs/design/` during scaffold
- If the user declines any customisation step, skip it and move on
- Do not create any ADRs or design docs during scaffold — that is the user's responsibility
